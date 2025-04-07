{ pkgs }:
with pkgs; {
  cliTools = [
    httpie
    xclip
    btop
    cowsay
    figlet
    boxes
    tldr
  ];
  media = [
    vlc
    flameshot
  ];
  devTools = [
    nodejs_23
    bun
    typescript
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    dprint
    nodePackages.prettier
    eslint
    emmet-ls
    deno
  ];

  allPackages = cliTools ++ media ++ devTools;
}
