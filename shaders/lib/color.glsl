
#define color_WAVELENGTH vec3(612.0, 549.0, 465.0) // unit : nanometers

/*
RGB = XYZ_TO_RGB * XYZ
*/

#define color_SRGB_TO_XYZ mat3( \
    vec3(0.41240788, 0.21264781, 0.01933162), \
    vec3(0.35758957, 0.71517915, 0.11919652), \
    vec3(0.18043260, 0.07217304, 0.95027835) \
)
#define color_XYZ_TO_SRGB mat3( \
    vec3( 3.24083571, -0.96922945,  0.05564494), \
    vec3(-1.53731950,  1.87594004, -0.20403144), \
    vec3(-0.49859011,  0.04155445,  1.05725381) \
)

#define color_PRIMARIES_TO_XYZ mat3( \
    vec3(0.47004978, 0.22944189, 0.00013293), \
    vec3(0.30262467, 0.71824156, 0.00689629), \
    vec3(0.17775560, 0.05231656, 1.08177728) \
)
#define color_XYZ_TO_PRIMARIES mat3( \
    vec3( 2.67612518, -0.85525996,  0.00512341), \
    vec3(-1.12386116,  1.75210963, -0.01103153), \
    vec3(-0.38538403,  0.05579975,  0.92409634) \
)

#define color_LMS_TO_XYZ mat3( \
    vec3( 1.86006661,  0.36122292,  0.00000000), \
    vec3(-1.12948008,  0.63880431, -0.00000000), \
    vec3( 0.21989830, -0.00000713,  1.08908734) \
)
#define color_XYZ_TO_LMS mat3( \
    vec3( 0.40020000, -0.22630000, 0.00000000), \
    vec3( 0.70760000,  1.16530000, 0.00000000), \
    vec3(-0.08080000,  0.04570000, 0.91820000) \
)

vec3 color_SRGBEOTF(vec3 color) {
    return mix((1.0 / 12.92) * color, pow((1.0 / 1.055) * (color + 0.055), vec3(2.4)), vec3(lessThan(vec3(0.04045), color)));
}

vec3 color_SRGBOETF(vec3 color) {
    return mix(12.92 * color, 1.055 * pow(color, vec3(1.0 / 2.4)) - 0.055, vec3(lessThan(vec3(0.0031308), color)));
}


vec3 color_TowerShaderToneMap(vec3 color) {

    color = max(color, 0.0);
    return 1.0 - 1.0 / (((color + 1.0) * color + 1.0) * color + 1.0);

}


#define color_ATMOSPHERE_DIFFUSE vec3(0.066396495, 0.10253248, 0.19922280) // 0.11627981 * pow(532.0 / WAVELENGTH, vec3(4.0))
#define color_SUN_LUMINANCE 131.6461


const vec3 color_MINIMUM_SKY_LIGHT_COLOR = exp2(-6) * 0.5 * vec3(0.63, 0.81, 2.92);
const vec3 color_BLOCK_LIGHT_COLOR = exp2(0) * 0.5 * vec3(1.28, 1.01, 0.80);
const vec3 color_MINIMUM_LIGHT_COLOR = exp2(-6) * 0.5 * vec3(1.0, 1.0, 1.0);
