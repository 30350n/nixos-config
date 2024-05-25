{pkgs, ...}: {
    programs.vscode = {
        extensions = with pkgs.vscode-extensions; [
            rust-lang.rust-analyzer
            serayuzgur.crates
            (import ./marketplace-extensions/probe-rs-debugger.nix {inherit pkgs;})
        ];
    };
}
