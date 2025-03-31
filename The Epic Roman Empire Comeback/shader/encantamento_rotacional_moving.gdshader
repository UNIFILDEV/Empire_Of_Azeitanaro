shader_type canvas_item;

uniform float speed = 2.0; // Velocidade do efeito de brilho
uniform float intensity = 0.5; // Intensidade do brilho
uniform vec4 glow_color1 = vec4(1.0, 0.5, 1.0, 1.0); // Cor inicial do brilho (roxo)
uniform vec4 glow_color2 = vec4(0.0, 1.0, 1.0, 1.0); // Cor secundária do brilho (ciano)

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    if (tex_color.a == 0.0) {
        discard; // Mantém transparência
    }

    // Criação do efeito de oscilação de brilho
    float wave = sin(TIME * speed) * 0.5 + 0.5;

    // Interpolação entre as cores para dar o efeito de oscilação
    vec4 glow = mix(glow_color1, glow_color2, wave);

    // Mistura do brilho encantado com a textura base
    COLOR = mix(tex_color, glow, intensity * wave);
}
