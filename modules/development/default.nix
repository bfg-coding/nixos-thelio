# modules/development/default.nix
{ config, pkgs, lib, ... }:

{
  imports = [
    ./languages
    ./lsp.nix
    ./docker.nix
    ./ml.nix
  ];

  # Enable direnv for automatic project environment switching
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Add core development libraries and tools - using STABLE OpenSSL
  home.packages = with pkgs; [
    # C/C++ toolchain (essential for many build processes)
    gcc
    binutils
    gnumake

    # Build tools
    pkg-config
    cmake

    # Common development libraries
    zlib.dev

    # OpenSSL
    openssl
    openssl.dev
  ];

  # Set environment variables for finding libraries - using STABLE OpenSSL
  home.sessionVariables = {
    # OpenSSL configuration - using stable OpenSSL paths
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";

    # PKG_CONFIG configuration - using stable OpenSSL
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

    # Additional environment variables for better compatibility
    OPENSSL_ROOT_DIR = "${pkgs.openssl}";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

    # Ensure stable OpenSSL is in library path
    LD_LIBRARY_PATH = "${pkgs.openssl.out}/lib";
  };

  # Add to shell initialization scripts - using STABLE OpenSSL
  programs.bash.initExtra = lib.mkIf config.programs.bash.enable ''
    # Development environment variables - STABLE OpenSSL
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
    export OPENSSL_ROOT_DIR="${pkgs.openssl}"
    export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH"
  '';

  programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
    # Development environment variables - STABLE OpenSSL
    export OPENSSL_DIR="${pkgs.openssl.dev}"
    export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib"
    export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include"
    export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
    export OPENSSL_ROOT_DIR="${pkgs.openssl}"
    export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH"
  '';

  # Create an enhanced development environment setup script
  home.file.".local/bin/init-dev-env" = {
    text = ''
            #!/usr/bin/env bash
            # Generate basic flake.nix and .envrc for automatic environment loading
            # Enhanced with stable OpenSSL support

            set -euo pipefail

            if [ -f "flake.nix" ]; then
              echo "⚠️  flake.nix already exists. Overwrite? (y/N)"
              read -n 1 -r
              echo
              if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 0
              fi
            fi

            PROJECT_NAME=$(basename "$(pwd)")

            echo "🚀 Creating development environment for: $PROJECT_NAME"
            echo ""
            echo "What languages/tools do you need? (separate with spaces)"
            echo "Options: dotnet node python rust go postgres redis mysql azure aws"
            read -p "Languages/tools: " TOOLS

            # Generate flake.nix with stable OpenSSL
            cat > flake.nix << 'EOF'
      {
        description = "Development environment for PROJECT_NAME";

        inputs = {
          nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
          nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
          flake-utils.url = "github:numtide/flake-utils";
        };

        outputs = { self, nixpkgs, nixpkgs-stable, flake-utils }:
          flake-utils.lib.eachDefaultSystem (system:
            let 
              pkgs = nixpkgs.legacyPackages.''${system};
              stable = nixpkgs-stable.legacyPackages.''${system};
            in {
              devShells.default = pkgs.mkShell {
                buildInputs = with pkgs; [
                  # Project-specific packages (edit as needed)
                  # Examples:
                  # nodejs_20        # or nodejs_18 for older clients
                  # stable.dotnet-sdk_8
                  # python311
                  # postgresql_15
                  # redis
                  # azure-cli
                ] ++ [
                  # STABLE OpenSSL for compatibility
                  stable.openssl
                  stable.openssl.dev
                ];

                shellHook = '''
                  echo "🚀 PROJECT_NAME Development Environment"
            
                  # STABLE OpenSSL environment variables
                  export OPENSSL_DIR="''${stable.openssl.dev}"
                  export OPENSSL_LIB_DIR="''${stable.openssl.out}/lib"
                  export OPENSSL_INCLUDE_DIR="''${stable.openssl.dev}/include"
                  export PKG_CONFIG_PATH="''${stable.openssl.dev}/lib/pkgconfig"
                  export OPENSSL_ROOT_DIR="''${stable.openssl}"
                  export LD_LIBRARY_PATH="''${stable.openssl.out}/lib:''${LD_LIBRARY_PATH:-}"
            
                  # Project-specific environment variables
                  # Examples:
                  # export NODE_ENV="development"
                  # export ASPNETCORE_ENVIRONMENT="Development"
            
                  echo "🔐 Using stable OpenSSL: $(''${stable.openssl}/bin/openssl version)"
                  echo "✅ Environment ready!"
                ''';
              };
            });
      }
      EOF

            # Replace PROJECT_NAME placeholder
            sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" flake.nix

            # Add common packages based on what they selected
            if [[ "$TOOLS" == *"dotnet"* ]]; then
              sed -i '/# Project-specific packages/a\            stable.dotnet-sdk_8' flake.nix
              sed -i '/# Project-specific environment variables/a\            export ASPNETCORE_ENVIRONMENT="Development"' flake.nix
              sed -i '/# Project-specific environment variables/a\            export DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER="0"' flake.nix
            fi

            if [[ "$TOOLS" == *"node"* ]]; then
              sed -i '/# Project-specific packages/a\            nodejs_20        # Change to nodejs_18 if needed' flake.nix
              sed -i '/# Project-specific environment variables/a\            export NODE_ENV="development"' flake.nix
            fi

            if [[ "$TOOLS" == *"python"* ]]; then
              sed -i '/# Project-specific packages/a\            python311' flake.nix
              sed -i '/# Project-specific packages/a\            python311Packages.pip' flake.nix
            fi

            if [[ "$TOOLS" == *"rust"* ]]; then
              sed -i '/# Project-specific packages/a\            rustc' flake.nix
              sed -i '/# Project-specific packages/a\            cargo' flake.nix
              sed -i '/# Project-specific packages/a\            rustfmt' flake.nix
              sed -i '/# Project-specific packages/a\            clippy' flake.nix
            fi

            if [[ "$TOOLS" == *"go"* ]]; then
              sed -i '/# Project-specific packages/a\            go' flake.nix
              sed -i '/# Project-specific packages/a\            gopls' flake.nix
            fi

            if [[ "$TOOLS" == *"postgres"* ]]; then
              sed -i '/# Project-specific packages/a\            postgresql_15' flake.nix
            fi

            if [[ "$TOOLS" == *"mysql"* ]]; then
              sed -i '/# Project-specific packages/a\            mysql80' flake.nix
            fi

            if [[ "$TOOLS" == *"redis"* ]]; then
              sed -i '/# Project-specific packages/a\            redis' flake.nix
            fi

            if [[ "$TOOLS" == *"azure"* ]]; then
              sed -i '/# Project-specific packages/a\            azure-cli' flake.nix
            fi

            if [[ "$TOOLS" == *"aws"* ]]; then
              sed -i '/# Project-specific packages/a\            aws-cli' flake.nix
            fi

            # Create .envrc
            cat > .envrc << 'EOF'
      use flake
      dotenv_if_exists .env.local
      dotenv_if_exists .env
      EOF

            echo "✅ Created flake.nix and .envrc with stable OpenSSL"
            echo ""
            echo "📝 Next steps:"
            echo "1. Edit flake.nix to customize package versions"
            echo "2. Run 'direnv allow' to activate the environment"
            echo "3. The environment will auto-load when you cd into this directory"
            echo "4. Stable OpenSSL will be automatically configured"
            echo ""

            # Ask if they want to allow immediately
            read -p "Allow direnv now? (Y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
              ${pkgs.direnv}/bin/direnv allow
              echo "🚀 Environment activated with stable OpenSSL!"
            fi
    '';
    executable = true;
  };

  # Create a script to check OpenSSL status
  home.file.".local/bin/check-openssl" = {
    text = ''
      #!/usr/bin/env bash
      # Check OpenSSL configuration and version
      
      echo "🔍 OpenSSL Configuration Check"
      echo "============================="
      echo ""
      
      echo "🔐 OpenSSL Version:"
      if command -v openssl >/dev/null 2>&1; then
        openssl version -a
      else
        echo "❌ OpenSSL not found in PATH"
      fi
      echo ""
      
      echo "📁 Environment Variables:"
      echo "OPENSSL_DIR: ''${OPENSSL_DIR:-Not set}"
      echo "OPENSSL_LIB_DIR: ''${OPENSSL_LIB_DIR:-Not set}"
      echo "OPENSSL_INCLUDE_DIR: ''${OPENSSL_INCLUDE_DIR:-Not set}"
      echo "OPENSSL_ROOT_DIR: ''${OPENSSL_ROOT_DIR:-Not set}"
      echo "PKG_CONFIG_PATH: ''${PKG_CONFIG_PATH:-Not set}"
      echo "LD_LIBRARY_PATH: ''${LD_LIBRARY_PATH:-Not set}"
      echo ""
      
      echo "📚 Library Files:"
      if [ -n "''${OPENSSL_LIB_DIR}" ] && [ -d "''${OPENSSL_LIB_DIR}" ]; then
        echo "✅ OpenSSL library directory exists: ''${OPENSSL_LIB_DIR}"
        ls -la "''${OPENSSL_LIB_DIR}"/libssl* "''${OPENSSL_LIB_DIR}"/libcrypto* 2>/dev/null || echo "❌ No SSL libraries found"
      else
        echo "❌ OpenSSL library directory not found"
      fi
      echo ""
      
      echo "🔧 Headers:"
      if [ -n "''${OPENSSL_INCLUDE_DIR}" ] && [ -d "''${OPENSSL_INCLUDE_DIR}" ]; then
        echo "✅ OpenSSL include directory exists: ''${OPENSSL_INCLUDE_DIR}"
        ls -la "''${OPENSSL_INCLUDE_DIR}"/openssl/ 2>/dev/null | head -5 || echo "❌ No SSL headers found"
      else
        echo "❌ OpenSSL include directory not found"
      fi
      echo ""
      
      echo "🎯 Stable OpenSSL Path (should be in use):"
      echo "${pkgs.openssl}/bin/openssl version: $(${pkgs.openssl}/bin/openssl version 2>/dev/null || echo 'Not found')"
      echo ""
      
      echo "💡 If you're having SSL issues:"
      echo "1. Make sure you're in a development environment (direnv or nix-shell)"
      echo "2. Try: source ~/.zshrc (to reload environment variables)"
      echo "3. Check your project's flake.nix uses stable OpenSSL"
      echo "4. For .NET projects, ensure OPENSSL_ROOT_DIR is set correctly"
    '';
    executable = true;
  };
}
