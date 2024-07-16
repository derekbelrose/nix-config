{ pkgs
, ...
}:
{
	virtualisation.oci-containers = {
		backend = "docker";
		containers = {
			"stirling-pdf" = {
				image = "frooodle/s-pdf:latest";
				volumes = [
				];
				ports = [
					"8080:8080"
				];
				environment = {
					DOCKER_ENABLE_SECURITY="false";
					INSTALL_BOOK_AND_ADVANCED_HTML_OPS="false";
					LANGS="en_US";
				};
			};
		};
	};
}
