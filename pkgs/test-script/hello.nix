{ writeTextFile,
	audience ? "world",
}:
writeTextFile {
		name = "meh";
		destination = "/etc/meh";
		text = ''
			Hello ${audience}! I am Derek
		'';
}
