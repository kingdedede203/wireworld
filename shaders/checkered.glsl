vec4 effect(vec4 colour, Image tex, vec2 texture_coords, vec2 screen_coords) {
    float mask = mod(dot(floor(screen_coords / 10.0), vec2(1.0)), 2.0);
    float square_colour = mix(0.2, 0.333, mask); /* 0.333*mask + 0.2*(1-mask); */

    return vec4(vec3(square_colour), 1.0);
}
