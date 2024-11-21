{ pkgs
, ...
}:{
	services.openweb-ui = {
		enable = true;
		package = pkgs.unstable.openweb-ui;
		stateDir = /store/service-data/openweb-ui;
		host = "0.0.0.0";
	};
}
