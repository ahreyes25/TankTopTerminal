/// @description Act On Tokens & Store In History

var _action = tokens[| 0];
var _object = tokens[| 1];
var _props  = ds_list_create();
var _values = ds_list_create();
var _delim	= false;

#region Organize Tokens
for (var i = 2; i < ds_list_size(tokens); i++) {
	var _token = tokens[| i];
	if (_token == ",") {
		_delim = true;
		continue;
	}
	if (_token == ":")
		continue;
	
	if (!_delim)
		ds_list_add(_props, tokens[| i]);
	else
		ds_list_add(_values, tokens[| i]);
}
#endregion

var _failed = true;
switch (_action) {
	#region create
	case "create":
		var _failed			= true;
		var _object_index	= undefined;
		
		for (var i = 0; i < 10000; i++) {
			if (!object_exists(i)) break;
			
			if (object_get_name(i) == _object) {
				_object_index = i;
				break;
			}
		}
		
		if (_object_index != undefined) {
			var _instance = instance_create_depth(0, 0, 0, _object_index);
			
			if (_instance != undefined && instance_exists(_instance)) {
				_failed = false;
				
				for (var i = 0; i < ds_list_size(_props); i++) {
					var _param = _props[| i];
					var _value = _values[| i];
					
					if (_param != undefined && _param != "" && _value != undefined && _value != "") {
						if (variable_instance_exists(_instance, _param)) {
							if (is_string(_value))
								variable_instance_set(_instance, _param, _value);
							else
								variable_instance_set(_instance, _param, real(_value));
						}
					}
				}
			}
		}
		ds_list_insert(history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
	#region destroy
	case "destroy":
		var _failed = true;
		
		with (all) {			
			if (string(id) == _object) {
				instance_destroy();	
				_failed = false;
			}
			else if (object_get_name(object_index) == _object) {
				instance_destroy();	
				_failed = false;
			}
		}
		ds_list_insert(history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
	#region get
	case "get":
		var _failed	 = true;
		var _history = history;
		var _inserts = ds_list_create();
		
		with (all) {
			if (string(id) == _object || object_get_name(object_index) == _object) {
				for (var i = 0; i < ds_list_size(_props); i++) {
					var _prop = _props[| i];
					
					if (_prop != undefined && _prop != "") {
						if (variable_instance_exists(id, _prop)) {
							var _get_string = string(variable_instance_get(id, _prop));
							_failed = false;
							ds_list_add(_inserts, [_get_string, string_length(_get_string), 0, false, false, false, _failed]);
						}
					}	
				}
			}
		}
		ds_list_insert(history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		
		for (var i = 0; i < ds_list_size(_inserts); i++)
			ds_list_insert(history, 0, _inserts[| i]);	
		ds_list_destroy(_inserts);
		break;
	#endregion
	#region set
	case "set":
		var _failed	 = true;
		var _history = history;
		
		with (all) {
			if (string(id) == _object || object_get_name(object_index) == _object) {
				for (var i = 0; i < ds_list_size(_props); i++) {
					var _param = _props[| i];
					var _value = _values[| i];
					
					if (_param != undefined && _param != "" && _value != undefined && _value != "") {
						if (variable_instance_exists(id, _param)) {
							if (is_string(_value))
								variable_instance_set(id, _param, _value);
							else
								variable_instance_set(id, _param, real(_value));
							_failed = false;
						}
					}	
				}
			}
		}
		ds_list_insert(_history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
	#region watch
	case "watch":
		var _failed	 = true;
		var _history = history;
		
		if (ds_list_size(_props) > 0) {
			var _gui = instance_create_depth(sw / 2, sh / 2, 0, _obj_terminal_gui);
			ds_list_add(gui_objects, _gui);
		
			with (all) {
				if (string(id) == _object || object_get_name(object_index) == _object) {
					// Collect Values and Props to Store
					var _values_list = ds_list_create();
					for (var i = 0; i < ds_list_size(_props); i++) {
						var _prop = _props[| i];
					
						if (_prop != undefined && _prop != "") {
							if (variable_instance_exists(id, _prop)) {
								var _get_string = string(variable_instance_get(id, _prop));
								var _value = [_prop, _get_string, _get_string, _get_string];
								ds_list_add(_values_list, _value);
								_failed = false;
							}
						}	
					}
					
					// Add Values To Existing, or New Gui Objects
					if (ds_list_size(_values_list) > 0) {
						var _existing_gui = undefined;
						
						// Check Against All Object Indexes
						with (_obj_terminal_gui) {
							if (id != _gui && object_get_name(object) == _object) {
								_existing_gui = id;
								break;	
							}
						}
						
						// Check Against All Instance IDs
						if (_existing_gui == undefined) {
							with (_obj_terminal_gui) {
								if (id != _gui && _existing_gui == undefined) {
									var _id = id;
									with (object) {
										if (id == _object) {
											_existing_gui = _id;
											break;
										}
									}
								}
							}
						}
						
						// No Previously Existing Gui Object
						if (_existing_gui == undefined) {
							_gui.object = object_index;
							ds_list_add(_gui.instances, id);
							ds_list_add(_gui.values, _values_list);
						}
						// Gui Object Already Exists
						else {
							ds_list_delete(_obj_terminal.gui_objects, ds_list_find_index(_obj_terminal.gui_objects, _existing_gui));
							instance_destroy(_existing_gui);
							_gui.object = object_index;
							ds_list_add(_gui.instances, id);
							ds_list_add(_gui.values, _values_list);
						}
					}
				}
			}
		}
		ds_list_insert(_history, 0, [input_string, string_length(input_string), space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
	#region clear
	case "clear":
		ds_list_clear(history);
		_failed = false;
		break;
		
	case "cls":
		ds_list_clear(history);
		_failed = false;
		break;
	#endregion
	#region room
	case "room":
		var _failed = true;
		
		switch (_object) {
			case "restart":
				room_restart();
				_failed = false;
				break;
				
			case "goto":
				break;
			
			case "next":
				if (room_exists(room + 1)) {
					room_goto_next();
					_failed = false;
				}
				break;
				
			case "previous":
				if (room_exists(room - 1)) {
					room_goto_previous();
					_failed = false;
				}
				break;
		}
		ds_list_insert(history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
	#region default
	default:
		ds_list_insert(history, 0, [input_string, input_index, space_count, comma_placed, auto_delim, true, _failed]);
		break;
	#endregion
}
#region Set Penguin State
if (_failed)
	penguin_state = "angry";
else
	penguin_state = "happy";
#endregion

ds_list_destroy(_props);
ds_list_destroy(_values);