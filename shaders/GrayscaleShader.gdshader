shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
//
//void fragment() {
    ////COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	 //COLOR = texture(TEXTURE, UV);
    //float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    //COLOR.rgb = vec3(avg);
//}

uniform vec2 holeCenter;
uniform float holeRadius;
uniform float penumbra = 20.0;

varying vec2 p;

void vertex(){
	p = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0) ).xy;
}

void fragment(){
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
	float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    COLOR.rgb = vec3(avg);
	COLOR.a = smoothstep(holeRadius - penumbra/2.0, holeRadius + penumbra/2.0, length(p - holeCenter));
}