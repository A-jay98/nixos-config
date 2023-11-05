{
  # Configure ACME appropriately
  security.acme = {
    acceptTerms = true;
    defaults.email = "ali@jamadi.me";
    defaults = {
      dnsProvider = "cloudflare";
      credentialsFile = "/var/lib/secrets/cert.secret";
      dnsPropagationCheck = true;
    };
  };

  # For each virtual host you would like to use DNS-01 validation with,
  # set acmeRoot = null
  services.nginx = {
    enable = true;
    virtualHosts = {
      "nix.morpheus.jamadi.me" = {
        enableACME = true;
        acmeRoot = null; # to inheret from security.acme
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "https://google.com";
          };
        };
      };
    };
  };

}
