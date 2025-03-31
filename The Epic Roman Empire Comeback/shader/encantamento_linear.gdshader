shader_type canvas_item;

uniform float speed = 2.0;
uniform float intensity = 0.5;
uniform vec4 glow_color1 = vec4(1.0, 0.5, 1.0, 1.0);
uniform vec4 glow_color2 = vec4(0.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (tex_color.a == 0.0) {
        discard;
    }
    
    float wave = sin((UV.y + TIME * speed) * 10.0) * 0.5 + 0.5;
    
    vec4 glow = mix(glow_color1, glow_color2, wave);
   
    COLOR = mix(tex_color, glow, intensity * wave);
}
