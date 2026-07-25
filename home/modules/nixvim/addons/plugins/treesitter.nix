{ config, ... }:
let
  treesitterMove = key: movement: capture: description: {
    mode = [
      "n"
      "x"
      "o"
    ];

    inherit key;

    action.__raw = ''
      function()
        require("nvim-treesitter-textobjects.move").${movement}(
          "${capture}",
          "textobjects"
        )
      end
    '';

    options = {
      desc = description;
      silent = true;
    };
  };
in
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;

      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        bash
        css
        java
        json
        lua
        markdown
        markdown-inline
        nix
        regex
        toml
        vim
        vimdoc
        yaml
      ];
      settings.treesitter-textobjects = {
        enable = true;

        settings.move = {
          set_jumps = true;
        };
      };
    };

    keymaps = [
      # Functions
      (treesitterMove "]f" "goto_next_start" "@function.outer" "Next function start")

      (treesitterMove "[f" "goto_previous_start" "@function.outer" "Previous function start")

      (treesitterMove "]F" "goto_next_end" "@function.outer" "Next function end")

      (treesitterMove "[F" "goto_previous_end" "@function.outer" "Previous function end")

      # Classes
      (treesitterMove "]c" "goto_next_start" "@class.outer" "Next class start")

      (treesitterMove "[c" "goto_previous_start" "@class.outer" "Previous class start")

      (treesitterMove "]C" "goto_next_end" "@class.outer" "Next class end")

      (treesitterMove "[C" "goto_previous_end" "@class.outer" "Previous class end")

      # Parameters
      (treesitterMove "]a" "goto_next_start" "@parameter.inner" "Next parameter")

      (treesitterMove "[a" "goto_previous_start" "@parameter.inner" "Previous parameter")

      (treesitterMove "]A" "goto_next_end" "@parameter.inner" "Next parameter end")

      (treesitterMove "[A" "goto_previous_end" "@parameter.inner" "Previous parameter end")
    ];
  };
}
