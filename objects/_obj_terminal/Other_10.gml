/// @description Parse Tokens

ds_list_clear(tokens);
typing				= false;
var _token			= "";
var _string_length	= string_length(input_string)

for (var i = 1; i <= _string_length; i++) {
	var _char = string_char_at(input_string, i);
	
	// Skip Spaces
	if (_char == " " && _token == "")
		continue;
	
	// Store Token
	if (_char == " ") {
		ds_list_add(tokens, _token);	
		_token = "";
	}
	// Last Char In Token String
	else if (i == _string_length) {
		_token += _char;
		ds_list_add(tokens, _token);	
		_token = "";
	}
	// Add Char To Token
	else 
		_token += _char;
}
typing = true;

// Act On Tokens
event_user(1);