{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.home.claude-code;
in
{

  imports = with inputs; [
    nix-agent-wire.homeModules.claude-code
    alexandria.homeModules.default
  ];

  options.my.home.claude-code = with lib; {
    enable = mkEnableOption "Claude Code configuration";
    autoWireDirs = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [
          inputs.my-claude-code-ai-skills.outPath
          (self.outPath + "/AI")
        ];
      '';
      description = ''
        List of directories containing agents/, commands/, skills/, mcp/, settings/claude-code.nix  and memory.md.
        All directories are merged, with later directories taking precedence.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        tree
        fd
      ];
      # Claude Code default fallback, local ollama instance
      sessionVariables = {
        ANTHROPIC_BASE_URL = "http://desktop:11434";
        ANTHROPIC_AUTH_TOKEN = "ollama";
        ANTHROPIC_MODEL = "qwen2.5-coder:latest";
      };
    };
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;

      autoWire.dirs = cfg.autoWireDirs;
      # Autowire only seems to pass along SKILL.md
      # For more advanced structures, we use skillsDir
      skillsDir =
        let
          lndir = pkgs.lib.getExe pkgs.lndir;
        in
        with inputs;
        (pkgs.runCommandLocal "claude-code-skills" { } ''
          mkdir -p $out/{backend-skill,frontend-skill}
          ${lndir} "${AI-opencode-backend-skill.outPath}" "$out/backend-skill"
          ${lndir} "${AI-opencode-frontend-skill.outPath}" "$out/frontend-skill"
        '').outPath;

      # TODO: Depend on my.services.alexandria.enabled
      # Also, optionally provide OpenAI http proxy with:
      #  my.services.alexandria.mcpProxy = { enable = true ; port = 57174; };
      # {  url = "http://localhost:517174/mcp" ; type = "http"; }
      mcpServers = {
        alexandria = {
          command = "alex";
          args = [ "serve" ];
          type = "stdio";
        };
      };
    };
  };
}
