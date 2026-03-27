# This is a flake module (perSystem)
{
  flakeInputs,
  pkgs,
  lib,
  ...
}:
{
  pai = {
    assistantName = "Iris";
    commandName = "i";

    extraPackages = with pkgs; [
      ripgrep
      tree
      fd
      azure-cli
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
      #attribution = "Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>";

      ollamaServer = "http://desktop:11434";
    };
    privateModel = "gpt-oss:20b";

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
