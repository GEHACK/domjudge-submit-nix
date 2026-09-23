{
  lib,
  python3Packages,
  fetchFromGitHub,
  submitBaseUrl ? null,
  submitContest ? null,
}:

let
  source = lib.importJSON ./source.json;
in
python3Packages.buildPythonApplication {
  pname = "domjudge-submit";
  version = "0-unstable-${lib.substring 0 12 source.rev}";
  pyproject = false;

  src = fetchFromGitHub {
    inherit (source) owner repo rev hash;
  };

  dependencies = with python3Packages; [
    requests
    python-magic
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm755 submit/submit $out/bin/submit
  '';

  makeWrapperArgs =
    lib.optionals (submitBaseUrl != null) [
      "--set-default"
      "SUBMITBASEURL"
      submitBaseUrl
    ]
    ++ lib.optionals (submitContest != null) [
      "--set-default"
      "SUBMITCONTEST"
      submitContest
    ];

  meta = {
    description = "DOMjudge command line submit client";
    homepage = "https://github.com/domjudge/domjudge";
    license = lib.licenses.gpl2Plus;
    mainProgram = "submit";
    platforms = lib.platforms.unix;
  };
}
