{ config, lib, pkgs, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    #../../services/keybase.nix
    #../../services/syncthing.nix
  ];

	home.packages = with pkgs; [
	];

 programs = {
    #fish.interactiveShellInit = ''
    #  set -x GH_TOKEN (cat ${config.sops.secrets.gh_token.path})
    #  set -x GITHUB_TOKEN (cat ${config.sops.secrets.gh_token.path})
    #'';
    git = {
      userEmail = "derek@derekbelrose.com";
      userName = "Derek Belrose";
    };
		emacs = {
			enable = true;
		};
  };

	home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 

  #sops = {
  #  age = {
  #    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  #    generateKey = false;
  #  };
  #  defaultSopsFile = ../../../../secrets/secrets.yaml;
  #  # sops-nix options: https://dl.thalheim.io/
  #  secrets = {
  #    asciinema.path = "${config.home.homeDirectory}/.config/asciinema/config";
  #    atuin_key.path = "${config.home.homeDirectory}/.local/share/atuin/key";
  #    flakehub_netrc.path = "${config.home.homeDirectory}/.local/share/flakehub/netrc";
  #    flakehub_token.path = "${config.home.homeDirectory}/.config/flakehub/auth";
  #    gh_token = {};
  #    gpg_private = {};
  #    gpg_public = {};
  #    gpg_ownertrust = {};
  #    halloy_config.path = "${config.home.homeDirectory}/.config/halloy/config.toml";
  #    hueadm.path = "${config.home.homeDirectory}/.hueadm.json";
  #    obs_secrets = {};
  #    ssh_config.path = "${config.home.homeDirectory}/.ssh/config";
  #    ssh_key.path = "${config.home.homeDirectory}/.ssh/id_rsa";
  #    ssh_pub.path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
  #    ssh_semaphore_key.path = "${config.home.homeDirectory}/.ssh/id_rsa_semaphore";
  #    ssh_semaphore_pub.path = "${config.home.homeDirectory}/.ssh/id_rsa_semaphore.pub";
  #    transifex.path = "${config.home.homeDirectory}/.transifexrc";
  #  };
  #};

  # Linux specific configuration
  #systemd.user.tmpfiles.rules = lib.mkIf isLinux [
  #  "L+ ${config.home.homeDirectory}/.config/obs-studio/ - - - - ${config.home.homeDirectory}/Studio/OBS/config/obs-studio/"
  #];
}

