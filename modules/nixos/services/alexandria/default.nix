{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.services.alexandria;
in
{
  imports = [
    inputs.alexandria.nixosModules.default
  ];

  options.my.services.alexandria = {
    enable = lib.mkEnableOption "Enable Alexandria MCP for semantic code search using Qdrant";
  };
  # TODO: Assertion: Requires qdrant enabled
  # TODO: Environment variables to configure, see https://github.com/milespossing/alexandria/blob/a1fdb33cf5904010413854ebba15ff20501ca622/flake.nix#L18
  # TODO: Alexandria implicitly enables services.{qdrant,ollama}
  #       Maybe use assertions instead and trust that the user can manage those services themselves?

  # QDRANT_URL              # default: http://localhost:6333
  # OLLAMA_HOST             # default: http://localhost:11434
  # ALEXANDRIA_EMBED_MODEL  # default: nomic-embed-text

  # Alexandria exposes three tools over MCP stdio transport:
  #  search_code -- search within a specific context by natural language query, with optional language filter
  #  search_all -- search across all indexed contexts, results merged and ranked by relevance
  #  list_contexts -- list available contexts with stats

  config = lib.mkIf cfg.enable {
    services.alexandria = {
      enable = true;
      reindexSchedule = "daily"; # systemd calendar expression
      mcpProxy = {
        enable = true;
        port = 57174;
      };
      indexes = {
        dotfiles = {
          path = /home/jq/dotfiles;
        };
      };
    };
  };
}
