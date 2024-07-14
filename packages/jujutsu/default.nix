{pkgs}:
pkgs.unstable.jujutsu.overrideAttrs (
    prevAttrs: {
        patches = [
            ./interactive-commit-by-default.patch
            ./max-message-length.patch
        ];
        doCheck = false;
    }
)
