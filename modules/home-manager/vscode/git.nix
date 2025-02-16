{pkgs, ...}: {
    programs.vscode.profiles.default = {
        extensions = with pkgs.unstable.vscode-extensions; [
            eamodio.gitlens
        ];

        userSettings = {
            "git.enableStatusBarSync" = false;

            "gitlens.showWelcomeOnInstall" = false;
            "gitlens.showWhatsNewAfterUpgrades" = false;
            "gitlens.plusFeatures.enabled" = false;
            "gitlens.virtualRepositories.enabled" = false;

            "gitlens.ai.experimental.generateCommitMessage.enabled" = false;

            "gitlens.graph.statusBar.enabled" = false;
            "gitlens.launchpad.indicator.enabled" = false;
            "gitlens.mode.statusBar.enabled" = false;
            "gitlens.statusBar.pullRequests.enabled" = false;

            "gitlens.menus" = {
                "editor" = {
                    "blame" = false;
                    "clipboard" = false;
                    "compare" = false;
                    "history" = false;
                    "remote" = false;
                };
                "editorGroup" = {
                    "blame" = false;
                    "compare" = false;
                };
                "editorTab" = {
                    "clipboard" = false;
                    "compare" = false;
                    "history" = false;
                    "remote" = false;
                };
                "explorer" = {
                    "clipboard" = false;
                    "compare" = false;
                    "history" = false;
                    "remote" = false;
                };
                "ghpr" = {
                    "worktree" = false;
                };
            };
        };
    };
}
