sw					 = surface_get_width( application_surface);
sh					 = surface_get_height(application_surface);
terminal_yt			 = sh / 2;
blink_iter			+= blink_speed;
terminal_y			 = lerp(terminal_y, (terminal_yt * show) - (!show * 20), 0.1);
input_string_y		 = terminal_y - char_height * 1.5;
penguin_image_index += penguin_image_speed;
bob_iter			+= bob_iter_speed;
suggested_index		 = clamp(suggested_index, 0, ds_list_size(suggested) - 1);

if (show && !in_history)
	suggested_y		 = lerp(suggested_y, (terminal_y + (ds_list_size(suggested) * char_height) + (char_height * (ds_list_size(suggested) > 0))), 0.2);
else if (show && in_history)
	suggested_y		 = lerp(suggested_y, terminal_y, 0.2);
else
	suggested_y		 = lerp(suggested_y, 0, 0.2);
