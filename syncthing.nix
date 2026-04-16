_: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        "Laptop" = {
          id = "DEVICE-ID-GOES-HERE";
          addres = "100.126.211.69";
        };
        "Phone" = {
          id = "DEVICE-ID-GOES-HERE";
          addres = "100.123.228.114";
        };
      };
      folders = {
        "Obsidian" = {
          path = "/home/julius/Everything";
          devices = [
            "Laptop"
            "Phone"
          ];
        };
        
      };
    };
  };
}
