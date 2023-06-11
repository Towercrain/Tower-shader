#define tsh_SHADERS_INFORMATION 0

#define tsh_PI 3.1415927410125732421875

#define tsh_ENCODE_GAMMA 2.2
#define tsh_DECODE_GAMMA 2.2

#define tsh_VANILLA_LIGHT_POS_0 normalize(vec3( 1.0, 4.0, -3.0))
//#define tsh_VANILLA_LIGHT_POS_1 normalize(vec3(-1.0, 4.0, 3.0))
#define tsh_VANILLA_LIGHT_POS_1 normalize(vec3(-1.0, -4.0, 3.0))

#define tsh_SHADOW_DISTORTION 6.0

// ======== orthographic settings ========

//#define tsh_ORTHOGRAPHIC_PROJECTION
#define tsh_ORTHOGRAPHIC_VIEW_DISTANCE 16.0 // [1.0 1.5 2.0 3.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0 192.0 256.0]

// ========  ========

const vec3 tsh_WAVELENGTH = vec3(612.0, 549.0, 464.0); // nanometers
const vec3 tsh_ATMOSPHERE_DIFFUSE = 0.11627981 * pow(532.0 / tsh_WAVELENGTH, vec3(4.0));

// ======== colors ========

#define tsh_MINIMUM_SKY_LIGHT_INTENSITY (1.0 / 128.0)
#define tsh_NIGHT_VISION_INTENSITY (1.0 / 16.0)
#define tsh_BLOCK_LIGHT_INTENSITY (1.0 / 2.0)

#define tsh_MINIMUM_SKY_LIGHT_COLOR vec3(0.6, 0.89, 3.23) * tsh_MINIMUM_SKY_LIGHT_INTENSITY
#define tsh_NIGHT_VISION_COLOR vec3(0.93, 0.93, 1.87) * tsh_NIGHT_VISION_INTENSITY
#define tsh_BLOCK_LIGHT_COLOR vec3(1.17, 0.98, 0.71) * tsh_BLOCK_LIGHT_INTENSITY

#if defined tsh_DIMENSION_THE_NETHER

    const float tsh_MINIMUM_LIGHT_INTENSITY = (1.0 / 128.0);
    const vec3 tsh_MINIMUM_LIGHT_COLOR = tsh_MINIMUM_LIGHT_INTENSITY * vec3(1.48, 0.89, 0.74);

#elif defined tsh_DIMENSION_OVERWORLD

    const float tsh_MINIMUM_LIGHT_INTENSITY = (1.0 / 1024.0);
    const vec3 tsh_MINIMUM_LIGHT_COLOR = tsh_MINIMUM_LIGHT_INTENSITY * vec3(1.0, 1.0, 1.0);

#elif defined tsh_DIMENSION_THE_END

    const float tsh_MINIMUM_LIGHT_INTENSITY = (1.0 / 128.0);
    const vec3 tsh_MINIMUM_LIGHT_COLOR = tsh_MINIMUM_LIGHT_INTENSITY * vec3(1.08, 0.9, 1.79);

#endif

// ======== ========

#define tsh_ShadowMapResolution 2048
#define tsh_ShadowDistance 160.0
