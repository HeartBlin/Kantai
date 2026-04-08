{
  flake.modules.nixos._Void-Constants = {
    nimic = {
      email = "26450233-heart.blin@users.noreply.gitlab.com";
      flake = "/etc/nixos/";
      gitName = "HeartBlin";
      user = "heartblin";

      nvidia = {
        prime = true;
        perDinam = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:6:0:0";
      };

      domain = "heartblin.eu";
      acmeEmail = false;
    };
  };
}
