{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
            rust-lang.rust-analyzer
            serayuzgur.crates
            vadimcn.vscode-lldb
            (import ./marketplace-extensions/probe-rs-debugger.nix {inherit pkgs;})
        ];

        userSettings = {
            "rust-analyzer.inlayHints.closingBraceHints.enable" = false;
            "rust-analyzer.inlayHints.chainingHints.enable" = false;
            "rust-analyzer.inlayHints.typeHints.enable" = false;
        };
    };
}
