# This is a flake module (perSystem)
{
  flakeInputs,
  pkgs,
  lib,
  ...
}:
let
  aperant = flakeInputs.nix-ai-tools.packages.${pkgs.stdenv.hostPlatform.system}.auto-claude;
in
{
  pai = {
    assistantName = "Iris";
    commandName = "i";

    extraPackages = with pkgs; [
      ripgrep
      tree
      fd
      azure-cli
      aperant
    ];
    extraSkills = [
      (
        let
          lndir = pkgs.lib.getExe pkgs.lndir;
        in
        with flakeInputs;
        pkgs.runCommandLocal "claude-code-skills" { } ''
          mkdir -p $out/{backend-skill,frontend-skill}
          ${lndir} "${AI-opencode-backend-skill.outPath}" "$out/backend-skill"
          ${lndir} "${AI-opencode-frontend-skill.outPath}" "$out/frontend-skill"
        ''
      )
    ];

    # Override or extend Claude Code settings
    claudeSettings = {
      outputStyle = "explanatory";
      companyAnnouncements = [ "Welcome! I'm Iris, ready to help." ];
      assistantColor = "red";
      commandName = "i"; # Used to invoke assistant

      permissions = {
        defaultMode = "default";
        # Add to default allow list
        allow = lib.mkAfter [
          "Bash(nix:*)"
        ];
      };

      # Claude plugins, see https://claude.com/p
      enabledPlugins = {
        "typescript-lsp@claude-plugins-official" = true;
        "rust-analyzer-lsp@claude-plugins-official" = true;
        "swift-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
        "lua-lsp@claude-plugins-official" = true;
      };

      env = {
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        CLAUDE_CODE_MAX_OUTPUT_TOKENS = "64000";
        CLAUDE_CODE_ENABLE_TELEMETRY = "0";
        ENABLE_LSP_TOOL = "1";

        # Use Azure Foundry
        # Disables /login, requires defining ANTHROPIC_FOUNDRY_API_KEY or pre-running `az login`
        CLAUDE_CODE_USE_FOUNDRY = "1";
        ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-5";
        ANTHROPIC_FOUNDRY_RESOURCE = "agentic-workspace-resource";
      };
      # TODO: pai overrides default, this sets it back
      attribution = rec {
        commit = "Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>";
        pr = commit;
      };

      ollamaServer = "http://desktop:11434";
    };
    # Claude Code Router (CCR)
    ccrSettings = {
      # Don't overwrite default Ollama instance
      Providers = lib.mkAfter [
        {
          name = "azure";
          # TODO: Maybe get from environment: ANTHROPIC_FOUNDRY_RESOURCE
          api_base_url = "http://agentic-workspace-resource.openai.azure.com";
          # api_key = "";
          models = [
            "claude-sonnet-4-5"
            "gpt-4"
          ];
        }
      ];
      Router = {
        # Default model for routing
        default = "gpt-4";

        # Model for thinking tasks (provider,model format)
        think = "gpt-4o";

        # Model for long context tasks
        longContext = "claude-sonnet-4-5";
        # Token threshold for switching to long context model
        longContextThreshold = 40000;
        # Model for background tasks
        # Model for web search tasks
        # Model for image tasks (leave empty to disable)"
        image = "";
      };
    };
    # Ideally, if you have the hardware
    #privateModel = "gpt-oss:20b";
    privateModel = "qwen2.5-coder:latest";

    otherTools = {
      enableCodex = false;
      enableGemini = false;
      enableOpencode = true;
    };

    opencodeSettings = {
      model = "ollama/qwen2.5-coder:latest:";
      theme = "catppuccin";
    };

    # Override or extend MCP servers
    mcpServers = {
      alexandria = {
        type = "stdio";
        command = "alex";
        args = [ "serve" ];
      };
    };
  };
}
