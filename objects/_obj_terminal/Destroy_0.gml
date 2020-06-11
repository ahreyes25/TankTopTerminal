event_user(3);		// save history

if (!destroyed) {	// singleton destruction
	ds_list_destroy(tokens);
	ds_list_destroy(history);
	ds_list_destroy(suggested);

	for (var i = 0; i < ds_list_size(gui_objects); i++) {
		if (instance_exists(gui_objects[| i]))
			instance_destroy(gui_objects[| i]);
	}

	ds_list_destroy(gui_objects);
}