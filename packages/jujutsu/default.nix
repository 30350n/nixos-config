{pkgs}:
pkgs.unstable.jujutsu.overrideAttrs (
    prevAttrs: {
        patches = (prevAttrs.patches or []) ++ [./max_message_length.patch];
        doCheck = false;
    }
)
