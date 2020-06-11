/// @description Autocomplete

if (show && typing) {
	#region First Word
	if (space_count == 0) {
		ds_list_clear(suggested);
		for (var i = 0; i < array_length_1d(commands); i++) {
			var _command = commands[i];
			
			var _matching = true;
			for (var j = 1; j <= string_length(input_string); j++) {
				if (string_char_at(_command, j) != string_char_at(input_string, j)) {
					_matching = false;
					break;
				}
			}
			
			// If Substring Matches Command, Add to Suggested List
			if (_matching) {
				if (ds_list_size(suggested) < suggestion_limit)
					ds_list_add(suggested, _command);
			}
		}
	}
	#endregion
	#region Second Word
	else if (space_count == 1) {
		#region Object
		if (suggested_action != "room" && suggested_action != "window" && suggested_action != "clear") {		
			// Compare Substring To All Object Names In Resource Tree
			ds_list_clear(suggested);
			
			// Add Favorite Objects to List First
			for (var i = 0; i < ds_list_size(fav_objects); i++)
				ds_list_add(suggested, fav_objects[| i]);	
					
			
			// Get Second Substring
			var _action_index  = 0;
			for (var i = 1; i <= string_length(input_string); i++) {
				if (string_char_at(input_string, i) == " ") {
					_action_index = i + 1;
					break;
				}
			}
			var _object_string = string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
			
			// Iterate Through All Game Objects
			for (var i = 0; i < 10000; i++) {
				if (!object_exists(i)) break;
			
				// Check If Name Match Substring
				var _matching	 = true;
				var _object_name = object_get_name(i);
				for (var j = 1; j <= string_length(_object_string); j++) {
					if (string_char_at(_object_name, j) != string_char_at(_object_string, j)) {
						_matching = false;
						break;
					}
				}
			
				// Check For Objects To Ignore
				var _valid_object = true;
				for (var j = 0; j < array_length_1d(objects_ignore); j++) {
					if (_object_name == object_get_name(objects_ignore[j])) {
						_valid_object = false;
						break;
					}
				}
			
				// If Substring Matches Name, Add to Suggested List
				var _object_exists		= instance_exists(i);
				var _action				= (suggested_action == "get" || suggested_action == "destroy" || suggested_action == "watch" || suggested_action == "set");
				var _invalid_command	= _action && !_object_exists;
				if (_matching && _valid_object && !_invalid_command && ds_list_size(suggested) < suggestion_limit)
					ds_list_add(suggested, _object_name);
			}
		}
		#endregion
		#region Room
		else if (suggested_action == "room") {
			var _room_commands = room_commands;
			// Get Second Substring
			var _action_index  = 0;
			for (var i = 1; i <= string_length(input_string); i++) {
				if (string_char_at(input_string, i) == " ") {
					_action_index = i + 1;
					break;
				}
			}
			var _room_string = string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
			
			// Compare Substring To All Object Names In Resource Tree
			ds_list_clear(suggested);
			for (var i = 0; i < array_length_1d(_room_commands); i++) {
				// Check If Name Match Substring
				var _matching	  = true;
				var _room_command = _room_commands[i];
				for (var j = 1; j <= string_length(_room_string); j++) {
					if (string_char_at(_room_command, j) != string_char_at(_room_string, j)) {
						_matching = false;
						break;
					}
				}
			
				// If Substring Matches Name, Add to Suggested List
				if (_matching) {
					if (ds_list_size(suggested) < suggestion_limit)
						ds_list_add(suggested, _room_command);
				}
			}
		}
		#endregion
		#region Window
		else if (suggested_action == "window") {
			var _window_commands = window_commands;
			// Get Second Substring
			var _action_index  = 0;
			for (var i = 1; i <= string_length(input_string); i++) {
				if (string_char_at(input_string, i) == " ") {
					_action_index = i + 1;
					break;
				}
			}
			var _window_string = string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
			
			// Compare Substring To All Object Names In Resource Tree
			ds_list_clear(suggested);
			for (var i = 0; i < array_length_1d(_window_commands); i++) {
				// Check If Name Match Substring
				var _matching		= true;
				var _window_command = _window_commands[i];
				for (var j = 1; j <= string_length(_window_string); j++) {
					if (string_char_at(_window_command, j) != string_char_at(_window_string, j)) {
						_matching = false;
						break;
					}
				}
			
				// If Substring Matches Name, Add to Suggested List
				if (_matching) {
					if (ds_list_size(suggested) < suggestion_limit)
						ds_list_add(suggested, _window_command);
				}
			}
		}
		#endregion
	}
	#endregion
	else
		ds_list_clear(suggested);	
}