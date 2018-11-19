shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_back,diffuse_burley,specular_schlick_ggx;


void node_emission(vec4 emission_color, float strength, out vec3 emission_out){
	if (strength < 0.2) {
		strength = 0.2;
	}
	
    emission_out = emission_color.rgb * strength;
}


void fragment() {
	float var1_Emission_Strength;
	var1_Emission_Strength = 5.0;
	vec3 var2_Emission_output_emission;
	node_emission(vec4(0.20650236904621124, 0.02781110256910324, 0.04908143728971481, 1.0), sin(TIME * 3.0) * var1_Emission_Strength, var2_Emission_output_emission);
	EMISSION = var2_Emission_output_emission;
	ALBEDO = var2_Emission_output_emission.rgb;
}
