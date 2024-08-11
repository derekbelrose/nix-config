{ pkgs
, config
, age
, ... 
}:
let 
	port = 9000;
	url = "https://recipes.belrose.io";
in {
	environment.systemPackages = with pkgs; [
		mealie
	];

	users.users."mealie" = {
		name = "mealie";
		isSystemUser=true;
		group = "mealie";
		extraGroups = [ config.users.groups.keys.name ];
	};

	users.groups.mealie = {};

	sops.secrets.mealie = {
		sopsFile = ./mealie.enc.env;
		format = "dotenv";
		owner = config.users.users.mealie.name;
		group = config.users.groups.${config.users.users.mealie.group}.name;
		mode = "0640";
		path = "/etc/mealie.env";
	};

	services.mealie = {
		package = pkgs.unstable.mealie;
		enable = true;
		port = port;
		credentialsFile = config.sops.secrets.mealie.path;
		settings = {
			TZ = "America/New_York";
			BASE_URL = url;

			PUID = config.users.users.mealie.uid;
			PGID = config.users.groups.${config.users.users.mealie.group}.gid;

			# OIDC Related
			OIDC_AUTH_ENABLED = true;
			OIDC_SIGNUP_ENABLED = true;
			OIDC_CONFIGURATION_URL = "https://idp.belrose.io/realms/belrose.io/.well-known/openid-configuration";
			OIDC_CLIENT_ID = "mealie";
			OIDC_AUTO_REDIRECT = true;

			# OpenAI
			#OPENAI_API_KEY is included in credentialsFile
			
			# SMTP
			SMTP_HOST = "smtp.sendgrid.net";
			SMTP_FROM_EMAIL = "mealie@derekbelrose.com";
			SMTP_USER = "apikey";
			#  SMTP_PASSWORD is included in credentialsFile
		};
	};

	networking.firewall.allowedTCPPorts = [
		port
	];

}
