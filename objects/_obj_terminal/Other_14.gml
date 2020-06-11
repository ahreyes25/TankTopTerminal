/// @description Load From Save File

if (file_exists("terminal.buf")) {
	// Load Buffer File
	var _buffer_compressed = buffer_load("terminal.buf");

	// Decompress Buffer
	var _buffer_encoded		 = buffer_decompress(_buffer_compressed);
	buffer_seek(_buffer_encoded, buffer_seek_start, 0);
	var _data_string_encoded = buffer_read(_buffer_encoded, buffer_text);

	// Decode Buffer
	var _buffer			= buffer_base64_decode(_data_string_encoded);
	buffer_seek(_buffer, buffer_seek_start, 0);
	var _data_string	= buffer_read(_buffer, buffer_text);
	var _data_map		= json_decode(_data_string);

	ds_list_clear(history);

	var _size = _data_map[? "size"];
	
	for (var i = 0; i < _size; i++) {
		var _data_point_string	= _data_map[? string(i)];
		var _data_point_map		= json_decode(_data_point_string);
		
		var _input_string		= _data_point_map[? "input_string"];
		var _input_index		= _data_point_map[? "input_index"];
		var _space_count		= _data_point_map[? "space_count"];
		var _comma_placed		= _data_point_map[? "comma_placed"];
		var _auto_delim			= _data_point_map[? "auto_delim"];
		var _command			= _data_point_map[? "command"];
		var _failed				= _data_point_map[? "failed"];
		var _fail_message		= _data_point_map[? "fail_message"];
		var _suggested_action	= _data_point_map[? "suggested_action"];
		var _suggested_object	= _data_point_map[? "suggested_object"];
		
		ds_list_add(history, [_input_string, _input_index, _space_count, _comma_placed, _auto_delim, _command, _failed, _fail_message, _suggested_action, _suggested_object]);
		ds_map_destroy(_data_point_map);
	}	
	
	// Cleanup
	buffer_delete(_buffer);
	buffer_delete(_buffer_compressed);
	buffer_delete(_buffer_encoded);
	ds_map_destroy(_data_map);
}