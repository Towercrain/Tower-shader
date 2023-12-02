//uniform float frameTimeCounter;

const vec3[16] endPortal_COLORS = vec3[](
    vec3(0.022087, 0.098399, 0.110818),
    vec3(0.011892, 0.095924, 0.089485),
    vec3(0.027636, 0.101689, 0.100326),
    vec3(0.046564, 0.109883, 0.114838),
    vec3(0.064901, 0.117696, 0.097189),
    vec3(0.063761, 0.086895, 0.123646),
    vec3(0.084817, 0.111994, 0.166380),
    vec3(0.097489, 0.154120, 0.091064),
    vec3(0.106152, 0.131144, 0.195191),
    vec3(0.097721, 0.110188, 0.187229),
    vec3(0.133516, 0.138278, 0.148582),
    vec3(0.070006, 0.243332, 0.235792),
    vec3(0.196766, 0.142899, 0.214696),
    vec3(0.047281, 0.315338, 0.321970),
    vec3(0.204675, 0.390010, 0.302066),
    vec3(0.080955, 0.314821, 0.661491)
);

const mat4 endPortal_SCALE_TRANSLATE = mat4(
    vec4(0.5, 0.0, 0.0, 0.25),
    vec4(0.0, 0.5, 0.0, 0.25),
    vec4(0.0, 0.0, 1.0, 0.0 ),
    vec4(0.0, 0.0, 0.0, 1.0 )
);

mat2 endPortal_ZRotate(float theta) {

    return mat2(
        vec2(cos(theta), -sin(theta)),
        vec2(sin(theta),  cos(theta))
    );

}

mat4 endPortal_CalcPortalLayerMatrix(float layer, float gameTime) {

    mat4 translate = mat4(
        vec4(1.0, 0.0, 0.0, 17.0 / layer),
        vec4(0.0, 1.0, 0.0, (2.0 + layer / 1.5) * (gameTime * 1.5)),
        vec4(0.0, 0.0, 1.0, 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );
    mat2 rotate = endPortal_ZRotate(radians((layer * layer * 4321.0 + layer * 9.0) * 2.0));
    mat2 scale = mat2((4.5 - layer / 4.0) * 2.0);
    return mat4(scale * rotate) * translate * endPortal_SCALE_TRANSLATE;

}

vec4 endPortal_CalcPortalColor(sampler2D portalTexture, vec2 uv) {

    float vaGameTime = frameTimeCounter * (20.0 / 24000.0); // GameTime ~ 20.0*frameTimeCounter/24000.0
    vec3 color = vec3(0.4627451, 0.3529412, 0.61960784) * endPortal_COLORS[0];
    vec4 coord = vec4(uv, 0.0, 1.0);
    for(int i = 0; i < 16; i++) {
        color += texture(
                portalTexture,
                (coord * endPortal_CalcPortalLayerMatrix(float(i + 1), vaGameTime)).xy
            ).rgb * endPortal_COLORS[i];
    }
    color = color_SRGBEOTF(color);
    return vec4(color, 1.0);

}
