{pkgs, repo, ...}: 
let 
  devNix = pkgs.writeText "dev.nix" ''
    {pkgs, ...}: {
        packages = [
            pkgs.python3
        ];

        idx.workspace.onCreate = {
            init = '''
              python3 ./git-cookie-authdaemon && \
                  git clone ${repo} $out && \
                  code -r $out
            ''';
        };
    }
  '';
in {
    packages = [
        pkgs.coreutils
        pkgs.curl
        pkgs.gzip
        pkgs.gnutar
    ];

    bootstrap = ''
      mkdir -p "$out/.idx"
      REV="6c05256"
      curl -L https://github.com/GerritCodeReview/gcompute-tools/tarball/"$REV" | tar -xz
      sed 's/metadata.google.internal/metadata.google.internal:8080/' -i GerritCodeReview-gcompute-tools-"$REV"/git-cookie-authdaemon
      install --mode u+rwx GerritCodeReview-gcompute-tools-"$REV"/git-cookie-authdaemon "$out"
      install --mode u+rw ${devNix} "$out"/.idx/dev.nix
    '';
}
