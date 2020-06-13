var _anykey_pressed	= keyboard_check_pressed(vk_anykey);
var _anykey			= keyboard_check(vk_anykey);
var _shift			= keyboard_check(vk_shift);
var _control		= keyboard_check(vk_control);
var _alt			= keyboard_check(vk_alt);
var _modifier		= keyboard_check(vk_alt) || keyboard_check(vk_shift) || keyboard_check(vk_control) || keyboard_check(vk_end) || keyboard_check(vk_home);

#region Show & Hide Terminal
if (keyboard_check_pressed(vk_f1) || (show && keyboard_check_pressed(vk_escape))) {
	show = !show;
	
	// Clear Input
	if (!show) {
		event_user(2);
		shift_held	= false;
		holding		= false;
		typing		= false;
		alarm[0]	= -1;
		event_user(3);	// save on close
	}
	else
		typing		= true;	
}
#endregion

if (typing) {
	if (_anykey_pressed || (_anykey && holding)) {
		switch (keyboard_key) {		
			#region vk_backspace
			case vk_backspace:
				if (in_history || in_suggested) {
					in_history	 = false;
					in_suggested = false;
				}
				
				// Normal Backspace
				if (anchor_index == undefined) {
					var _last_char			= string_char_at(input_string, input_index);
					var _second_last_char	= string_char_at(input_string, input_index - 1);
				
					if (_last_char == " " && _second_last_char != " " && _second_last_char != ":")
						space_count--;
					
					if (_last_char == ",")
						comma_placed = false;
					
					if (_last_char == " " && _second_last_char == ":") {
						auto_delim   = false;
						input_string = string_delete(input_string, input_index - 2, 3);
						input_index	 = clamp(input_index - 3, 0, string_length(input_string));
						space_count--;
					}
					else {
						input_string = string_delete(input_string, input_index, 1);
						input_index	 = clamp(input_index - 1, 0, string_length(input_string));
					}
				}
				// Mass Backspace
				else {
					var _string_delete = "";
					var _min = min(input_index, anchor_index);
					var _max = max(input_index, anchor_index);
					var _len = abs(input_index - anchor_index);
					
					for (var i = _min; i < _max; i++)
						_string_delete += string_char_at(input_string, i);
						
					input_string = string_delete(input_string, _min + 1, _len);
					anchor_index = undefined;
					
					for (var i = string_length(_string_delete); i >= 1; i--) {
						var _char = string_char_at(_string_delete, i);
						switch (_char) {
							case " ":
								if (string_char_at(_string_delete, i - 1) != " " && string_char_at(_string_delete, i - 1) != ":")
									space_count--;
								break;
								
							case ":":
								auto_delim = false;
								break;
								
							case ",":
								comma_placed = false;
								break;
						}
					}
				}
					
				if (input_string == "")
					event_user(2);
				break;
			#endregion
			#region vk_left
			case vk_left:
				if (in_history || in_suggested)	break;
				
				if (_shift) {
					if (!shift_held)
						anchor_index = input_index;
					shift_held = true;
				}
					
				// Skip Whole Word
				if (_alt || _control) {
					if (string_char_at(input_string, input_index) != " ") {
						while (input_index != 0 && string_char_at(input_string, input_index) != " ")
							input_index = clamp(input_index - 1, 0, string_length(input_string));
					}
					else
						input_index = clamp(input_index - 1, 0, string_length(input_string));
				}
				else {
					input_index = clamp(input_index - 1, 0, string_length(input_string));
					
					if (anchor_index != undefined && !_shift)
						input_index = clamp(min(anchor_index, input_index), 0, string_length(input_string));	
				}
					
				#region Reset Shift Held
				if (!_shift) {
					anchor_index = undefined;
					shift_held	 = false;	
				}
				#endregion
				break;
			#endregion
			#region vk_right
			case vk_right:
				if (in_history || in_suggested)	break;
				
				if (_shift) {
					if (!shift_held)
						anchor_index = input_index;
					shift_held = true;
				}

				// Skip Whole Word
				if (_alt || _control) {
					if (input_index == 0 || string_char_at(input_string, input_index + 1) != " ") {
						while (input_index != string_length(input_string) && string_char_at(input_string, input_index + 1) != " ")
							input_index = clamp(input_index + 1, 0, string_length(input_string));
					}
					else
						input_index = clamp(input_index + 1, 0, string_length(input_string));
				}
				else {
					input_index = clamp(input_index + 1, 0, string_length(input_string));
					
					if (anchor_index != undefined && !_shift)
						input_index = clamp(max(anchor_index, input_index), 0, string_length(input_string));
				}
					
				#region Reset Shift Held
				if (!_shift) {
					anchor_index = undefined;
					shift_held	 = false;	
				}
				#endregion
				break;
			#endregion
			#region vk_up
			case vk_up:
				// Normal Terminal
				if (!in_history && !in_suggested && ds_list_size(history) > 0) {
					in_history	  = true;
					history_index = 0;
				}
				// Suggested
				else if (in_suggested) {
					if (suggested_index == 0)
						in_suggested = false;
					else
						suggested_index = clamp(suggested_index - 1, 0, ds_list_size(suggested) - 1);	
				}
				// History
				else if (in_history)
					history_index = clamp(history_index + 1, 0, ds_list_size(history) - 1);
				break;
			#endregion
			#region vk_down
			case vk_down:
				// Normal Terminal
				if (!in_history && !in_suggested && ds_list_size(suggested) > 0) {
					in_suggested	= true;
					suggested_index = 0;
				}
				// Suggested
				else if (in_suggested)
					suggested_index = clamp(suggested_index + 1, 0, ds_list_size(suggested) - 1);	
				// History
				else if (in_history) {
					if (history_index == 0)
						in_history = false;
					else
						history_index = clamp(history_index - 1, 0, ds_list_size(history) - 1);
				}
				break;
			#endregion
			#region vk_enter
			case vk_enter:
				#region Normal Enter
				if (!in_history && !in_suggested) {
					if (input_string != "") {
						event_user(0);
						event_user(2);
					}
				}
				#endregion
				#region Select History Element
				else if (in_history) {
					var _history_data	= history[| history_index];
					var _is_command		= _history_data[5];
					if (_is_command) {
						input_string		= _history_data[0];
						input_index			= _history_data[1];
						space_count			= _history_data[2];
						comma_placed		= _history_data[3];
						auto_delim			= _history_data[4];
						suggested_action	= _history_data[8];
						suggested_object	= _history_data[9];
						anchor_index		= undefined;
						in_history			= false;
					}
					else {
						var _property	= _history_data[0];
						input_string	= string_insert(_property, input_string, input_index + 1);
						input_index		= input_index + string_length(_property);
						in_history		= false;
					}
				}
				#endregion
				#region Select Suggested
				else if (in_suggested && ds_list_size(suggested) > 0) {
					#region First Word
					if (space_count == 0) {
						input_string		= suggested[| suggested_index] + " ";
						input_index			= string_length(input_string);
						in_suggested		= false;
						space_count			= 1;
						suggested_index		= 0;
						suggested_action	= string_delete(input_string, string_length(input_string), 1);
						ds_list_clear(suggested);
					}
					#endregion
					#region Second Word
					else if (space_count == 1) {
						// Get Object Name Substring
						var _action_index  = 0;
						for (var i = 1; i <= string_length(input_string); i++) {
							if (string_char_at(input_string, i) == " " && string_char_at(input_string, i + 1) != ":") {
								_action_index = i + 1;
								break;
							}
						}
					
						var _object_string			= string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
						var _suggested_substring	= string_delete(suggested[| suggested_index], 1, string_length(_object_string));
						_suggested_substring		= string_replace_all(_suggested_substring, " ", "");
						input_string	   += _suggested_substring + " ";
						input_index		   += string_length(_suggested_substring) + 1;
						in_suggested		= false;
						suggested_object	= suggested[| suggested_index];
						suggested_index		= 0;
						space_count		   += 1;
					}
					#endregion
					#region Fourth Word
					else if (space_count >= 4) {
						// Get Object Name Substring
						var _action_index  = 0;
						for (var i = 1; i <= string_length(input_string); i++) {
							if (string_char_at(input_string, i) == ",") {
								_action_index = i + 1;
								break;
							}
						}
					
						var _value_string			= string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
						var _suggested_substring	= string_delete(suggested[| suggested_index], 1, string_length(_value_string) - 1);
						_suggested_substring		= string_replace_all(_suggested_substring, " ", "");
						input_string	   += _suggested_substring + " ";
						input_index		   += string_length(_suggested_substring) + 1;
						in_suggested		= false;
						suggested_index		= 0;
						space_count		   += 1;
					}
					#endregion
				}
				#endregion
				
				#region Auto Format Colon
				event_user(5);
				#endregion
				#region Auto Format Comma
				if (keyboard_key == 188) {
					comma_placed			= true;	
					var _last_char			= string_char_at(input_string, string_length(input_string));
					var _second_last_char	= string_char_at(input_string, string_length(input_string) - 1);
					
					if (_last_char == ",") {
						if (_second_last_char != " ") {
							input_string  = string_delete(input_string, string_length(input_string), 1);
							input_string += " , ";
							space_count  += 2;
							input_index  += 2;
						}
						else {
							input_string += " ";
							space_count  += 1;
							input_index  += 1;
						}
					}
				}
				#endregion
				io_clear();
				break;
			#endregion
			#region vk_tab
			case vk_tab:
				#region Autocomplete First Word
				if (space_count == 0 && ds_list_size(suggested) > 0) {
					input_string		= suggested[| suggested_index] + " ";
					input_index			= string_length(input_string);
					in_suggested		= false;
					space_count			= 1;
					suggested_index		= 0;
					suggested_action	= string_delete(input_string, string_length(input_string), 1);
					ds_list_clear(suggested);
				}
				#endregion
				#region Autocomplete Second Word
				else if (space_count == 1 && ds_list_size(suggested) > 0) {
					// Get Object Name Substring
					var _action_index  = 0;
					for (var i = 1; i <= string_length(input_string); i++) {
						if (string_char_at(input_string, i) == " " && string_char_at(input_string, i + 1) != ":") {
							_action_index = i + 1;
							break;
						}
					}
					
					var _object_string			= string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
					var _suggested_substring	= string_delete(suggested[| suggested_index], 1, string_length(_object_string));
					input_string	   += _suggested_substring + " ";
					input_index		   += string_length(_suggested_substring) + 1;
					in_suggested		= false;
					suggested_object	= suggested[| suggested_index];
					suggested_index		= 0;
					space_count		   += 1;
				}
				#endregion
				#region Autocomplete Fourth Word
				else if (space_count >= 4 && ds_list_size(suggested) > 0) {
					// Get Object Name Substring
					var _action_index  = 0;
					for (var i = 1; i <= string_length(input_string); i++) {
						if (string_char_at(input_string, i) == ",") {
							_action_index = i + 1;
							break;
						}
					}
					
					var _value_string			= string_copy(input_string, _action_index, string_length(input_string) - _action_index + 1);
					var _suggested_substring	= string_delete(suggested[| suggested_index], 1, string_length(_value_string) - 1);
					_suggested_substring		= string_replace_all(_suggested_substring, " ", "");
					input_string	   += _suggested_substring + " ";
					input_index		   += string_length(_suggested_substring) + 1;
					in_suggested		= false;
					suggested_index		= 0;
					space_count		   += 1;
				}
				#endregion
				
				#region Auto Format Colon
				event_user(5);
				#endregion
				#region Auto Format Comma
				if (keyboard_key == 188) {
					comma_placed			= true;	
					var _last_char			= string_char_at(input_string, string_length(input_string));
					var _second_last_char	= string_char_at(input_string, string_length(input_string) - 1);
					
					if (_last_char == ",") {
						if (_second_last_char != " ") {
							input_string  = string_delete(input_string, string_length(input_string), 1);
							input_string += " , ";
							space_count  += 2;
							input_index  += 2;
						}
						else {
							input_string += " ";
							space_count  += 1;
							input_index  += 1;
						}
					}
				}
				#endregion
				io_clear();
				break;
			#endregion
			#region vk_home
			case vk_home:
				if (_shift) {
					if (!shift_held)
						anchor_index = input_index;
					shift_held = true;
				}
				input_index = 0;
				
				#region Reset Shift Held
				if (!_shift) {
					anchor_index = undefined;
					shift_held	 = false;	
				}
				#endregion
				break;
			#endregion
			#region vk_end
			case vk_end:
				if (_shift) {
					if (!shift_held)
						anchor_index = input_index;
					shift_held = true;
				}
				input_index = string_length(input_string);
				
				#region Reset Shift Held
				if (!_shift) {
					anchor_index = undefined;
					shift_held	 = false;	
				}
				#endregion
				break;
			#endregion
			#region default
			default:
				if (in_history || in_suggested)	{
					in_history	 = false;
					in_suggested = false;
				}
				
				// Ignore Special Keys
				var _keys_to_ignore = [vk_f1, vk_home, vk_end, vk_enter, vk_shift, vk_lshift, vk_rshift, vk_control, vk_lcontrol, vk_rcontrol, vk_alt, vk_lalt, vk_ralt, 0];
				var _wrong_key		= false;
				for (var i = 0; i < array_length_1d(_keys_to_ignore); i++) {
					if (keyboard_key == _keys_to_ignore[i]) {
						_wrong_key = true;
						break;
					}
				}
				if (_wrong_key) break;
					
				if (keyboard_key == vk_space && string_char_at(input_string, string_length(input_string)) != " ")
					space_count++;
		
				// Normal Insert
				if (anchor_index == undefined) {
					input_string  = string_insert(keyboard_lastchar, input_string, input_index + 1);
					input_index  += string_length(keyboard_lastchar);
				}
				// Override Selected Text With Insert
				else if (!_modifier) {
					
					// Mass Delete
					var _string_delete = "";
					var _min = min(input_index, anchor_index);
					var _max = max(input_index, anchor_index);
					var _len = abs(input_index - anchor_index);
					
					for (var i = _min; i < _max; i++)
						_string_delete += string_char_at(input_string, i);
						
					input_string = string_delete(input_string, _min + 1, _len);
					anchor_index = undefined;
					
					for (var i = string_length(_string_delete); i >= 1; i--) {
						var _char = string_char_at(_string_delete, i);
						switch (_char) {
							case " ":
								if (string_char_at(_string_delete, i - 1) != " " && string_char_at(_string_delete, i - 1) != ":")
									space_count--;
								break;
								
							case ":":
								auto_delim = false;
								break;
								
							case ",":
								comma_placed = false;
								break;
						}
					}	
						
					input_string = string_insert(keyboard_lastchar, input_string, input_index + 1);
					input_index++;
				}
					
				#region Get Suggested Action
				if (space_count == 1) {
					var _index  = 0;
					for (var i = 1; i <= string_length(input_string); i++) {
						if (string_char_at(input_string, i) == " ") {
							_index = i + 1;
							break;
						}
					}
					suggested_action = string_copy(input_string, 1, _index - 2);
				}
				#endregion
				#region Get Suggested Object
				if (space_count == 2) {
					var _index  = 0;
					for (var i = 1; i <= string_length(input_string); i++) {
						if (string_char_at(input_string, i) == " ") {
							_index = i + 1;
							break;
						}
					}
					suggested_object = string_copy(input_string, _index, string_length(input_string) - _index);
				}
				#endregion
				#region Auto Format Colon
				event_user(5);
				#endregion
				#region Auto Format Comma
				if (keyboard_key == 188) {
					comma_placed			= true;	
					var _last_char			= string_char_at(input_string, string_length(input_string));
					var _second_last_char	= string_char_at(input_string, string_length(input_string) - 1);
					
					if (_last_char == ",") {
						if (_second_last_char != " ") {
							input_string  = string_delete(input_string, string_length(input_string), 1);
							input_string += " , ";
							space_count  += 2;
							input_index  += 2;
						}
						else {
							input_string += " ";
							space_count  += 1;
							input_index  += 1;
						}
					}
				}
				#endregion
				#region Reset Shift Held
				if (!_modifier) {
					anchor_index = undefined;
					shift_held	 = false;	
				}
				#endregion
				
				if (_anykey && !_modifier)
					io_clear();
				break;
			#endregion
		}
	}
	#region Hold Key Down
	if (_anykey && alarm[0] == -1) {
		
		// Ignore Special Keys
		var _keys_to_ignore = [vk_f1, vk_home, vk_end, vk_enter, vk_shift, vk_lshift, vk_rshift, vk_control, vk_lcontrol, vk_rcontrol, vk_alt, vk_lalt, vk_ralt, 0];
		var _wrong_key		= false;
		for (var i = 0; i < array_length_1d(_keys_to_ignore); i++) {
			if (keyboard_key == _keys_to_ignore[i]) {
				_wrong_key = true;
				break;
			}
		}
		if (!_wrong_key) {
			alarm[0] = hold_time;
			hold_key = keyboard_key;
		}
	}

	// Reset Holdkey
	if (!_anykey || !keyboard_check(hold_key)) {
		alarm[0] = -1;
		holding	 = false;
		hold_key = 0;
	}	
	#endregion
}
#region Trim History If Exceeds Storage Limit
if (show && ds_list_size(history) > history_limit)
	ds_list_delete(history, history_limit - 1);
#endregion

// Autocomplete Suggestions
event_user(6);