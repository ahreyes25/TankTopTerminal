// Util
sw					= surface_get_width(application_surface);
sh					= surface_get_height(application_surface);
char_width			= string_width("A");
char_height			= string_height("A");
					
// String			
input_string		= "";
input_index			= 0;
input_string_y		= 0;
tokens				= ds_list_create();
text_padding		= 20;
shift				= false;
auto_delim			= false;
comma_placed		= false;
anchor_index		= undefined;
shift_held			= false;
suggested_action	= "";
commands			= [
	"create", "destroy", "get", "set", "watch", "clear",
];
objects_ignore		= [
	_obj_terminal, _obj_terminal_gui
];

// Keyboard
hold_time			= 30;
holding				= false;
hold_key			= undefined;
typing				= true;
space_count			= 0;
					
// Decorative		
blink_iter			= 0;
blink_speed			= 0.05;
text_color			= c_white;
					
// Terminal			
terminal_y			= 0;
terminal_yt			= sh / 2;
show				= true;
history				= ds_list_create();
in_history			= false;
history_index		= 0;
history_limit		= 15;
suggested			= ds_list_create();
in_suggested		= false;
suggested_index		= 0;
suggested_y			= terminal_y;
suggestion_limit	= 10;

// Logo
penguin_scale		= 10;
penguin_image_index	= 0;
penguin_image_speed	= 0.05;
penguin_state		= "idle";
bob_iter			= 0;
bob_iter_speed		= 0.3;
orange				= make_color_rgb(242, 102, 47);

// Other 
gui_objects			= ds_list_create();