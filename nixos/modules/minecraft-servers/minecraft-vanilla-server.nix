let
  SERVER_NAME = "Minecraft Vanilla Server";
in {
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;
    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "${SERVER_NAME}";
      max-players = 10;
      #enable-rcon = true;
      #enable-query = true;

      allow-flight = true;
      difficulty = "easy";
      memory = "8G";

      online-mode = false;
      level-seed = "8016074285773694051";
      server-name = "${SERVER_NAME}";
      snooper-enabled = false;
      spawn-protection = 0;
      tz = "Europe/Stockholm";
      view-distance = 15;

      # This password can be used to administer your minecraft server.
      # Exact details as to how will be explained later. If you want
      # you can replace this with another password.
      #        rcon.password = "hunter2";
      #        query.port = 25565;
    };
  };
}
