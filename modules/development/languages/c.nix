{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core toolchain
    clang

    # Build systems
    cmake
    gnumake
    ninja

    # Debugging
    lldb
    valgrind

    # Code tools
    cppcheck
    clang-tools # clang-format, clang-tidy, clangd

    # Build optimization
    ccache
    bear
    pkg-config

    # Package manager
    vcpkg

    # Graphics/Game libraries
    SDL2
    SDL2_image
    glfw
    glm
    openal
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
