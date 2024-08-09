{pkgs}:
pkgs.unstable.jujutsu.overrideAttrs (
    prevAttrs: {
        patches = [
            ./interactive-commit-by-default.patch
        ];
        doCheck = false;
    }
)
