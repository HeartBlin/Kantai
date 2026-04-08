let
  "heartblin" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPxLuz5zNJwNe1jo/2roupQAlzz0j+ORP1txbBYl5sam agenix-administration";
  "Reason" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFDqgPvLILssv37DaahDr6iXsIalvE3oh8pG0OmyBlwq root@nixos"; # Root is disabled for ssh
in {
  "secrets/dns.age".publicKeys = [ heartblin Reason ];
  "secrets/nextcloud.age".publicKeys = [ heartblin Reason ];
  "secrets/ovh.age".publicKeys = [ heartblin Reason ];
  "secrets/restic.age".publicKeys = [ heartblin Reason ];
}
