{pkgs}:
pkgs.vscodium.overrideAttrs (prevAttrs: {
    buildInputs = prevAttrs.buildInputs ++ [pkgs.openssl];
    preInstall = let
        product_json = "resources/app/product.json";
        main_js = "resources/app/out/vs/workbench/workbench.desktop.main.js";
        main_css = "resources/app/out/vs/workbench/workbench.desktop.main.css";
        minimize_button_regex =
            "const [^=]\\+=([^()]\\+)(this.[^,]\\+,([^()]\\+)(\\\"div.window-icon."
            + "window-minimize\\\"+[^.]\\+.ThemeIcon.asCSSSelector([^.]\\+.[^.]\\+."
            + "chromeMinimize)));this.[^()]\\+(([^()]\\+)([^()]\\+()=>{this.[^.]\\+."
            + "minimizeWindow([^()]\\+)})),";
    in ''
        sed -e "s/${minimize_button_regex}//g" -i "${main_js}"
        hash=$(openssl sha256 --binary "${main_js}" | openssl enc -base64 | sed -e "s/=//g")
        sed -E "s/(workbench.desktop.main.js\":\s*\")[^\"]+\"/\1$hash\"/g" -i "${product_json}"

        sed -e "s/138px/115px/g" -i "${main_css}"
        sed -E "s/(window-controls-container\{[^}]*)/\1;justify-content:end/g" -i "${main_css}"
        hash=$(openssl sha256 --binary "${main_css}" | openssl enc -base64 | sed -e "s/=//g")
        sed -E "s/(workbench.desktop.main.css\":\s*\")[^\"]+\"/\1$hash\"/g" -i "${product_json}"
    '';
})
