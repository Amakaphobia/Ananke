{ config, lib, ... }:
let
  cfg = config.ananke.profiles.home.cli.nixvim.enable;
in
{
  imports = [
    ./bash.nix
    ./css.nix
    ./json.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
  ];

  config = lib.mkIf cfg {
    programs.nixvim = {
      plugins.lsp = {
        enable = true;
      };
      lsp.keymaps = [
        {
          mode = "n";
          key = "K";
          lspBufAction = "hover";
          options.desc = "LSP hover";
        }
        {
          mode = "n";
          key = "gd";
          lspBufAction = "definition";
          options.desc = "Go to definition";
        }
        {
          mode = "n";
          key = "gr";
          action.__raw = "function() Snacks.picker.lsp_references() end";
          options.desc = "Find references";
        }

        {
          mode = "n";
          key = "<leader>ss";
          action.__raw = "function() Snacks.picker.lsp_symbols() end";
          options.desc = "Search document symbols";
        }

        {
          mode = "n";
          key = "<leader>sS";
          action.__raw = "function() Snacks.picker.lsp_workspace_symbols() end";
          options.desc = "Search workspace symbols";
        }
        {
          mode = "n";
          key = "<leader>cr";
          lspBufAction = "rename";
          options.desc = "Rename symbol";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "Code action";
        }
        {
          mode = "n";
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "Go to declaration";
        }
        {
          mode = "n";
          key = "gi";
          action.__raw = "function() Snacks.picker.lsp_implementations() end";
          options.desc = "Go to implementation";
        }
        {
          mode = "n";
          key = "gy";
          lspBufAction = "type_definition";
          options.desc = "Go to type definition";
        }
      ];
    };
  };
}
