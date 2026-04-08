{
  flake.modules.nixos._Reason-Constants = {
    nimic = {
      email = false;
      flake = "gitlab:heart.blin/nimic";
      gitName = false;
      user = "server";

      nvidia = {
        prime = false;
        perDinam = false;
        nvidiaBusId = false;
        amdgpuBusId = false;
      };

      domain = "heartblin.eu";
      acmeEmail = "manea.emil@proton.me";
    };
  };
}
