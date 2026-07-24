{ ... }:
{
  programs.nixvim.keymaps = [
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
      key = "<leader>rn";
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
      key = "<leader>cf";
      action.__raw = "vim.lsp.buf.format";
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "vim.diagnostic.goto_prev";
      options.desc = "Previous diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "vim.diagnostic.goto_next";
      options.desc = "Next diagnostic";
    }
  ];
}
