#define tsh_PI 3.1415927410125732421875

// ======== ambient light position ========

//#define tsh_VANILLA_LIGHT_POS_0 normalize(vec3( 1.0, 4.0,-3.0))
//#define tsh_VANILLA_LIGHT_POS_1 normalize(vec3(-1.0, 4.0, 3.0))
#define tsh_AMBIENT_LIGHT_POS_0 normalize(vec3( 1.0, 5.0, -3.0))
#define tsh_AMBIENT_LIGHT_POS_1 normalize(vec3(-1.0, -5.0, 3.0))

// ======== options ========

//#define tsh_ORTHOGRAPHIC_PROJECTION
#define tsh_ORTHOGRAPHIC_VIEW_DISTANCE 16.0 // [1.0 1.5 2.0 3.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0 192.0 256.0 384.0 512.0]

//#define tsh_NIGHTVISION_LIGHT

//#define tsh_FAST_SHADOWS

#ifdef tsh_FAST_SHADOWS
#endif

// ======== shadow map ========

#define tsh_SHADOW_DISTANCE 512
#define tsh_SHADOW_DISTORTION 16.0
#define tsh_SHADOW_MAP_RESOLUTION 2048

const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowColor0Nearest = true;
