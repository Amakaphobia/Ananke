{ config, ... }:
{
  programs.nixvim.plugins.treesitter = {
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
  };
}
