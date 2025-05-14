shader_type spatial;
render_mode unshaded; // Optional: Use for brighter colors, remove if you want lighting

uniform float pulse_amount = 0.1; // Controls intensity of color/opacity change
uniform float pulse_speed = 5.0; // Controls speed of pulsing
uniform vec3 base_color = vec3(1.0, 0.5, 0.5); // Default color (reddish)

void fragment() {
    float pulse = sin(TIME * pulse_speed) * pulse_amount;
    // Pulse color by modifying base color
    vec3 color = base_color + vec3(pulse, pulse * 0.5, pulse * 0.2);
    ALBEDO = color;
    // Optional: Pulse opacity (uncomment if you want transparency)
    // ALPHA = 1.0 - pulse * 0.5;
}