# modules/development/languages/typescript.nix
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # JS runtimes
    nodejs_22 # Latest LTS version
    bun # Fast JavaScript runtime (AGS recommended)
    deno

    # package managers
    pnpm # Your preferred package manager
    yarn # Alternative package manager (useful for some projects)

    # TypeScript toolchain (essential global tools)
    typescript # TypeScript compiler
    typescript-language-server # Language server for TS/JS

    # Only globally install essential development tools available in nixpkgs
    # Note: Most npm packages should be installed per-project via package.json
    nodePackages.npm-check-updates # Update package.json dependencies
    nodePackages.live-server # Development server
    nodePackages.serve # Static file server
    nodePackages.nodemon # File watcher for development
    nodePackages.ts-node # Execute TypeScript directly

    # Build tools available in nixpkgs  
    vite # Fast build tool
    nodePackages.webpack-cli # Webpack bundler

    # Useful development utilities
    jq # JSON processor (useful for package.json manipulation)
  ];

  # Set up pnpm configuration
  home.file.".npmrc" = {
    text = ''
      # Use pnpm as default package manager
      package-manager=pnpm
      
      # Store configuration
      store-dir=${config.home.homeDirectory}/.pnpm-store
      
      # Cache configuration  
      cache-dir=${config.home.homeDirectory}/.pnpm-cache
      
      # Auto-install peer dependencies
      auto-install-peers=true
      
      # Use strict peer dependencies
      strict-peer-dependencies=false
      
      # Save exact versions
      save-exact=true
      
      # Faster installs
      prefer-offline=true
      
      # Enable shamefully-hoist for compatibility
      shamefully-hoist=false
      node-linker=isolated
    '';
  };

  # Create pnpm configuration
  home.file.".pnpmrc" = {
    text = ''
      store-dir=${config.home.homeDirectory}/.pnpm-store
      cache-dir=${config.home.homeDirectory}/.pnpm-cache
      auto-install-peers=true
      strict-peer-dependencies=false
      save-exact=true
      prefer-offline=true
      shamefully-hoist=false
      node-linker=isolated
    '';
  };

  # Environment variables for Node.js development
  home.sessionVariables = {
    # Set pnpm store location
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";

    # Node.js options
    NODE_OPTIONS = "--max-old-space-size=4096";

    # Enable pnpm tab completion
    PNPM_TAB_COMPLETION = "true";
  };

  # Add pnpm to PATH through zsh
  programs.zsh = {
    enable = true;
    profileExtra = ''
      # Add pnpm to PATH
      export PATH="$PNPM_HOME:$PATH"
    '';

    # Useful aliases for TypeScript/JavaScript development
    shellAliases = {
      # pnpm shortcuts
      pn = "pnpm";
      pnx = "pnpx"; # pnpm dlx equivalent

      # Development servers
      dev = "pnpm run dev";
      build = "pnpm run build";
      test = "pnpm test";
      lint = "pnpm run lint";
      format = "pnpm run format";

      # TypeScript shortcuts
      tsc = "pnpm exec tsc";
      tsnode = "pnpm exec ts-node";

      # Quick project setup
      create-react = "pnpm create react-app";
      create-next = "pnpm create next-app";
      create-vite = "pnpm create vite";
      create-svelte = "pnpm create svelte";

      # Package management
      outdated = "pnpm outdated";
      update-deps = "pnpm update";
      add-dev = "pnpm add -D";

      # Useful development commands
      serve = "pnpm exec serve";
      live-server = "pnpm exec live-server";
    };
  };

  # Helix configuration for TypeScript/JavaScript
  # Note: Prettier and ESLint will be project-local via pnpm
  programs.helix.languages = {
    language = [
      {
        name = "typescript";
        auto-format = true;
        # Use project-local prettier if available, fallback to basic formatting
        formatter = {
          command = "sh";
          args = [ "-c" "npx prettier --stdin-filepath file.ts || cat" ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "javascript";
        auto-format = true;
        formatter = {
          command = "sh";
          args = [ "-c" "npx prettier --stdin-filepath file.js || cat" ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "tsx";
        auto-format = true;
        formatter = {
          command = "sh";
          args = [ "-c" "npx prettier --stdin-filepath file.tsx || cat" ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "jsx";
        auto-format = true;
        formatter = {
          command = "sh";
          args = [ "-c" "npx prettier --stdin-filepath file.jsx || cat" ];
        };
        language-servers = [ "typescript-language-server" ];
      }
      {
        name = "json";
        auto-format = true;
        formatter = {
          command = "sh";
          args = [ "-c" "npx prettier --stdin-filepath file.json || cat" ];
        };
        language-servers = [ "typescript-language-server" ];
      }
    ];

    language-server = {
      typescript-language-server = {
        command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
        args = [ "--stdio" ];
        config = {
          # Enable inlay hints
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
            # Suggest auto-imports
            suggest = {
              includeCompletionsForModuleExports = true;
              includeCompletionsForImportStatements = true;
            };
            # Preferences
            preferences = {
              includePackageJsonAutoImports = "on";
              quoteStyle = "single";
            };
          };
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayVariableTypeHints = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayEnumMemberValueHints = true;
            };
            suggest = {
              includeCompletionsForModuleExports = true;
              includeCompletionsForImportStatements = true;
            };
            preferences = {
              includePackageJsonAutoImports = "on";
              quoteStyle = "single";
            };
          };
        };
      };
    };
  };

  # Create useful development scripts
  home.file.".local/bin/setup-ts-project" = {
    text = ''
      #!/usr/bin/env bash
      # TypeScript project setup script
      
      set -euo pipefail
      
      PROJECT_NAME="''${1:-}"
      PROJECT_TYPE="''${2:-vanilla}"
      
      if [ -z "$PROJECT_NAME" ]; then
          echo "Usage: setup-ts-project <project-name> [type]"
          echo "Types: vanilla, react, next, vite, node"
          exit 1
      fi
      
      echo "🚀 Setting up TypeScript project: $PROJECT_NAME ($PROJECT_TYPE)"
      
      case $PROJECT_TYPE in
          "react")
              pnpm create react-app "$PROJECT_NAME" --template typescript
              ;;
          "next")
              pnpx create-next-app@latest "$PROJECT_NAME" --typescript --tailwind --eslint --app
              ;;
          "vite")
              pnpm create vite "$PROJECT_NAME" --template vanilla-ts
              ;;
          "node")
              mkdir "$PROJECT_NAME"
              cd "$PROJECT_NAME"
              pnpm init
              
              # Install dev dependencies
              pnpm add -D typescript @types/node ts-node nodemon
              pnpm add -D prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
              pnpm add -D jest @types/jest ts-jest
              
              # Create basic tsconfig.json
              cat > tsconfig.json << EOF
      {
        "compilerOptions": {
          "target": "ES2022",
          "module": "commonjs",
          "lib": ["ES2022"],
          "outDir": "./dist",
          "rootDir": "./src",
          "strict": true,
          "esModuleInterop": true,
          "skipLibCheck": true,
          "forceConsistentCasingInFileNames": true,
          "resolveJsonModule": true,
          "declaration": true,
          "declarationMap": true,
          "sourceMap": true
        },
        "include": ["src/**/*"],
        "exclude": ["node_modules", "dist"]
      }
      EOF

              # Create prettier config
              cat > .prettierrc << EOF
      {
        "semi": true,
        "trailingComma": "es5",
        "singleQuote": true,
        "printWidth": 100,
        "tabWidth": 2
      }
      EOF

              # Create eslint config
              cat > .eslintrc.json << EOF
      {
        "root": true,
        "extends": [
          "eslint:recommended",
          "@typescript-eslint/recommended"
        ],
        "parser": "@typescript-eslint/parser",
        "parserOptions": {
          "ecmaVersion": 2022,
          "sourceType": "module"
        },
        "plugins": ["@typescript-eslint"],
        "rules": {}
      }
      EOF

              # Create jest config
              cat > jest.config.js << EOF
      module.exports = {
        preset: 'ts-jest',
        testEnvironment: 'node',
        roots: ['<rootDir>/src'],
        testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
        collectCoverageFrom: [
          'src/**/*.ts',
          '!src/**/*.d.ts'
        ]
      };
      EOF
              
              # Create basic file structure
              mkdir -p src
              echo 'console.log("Hello, TypeScript!");' > src/index.ts
              
              # Update package.json scripts
              jq '.scripts = {
                "build": "tsc",
                "dev": "ts-node src/index.ts", 
                "watch": "nodemon --exec ts-node src/index.ts",
                "start": "node dist/index.js",
                "test": "jest",
                "test:watch": "jest --watch",
                "lint": "eslint src/**/*.ts",
                "lint:fix": "eslint src/**/*.ts --fix",
                "format": "prettier --write src/**/*.ts",
                "clean": "rm -rf dist"
              }' package.json > package.json.tmp && mv package.json.tmp package.json
              ;;
          *)
              mkdir "$PROJECT_NAME"
              cd "$PROJECT_NAME"
              pnpm init
              pnpm add -D typescript prettier eslint
              echo 'console.log("Hello, TypeScript!");' > index.ts
              ;;
      esac
      
      echo "✅ Project $PROJECT_NAME created successfully!"
      echo "📁 cd $PROJECT_NAME"
      echo "🚀 pnpm install (if not already done)"
      echo "💻 code . (to open in editor)"
    '';
    executable = true;
  };

  # Enhanced package.json template generator
  home.file.".local/bin/init-package-json" = {
    text = ''
      #!/usr/bin/env bash
      # Enhanced package.json initialization
      
      PROJECT_NAME="''${PWD##*/}"
      
      cat > package.json << EOF
      {
        "name": "$PROJECT_NAME",
        "version": "1.0.0",
        "description": "",
        "main": "dist/index.js",
        "scripts": {
          "build": "tsc",
          "dev": "ts-node src/index.ts",
          "watch": "nodemon --exec ts-node src/index.ts",
          "start": "node dist/index.js",
          "test": "jest",
          "test:watch": "jest --watch",
          "lint": "eslint src/**/*.ts",
          "lint:fix": "eslint src/**/*.ts --fix",
          "format": "prettier --write src/**/*.ts",
          "clean": "rm -rf dist"
        },
        "keywords": [],
        "author": "",
        "license": "MIT",
        "packageManager": "pnpm@8.0.0"
      }
      EOF
      
      echo "📦 package.json created for $PROJECT_NAME"
      echo "💡 Run 'setup-ts-project . node' to add TypeScript dependencies"
    '';
    executable = true;
  };

  # Quick pnpm project analysis
  home.file.".local/bin/analyze-project" = {
    text = ''
      #!/usr/bin/env bash
      # Analyze current Node.js project
      
      echo "📊 Project Analysis"
      echo "=================="
      
      if [ -f "package.json" ]; then
          echo "📦 Package info:"
          jq -r '.name + " v" + .version' package.json 2>/dev/null || echo "Invalid package.json"
          echo
          
          echo "🔧 Scripts available:"
          jq -r '.scripts | keys[]' package.json 2>/dev/null || echo "No scripts found"
          echo
          
          echo "📋 Dependencies:"
          echo "Production: $(jq -r '.dependencies // {} | keys | length' package.json)"
          echo "Development: $(jq -r '.devDependencies // {} | keys | length' package.json)"
          echo
          
          if command -v pnpm >/dev/null 2>&1; then
              echo "🔍 Outdated packages:"
              pnpm outdated || echo "All packages up to date"
              echo
              
              echo "💾 Package manager files:"
              [ -f "pnpm-lock.yaml" ] && echo "✅ pnpm-lock.yaml" || echo "❌ pnpm-lock.yaml (run 'pnpm install')"
              [ -f "package-lock.json" ] && echo "⚠️  package-lock.json (consider using pnpm)"
              [ -f "yarn.lock" ] && echo "⚠️  yarn.lock (consider using pnpm)"
          fi
      else
          echo "❌ No package.json found in current directory"
          echo "💡 Run 'init-package-json' or 'setup-ts-project <name> <type>' to get started"
      fi
    '';
    executable = true;
  };

  # Quick dependency installer
  home.file.".local/bin/ts-deps" = {
    text = ''
      #!/usr/bin/env bash
      # Quick TypeScript dependencies installer
      
      if [ ! -f "package.json" ]; then
          echo "❌ No package.json found. Run in a Node.js project directory."
          exit 1
      fi
      
      echo "🔧 Installing common TypeScript dependencies..."
      
      # Essential TypeScript deps
      pnpm add -D typescript @types/node ts-node
      
      # Formatting and linting
      pnpm add -D prettier eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin
      
      # Testing
      pnpm add -D jest @types/jest ts-jest
      
      # Development tools
      pnpm add -D nodemon
      
      echo "✅ TypeScript dependencies installed!"
      echo "💡 Consider running 'setup-ts-project . node' for complete setup"
    '';
    executable = true;
  };
}
