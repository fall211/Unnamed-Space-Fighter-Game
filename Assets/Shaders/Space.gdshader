shader_type sky;

uniform sampler2D sky_texture;
uniform sampler2D noise_texture;
uniform bool flicker;

void sky() {
	
	vec4 final_col = texture(sky_texture, SKY_COORDS);
	

	if (flicker){
		vec4 noise = texture(noise_texture, SKY_COORDS);
		vec4 noise2 = texture(noise_texture, -SKY_COORDS);
		noise += sin(TIME)/2.0 + 0.5;
		noise2 += sin(TIME + PI)/2.0 + 0.5;
		COLOR = noise.rgb * final_col.rgb;
	} else {
		COLOR = final_col.rgb;
	}

}