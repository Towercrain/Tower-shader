
#define color_WAVELENGTH vec3(630.0, 532.0, 467.0) // unit : nanometers, reference : Rec.2020

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

#define color_P3_TO_XYZ mat3( \
    vec3(0.48658879, 0.22898296, 0.00000000), \
    vec3(0.26567182, 0.69174926, 0.04511408), \
    vec3(0.19816944, 0.07926778, 1.04369241) \
)
#define color_XYZ_TO_P3 mat3( \
    vec3( 2.49340549, -0.82947609,  0.03585448), \
    vec3(-0.93134947,  1.76263669, -0.07619078), \
    vec3(-0.40269602,  0.02362432,  0.95711553) \
)

#define color_BT2020_TO_XYZ mat3( \
    vec3(0.63697030, 0.26270527, 0.00000000), \
    vec3(0.14461883, 0.67800708, 0.02807307), \
    vec3(0.16884092, 0.05928765, 1.06073343) \
)
#define color_XYZ_TO_BT2020 mat3( \
    vec3( 1.71661816, -0.66667549,  0.01764404), \
    vec3(-0.35566394,  1.61645976, -0.04278076), \
    vec3(-0.25336141,  0.01576834,  0.94232661) \
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


#define color_ATMOSPHERE_DIFFUSE vec3(0.059127381, 0.11627981, 0.19583185) // 0.11627981 * pow(532.0 / WAVELENGTH, vec3(4.0))




#define color_MINIMUM_SKY_LIGHT_INTENSITY (1.0 / 64.0)
#define color_NIGHT_VISION_INTENSITY (1.0 / 16.0)
#define color_BLOCK_LIGHT_INTENSITY (1.0 / 2.0)

const vec3 color_MINIMUM_SKY_LIGHT_COLOR = vec3(0.6, 0.89, 3.23) * color_MINIMUM_SKY_LIGHT_INTENSITY;
//const vec3 color_NIGHT_VISION_COLOR = vec3(0.93, 0.93, 1.87) * color_NIGHT_VISION_INTENSITY;
const vec3 color_BLOCK_LIGHT_COLOR = vec3(1.17, 0.98, 0.71) * color_BLOCK_LIGHT_INTENSITY;

#if defined tsh_DIMENSION_THE_NETHER

    const float color_MINIMUM_LIGHT_INTENSITY = (1.0 / 64.0);
    const vec3 color_MINIMUM_LIGHT_COLOR = color_MINIMUM_LIGHT_INTENSITY * vec3(1.48, 0.89, 0.74);

#elif defined tsh_DIMENSION_OVERWORLD

    const float color_MINIMUM_LIGHT_INTENSITY = (1.0 / 256.0);
    const vec3 color_MINIMUM_LIGHT_COLOR = color_MINIMUM_LIGHT_INTENSITY * vec3(1.0, 1.0, 1.0);

#elif defined tsh_DIMENSION_THE_END

    const float color_MINIMUM_LIGHT_INTENSITY = (1.0 / 64.0);
    const vec3 color_MINIMUM_LIGHT_COLOR = color_MINIMUM_LIGHT_INTENSITY * vec3(1.08, 0.9, 1.79);

#endif
