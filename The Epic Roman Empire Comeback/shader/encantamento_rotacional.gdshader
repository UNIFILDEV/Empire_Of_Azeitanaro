shader_type canvas_item;

uniform float speed = 2.0; // Velocidade do efeito
uniform float intensity = 0.5; // Intensidade do brilho
uniform vec4 glow_color1 = vec4(1.0, 0.5, 1.0, 1.0); // Cor inicial do brilho (roxo)
uniform vec4 glow_color2 = vec4(0.0, 1.0, 1.0, 1.0); // Cor secundária do brilho (ciano)

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a == 0.0) {
        discard; // Mantém transparência
    }

    // Calcula o centro da textura
    vec2 center = vec2(0.5, 0.5);
    vec2 uv_offset = UV - center;

    // Aplica rotação às coordenadas UV
    float angle = TIME * speed;
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);
    vec2 rotated_uv = vec2(
        cos_angle * uv_offset.x - sin_angle * uv_offset.y,
        sin_angle * uv_offset.x + cos_angle * uv_offset.y
    ) + center;

    // Criação do efeito de onda com rotação
    float wave = sin(rotated_uv.y * 10.0) * 0.5 + 0.5;

    // Interpolação entre as cores para dar o efeito de oscilação
    vec4 glow = mix(glow_color1, glow_color2, wave);

    // Mistura do brilho encantado com a textura base
    COLOR = mix(tex_color, glow, intensity * wave);
}
