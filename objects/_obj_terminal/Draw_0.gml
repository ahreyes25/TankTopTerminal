// Draw Arrow Over Selected Instance
if (show && in_history) {
	var _history_data	= history[| history_index];
	var _command		= _history_data[5];
	
	if (!_command) {
		var _prop		= _history_data[0];
		var _bob_iter	= bob_iter;
		
		with (all) {
			if (string(id) == _prop) {
				var _scale = 0.5;
				draw_sprite_ext(spr_arrow, 0, x, y + sin(_bob_iter / 2) * 5, _scale, _scale, 0, c_white, 0.75);
				break;	
			}
		}
	}
}