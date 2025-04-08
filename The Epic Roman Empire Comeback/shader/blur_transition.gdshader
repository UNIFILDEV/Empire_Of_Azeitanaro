shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // Controle da transição do círculo
uniform float loud : hint_range(0.0, 1.0) = 0.0; // Controle blur para transição

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = vec2(0.5, 0.5);
    float radius = mix(1.2, 0.0, progress);
    float dist = length(uv - center);
    float mask = smoothstep(radius - 0.02, radius, dist);

    // Aplicação do loud (efeito blur)
    float loud_effect = mix(0.0, 1.0, loud);
    // Mantém a tela sempre preta, revelando apenas o círculo
    vec4 final_color = mix(vec4(0.0), vec4(0.0, 0.0, 0.0, 1.0), mask * loud_effect);
    COLOR = final_color;
}
