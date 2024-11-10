{ ... }:
{
	services.searx = {
	  enable = true;
	  redisCreateLocally = true;
	  settings.server = {
	    bind_address = "::1";
	    # port = yourPort;
	    # secret_key = "Your secret key.";
	  };
	};
}
