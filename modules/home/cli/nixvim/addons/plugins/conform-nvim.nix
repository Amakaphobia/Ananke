{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ananke.cli.nixvim.enable;
in
{
  config = lib.mkIf cfg {
    # formatting orchestrator
    programs.nixvim = {

      # import formatting tools here
      extraPackages = with pkgs; [
        markdown-toc
        nixfmt
        prettier
        shfmt
        stylua
      ];
      plugins.conform-nvim = {
        enable = true;

        # declare tool for language
        settings = {

          formatters = {
            "markdown-toc" = {
              condition.__raw = ''
                function(_, ctx)
                  local lines = vim.api.nvim_buf_get_lines(
                    ctx.buf,
                    0,
                    -1,
                    false
                  )

                  for _, line in ipairs(lines) do
                    if line:find("<!%-%- toc %-%->") then
                      return true
                    end
                  end

                  return false
                end
              '';
            };
          };

          formatters_by_ft = {

            nix = [ "nixfmt" ];
            lua = [ "stylua" ];

            css = [ "prettier" ];

            sh = [ "shfmt" ];

            json = [ "prettier" ];
            jsonc = [ "prettier" ];

            markdown = [
              "prettier"
              "markdownlint-cli2"
              "markdown-toc"
            ];

            "markdown.mdx" = [
              "prettier"
              "markdownlint-cli2"
              "markdown-toc"
            ];
          };

          format_on_save = {
            timeout_ms = 3000;
            lsp_format = "fallback";
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>cf";

          action.__raw = ''
            function()
              require("conform").format({
                lsp_format = "fallback",
              })
            end
          '';

          options.desc = "Format buffer";
        }
      ];
    };
  };
}
