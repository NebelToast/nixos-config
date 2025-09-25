{ config, pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "${config.home.homeDirectory}/.config/btop/themes/btopcolor.theme";
      theme_background = true;
      truecolor = true;
      rounded_corners = true;
      graph_symbol = "braille";
      update_ms = 1000;
      proc_sorting = "cpu direct";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      check_temp = true;
      show_coretemp = true;
      temp_scale = "celsius";
      show_cpu_freq = true;
      clock_format = "%X";
      mem_graphs = true;
      net_auto = true;
      net_sync = true;
    };
  };
}
