{ config, pkgs, lib, ... }:

let
  cfg = config.editors.jetbrains;

  # Direct IDE packages based on configuration
  directIDEPackages = map (ide: pkgs.jetbrains.${ide}) cfg.directIDEs;

  # Toolbox package if enabled
  toolboxPackages = lib.optionals cfg.toolbox.enable [ pkgs.jetbrains-toolbox ];

  # Support libraries for JetBrains IDEs
  jetbrainsSupportLibs = with pkgs; [
    jdk17 # Modern JDK
    nodejs # For web development plugins
    python3 # For Python plugins
  ];
in
{
  options.editors.jetbrains = {
    enable = lib.mkEnableOption "JetBrains IDE support";

    toolbox.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable JetBrains Toolbox for managing IDEs";
    };

    directIDEs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "idea-ultimate" "pycharm-professional" ];
      description = "List of JetBrains IDEs to install directly from nixpkgs";
    };

    hyprlandIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Hyprland window rules and keybindings";
    };
  };

  config = lib.mkIf cfg.enable {

    # ==========================================
    # PACKAGES AND ENVIRONMENT
    # ==========================================

    home.packages = directIDEPackages ++ toolboxPackages ++ jetbrainsSupportLibs;

    # JetBrains-specific environment variables
    home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk17}";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
    };

    # ==========================================
    # DESKTOP INTEGRATION
    # ==========================================

    # Desktop entries for direct IDEs
    xdg.desktopEntries = (lib.mkIf (cfg.directIDEs != [ ]) (
      lib.listToAttrs (map
        (ide: {
          name = "jetbrains-${ide}";
          value = {
            name = "JetBrains ${ide}";
            comment = "JetBrains ${ide} IDE";
            exec = "${pkgs.jetbrains.${ide}}/bin/${ide}";
            icon = "jetbrains-${ide}";
            categories = [ "Development" ];
            terminal = false;
            type = "Application";
          };
        })
        cfg.directIDEs)
    )) // (lib.mkIf cfg.toolbox.enable {
      # Toolbox desktop entry
      jetbrains-toolbox = {
        name = "JetBrains Toolbox";
        comment = "JetBrains Toolbox - Manage JetBrains IDEs";
        exec = "${pkgs.jetbrains-toolbox}/bin/jetbrains-toolbox";
        icon = "jetbrains-toolbox";
        categories = [ "Development" ];
        terminal = false;
        type = "Application";
      };
    });

    # ==========================================
    # HELPER SCRIPTS
    # ==========================================

    # JetBrains setup script
    home.file.".local/bin/jetbrains-setup" = lib.mkIf cfg.toolbox.enable {
      text = ''
        #!/usr/bin/env bash
        # JetBrains Toolbox setup script for NixOS

        set -euo pipefail

        TOOLBOX_DIR="$HOME/.local/share/JetBrains/Toolbox"
        STORAGE_FILE="$TOOLBOX_DIR/.storage.json"

        echo "🚀 Setting up JetBrains Toolbox for NixOS..."

        # Create toolbox directory
        mkdir -p "$TOOLBOX_DIR"

        # Configure credential storage for NixOS compatibility
        if [ ! -f "$STORAGE_FILE" ]; then
            echo '{"preferredKeychain": "linux-fallback"}' > "$STORAGE_FILE"
            echo "✓ Created storage configuration"
        else
            if ! grep -q "preferredKeychain" "$STORAGE_FILE"; then
                ${pkgs.jq}/bin/jq '. + {"preferredKeychain": "linux-fallback"}' "$STORAGE_FILE" > "$STORAGE_FILE.tmp" && mv "$STORAGE_FILE.tmp" "$STORAGE_FILE"
                echo "✓ Updated storage configuration"
            else
                echo "✓ Storage configuration already exists"
            fi
        fi

        echo ""
        echo "🎉 Setup complete!"
        echo ""
        echo "📋 Next steps:"
        echo "1. Launch: jetbrains-toolbox"
        echo "2. Start login but STOP after webpage opens"
        echo "3. Reopen Toolbox, Settings → 'Troubleshoot...'"
        echo "4. Complete login"
        echo ""
        echo "⚠️  Always launch IDEs through Toolbox!"
      '';
      executable = true;
    };

    # Project launcher script
    home.file.".local/bin/jetbrains-project-launcher" = {
      text = ''
        #!/usr/bin/env bash
        # Quick project launcher for JetBrains IDEs

        set -euo pipefail

        PROJECTS_DIR="''${1:-$HOME/Projects}"

        if [ ! -d "$PROJECTS_DIR" ]; then
            ${pkgs.libnotify}/bin/notify-send "Projects directory not found: $PROJECTS_DIR"
            exit 1
        fi

        PROJECT=$(find "$PROJECTS_DIR" -maxdepth 1 -type d -not -path "$PROJECTS_DIR" -exec basename {} \; | sort | ${pkgs.rofi-wayland}/bin/rofi -dmenu -p "Open project in JetBrains")

        if [ -n "$PROJECT" ]; then
            PROJECT_PATH="$PROJECTS_DIR/$PROJECT"
            
            # Detect project type and suggest IDE
            if [ -f "$PROJECT_PATH/pom.xml" ] || [ -f "$PROJECT_PATH/build.gradle" ]; then
                IDE_SUGGESTION="IntelliJ IDEA"
            elif [ -f "$PROJECT_PATH/requirements.txt" ] || [ -f "$PROJECT_PATH/setup.py" ]; then
                IDE_SUGGESTION="PyCharm"
            elif [ -f "$PROJECT_PATH/package.json" ]; then
                IDE_SUGGESTION="WebStorm"
            elif [ -f "$PROJECT_PATH/Cargo.toml" ]; then
                IDE_SUGGESTION="RustRover"
            elif [ -f "$PROJECT_PATH/go.mod" ]; then
                IDE_SUGGESTION="GoLand"
            else
                IDE_SUGGESTION="IDE"
            fi
            
            ${pkgs.libnotify}/bin/notify-send "Opening $PROJECT" "Suggested: $IDE_SUGGESTION"
            ${pkgs.jetbrains-toolbox}/bin/jetbrains-toolbox &
            ${pkgs.xdg-utils}/bin/xdg-open "$PROJECT_PATH" &
        fi
      '';
      executable = true;
    };

    # Cleanup script for complete removal
    home.file.".local/bin/jetbrains-cleanup" = {
      text = ''
        #!/usr/bin/env bash
        # JetBrains cleanup script - run before removing module

        set -euo pipefail

        echo "🧹 JetBrains Cleanup Script"
        echo "=========================="
        echo ""

        read -p "Remove all JetBrains data? (y/N): " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🗑️  Removing JetBrains data..."
            rm -rf "$HOME/.local/share/JetBrains" || true
            rm -rf "$HOME/.cache/JetBrains" || true
            rm -rf "$HOME/.config/JetBrains" || true
            find "$HOME/.local/share/applications" -name "*jetbrains*" -delete 2>/dev/null || true
            
            echo ""
            echo "✅ Cleanup complete!"
            echo ""
            echo "📋 Don't forget to:"
            echo "1. Remove JetBrains module from configuration"
            echo "2. Remove nix-ld libraries from configuration.nix"
            echo "3. Rebuild: sudo nixos-rebuild switch"
        else
            echo "❌ Cleanup cancelled"
        fi
      '';
      executable = true;
    };

    # ==========================================
    # HYPRLAND INTEGRATION
    # ==========================================

    wayland.windowManager.hyprland.settings = lib.mkIf cfg.hyprlandIntegration {
      # JetBrains window rules
      windowrule = [
        # Toolbox
        "float, class:^(jetbrains-toolbox)$"
        "size 1200 800, class:^(jetbrains-toolbox)$"
        "center, class:^(jetbrains-toolbox)$"

        # IDEs - workspace assignment
        "opacity 0.98, class:^(jetbrains-.*)$"
        # "workspace 2, class:^(jetbrains-.*)$"
        # "workspace 2, class:^(java-lang-Thread)$"
        # "workspace 2, title:^(.*IntelliJ IDEA.*)$"
        # "workspace 2, title:^(.*PyCharm.*)$"
        # "workspace 2, title:^(.*WebStorm.*)$"
        # "workspace 2, title:^(.*CLion.*)$"
        # "workspace 2, title:^(.*GoLand.*)$"
        # "workspace 2, title:^(.*RustRover.*)$"

        # Splash screens and dialogs
        "float, title:^(splash)$"
        "center, title:^(splash)$"
        "noborder, title:^(splash)$"
        "float, title:^(.*Settings.*)$, class:^(jetbrains-.*)$"
        "float, title:^(.*Preferences.*)$, class:^(jetbrains-.*)$"
        "float, title:^(.*Update.*)$, class:^(jetbrains-.*)$"
        "center, title:^(.*Update.*)$"
      ];

      windowrulev2 = [
        "float, class:^(jetbrains-.*), title:^(win.*)$"
        "center, class:^(jetbrains-.*), title:^(win.*)$"
      ];
    };

    # ==========================================
    # WARNINGS AND DOCUMENTATION
    # ==========================================

    warnings = [
      ''
        JetBrains module is enabled. 
        
        SYSTEM CONFIGURATION REQUIRED:
        Add this to your configuration.nix:
        
        # ===== JETBRAINS REQUIREMENTS (Remove when removing JetBrains) =====
        programs.nix-ld = {
          enable = true;
          libraries = with pkgs; [
            curl expat fontconfig freetype fuse fuse3 glib icu
            libclang.lib libdbusmenu libxcrypt-legacy libxml2 nss openssl
            python3 stdenv.cc.cc xorg.libX11 xorg.libXcursor xorg.libXext
            xorg.libXi xorg.libXrender xorg.libXtst xz zlib alsa-lib
            at-spi2-atk at-spi2-core atk cairo cups dbus gtk3 libdrm
            libGL libappindicator-gtk3 libxkbcommon mesa nspr pango systemd
            vulkan-loader
          ];
        };
        # ===== END JETBRAINS REQUIREMENTS =====
        
        REMOVAL PROCESS:
        1. Run: ~/.local/bin/jetbrains-cleanup
        2. Remove this module from editors/default.nix
        3. Remove nix-ld configuration from configuration.nix
        4. Rebuild system
      ''
    ];
  };
}
