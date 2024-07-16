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

	age.secrets.mealie.file = ./mealie.age;

	services.mealie = {
		package = pkgs.unstable.mealie;
		enable = true;
		port = port;
		credentialsFile = config.age.secrets.mealie.path;
		settings = {
			TZ = "America/New_York";
			BASE_URL = url;

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
