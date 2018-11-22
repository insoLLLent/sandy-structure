extends ShaderMaterial

var prev_val = null

func set_pause_material(val):
	if prev_val == null or prev_val != val:
		set_shader_param("isPaused", val)
		prev_val = val

