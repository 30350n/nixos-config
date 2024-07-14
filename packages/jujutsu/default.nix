{pkgs}:
pkgs.unstable.jujutsu.overrideAttrs (
    prevAttrs: {
        patches = [
            ./max-message-length.patch
        ];
        doCheck = false;
    }
)
