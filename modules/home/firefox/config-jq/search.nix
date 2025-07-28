{
  force = true;
  default = "ddg"; # DuckDuckGo
  engines = {
    ## Nix
    "Nix Packages" = {
      definedAliases = [ "@np" ];
      icon = ./icons/nx.png;
      urls = [
        {
          template = "https://search.nixos.org/packages?channel=unstable&size=50&sort=relevance&type=packages&query={searchTerms}";
        }
      ];
    };
    "Nix Options" = {
      definedAliases = [ "@no" ];
      icon = ./icons/nx.png;
      urls = [
        {
          template = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query={searchTerms}";
        }
      ];
    };
    "Nix Wiki" = {
      definedAliases = [ "@nw" ];
      icon = ./icons/nx.png;
      urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
    };
    "My Nix OS" = {
      definedAliases = [ "@mo" ];
      icon = ./icons/mo.png;
      urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
    };
    "Noogle" = {
      definedAliases = [ "@ng" ];
      icon = ./icons/ng.png;
      urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
    };
    ## Torrents
    "The Pirate Bay" = {
      definedAliases = [ "@pi" ];
      icon = ./icons/pi.png;
      urls = [
        {
          template = "https://thepiratebay.org/search.php?q={searchTerms}&all=on&search=Pirate+Search&page=0&orderby=";
        }
      ];
    };
    "Knaben" = {
      definedAlias = [ "@kn" ];
      icon = ./icons/kn.png;
      urls = [ { template = "https://knaben.org/search/{searchTerms}"; } ];
    };
    "VSTorrent" = {
      definedAliases = [ "@vs" ];
      icon = ./icons/vs.png;
      urls = [ { template = "https://vstorrent.org/?s={searchTerms}"; } ];
    };
    "1337x" = {
      definedAliases = [ "@13" ];
      icon = ./icons/13.png;
      urls = [ { template = "https://1337x.to/search/{searchTerms}/1/"; } ];
    };
    "TorrentGalaxy" = {
      definedAliases = [ "@tg" ];
      icon = ./icons/tg.png;
      urls = [ { template = "https://torrentgalaxy.to/torrents.php?search={searchTerms}"; } ];
    };
    "Cloudtorrents" = {
      definedAliases = [ "@ct" ];
      icon = ./icons/ct.png;
      urls = [ { template = "https://cloudtorrents.com/search?query={searchTerms}"; } ];
    };
    "AnimeTosho" = {
      definedAliases = [ "@at" ];
      icon = ./icons/at.png;
      urls = [ { template = "https://mirror.animetosho.org/search?q={searchTerms}"; } ];
    };
    ## Misc
    "Wikipedia" = {
      definedAliases = [ "@wi" ];
      icon = ./icons/wi.png;
      urls = [ { template = "https://en.wikipedia.org/wiki/{searchTerms}"; } ];
    };
    "AlternativeTo" = {
      definedAliases = [ "@al" ];
      icon = ./icons/al.png;
      urls = [ { template = "https://alternativeto.net/browse/search/?q={searchTerms}"; } ];
    };
    ## Social
    "reddit" = {
      definedAliases = [ "@re" ];
      icon = ./icons/re.png;
      urls = [ { template = "https://www.old.reddit.com/search/?q={searchTerms}"; } ];
    };
    "youtube" = {
      definedAliases = [ "@yo" ];
      icon = ./icons/yo.png;
      urls = [ { template = "https://www.youtube.com/results?search_query={searchTerms}"; } ];
    };
    ## Books
    "Library Genesis" = {
      definedAliases = [
        "@lg"
        "@lib"
      ];
      icon = ./icons/lg.png;
      urls = [ { template = "https://libgen.is/fiction/?q={searchTerms}"; } ];
    };
    "Anna's Archive" = {
      definedAlias = [
        "@aa"
        "@ar"
      ];
      icon = ./icons/aa.png;
      urls = [ { template = "https://annas-archive.org/search?q={searchTerms}"; } ];
    };
    # Unused
    "amazondotcom-en".metaData.hidden = true;
    "bing".metaData.hidden = true;
    "ebay".metaData.hidden = true;
    "wikipedia".metaData.hidden = true;
  };
  order = [
    "AlternativeTo"
    "Nix Packages"
    "Nix Options"
    "My Nix OS"
    "Knaben"
    "TorrentGalaxy"
    "Library Genesis"
    "The Pirate Bay"
    "AnimeTosho"
    "reddit"
    "VSTorrent"
    "Wikipedia"
    "youtube"
    "1337x"
    "google"
  ];
}
