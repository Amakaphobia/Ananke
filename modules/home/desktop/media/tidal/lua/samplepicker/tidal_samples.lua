local M = {}

local insertion_namespace = vim.api.nvim_create_namespace("ananke_tidal_samples")

local AUDIO_EXTENSIONS = {
	wav = true,
	aif = true,
	aiff = true,
	aifc = true,
}

local state = {
	options = nil,
	index = nil,
	preview_job = nil,
	preview_generation = 0,
}

local function is_directory(path)
	local metadata = vim.uv.fs_stat(path)

	return metadata ~= nil and metadata.type == "directory"
end

local function is_audio_file(path, filename)
	local extension = filename:match("%.([^%.]+)$")

	if extension == nil then
		return false
	end

	extension = extension:lower()

	if not AUDIO_EXTENSIONS[extension] then
		return false
	end

	local metadata = vim.uv.fs_stat(path)

	return metadata ~= nil and metadata.type == "file"
end

local function sorted_directory_entries(path)
	local succeeded, iterator, filesystem_error = pcall(vim.fs.dir, path)

	if not succeeded then
		return nil, iterator
	end

	if iterator == nil then
		return nil, filesystem_error or "unknown filesystem error"
	end

	local entries = {}

	for name in iterator do
		entries[#entries + 1] = name
	end

	table.sort(entries)

	return entries
end

local function scan_root(root)
	if not is_directory(root) then
		return nil, ("Sample root is not a directory: %s"):format(root)
	end

	local bank_names, directory_error = sorted_directory_entries(root)

	if bank_names == nil then
		return nil, ("Could not read sample root %s: %s"):format(root, directory_error)
	end

	local result = {
		banks = {},
		items = {},
	}

	for _, bank_name in ipairs(bank_names) do
		local bank_path = vim.fs.joinpath(root, bank_name)

		if is_directory(bank_path) then
			local filenames, bank_error = sorted_directory_entries(bank_path)

			if filenames == nil then
				return nil, ("Could not read sample bank %s: %s"):format(bank_path, bank_error)
			end

			local audio_files = {}

			for _, filename in ipairs(filenames) do
				local sample_path = vim.fs.joinpath(bank_path, filename)

				if is_audio_file(sample_path, filename) then
					audio_files[#audio_files + 1] = {
						filename = filename,
						path = sample_path,
					}
				end
			end

			if #audio_files > 0 then
				result.banks[#result.banks + 1] = bank_name

				for lua_index, sample in ipairs(audio_files) do
					local tidal_index = lua_index - 1
					local token = ("%s:%d"):format(bank_name, tidal_index)

					result.items[#result.items + 1] = {
						kind = "sample",

						bank = bank_name,
						index = tidal_index,
						token = token,
						filename = sample.filename,
						sample_path = sample.path,

						text = ("%s %s sample"):format(token, sample.filename),
					}
				end
			end
		end
	end

	return result
end

local function scan_roots(roots)
	local result = {
		banks = {},
		items = {},
	}

	local known_banks = {}

	for _, root in ipairs(roots) do
		local root_result, scan_error = scan_root(root)

		if root_result == nil then
			return nil, scan_error
		end

		for _, bank_name in ipairs(root_result.banks) do
			if known_banks[bank_name] ~= nil then
				return nil, ("Sample bank %q exists in both %s and %s"):format(bank_name, known_banks[bank_name], root)
			end

			known_banks[bank_name] = root
			result.banks[#result.banks + 1] = bank_name
		end

		for _, item in ipairs(root_result.items) do
			item.idx = #result.items + 1
			result.items[#result.items + 1] = item
		end
	end

	return result
end

local function create_synth_items(synths)
	local items = {}

	for _, synth_name in ipairs(synths) do
		items[#items + 1] = {
			kind = "synth",
			name = synth_name,
			token = synth_name,

			text = ("%s synth"):format(synth_name),
		}
	end

	return items
end

local function read_synth_manifest(path)
	local file = io.open(path, "r")

	if file == nil then
		return {}
	end

	local synths = {}

	for line in file:lines() do
		local name = vim.trim(line)

		if name ~= "" then
			synths[#synths + 1] = name
		end
	end

	file:close()

	table.sort(synths)

	return synths
end

local PICKER_SEARCH_FIELDS = {
	kind = true,
	bank = true,
	token = true,
	filename = true,
	name = true,
}

local function normalize_picker_pattern(pattern)
	return pattern:gsub("%S+", function(term)
		local first_character = term:sub(1, 1)

		-- Preserve deliberate fzf-style modifiers.
		if first_character == "'" or first_character == "!" or first_character == "^" then
			return term
		end

		local field, value = term:match("^([%w_][%w_]+):(.*)$")

		if field == nil then
			return term
		end

		local normalized_field = field:lower()

		-- Preserve intentional field searches such as:
		--
		-- bank:bd
		-- token:bd:0
		-- filename:kick
		if PICKER_SEARCH_FIELDS[normalized_field] then
			return normalized_field .. ":" .. value
		end

		-- A colon with an unknown field is assumed to be
		-- Tidal's bank:index syntax.
		--
		-- bd:0 becomes token:^bd:0
		--
		-- This means:
		--   use the token field
		--   require the token to start with bd:0
		return "token:^" .. term
	end)
end

local function apply_picker_score_bonuses(items, pattern)
	local query = vim.trim(pattern):lower()

	local first_character = query:sub(1, 1)
	local field = query:match("^([%w_][%w_]+):")

	local is_explicit_field_search = field ~= nil and PICKER_SEARCH_FIELDS[field:lower()]

	local is_simple_query = query ~= ""
		and not query:find("%s")
		and first_character ~= "'"
		and first_character ~= "!"
		and first_character ~= "^"
		and not is_explicit_field_search

	for _, item in ipairs(items) do
		item.score_add = 0

		if is_simple_query then
			local token = (item.token or ""):lower()
			local bank = (item.bank or ""):lower()
			local name = (item.name or ""):lower()

			if token == query then
				item.score_add = 4000
			elseif bank == query or name == query then
				item.score_add = 3000
			elseif token:sub(1, #query) == query then
				item.score_add = 2000
			elseif bank:sub(1, #query) == query or name:sub(1, #query) == query then
				item.score_add = 1000
			end
		end
	end
end

local function stop_preview()
	state.preview_generation = state.preview_generation + 1

	local job = state.preview_job

	state.preview_job = nil

	if job ~= nil then
		pcall(function()
			job:kill(15)
		end)
	end
end

local function audition_sample(item)
	if state.options == nil then
		vim.notify("Tidal sample browser has not been configured", vim.log.levels.ERROR)
		return
	end

	if item == nil or type(item.sample_path) ~= "string" then
		vim.notify("Selected item has no sample path", vim.log.levels.ERROR)
		return
	end

	stop_preview()

	local generation = state.preview_generation

	local command = {
		state.options.player,

		"--no-config",
		"--no-video",
		"--audio-display=no",
		"--force-window=no",
		"--no-terminal",
		"--really-quiet",
		"--keep-open=no",

		("--volume=%d"):format(state.options.preview_volume),

		"--",
		item.sample_path,
	}

	local job

	local started, start_error = pcall(function()
		job = vim.system(command, {
			text = true,
		}, function(result)
			vim.schedule(function()
				if generation ~= state.preview_generation then
					return
				end

				if state.preview_job == job then
					state.preview_job = nil
				end

				if result.code ~= 0 then
					local stderr = vim.trim(result.stderr or "")

					local message = ("Sample preview failed with exit code %d"):format(result.code)

					if stderr ~= "" then
						message = message .. "\n" .. stderr
					end

					vim.notify(message, vim.log.levels.ERROR)
				end
			end)
		end)
	end)

	if not started then
		state.preview_job = nil

		vim.notify("Could not start sample preview:\n" .. tostring(start_error), vim.log.levels.ERROR)

		return
	end

	state.preview_job = job
end

local function audition_item(item)
	if item == nil then
		return
	end

	if item.kind == "sample" then
		audition_sample(item)
		return
	end

	if item.kind == "synth" then
		vim.notify(("Synth preview is not implemented yet: %s"):format(item.token), vim.log.levels.INFO)
		return
	end

	vim.notify(("Unknown Tidal sound kind: %s"):format(tostring(item.kind)), vim.log.levels.ERROR)
end

function M.stop()
	stop_preview()
end

local function create_insertion_target()
	local buffer = vim.api.nvim_get_current_buf()
	local window = vim.api.nvim_get_current_win()

	if not vim.api.nvim_buf_is_valid(buffer) then
		return nil, "Current buffer is invalid"
	end

	if not vim.api.nvim_buf_is_loaded(buffer) then
		return nil, "Current buffer is not loaded"
	end

	if not vim.bo[buffer].modifiable then
		return nil, "Current buffer is not modifiable"
	end

	if vim.bo[buffer].readonly then
		return nil, "Current buffer is read-only"
	end

	local cursor = vim.api.nvim_win_get_cursor(window)
	local mode = vim.api.nvim_get_mode().mode

	local row = cursor[1] - 1
	local column = cursor[2]

	if mode:sub(1, 1) == "n" then
		local line = vim.api.nvim_buf_get_lines(buffer, row, row + 1, true)[1] or ""

		if line ~= "" and column < #line then
			local character_index = vim.fn.charidx(line, column)
			local next_column = vim.fn.byteidx(line, character_index + 1)

			column = next_column == -1 and #line or next_column
		end
	end

	local mark_id = vim.api.nvim_buf_set_extmark(buffer, insertion_namespace, row, column, {
		right_gravity = false,
	})

	return {
		buffer = buffer,
		window = window,
		mark_id = mark_id,
		confirmed = false,
	}
end

local function clear_insertion_target(target)
	if target == nil or target.mark_id == nil then
		return
	end

	if vim.api.nvim_buf_is_valid(target.buffer) then
		pcall(vim.api.nvim_buf_del_extmark, target.buffer, insertion_namespace, target.mark_id)
	end

	target.mark_id = nil
end

local function insert_at_target(target, text)
	if target == nil then
		return false, "No insertion target exists"
	end

	if not vim.api.nvim_buf_is_valid(target.buffer) then
		return false, "Original buffer is no longer valid"
	end

	if not vim.api.nvim_buf_is_loaded(target.buffer) then
		return false, "Original buffer is no longer loaded"
	end

	if not vim.bo[target.buffer].modifiable then
		clear_insertion_target(target)

		return false, "Original buffer is not modifiable"
	end

	if vim.bo[target.buffer].readonly then
		clear_insertion_target(target)

		return false, "Original buffer is read-only"
	end

	local position = vim.api.nvim_buf_get_extmark_by_id(target.buffer, insertion_namespace, target.mark_id, {})

	if #position ~= 2 then
		clear_insertion_target(target)

		return false, "Insertion position no longer exists"
	end

	local row = position[1]
	local column = position[2]

	clear_insertion_target(target)

	local inserted, insertion_error = pcall(vim.api.nvim_buf_set_text, target.buffer, row, column, row, column, {
		text,
	})

	if not inserted then
		return false, tostring(insertion_error)
	end

	local target_window = target.window

	if not vim.api.nvim_win_is_valid(target_window) or vim.api.nvim_win_get_buf(target_window) ~= target.buffer then
		target_window = vim.fn.bufwinid(target.buffer)
	end

	if target_window ~= -1 then
		local cursor_column = column + math.max(#text - 1, 0)

		pcall(vim.api.nvim_win_set_cursor, target_window, {
			row + 1,
			cursor_column,
		})
	end

	return true
end

function M.refresh()
	if state.options == nil then
		vim.notify("Tidal sample browser has not been configured", vim.log.levels.ERROR)
		return nil
	end

	local index, scan_error = scan_roots(state.options.sample_roots)

	if index == nil then
		vim.notify("Could not index Tidal samples:\n" .. scan_error, vim.log.levels.ERROR)
		return nil
	end
	local synths = read_synth_manifest(state.options.synth_manifest)
	local synth_items = create_synth_items(synths)

	for _, item in ipairs(synth_items) do
		item.idx = #index.items + 1
		index.items[#index.items + 1] = item
	end

	index.synths = synth_items

	state.index = index

	return index
end

function M.open()
	if state.options == nil then
		vim.notify("Tidal sample browser has not been configured", vim.log.levels.ERROR)
		return
	end

	local index = M.refresh()

	if index == nil then
		return
	end

	if #index.items == 0 then
		vim.notify("No Tidal samples were found", vim.log.levels.WARN)
		return
	end

	local snacks_loaded, snacks = pcall(require, "snacks")

	if not snacks_loaded or snacks.picker == nil then
		vim.notify("Snacks Picker is not available", vim.log.levels.ERROR)
		return
	end

	local target, target_error = create_insertion_target()

	if target == nil then
		vim.notify("Cannot insert a Tidal sample:\n" .. target_error, vim.log.levels.ERROR)
		return
	end

	local token_width = 0

	for _, item in ipairs(index.items) do
		token_width = math.max(token_width, #item.token)
	end

	snacks.picker.pick({
		title = ("Tidal Sounds (%d) ..."):format(#index.items),

		prompt = "sound> ",

		items = index.items,

		focus = "input",
		auto_confirm = false,

		preview = "none",

		layout = {
			preset = "vscode",
		},

		filter = {
			transform = function(_, filter)
				apply_picker_score_bonuses(index.items, filter.pattern)

				filter.pattern = normalize_picker_pattern(filter.pattern)
			end,
		},

		matcher = {
			sort_empty = false,
			filename_bonus = false,
			file_pos = false,
		},

		sort = {
			fields = {
				"score:desc",
				"idx",
			},
		},

		actions = {
			audition_sample = {
				action = function(_, item)
					audition_item(item)
				end,
				desc = "Play selected sample",
			},

			stop_audition = {
				action = function()
					M.stop()
				end,
				desc = "Stop sample playback",
			},
		},

		win = {
			input = {
				keys = {

					["<c-j>"] = {
						"list_down",
						mode = { "i", "n" },
					},

					["<c-k>"] = {
						"list_up",
						mode = { "i", "n" },
					},

					["<c-p>"] = {
						"audition_sample",
						mode = { "i", "n" },
					},

					["<c-x>"] = {
						"stop_audition",
						mode = { "i", "n" },
					},

					["<CR>"] = {
						"confirm",
						mode = { "i", "n" },
					},
				},
			},

			list = {
				keys = {
					["<c-j>"] = "list_down",
					["<c-k>"] = "list_up",
					["<c-p>"] = "audition_sample",
					["<c-s>"] = "stop_audition",
					["<CR>"] = "confirm",
				},
			},
		},

		format = function(item)
			local padded_token = ("%-" .. token_width .. "s"):format(item.token)

			if item.kind == "sample" then
				return {
					{
						"[sample] ",
						"SnacksPickerComment",
					},
					{
						padded_token,
						"SnacksPickerLabel",
					},
					{
						"  ",
					},
					{
						item.filename,
						"SnacksPickerComment",
					},
				}
			end

			if item.kind == "synth" then
				return {
					{
						"[synth]  ",
						"SnacksPickerComment",
					},
					{
						padded_token,
						"SnacksPickerLabel",
					},
				}
			end

			return {
				{
					padded_token,
					"SnacksPickerLabel",
				},
			}
		end,

		confirm = function(picker, item)
			if item == nil then
				picker:close()
				return
			end

			target.confirmed = true

			picker:close()

			vim.schedule(function()
				local inserted, insertion_error = insert_at_target(target, item.token)

				if not inserted then
					vim.notify("Could not insert Tidal sample:\n" .. insertion_error, vim.log.levels.ERROR)
				end
			end)
		end,

		on_close = function()
			M.stop()

			if not target.confirmed then
				clear_insertion_target(target)
			end
		end,
	})
end

function M.setup(options)
	options = options or {}

	if type(options) ~= "table" then
		error("tidal_samples.setup() expects a table")
	end

	local defaults = {
		sample_roots = {},
		synth_manifest = nil,
		player = nil,
		preview_volume = 70,
	}

	state.options = vim.tbl_deep_extend("force", {}, defaults, options)

	-- validating sample roots
	if #state.options.sample_roots == 0 then
		error("tidal_samples requires at least one sample root")
	end

	for index, root in ipairs(state.options.sample_roots) do
		if type(root) ~= "string" then
			error(("sample_roots[%d] must be a string"):format(index))
		end
	end

	-- validate synths
	if type(state.options.synth_manifest) ~= "string" or state.options.synth_manifest == "" then
		error("synth_manifest must be a non-empty string")
	end
	-- validating player
	if type(state.options.player) ~= "string" or state.options.player == "" then
		error("tidal_samples requires a preview player")
	end

	if vim.fn.executable(state.options.player) ~= 1 then
		error("Tidal sample player is not executable: " .. state.options.player)
	end

	if
		type(state.options.preview_volume) ~= "number"
		or state.options.preview_volume < 0
		or state.options.preview_volume > 100
	then
		error("preview_volume must be a number from 0 to 100")
	end

	state.index = nil

	vim.api.nvim_create_user_command("TidalSounds", M.open, {
		desc = "Open the Tidal sound browser",
		force = true,
	})

	vim.api.nvim_create_user_command("TidalSamples", M.open, {
		desc = "Open the Tidal sound browser",
		force = true,
	})

	vim.api.nvim_create_user_command("TidalSamplesRefresh", function()
		local index = M.refresh()

		local sample_count = #index.items - #index.synths
		local synth_count = #index.synths
		if index ~= nil then
			vim.notify(
				("Reindexed %d banks, %d samples and %d synths"):format(#index.banks, sample_count, synth_count),
				vim.log.levels.INFO
			)
		end
	end, {
		desc = "Reindex the Tidal sample library",
		force = true,
	})
	vim.api.nvim_create_user_command("TidalSampleStop", M.stop, {
		desc = "Stop the current Tidal sample preview",
		force = true,
	})

	local preview_group = vim.api.nvim_create_augroup("AnankeTidalSamplePreview", {
		clear = true,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = preview_group,
		callback = M.stop,
	})
end

return M
