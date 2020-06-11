/// @description Save Terminal History & Props

var _buffer		= buffer_create(1, buffer_grow, 1);
var _data_map	= ds_map_create();
buffer_seek(_buffer, buffer_seek_start, 0);

#region Save History
_data_map[? "history_size"] = ds_list_size(history);

for (var i = 0; i < ds_list_size(history); i++) {
	var _data				= history[| i];
	var _input_string		= _data[0];
	var _input_index		= _data[1];
	var _space_count		= _data[2];
	var _comma_placed		= _data[3];
	var _auto_delim			= _data[4];
	var _command			= _data[5];
	var _failed				= _data[6];
	var _fail_message		= _data[7];
	var _suggested_action	= _data[8];
	var _suggested_object	= _data[9];
									
	var _data_point_map						= ds_map_create();
	_data_point_map[? "input_string"]		= _input_string;
	_data_point_map[? "input_index"]		= _input_index;
	_data_point_map[? "space_count"]		= _space_count;
	_data_point_map[? "comma_placed"]		= _comma_placed;
	_data_point_map[? "auto_delim"]			= _auto_delim;
	_data_point_map[? "command"]			= _command;
	_data_point_map[? "failed"]				= _failed;
	_data_point_map[? "fail_message"]		= _fail_message;
	_data_point_map[? "suggested_action"]	= _suggested_action;
	_data_point_map[? "suggested_object"]	= _suggested_object;
	
	var _data_point_string	= json_encode(_data_point_map);
	_data_map[? "h_" + string(i)] = _data_point_string;
	ds_map_destroy(_data_point_map);
}
#endregion
#region Save Fav Objects
_data_map[? "fav_objects_size"] = ds_list_size(fav_objects);

for (var i = 0; i < ds_list_size(fav_objects); i++) {
	var _fav_object_string					= fav_objects[| i];
	var _data_point_map						= ds_map_create();
	_data_point_map[? "fav_object_string"]	= _fav_object_string;
	
	var _data_point_string	= json_encode(_data_point_map);
	_data_map[? "fo_" + string(i)] = _data_point_string;
	ds_map_destroy(_data_point_map);
}
#endregion

var _data_string = json_encode(_data_map);
buffer_write(_buffer, buffer_text, _data_string);

// Encode Buffer
var _buffer_size	= buffer_get_size(_buffer);
var _encoded_string	= buffer_base64_encode(_buffer, 0, _buffer_size);
var _buffer_size	= string_length(_encoded_string);
var _buffer_encoded	= buffer_create(_buffer_size, buffer_fixed, 1);
buffer_seek(_buffer_encoded,  buffer_seek_start, 0);
buffer_write(_buffer_encoded, buffer_text, _encoded_string);

// Compress Buffer
var _buffer_compressed = buffer_compress(_buffer_encoded, 0, _buffer_size);
buffer_save(_buffer_compressed, "terminal.buf");

// Cleanup
buffer_delete(_buffer);
buffer_delete(_buffer_compressed);
buffer_delete(_buffer_encoded);