{ pkgs, ... }:
{
  # formatting orchestrator
  programs.nixvim = {

    # import formatting tools here
    extraPackages = with pkgs; [
      nixfmt
      prettier
      shfmt
      stylua
    ];

    plugins.conform-nvim = {
      enable = true;

      # declare tool for language
      settings = {
        formatters_by_ft = {

          nix = [ "nixfmt" ];
          lua = [ "stylua" ];

          css = [ "prettier" ];

          sh = [ "shfmt" ];

          json = [ "prettier" ];
          jsonc = [ "prettier" ];

          markdown = [ "prettier" ];
        };

        format_on_save = {
          timeout_ms = 3000;
          lsp_format = "fallback";
        };
      };
    };
  };
}
