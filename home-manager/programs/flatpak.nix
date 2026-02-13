{ config, pkgs, lib, ... }:

let
  # ---------------------------------------------------------------------------
  # FLATPAK APPLICATIONS
  # ---------------------------------------------------------------------------
  flatpakPackages = [
    # Example: { appId = "org.telegram.desktop"; origin = "flathub"; }
    { appId = "com.github.tchx84.Flatseal"; origin = "flathub"; }
    { appId = "md.obsidian.Obsidian"; origin = "flathub"; }
    # { appId = "app.zen_browser.zen"; origin = "flathub"; }
    { appId = "com.google.Chrome"; origin = "flathub"; }
    { appId = "com.github.dail8859.NotepadNext"; origin = "flathub"; }
    { appId = "io.httpie.Httpie"; origin = "flathub"; }
    # { appId = "org.libreoffice.LibreOffice"; origin = "flathub"; }
    { appId = "com.obsproject.Studio"; origin = "flathub"; }
    { appId = "org.keepassxc.KeePassXC"; origin = "flathub"; }
    { appId = "io.github.dvlv.boxbuddyrs"; origin = "flathub"; }
    { appId = "org.signal.Signal"; origin = "flathub"; }
  ];
in {
  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  services.flatpak = {
    enable = true;
    remotes = [
      { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
    ];
    # Optional: Add Flatpak apps here (see "How to Use" below)
    # packages = flatpakPackages;
    update.onActivation = true; # Automatically update on switch
    uninstallUnmanaged = false; # true: Remove apps not in package list; false: Keep existed
  };
  # =============================================================================
  #                            ACTIVATION SCRIPTS
  # =============================================================================
  home.activation = {
    installFlatpak = lib.hm.dag.entryAfter ["initializeNvim"] ''
      echo " - Install Flatpak Apps..."
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub com.github.tchx84.Flatseal
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub md.obsidian.Obsidian
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub com.google.Chrome
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub com.github.dail8859.NotepadNext
      # ${pkgs.flatpak}/bin/flatpak install --user -y flathub io.httpie.Httpie
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub com.obsproject.Studio
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub org.keepassxc.KeePassXC
      ${pkgs.flatpak}/bin/flatpak install --user -y flathub io.github.dvlv.boxbuddyrs
    '';
  };
}
