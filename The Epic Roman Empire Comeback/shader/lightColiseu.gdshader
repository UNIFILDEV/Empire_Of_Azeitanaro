shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 4.0; // Velocidade do piscar

void fragment() {
    float alpha = abs(sin(TIME * speed)); // Alterna entre 0 e 1
    vec4 color = texture(TEXTURE, UV);
    color.a *= alpha; // Ajusta a transparência com base no tempo
    COLOR = color;
}
