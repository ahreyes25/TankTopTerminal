var _mx = device_mouse_x_to_gui(0);	
var _my = device_mouse_y_to_gui(0);
	
if (device_mouse_check_button(0, mb_left)) {
	// Click On Trash Icon
	if (_mx >= draw_x + box_width - node_size && _mx <= draw_x + box_width + node_size && _my >= draw_y + box_height - node_size && _my <= draw_y + box_height + node_size) {
		instance_destroy();
		return;
	}
			
	// Click On Move Node
	if (_mx >= draw_x - node_size && _mx <= draw_x + node_size && _my >= draw_y - node_size && _my <= draw_y + node_size)
		moving = true;
}

if (device_mouse_check_button_released(0, mb_left))
	moving = false;	

if (moving) {
	draw_x = _mx;
	draw_y = _my;
}

// Get Realtime Values
for (var i = 0; i < ds_list_size(values); i++) {
	var _id			= instances[| i];
	var _var_list	= values[| i];
	
	for (var j = 0; j < ds_list_size(_var_list); j++) {
		var _var_data	= _var_list[| j];
		var _var_name	= _var_data[0];
		var _var_value	= _var_data[1];
		var _var_min	= _var_data[2];
		var _var_max	= _var_data[3];
	
		if (variable_instance_exists(_id, _var_name)) {
			_var_value = variable_instance_get(_id, _var_name);
			
			if (_var_value > _var_max)
				_var_max = _var_value;
			if (_var_value < _var_min)
				_var_min = _var_value;
		}
		
		ds_list_replace(_var_list, j, [_var_name, _var_value, _var_min, _var_max]);
	}
}
	
// Check For Instances That Destroy Themselved
for (var i = 0; i < ds_list_size(instances); i++) {
	if (!instance_exists(instances[| i])) {
		ds_list_delete(instances, i);	
		ds_list_destroy(values[| i]);
		ds_list_delete(values, i);
		
		if (ds_list_size(instances) == 0) {
			instance_destroy();
			return;
		}
	}
}