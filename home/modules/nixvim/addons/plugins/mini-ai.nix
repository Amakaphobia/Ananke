{ config, ... }:
let
  nixvim = config.lib.nixvim;
in
{
  programs.nixvim.plugins.mini-ai = {
    enable = true;

    settings = {
      # search on cursor line +- 500 lines
      n_lines = 500;

      custom_textobjects = {
        # Block, conditional, or loop.
        o = nixvim.mkRaw ''
          require("mini.ai").gen_spec.treesitter({
            a = {
              "@block.outer",
              "@conditional.outer",
              "@loop.outer",
            },
            i = {
              "@block.inner",
              "@conditional.inner",
              "@loop.inner",
            },
          })
        '';

        # Function or method definition.
        f = nixvim.mkRaw ''
          require("mini.ai").gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          })
        '';

        # Class definition.
        c = nixvim.mkRaw ''
          require("mini.ai").gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          })
        '';

        # Function call, including a dotted name.
        u = nixvim.mkRaw ''
          require("mini.ai").gen_spec.function_call()
        '';

        # Function call without including a dotted receiver.
        U = nixvim.mkRaw ''
          require("mini.ai").gen_spec.function_call({
            name_pattern = "[%w_]",
          })
        '';
      };
    };
  };
}
