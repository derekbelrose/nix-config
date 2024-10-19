{ pkgs, ... }:

{
	services = {
#    nextjs-ollama-llm-ui = {
#      enable = true;
#      hostname = "0.0.0.0";
#    };
#
		ollama = {
			enable = true;
			package = pkgs.ollama.override { acceleration = "cuda"; };
			writablePaths = [ "/store/ollama" ];
      listenAddress = "0.0.0.0:11434";
			models = "/store/ollama/models";
			environmentVariables = {
				LD_LIBRARY_PATH = "/run/opengl-driver/lib";
        OLLAMA_HOST = "0.0.0.0:11434";
			};
		};	
	};
}

