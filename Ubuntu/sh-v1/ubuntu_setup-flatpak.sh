sudo nala install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub -y com.google.Chrome md.obsidian.Obsidian org.signal.Signal com.obsproject.Studio io.httpie.Httpie org.libreoffice.LibreOffice
# com.visualstudio.code org.chromium.Chromium com.getpostman.Postman
