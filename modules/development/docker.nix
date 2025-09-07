# modules/development/docker.nix
{ config, pkgs, lib, ... }:

{
  # Docker-related packages for development
  home.packages = with pkgs; [
    # Docker tools
    docker-compose
    docker-buildx
    lazydocker # TUI for Docker management
    dive # Tool for exploring Docker images
    hadolint # Dockerfile linter

    # Container registries and tools
    skopeo # Work with container registries
    buildah # Build container images
    podman # Alternative container runtime

    # Kubernetes tools (if you use Docker with k8s)
    kubectl
    k9s # Kubernetes TUI
  ];

  # Shell aliases for Docker (add to your zsh config)
  programs.zsh = {
    shellAliases = {
      # Docker shortcuts
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcd = "docker-compose down";
      dcb = "docker-compose build";
      dps = "docker ps";
      dpsa = "docker ps -a";
      di = "docker images";
      drmi = "docker rmi";
      drmif = "docker rmi -f";
      dstop = "docker stop $(docker ps -q)";
      dclean = "docker system prune -af";

      # Lazydocker
      lzd = "lazydocker";

      # Docker logs
      dlogs = "docker logs -f";
    };
  };

  # Helix configuration for Dockerfiles
  programs.helix.languages = {
    language = [
      {
        name = "dockerfile";
        auto-format = true;
        language-servers = [ "dockerfile-langserver" ];
      }
    ];

    language-server = {
      dockerfile-langserver = {
        command = "${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver";
        args = [ "--stdio" ];
      };
    };
  };

  # XDG desktop entries for Docker tools
  xdg.desktopEntries = {
    lazydocker = {
      name = "Lazydocker";
      comment = "Docker management TUI";
      exec = "${pkgs.ghostty}/bin/ghostty -e lazydocker";
      icon = "docker";
      categories = [ "Development" "System" ];
    };
  };

  # Environment variables for Docker development
  home.sessionVariables = {
    DOCKER_BUILDKIT = "1";
    COMPOSE_DOCKER_CLI_BUILD = "1";
  };
}
