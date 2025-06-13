{
    buildDotnetModule,
    fetchFromGitHub,
    pkgs,
}:
buildDotnetModule rec {
    pname = "uvtools";
    version = "5.1.4";

    src = fetchFromGitHub {
        owner = "sn4k3";
        repo = "UVtools";
        rev = "v${version}";
        hash = "sha256-aJKeMHyuJY1Uhxqd1Qo+tG+Qssx/yFgcxQnrtH59RZY=";
    };

    nativeBuildInputs = with pkgs; [dos2unix];
    postUnpack = ''
        shopt -s globstar
        dos2unix **/*
    '';

    patches = [./dotnet-version.patch];

    projectFile = "UVtools.UI";
    nugetDeps = ./deps.json;

    dotnet-sdk = pkgs.dotnet-sdk_9;
    dotnet-runtime = pkgs.dotnet-runtime_9;
}
