for (var i = 0; i < ds_list_size(values); i++) {
	if (ds_exists(values[| i], ds_type_list))
		ds_list_destroy(values[| i]);
}
ds_list_destroy(values);
ds_list_destroy(instances);

// Remove Self From Terminal GUI Objects List
var _index = ds_list_find_index(_obj_terminal.gui_objects, id);
ds_list_delete(_obj_terminal.gui_objects, _index);