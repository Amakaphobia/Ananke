{ ... }:
{
  imports = [
    ./bash.nix
    ./css.nix
    ./json.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
  ];

  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      keymaps = [
        {
          mode = "n";
          key = "K";
          action.__raw = "vim.lsp.buf.hover";
          options.desc = "LSP hover";
        }
        {
          mode = "n";
          key = "gd";
          action.__raw = "vim.lsp.buf.definition";
          options.desc = "Go to definition";
        }
        {
          mode = "n";
          key = "gr";
          action.__raw = "vim.lsp.buf.references";
          options.desc = "Find references";
        }
        {
          mode = "n";
          key = "<leader>cr";
          action.__raw = "vim.lsp.buf.rename";
          options.desc = "Rename symbol";
        }
        {
          mode = "n";
          key = "<leader>ca";
          action.__raw = "vim.lsp.buf.code_action";
          options.desc = "Code action";
        }
        {
          mode = "n";
          key = "]d";
          action.__raw = ''
            function()
              vim.diagnostic.jump({ count = 1, float = true })
            end
          '';
          options.desc = "Next diagnostic";
        }
        {
          mode = "n";
          key = "[d";
          action.__raw = ''
            function()
              vim.diagnostic.jump({ count = -1, float = true })
            end
          '';
          options.desc = "Previous diagnostic";
        }
        {
          mode = "n";
          key = "<leader>cd";
          action.__raw = "vim.diagnostic.open_float";
          options.desc = "Line diagnostic";
        }
        {
          mode = "n";
          key = "gD";
          action.__raw = "vim.lsp.buf.declaration";
          options.desc = "Go to declaration";
        }
        {
          mode = "n";
          key = "gi";
          action.__raw = "vim.lsp.buf.implementation";
          options.desc = "Go to implementation";
        }
        {
          mode = "n";
          key = "gy";
          action.__raw = "vim.lsp.buf.type_definition";
          options.desc = "Go to type definition";
        }
      ];
    };
  };
}
