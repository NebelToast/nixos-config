_: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "julius";
    group = "users";
    dataDir = "/home/julius";
        settings = {
      devices = {
        "Laptop" = {
          id = "5FQCYUU-Z3REEJK-4NVRU3R-N74WHOS-HVPTO3H-DY6Z6KR-CS2KKJO-HHSFQQR";
          addres = "100.126.211.69";
        };
        "Phone" = {
          id = "MRJYFEH-QCO6BSS-N6EQLAD-HROGGTD-27LW6VG-5GYHYLL-6F73RTT-QN366QH";
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
