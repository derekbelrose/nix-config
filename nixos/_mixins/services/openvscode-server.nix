{ pkgs
, username
, ...
}:
{
	services.openvscode-server = {
		enable = true;
		host = "0.0.0.0";
		#disableTelemetry = true;
		user = username;
		withoutConnectionToken = true;
	};
}
