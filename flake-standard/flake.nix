{
  description = "Modular Dev Shell for Node.js, Tauri 2, and Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # Import các modules
        nodeDeps = import ./nodejs.nix { inherit pkgs; };
        pythonDeps = import ./python.nix { inherit pkgs; };
        rustModule = import ./rust.nix { inherit pkgs; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = nodeDeps ++ pythonDeps ++ rustModule.packages;

          shellHook = ''
            echo "🚀 Multi-language Dev Environment Loaded!"
            echo "Node version: $(node -v)"
            echo "Npm version: $(npm -v)"
            echo "Uv version: $(uv --version)"
            echo "Python version: $(python --version)"

            ${rustModule.shellHook}
          '';
        };
      });
}

# echo "use flake" > .envrc
# direnv allow
# direnv deny
