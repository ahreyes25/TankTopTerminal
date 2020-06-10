// Draw Box
draw_set_color(box_color);
draw_set_alpha(box_alpha);
draw_rectangle(draw_x, draw_y, draw_x + box_width, draw_y + box_height, false);
draw_set_color(frame_color);
draw_set_alpha(frame_alpha);
draw_rectangle(draw_x, draw_y, draw_x + box_width, draw_y + box_height, true);
draw_set_color(c_white);
draw_set_alpha(1);

// Draw Text
draw_set_color(text_color);
draw_set_alpha(text_alpha);
var _n_rows = 0;

// Object Index Text
var _object_string = "object_index: " + string(object_get_name(object));
draw_text(draw_x, draw_y, _object_string);

// Values Line Separator
draw_set_color(frame_color);
draw_set_alpha(frame_alpha);
var _line_y = draw_y + text_space;
draw_line(draw_x, _line_y, draw_x + box_width, _line_y);
draw_set_color(c_white);
draw_set_alpha(1);

for (var i = 0; i < ds_list_size(instances); i++) {	
	// Object id Text
	var _instance_string = "id: " + string(instances[| i]);
	if (i == 0)
		draw_text(draw_x, draw_y + (text_space * _n_rows) + text_space + (text_space * i), _instance_string);
	else 
		draw_text(draw_x, draw_y + (text_space * _n_rows) + (text_space * i), _instance_string);
	
	// Values Line Separator
	draw_set_color(frame_color);
	draw_set_alpha(frame_alpha);
	if (i != 0)
		var _line_y = draw_y + (text_space * _n_rows) + (text_space * 2) + (text_space * (i - 1));
	else
		var _line_y = draw_y + (text_space * _n_rows) + (text_space * 2) + (text_space * i);
	draw_line(draw_x, _line_y, draw_x + box_width, _line_y);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	// Values Text
	var _values_list = values[| i];
	for (var j = 0; j < ds_list_size(_values_list); j++) {
		var _value_data		= _values_list[| j];
		var _value_prop		= _value_data[0];
		var _value_value	= _value_data[1];
		//var _value_min		= _value_data[2];
		//var _value_max		= _value_data[3];
		var _value_string	= string(_value_prop) + ": " + string(_value_value);
		//if (!is_string(_value_value)) 
		//	var _min_max_string	= " | min: " + string(_value_min) + ", max: " + string(_value_max);
		//else
		//	var _min_max_string = "";
		if (i == 0) {
			draw_text(draw_x, draw_y + (text_space * _n_rows) + (text_space * 2) + (text_space * i) + (text_space * j), _value_string);
		//	draw_text_transformed(draw_x + string_width(_value_string), draw_y + (text_space * _n_rows) + (text_space * 2) + (text_space * i) + (text_space * j), _min_max_string, 0.75, 0.75, 0);
		}	
		else {
			draw_text(draw_x, draw_y + (text_space * _n_rows) + text_space + (text_space * i) + (text_space * j), _value_string);
		//	draw_text_transformed(draw_x + string_width(_value_string), draw_y + (text_space * _n_rows) + text_space + (text_space * i) + (text_space * j), _min_max_string, 0.75, 0.75, 0);
		}
	}
	if (i == 0)
		_n_rows += ds_list_size(_values_list) + 2;
	else
		_n_rows += ds_list_size(_values_list) + 1;
	
	// Object Line Separator
	draw_set_color(frame_color);
	draw_set_alpha(frame_alpha);
	if (i > 0) {
		var _line_y = draw_y + ((text_space * (ds_list_size(_values_list) + 2))) * i;	
		draw_rectangle(draw_x, _line_y, draw_x + box_width, clamp(_line_y + string_height("A") - 5, draw_y, draw_y + box_height), false);
	}
	draw_set_color(c_white);
	draw_set_alpha(1);
}
draw_set_color(c_white);
draw_set_alpha(1);

box_width  = max(string_width(_object_string), string_width(_instance_string), string_width(_value_string));
box_height = (ds_list_size(instances) + _n_rows - 1) * text_space;

// Draw Move Node
draw_set_color(frame_color);
draw_set_alpha(frame_alpha);
draw_rectangle(draw_x - node_size / 2, draw_y - node_size / 2, draw_x + node_size / 2, draw_y + node_size / 2, false);
draw_set_color(c_white);
draw_set_alpha(1);

// Draw Delete Icon
draw_sprite_ext(spr_trash_icon, 0, draw_x + box_width, draw_y + box_height, 2, 2, 0, c_white, frame_alpha);