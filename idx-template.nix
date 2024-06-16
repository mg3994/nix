{pkgs, repo, ...}: 
let 
  devNix = pkgs.writeText "dev.nix" ''
    {pkgs, ...}: {
        packages = [
            pkgs.python3
        ];

        idx.workspace.onCreate = {
            init = '''
                  git clone ${repo} "$out" && \
                  code -r "$out"
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
      git clone ${repo} "$out"
      install --mode u+rw ${devNix} "$out"/.idx/dev.nix
    '';
}
