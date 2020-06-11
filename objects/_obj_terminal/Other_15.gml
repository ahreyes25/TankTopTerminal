/// @description Autoformat Colon

if (suggested_action == "destroy") {
	if (space_count == 1 && !auto_delim) {
		input_string += ": ";
		input_index  += 2;
		auto_delim = true;
	}
}
else {
	if (space_count == 2 && !auto_delim) {
		input_string += ": ";
		input_index  += 2;
		auto_delim = true;
	}
}