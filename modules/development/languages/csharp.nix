{ config, pkgs, unstable, lib, ... }:

{
  home.packages = with pkgs; [
    # Required runtime dependencies
    icu
  ] ++ (with unstable; [
    dotnet-sdk_9
    dotnet-ef
    omnisharp-roslyn
    netcoredbg
    csharpier
  ]);

  # Set up .NET environment variables with stable OpenSSL
  home.sessionVariables = {
    # .NET configuration
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    NUGET_PACKAGES = "${config.home.homeDirectory}/.nuget/packages";
    DOTNET_CLI_UI_LANGUAGE = "en-US";
    DOTNET_TOOLS_PATH = "${config.home.homeDirectory}/.dotnet/tools";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
    MSBuildSDKsPath = "${pkgs.dotnet-sdk_9}/share/dotnet/sdk/${pkgs.dotnet-sdk_9.version}/Sdks";

    # .NET SSL configuration for compatibility
    DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER = "0";
    SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  # Create useful aliases for C# development
  programs.zsh.shellAliases = {
    # Common dotnet commands
    "dn" = "dotnet";
    "dnr" = "dotnet run";
    "dnb" = "dotnet build";
    "dnt" = "dotnet test";
    "dnc" = "dotnet clean";
    "dnw" = "dotnet watch";
    "dnwr" = "dotnet watch run";
    "dnwt" = "dotnet watch test";

    # Project creation shortcuts
    "dnew-console" = "dotnet new console";
    "dnew-web" = "dotnet new web";
    "dnew-api" = "dotnet new webapi";
    "dnew-mvc" = "dotnet new mvc";
    "dnew-blazor" = "dotnet new blazorserver";
    "dnew-test" = "dotnet new xunit";
    "dnew-lib" = "dotnet new classlib";
    "dnew-sln" = "dotnet new sln";

    # Package management
    "dna" = "dotnet add package";
    "dnr-pkg" = "dotnet remove package";
    "dnl-pkg" = "dotnet list package";
    "dnrestore" = "dotnet restore";
  };

  # Helix Configuration for C# with stable OpenSSL
  programs.helix.languages = {
    language = [{
      name = "c-sharp";
      auto-format = true;
      language-servers = [ "omnisharp" ];
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      file-types = [ "cs" "csx" ];
      formatter = {
        command = "${pkgs.csharpier}/bin/dotnet-csharpier";
        args = [ "--write-stdout" ];
      };
    }];

    # Language server configuration with stable OpenSSL environment
    language-server = {
      omnisharp = {
        command = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
        args = [ "--languageserver" ];
        timeout = 120;

        # Environment variables with stable OpenSSL
        environment = {
          DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";
          MSBuildSDKsPath = "${pkgs.dotnet-sdk_9}/share/dotnet/sdk/${pkgs.dotnet-sdk_9.version}/Sdks";
          DOTNET_HOST_PATH = "${pkgs.dotnet-sdk_9}/share/dotnet/dotnet";

          SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

          # .NET compatibility settings
          DOTNET_SYSTEM_NET_HTTP_USESOCKETSHTTPHANDLER = "0";
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
        };
      };
    };
  };
}
