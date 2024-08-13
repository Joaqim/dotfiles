{
  force = true;
  default = "DuckDuckGo";
  engines = {
    "AlternativeTo" = {
      definedAliases = ["@al"];
      icon = ./icons/al.png;
      urls = [{template = "https://alternativeto.net/browse/search/?q={searchTerms}";}];
    };
    "Amazon" = {
      definedAliases = ["@am"];
      icon = ./icons/am.png;
      urls = [{template = "https://www.amazon.com/s?k={searchTerms}&ref=nav_bb_sb";}];
    };
    "Brave" = {
      definedAliases = ["@br"];
      icon = ./icons/br.png;
      urls = [{template = "https://search.brave.com/search?q={searchTerms}&source=web";}];
    };
    "Nix Packages" = {
      definedAliases = ["@np"];
      icon = ./icons/nx.png;
      urls = [{template = "https://search.nixos.org/packages?channel=unstable&size=50&sort=relevance&type=packages&query={searchTerms}";}];
    };
    "Nix Options" = {
      definedAliases = ["@no"];
      icon = ./icons/nx.png;
      urls = [{template = "https://search.nixos.org/options?channel=unstable&size=50&sort=relevance&type=packages&query={searchTerms}";}];
    };
    "Nix Wiki" = {
      definedAliases = ["@nw"];
      icon = ./icons/nx.png;
      urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
    };
    "My Nix OS" = {
      definedAliases = ["@mo"];
      icon = ./icons/mo.png;
      urls = [{template = "https://mynixos.com/search?q={searchTerms}";}];
    };
    "The Pirate Bay" = {
      definedAliases = ["@pi"];
      icon = ./icons/pi.png;
      urls = [{template = "https://thepiratebay.org/search.php?q={searchTerms}&all=on&search=Pirate+Search&page=0&orderby=";}];
    };
    "Knaben" = {
      definedAlias = ["@kn"];
      icon = ./icons/kn.png;
      urls = [{template = "https://knaben.eu/search/{searchTerms}";}];
    };
    "Reddit" = {
      definedAliases = ["@re"];
      icon = ./icons/re.png;
      urls = [{template = "https://www.old.reddit.com/search/?q={searchTerms}";}];
    };
    "VSTorrent" = {
      definedAliases = ["@vs"];
      icon = ./icons/vs.png;
      urls = [{template = "https://vstorrent.org/?s={searchTerms}";}];
    };
    "Wikipedia" = {
      definedAliases = ["@wi"];
      icon = ./icons/wi.png;
      urls = [{template = "https://en.wikipedia.org/wiki/{searchTerms}";}];
    };
    "YouTube" = {
      definedAliases = ["@yo"];
      icon = ./icons/yo.png;
      urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
    };
    "1337x" = {
      definedAliases = ["@13"];
      icon = ./icons/13.png;
      urls = [{template = "https://1337x.to/search/{searchTerms}/1/";}];
    };
    "TorrentGalaxy" = {
      definedAliases = ["@tg"];
      icon = ./icons/tg.png;
      urls = [{template = "https://torrentgalaxy.to/torrents.php?search={searchTerms}";}];
    };
    "AnimeTosho" = {
      definedAliases = ["@at"];
      icon = ./icons/at.png;
      urls = [{template = "https://mirror.animetosho.org/search?q={searchTerms}";}];
    };
    "Amazon.com".metaData.hidden = true;
    "Bing".metaData.hidden = true;
    "eBay".metaData.hidden = true;
    "Wikipedia (en)".metaData.hidden = true;
  };
  order = [
    "AlternativeTo"
    "Amazon"
    "Nix Packages"
    "Knaben"
    "TorrentGalaxy"
    "The Pirate Bay"
    "AnimeTosho"
    "Reddit"
    "VSTorrent"
    "Wikipedia"
    "YouTube"
    "1337x"
    "Nix Packages"
    "Nix Options"
    "Brave"
    "Google"
    "Kagi"
  ];
}
