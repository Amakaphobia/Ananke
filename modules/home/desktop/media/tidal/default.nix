{
  config,
  inputs,
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  cfg = config.ananke.profiles.home.desktop.media.tidal;

  sc3Plugins = pkgsUnstable.supercolliderPlugins.sc3-plugins;

  tidal = pkgsUnstable.tidal-cycles-full;
  sampleDir = "${config.home.homeDirectory}/Music/tidal/samples/";

  synthCacheDir = "${config.home.homeDirectory}/.cache/tidal";
  synthManifest = "${synthCacheDir}/synths";

  vimTidal = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-tidal";
    version = inputs.vim-tidal.shortRev or "unstable";
    src = inputs.vim-tidal;
  };

  superdirtStartup = pkgs.writeText "superdirt-startup.scd" ''
    (
      s.options.numBuffers = 1024 * 16;
      s.options.memSize = 8192 * 32;
      s.options.ugenPluginsPath = "${tidal}/lib/SuperCollider/plugins";

      s.waitForBoot {
        var synthsBeforeDirt;
        var synthsAfterDirt;
        var tidalSynths;

        synthsBeforeDirt = SynthDescLib.global.synthDescs.keys.as(Set);

        ~dirt = SuperDirt(2, s);

        ~dirt.loadSoundFiles;
        ~dirt.loadSoundFiles("${sampleDir}*");

        s.sync;

        ~dirt.start(57120, 0 ! 12);

        synthsAfterDirt = SynthDescLib.global.synthDescs.keys.as(Set);

        tidalSynths = (synthsAfterDirt - synthsBeforeDirt)
          .select { |name|
            name.asString.beginsWith("dirt_").not
          }
          .asArray
          .sort;

        File.mkdir("${synthCacheDir}");

        File.use("${synthManifest}", "w", { |file|
          tidalSynths.do { |name|
            file.write(name.asString ++ "\n");
          };
        });

        "Tidal synth manifest: % synths written to ${synthManifest}"
          .format(tidalSynths.size)
          .postln;
      };
    );
  '';

  sclangConfig = pkgs.writeText "tidal-sclang-conf.yaml" ''
    includePaths:
      - ${tidal.superdirt}/quark
      - ${sc3Plugins}/share/SuperCollider/Extensions
    excludePaths: []
    postInlineWarnings: false
    excludeDefaultPaths: false
  '';
in
{
  options.ananke.profiles.home.desktop.media.tidal = {
    enable = lib.mkEnableOption "TidalCycles live-coding environment";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      tidal
      pkgs.pipewire.jack
    ];

    programs.nixvim = {
      extraPlugins = [
        vimTidal
      ];

      # sample picker
      extraFiles = {
        "lua/samplepicker/tidal_samples.lua".source = ./lua/samplepicker/tidal_samples.lua;

        "ftplugin/tidal.lua".text = ''
          vim.keymap.set(
            "n",
            "<leader>st",
            "<cmd>TidalSamples<CR>",
            {
              buffer = true,
              desc = "Browse Tidal samples",
            }
          )

          vim.keymap.set(
            "n",
            "<C-p>",
            "<cmd>TidalHush<CR>",
            {
              buffer = true,
              desc = "Hush Tidal",
            }
          )
        '';
      };
      extraConfigLua = ''
        require("samplepicker.tidal_samples").setup({
          sample_roots = {
            "${tidal.dirt-samples}/quark/Dirt-Samples",
            "${sampleDir}",
          },
          synth_manifest = "${synthManifest}",
          player = "${lib.getExe pkgs.mpv}",
          preview_volume = 70,
        })
      '';
      # recolor operators
      highlightOverride = {
        "@operator.haskell" = {
          fg = config.lib.stylix.colors.withHashtag.base0E;
        };
      };

      globals = {
        # Use Neovim terminal splits instead of requiring a tmux session.
        tidal_target = "terminal";

        # Use the GHCi environment
        tidal_ghci = "${tidal.ghcWithTidal}/bin/ghci";

        # Keep Vim-Tidal and the Tidal library on the same boot configuration.
        tidal_boot_fallback = "${tidal.tidalBoot}/share/tidal-cycles/BootTidal.hs";

        # Start SuperDirt automatically when the Tidal terminal opens.
        tidal_sc_enable = 1;
        tidal_sc_boot_cmd =
          "${pkgs.pipewire.jack}/bin/pw-jack "
          + "${tidal}/bin/sclang "
          + "-l ${sclangConfig} "
          + "${superdirtStartup}";
      };
    };
  };
}
