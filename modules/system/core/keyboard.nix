_: {
  services.xserver.xkb.extraLayouts = {
    ananke-de = {
      description = "Ananke custom layout";
      languages = [ "deu" ];
      symbolsFile = ./xkb/ananke-de;
    };
  };
}
