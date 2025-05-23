{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.xdg;
in {
  options.my.home.xdg = with lib; {
    enable = my.mkDisableOption "XDG configuration";
  };

  config.xdg = lib.mkIf cfg.enable {
    enable = true;
    # File types
    mime.enable = true;
    # File associations
    mimeApps = {
      enable = true;
    };
    # User directories
    userDirs = {
      enable = true;
      desktop = "\$HOME/Desktop";
      documents = "\$HOME/Documents";
      download = "\$HOME/Downloads";
      music = "\$HOME/Music";
      pictures = "\$HOME/Pictures";
      publicShare = "\$HOME/Public";
      templates = "\$HOME/Templates";
      videos = "\$HOME/Videos";
    };
    dataFile = {
      "tig/.keep".text = ""; # `tig` uses `XDG_DATA_HOME` specifically...
    };
    stateFile = {
      "bash/.keep".text = "";
      "python/.keep".text = "";
    };
  };

  # Attempt to create a tidier home
  config.home.sessionVariables = with config.xdg;
    lib.mkIf cfg.enable {
      ANDROID_HOME = "${dataHome}/android";
      ANDROID_USER_HOME = "${configHome}/android";
      CARGO_HOME = "${dataHome}/cargo";
      DOCKER_CONFIG = "${configHome}/docker";
      GRADLE_USER_HOME = "${dataHome}/gradle";
      HISTFILE = "${stateHome}/bash/history";
      INPUTRC = "${configHome}/readline/inputrc";
      PSQL_HISTORY = "${stateHome}/psql_history";
      PYTHONPYCACHEPREFIX = "${cacheHome}/python/";
      PYTHONUSERBASE = "${dataHome}/python/";
      PYTHON_HISTORY = "${stateHome}/python/history";
      REDISCLI_HISTFILE = "${stateHome}/redis/rediscli_history";
      REPO_CONFIG_DIR = "${configHome}/repo";
      XCOMPOSECACHE = "${dataHome}/X11/xcompose";
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
    };
}
