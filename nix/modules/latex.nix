{ inputs, ... }:
{
  perSystem =
    { config
    , self'
    , pkgs
    , lib
    , ...
    }:
    let
      # LaTeX environment with required packages
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          scheme-medium
          fontawesome;
      };

      # Build script for the resume
      buildResume = pkgs.writeShellScriptBin "build-resume" ''
        echo "Building resume..."
        ${tex}/bin/pdflatex resume.tex
        echo "Resume built successfully: resume.pdf"
      '';

      # Clean build artifacts
      cleanBuild = pkgs.writeShellScriptBin "clean-resume" ''
        echo "Cleaning build artifacts..."
        rm -f *.aux *.log *.out *.fls *.fdb_latexmk *.synctex.gz
        echo "Build artifacts cleaned"
      '';
    in
    {
      devShells.latex = pkgs.mkShell {
        name = "latex-shell";
        buildInputs = [
          tex
          buildResume
          cleanBuild
        ];
      };

      # Package for building the resume
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "jason-bowman-resume";
        version = "1.0.0";

        src = ./.;

        buildInputs = [ tex ];

        buildPhase = ''
          pdflatex resume.tex
        '';

        installPhase = ''
          mkdir -p $out
          cp resume.pdf $out/
        '';
      };
    };
}
