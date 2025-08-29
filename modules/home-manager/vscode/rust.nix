{
    pkgs,
    extensions,
    ...
}: {
    programs.vscode.profiles.default = {
        extensions = with extensions.vscode-marketplace; [
            rust-lang.rust-analyzer
            serayuzgur.crates
            pkgs.unstable.vscode-extensions.vadimcn.vscode-lldb
            probe-rs.probe-rs-debugger
        ];

        userSettings = {
            "rust-analyzer.inlayHints.closingBraceHints.enable" = false;
            "rust-analyzer.inlayHints.chainingHints.enable" = false;
            "rust-analyzer.inlayHints.typeHints.enable" = false;
        };
    };
}
