{ pkgs, ... }:
{
  # formatting orchestrator
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    # import formatting tools here
    extraPackages = with pkgs; [
      nixfmt
      prettier
      stylua
    ];

    # declare tool for language
    settings = {
      formatters_by_ft = {

        nix = [ "nixfmt" ];
        lua = [ "stylua" ];

        css = [ "prettier" ];

        json = [ "prettier" ];
        jsonc = [ "prettier" ];
      };

      format_on_save = {
        timeout_ms = 3000;
        lsp_format = "fallback";
      };
    };

  };
}
