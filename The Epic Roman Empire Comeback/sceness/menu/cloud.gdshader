shader_type canvas_item;

uniform float move_speed = 0.5;

void vertex() {
    UV.x += TIME * move_speed; // Move a coordenada UV no eixo X ao longo do tempo
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV); // Amostra a textura usando as coordenadas UV
    COLOR = tex_color; // Aplica a cor da textura ao fragmento
}
