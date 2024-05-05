{lib, ...}: {
    nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
            "discord"
            "gitkraken"
            "minecraft-launcher"
            "reaper"
            "steam"
            "steam-original"
            "steam-run"
        ];
}
