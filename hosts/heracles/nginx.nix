{ ... }:
{
  # For each virtual host you would like to use DNS-01 validation with,
  # set acmeRoot = null
  services.nginx = {

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;


    # upstream authentik {
    # server <hostname of your authentik server>:9443;
    # # Improve performance by keeping some connections alive.
    # keepalive 10;
    # }
    upstreams.authentik = {
      servers = {
        "10.0.0.69:443" = { };
      };
      extraConfig = ''
        keepalive 10;
      '';

    };

    # Upgrade WebSocket if requested, otherwise use keepalive
    appendHttpConfig = ''
      map $http_upgrade $connection_upgrade_keepalive {
        default upgrade;
    '' + "'" + "'" + " '" + "'" + ";\n}";


    virtualHosts = {
      "auth.jamadi.me" = {
        enableACME = true;
        acmeRoot = null; # to inheret from security.acme
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "https://authentik";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $host;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade_keepalive;
            '';
          };
        };
      };
    };
  };

}
