#region Draw Terminal Drop Shadow
draw_set_color(c_black);
draw_set_alpha(0.2);
draw_rectangle(0, suggested_y, sw, suggested_y + 10, false);
draw_set_color(c_white);
draw_set_alpha(1);
#endregion
#region Draw Black Background
draw_set_color(c_black);
draw_set_alpha(0.6);
// Main Background
draw_rectangle(0, 0, sw, terminal_y, false);

// Suggested Background
draw_rectangle(0, terminal_y, sw, suggested_y, false);

draw_set_color(c_white);
draw_set_alpha(1);
#endregion
#region Draw Selection Highlight
if (anchor_index != undefined) {
	var _x1 = text_padding + char_width + (anchor_index * char_width);
	var _y1 = input_string_y;
	var _x2 = text_padding + char_width + (input_index * char_width);
	var _y2 = input_string_y + char_height;
	var _c  = c_gray;
	draw_rectangle_color(_x1, _y1, _x2, _y2, _c, _c, _c, _c, false); 	
}
#endregion
#region Draw Anchor Point
draw_set_color(text_color);	
if (!in_history && !in_suggested)
	draw_text(text_padding / 2, input_string_y, ">");
else if (in_history)
	draw_text(text_padding / 2, input_string_y - (char_height * 2) - (char_height * history_index), ">");
else if (in_suggested) 
	draw_text(text_padding / 2, input_string_y + (char_height * 2) + (char_height * suggested_index), ">");
draw_set_color(c_white);	
#endregion
#region Draw Blinking Cursor
draw_set_color(text_color);	
var _cursor_x = (input_index * char_width) + char_width * 0.5;
if ((blink_iter mod 2 || !typing) && !in_history && !in_suggested)
	draw_text(text_padding + _cursor_x, input_string_y, "|");
draw_set_color(c_white);	
#endregion
#region Draw Input Text
draw_set_color(text_color);	
if (in_history) 
	draw_set_color(c_gray);
draw_text(text_padding + char_width, input_string_y, input_string); 
draw_set_color(c_white);
#endregion
#region Draw Template Text
draw_set_color(c_dkgray);
if (input_string == "")
	draw_text(text_padding + char_width, input_string_y, "action object : [parameters]* , [values]*"); 
else if (string_char_at(input_string, string_length(input_string) - 1) == ":")
	draw_text(text_padding + char_width + string_width(input_string), input_string_y, " [parameters]* , [values]*"); 
else if (string_char_at(input_string, string_length(input_string) - 1) == ",")
	draw_text(text_padding + char_width + string_width(input_string), input_string_y, " [values]*"); 
draw_set_color(c_white);
#endregion
#region Draw Suggested Text
if (show) {
	draw_set_color(text_color);	
	for (var i = 0; i < ds_list_size(suggested); i++) {
		if (in_suggested && i == suggested_index) {
			draw_set_color(c_white);
			
			switch(suggested[| i]) {
				#region create
				case "create":
					var _info_text		= " -- info| create object with defined properties/values.";
					var _example_text	= " example| create obj_player : x y , 100 200";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region destroy
				case "destroy":
					var _info_text		= " -- info| destroy object or instance.";
					var _example_text	= " example| destroy obj_player";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region get
				case "get":
					var _info_text		= " -- info| get object value into console output.";
					var _example_text	= " example| get obj_player : image_angle";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region set
				case "set":
					var _info_text		= " -- info| set object property.";
					var _example_text	= " example| set obj_player : image_alpha , 0.5";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region watch
				case "watch":
					var _info_text		= " -- info| watch object property on gui.";
					var _example_text	= " example| watch obj_player : life";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region clear
				case "clear":
					var _info_text		= " -- info| clear terminal history";
					var _example_text	= " example| clear";
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					draw_set_color(orange);
					draw_text(text_padding + char_width + string_width(suggested[| i]), input_string_y + (char_height * 2) + (char_height * i), _info_text); 
					draw_set_color(c_white);
					draw_text(text_padding + char_width + string_width(suggested[| i]) + string_width(_info_text), input_string_y + (char_height * 2) + (char_height * i), _example_text); 
					break;
				#endregion
				#region default
				default:
					draw_set_color(c_white);
					draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]);
					break;
				#endregion
			}
		}
		else {
			draw_set_color(c_gray);
			draw_text(text_padding + char_width, input_string_y + (char_height * 2) + (char_height * i), suggested[| i]); 
		}
		draw_set_color(c_white);
	}
	draw_set_color(c_white);
}
#endregion
#region Draw Terminal Decorators
// Terminal Top Line
draw_set_color(c_gray);
draw_line(0, input_string_y - 5, sw, input_string_y - 5);

// Terminal Bottom Line
draw_set_color(c_gray);
draw_line(0, terminal_y, sw, terminal_y);

// Suggestion Bottom Line
draw_set_color(orange);
draw_line(0, suggested_y, sw, suggested_y);
draw_set_color(c_white);
#endregion
#region Draw Command History
for (var i = 0; i < ds_list_size(history); i++) {
	if (in_history && i == history_index) {
		var _history_data	= history[| i];
		var _failed			= _history_data[6];
		
		if (!_failed)
			draw_set_color(c_white);
		else
			draw_set_color(orange);
	}
	else {
		var _history_data	= history[| i];
		var _failed			= _history_data[6];
		if (!_failed)
			draw_set_color(c_gray);
		else
			draw_set_color(merge_color(orange, c_black, 0.5));
	}
		
	var _command = _history_data[5];
	var _string	 = _history_data[0];
	
	if (_command) {
		var _text_x = text_padding + char_width;
		draw_text(_text_x, input_string_y - (char_height * 2) - (char_height * i), _string);
	}
	else {
		var _text_x = text_padding + char_width + char_width * 4;
		draw_text(_text_x, input_string_y - (char_height * 2) - (char_height * i), _string);
	}
		
	if (_failed)
		draw_text(_text_x + string_width(_string), input_string_y - (char_height * 2) - (char_height * i), " -- FAILED");
	draw_set_color(c_white);
}
#endregion
#region Draw Logo
var _scale = penguin_scale;
switch (penguin_state) {
	case "idle":
		penguin_image_speed = 0.05;
		//_scale = 3;
		draw_sprite_ext(spr_logo_idle, penguin_image_index, sw - sprite_get_width(spr_logo_idle) * _scale, input_string_y - 5, -_scale, _scale, 0, c_white, 1);
		break;
	
	case "angry":	
		penguin_image_speed = 0;
		var _x = sw - sprite_get_width(spr_logo_idle) * _scale;
		draw_sprite_ext(spr_logo_angry, penguin_image_index, _x + random_range(-5, 5), input_string_y - 5, -_scale, _scale, 0, c_white, 1);
		
		if (alarm[1] == -1)
			alarm[1] = 30;
		break;
		
	case "happy":
		penguin_image_speed = 0;
		var _x = sw - sprite_get_width(spr_logo_idle) * _scale;
		draw_sprite_ext(spr_logo_happy, penguin_image_index, _x, input_string_y - 5 - sin(bob_iter) * 6, -_scale, _scale, 0, c_white, 1);
		
		if (alarm[1] == -1)
			alarm[1] = 30;
		break;
}
#endregion

draw_text(10, 10, "suggested_action: " + string(suggested_action));
/*draw_text(10, 30, "input_index: " + string(input_index));
draw_text(10, 50, "space_count: " + string(space_count));
draw_text(10, 70, "shift: " + string(keyboard_check(vk_shift)));
draw_text(10, 90, "alt: " + string(keyboard_check(vk_lalt)));
draw_text(10, 110, "ctrl: " + string(keyboard_check(vk_lcontrol)));