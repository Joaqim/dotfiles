{
  force = true;
  default = "Brave";
  engines = {
    "Amazon" = {
      definedAliases = ["@am"];
      icon = ./icons/am.png;
      urls = [{template = "https://www.amazon.ca/s?k={searchTerms}&ref=nav_bb_sb";}];
    };
    "Brave" = {
      definedAliases = ["@br"];
      icon = ./icons/br.png;
      urls = [{template = "https://search.brave.com/search?q={searchTerms}&source=web";}];
    };
    "Netflix" = {
      definedAliases = ["@ne"];
      icon = ./icons/ne.png;
      urls = [{template = "https://www.netflix.com/search?q={searchTerms}";}];
    };
    "Reddit" = {
      definedAliases = ["@re"];
      icon = ./icons/re.png;
      urls = [{template = "https://www.reddit.com/search/?q={searchTerms}";}];
    };
    "Urban Dictionary" = {
      definedAliases = ["@ur"];
      icon = ./icons/ur.png;
      urls = [{template = "https://www.urbandictionary.com/define.php?term={searchTerms}";}];
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
    "Amazon.ca".metaData.hidden = true;
    "Bing".metaData.hidden = true;
    "eBay".metaData.hidden = true;
    "Wikipedia (en)".metaData.hidden = true;
  };
  order = [
    "Amazon"
    "Reddit"
    "Urban Dictionary"
    "Wikipedia"
    "YouTube"
    "Brave"
    "Google"
  ];
}
