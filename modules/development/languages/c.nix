{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core C/C++ toolchain
    gcc # GNU Compiler Collection
    clang # LLVM C/C++ compiler (alternative to gcc)
    llvmPackages.libcxxClang # C++ standard library for clang

    # Build systems
    cmake # Cross-platform build system
    gnumake # GNU Make
    ninja # Fast build system
    meson # Modern build system

    # Debugging and profiling
    gdb # GNU Debugger
    lldb # LLVM Debugger
    valgrind # Memory debugging and profiling

    # Code analysis and formatting
    cppcheck # Static analysis
    clang-tools # clang-format, clang-tidy, etc.

    # Language server
    clang-tools # Includes clangd LSP

    # Package managers
    vcpkg # C++ package manager

    # Additional useful tools
    ccache # Compiler cache for faster rebuilds
    bear # Generate compile_commands.json
  ];

  # ZSH aliases for C/C++ development
  programs.zsh.shellAliases = {
    # Compilation shortcuts
    "gcc-debug" = "gcc -g -Wall -Wextra -pedantic";
    "g++-debug" = "g++ -g -Wall -Wextra -pedantic -std=c++20";
    "clang-debug" = "clang -g -Wall -Wextra -pedantic";
    "clang++-debug" = "clang++ -g -Wall -Wextra -pedantic -std=c++20";

    # CMake shortcuts
    "cmake-debug" = "cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
    "cmake-release" = "cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";

    # Build shortcuts
    "make-j" = "make -j$(nproc)";
    "ninja-j" = "ninja -j$(nproc)";

    # Analysis tools
    "valgrind-leak" = "valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes";
    "valgrind-cache" = "valgrind --tool=cachegrind";
  };

  # Helix configuration for C/C++
  programs.helix.languages = {
    language = [
      {
        name = "c";
        auto-format = true;
        formatter = {
          command = "${pkgs.clang-tools}/bin/clang-format";
          args = [ "--style=file" ];
        };
        language-servers = [ "clangd" ];
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
      {
        name = "cpp";
        auto-format = true;
        formatter = {
          command = "${pkgs.clang-tools}/bin/clang-format";
          args = [ "--style=file" ];
        };
        language-servers = [ "clangd" ];
        indent = {
          tab-width = 4;
          unit = "    ";
        };
      }
    ];

    language-server = {
      clangd = {
        command = "${pkgs.clang-tools}/bin/clangd";
        args = [
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=iwyu"
          "--pch-storage=memory"
        ];
        config = {
          compilationDatabasePath = "build";
        };
      };
    };
  };
}
