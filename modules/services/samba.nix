{ pkgs, vars, ... }:
{

  services.samba = {
    enable = true;
    # set up the user accounts to begin with:
    # $ sudo smbpasswd -a yourusername
    # This adds to the [global] section:
    extraConfig = ''
      browseable = no
      smb encrypt = required
      netbios name = morpheus
      server string = morpheus
      hosts allow = 10.0.
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';

    shares = {
      homes = {
        browseable = "no"; # note: each home will be browseable; the "homes" share will not.
        "read only" = "no";
        "guest ok" = "no";
      };
      common-morpheus = {
        path = "/mnt/Shares/Private";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        # "force user" = "aj";
        # "force group" = "users";
      };
    };
  };



}
