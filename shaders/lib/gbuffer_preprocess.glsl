#if defined tsh_PROGRAM_gbuffers_armor_glint

    #define tsh_VARYING_TextureCoord

#elif defined tsh_PROGRAM_gbuffers_basic

    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_beaconbeam

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord

#elif defined tsh_PROGRAM_gbuffers_block

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_clouds

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_damagedblock

    #define tsh_VARYING_TextureCoord

#elif defined tsh_PROGRAM_gbuffers_entities

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_hand_water

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_hand

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_line

#elif defined tsh_PROGRAM_gbuffers_skybasic

#elif defined tsh_PROGRAM_gbuffers_skytextured

    #define tsh_VARYING_TextureCoord

#elif defined tsh_PROGRAM_gbuffers_spidereyes

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_terrain

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_VARYING_BlockId
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_textured_lit

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_textured

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_Normal

#elif defined tsh_PROGRAM_gbuffers_water

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_VARYING_BlockId
    #define tsh_USE_SHADOW

#elif defined tsh_PROGRAM_gbuffers_weather

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_Normal
    #define tsh_USE_SHADOW

#endif

/*

#elif defined tsh_PROGRAM_gbuffers_

    #define tsh_VARYING_TextureCoord
    #define tsh_VARYING_LightmapCoord
    #define tsh_VARYING_AmbientShading
    #define tsh_VARYING_Normal
    #define tsh_VARYING_BlockId
    #define tsh_USE_SHADOW

*/

#if defined tsh_USE_SHADOW && !(defined tsh_DIMENSION_OVERWORLD)
    #undef tsh_USE_SHADOW
#endif
