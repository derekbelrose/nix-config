{ pkgs
, configs
, lib
, ... }:

#ollama = {
      #  acceleration = "rocm";
      #  enable = true;
      #  environmentVariables = {
      #    ROC_ENABLE_PRE_VEGA = "1";
      #    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      #    OLLAMA_HOST="superbia:11434";
      #    OLLAMA_NUM_PARALLEL= "1";
      #    OLLAMA_SCHED_SPREAD = "1";
      #    OLLAMA_GPU_OVERHEAD="20000000";
      #  };
      #};

{
	networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 11434 ];
	services = {
		ollama = {
      openFirewall = true;
			enable = true;
			package = pkgs.unstable.ollama;
			acceleration = "rocm";
			home = "/store/service-data/ollama";
			models = "/store/service-data/ollama/models";
      port = 11434;
      host = "0.0.0.0";
			environmentVariables = {
				LD_LIBRARY_PATH = "/run/opengl-driver/lib";
        OLLAMA_HOST = "0.0.0.0:11434";
        ROC_ENABLE_PRE_VEGA = "0";
        HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        OLLAMA_NUM_PARALLEL= "1";
        OLLAMA_SCHED_SPREAD = "1";
        OLLAMA_GPU_OVERHEAD="20000000";
     	};
		};	
	};
}

