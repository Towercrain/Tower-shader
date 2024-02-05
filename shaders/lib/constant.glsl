#define tsh_PI 3.1415927410125732421875

// ======== ambient light position ========

//#define tsh_VANILLA_LIGHT_POS_0 normalize(vec3( 1.0, 4.0,-3.0))
//#define tsh_VANILLA_LIGHT_POS_1 normalize(vec3(-1.0, 4.0, 3.0))
#define tsh_AMBIENT_LIGHT_POS_0 normalize(vec3( 1.0, 5.0, -3.0))
#define tsh_AMBIENT_LIGHT_POS_1 normalize(vec3(-1.0, -5.0, 3.0))

// ======== settings ========

//#define tsh_ORTHOGRAPHIC_PROJECTION
#define tsh_ORTHOGRAPHIC_VIEW_DISTANCE 16.0 // [1.0 1.5 2.0 3.0 4.0 6.0 8.0 12.0 16.0 24.0 32.0 48.0 64.0 96.0 128.0 192.0 256.0 384.0 512.0]

//#define tsh_FAST_SHADOWS

#ifdef tsh_FAST_SHADOWS
    //avoiding glsl optimization for this option
#endif

// ======== shadow map ========

#define tsh_SHADOW_DISTANCE 160.0 // [32.0 48.0 64.0 80.0 96.0 112.0 128.0 144.0 160.0 176.0 192.0 208.0 224.0 240.0 256.0 272.0 288.0 304.0 320.0 336.0 352.0 368.0 384.0 400.0 416.0 432.0 448.0 464.0 480.0 496.0 512.0]

#define tsh_SHADOW_DISTORTION 6.0 // [1.0 6.0]


#if tsh_SHADOW_DISTANCE <= 64.0

    #if tsh_SHADOW_DISTORTION <= 1.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 2.0
        #define tsh_SHADOW_MAP_RESOLUTION 2048
    #elif tsh_SHADOW_DISTORTION <= 4.0
        #define tsh_SHADOW_MAP_RESOLUTION 1024
    #else // tsh_SHADOW_DISTORTION <= 8.0
        #define tsh_SHADOW_MAP_RESOLUTION 512
    #endif

#elif tsh_SHADOW_DISTANCE <= 128.0

    #if tsh_SHADOW_DISTORTION <= 1.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 2.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 4.0
        #define tsh_SHADOW_MAP_RESOLUTION 2048
    #else // tsh_SHADOW_DISTORTION <= 8.0
        #define tsh_SHADOW_MAP_RESOLUTION 1024
    #endif

#elif tsh_SHADOW_DISTANCE <= 256.0

    #if tsh_SHADOW_DISTORTION <= 1.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 2.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 4.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #else // tsh_SHADOW_DISTORTION <= 8.0
        #define tsh_SHADOW_MAP_RESOLUTION 2048
    #endif

#else // tsh_SHADOW_DISTANCE <= 512.0

    #if tsh_SHADOW_DISTORTION <= 1.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 2.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #elif tsh_SHADOW_DISTORTION <= 4.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #else // tsh_SHADOW_DISTORTION <= 8.0
        #define tsh_SHADOW_MAP_RESOLUTION 4096
    #endif

#endif


const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;
const bool shadowColor0Nearest = true;
