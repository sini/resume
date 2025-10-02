{ inputs, ... }:
{
  perSystem =
    { config
    , self'
    , pkgs
    , lib
    , ...
    }: {
      devShells.default = pkgs.mkShell {
        name = "resume-shell";
        inputsFrom = [
          self'.devShells.latex
          config.pre-commit.devShell # See ./nix/modules/pre-commit.nix
        ];
        packages = with pkgs; [
          nixd # Nix language server
          zathura # PDF viewer
        ];

        shellHook = ''
          echo "LaTeX Resume Development Environment"
          echo "Available commands:"
          echo "  build-resume  - Compile resume.tex to PDF"
          echo "  clean-resume  - Remove build artifacts"
          echo "  chktex        - Lint LaTeX files"
          echo "  zathura       - View PDF files"
          echo "  treefmt       - Format .nix files"
        '';
      };
    };
}
