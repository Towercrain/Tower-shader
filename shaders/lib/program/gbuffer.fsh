// ======== preprocess ========

#define tsh_PROGRAM_fsh

#include "/lib/gbuffer_preprocess.glsl"

// ======== input ========

in vec4 v_VertexColor;

#ifdef tsh_VARYING_TextureCoord
    in vec2 v_TextureCoord;
#endif
#ifdef tsh_VARYING_LightmapCoord
    in vec2 v_LightmapCoord;
#endif
#ifdef tsh_VARYING_Normal
    in vec3 v_Normal;
#endif
#ifdef tsh_VARYING_BlockId
    in float v_BlockId;
#endif

// ======== output ========

/* DRAWBUFFERS:0 */
out vec4 outColor0;

// ======== uniform ========

uniform int fogShape;
uniform int entityId;
uniform int blockEntityId;

uniform vec3 skyColor;
uniform vec3 fogColor;
uniform vec4 entityColor;

uniform float fogStart, fogEnd;
uniform vec3 shadowLightPosition;
uniform vec3 sunPosition;

uniform float nightVision;
uniform float rainStrength;
uniform float moonBrightness;

uniform int renderStage;
uniform float alphaTestRef;
uniform float frameTimeCounter;
uniform vec2 viewResolution;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform sampler2D gtexture;
//uniform sampler2D lightmap;

#if defined tsh_USE_SHADOW
    uniform sampler2DShadow shadowtex0;
    uniform sampler2DShadow shadowtex1;
    uniform sampler2D shadowcolor0;
#endif

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#if defined tsh_PROGRAM_gbuffers_block
    #include "/lib/module/end_portal.glsl"
#endif

#if defined tsh_USE_SHADOW
    #include "/lib/module/shadow.glsl"
#endif

void main() {

    #ifdef tsh_ORTHOGRAPHIC_PROJECTION
        #define gbufferProjectionInverse mat4( \
            vec4(tsh_ORTHOGRAPHIC_VIEW_DISTANCE * gbufferProjectionInverse[0].x, 0.0, 0.0, 0.0), \
            vec4(0.0, tsh_ORTHOGRAPHIC_VIEW_DISTANCE * gbufferProjectionInverse[1].y, 0.0, 0.0), \
            vec4(0.0, 0.0, -1024.0, 0.0), \
            vec4(0.0, 0.0, 0.0, 1.0) \
        )
    #endif

    #ifdef tsh_VARYING_BlockId
        int blockIdInt = int(floor(v_BlockId));
    #endif

    vec4 screenPos = vec4(gl_FragCoord.xy / viewResolution, gl_FragCoord.z, 1.0);
    vec4 ndcPos = 2.0 * screenPos - 1.0;
    vec4 viewPos = gbufferProjectionInverse * ndcPos; viewPos /= viewPos.w;
    vec4 playerPos = gbufferModelViewInverse * viewPos;
    vec4 scenePos = vec4(mat3(gbufferModelViewInverse) * viewPos.xyz, 1.0);

    // ======== diffuse process ========

    vec4 diffuse;

    #if defined tsh_PROGRAM_gbuffers_terrain || defined tsh_PROGRAM_gbuffers_water
        diffuse = vec4(v_VertexColor.rgb, 1.0);
    #else
        diffuse = v_VertexColor;
    #endif

    #ifdef tsh_VARYING_TextureCoord
        vec4 textureColor = texture(gtexture, v_TextureCoord);
        #if !defined tsh_PROGRAM_gbuffers_damagedblock
            textureColor.rgb = color_SRGBEOTF(textureColor.rgb);
        #endif
        diffuse *= textureColor;
    #endif

    #if defined tsh_PROGRAM_gbuffers_entities
        if(entityId == 16384) {diffuse = vec4(1.0);}
    #endif
/*
    #if defined tsh_PROGRAM_gbuffers_textured_lit
        if(renderStage == MC_RENDER_STAGE_WORLD_BORDER) {
            diffuse.a *= smoothstep(128.0, 0.0, length(scenePos.xyz));
        }
    #endif
*/
    if(diffuse.a < alphaTestRef) {discard;}

    #if defined tsh_PROGRAM_gbuffers_entities
        diffuse.rgb = mix(diffuse.rgb, color_SRGBEOTF(entityColor.rgb), entityColor.a);
    #endif

    // ======== light process ========

    vec3 light = vec3(1.0);

    float sunDirectionHeight = dot(gbufferModelView[1].xyz, normalize(sunPosition));
    vec3 sunLightColor = color_XYZ_TO_P3 * color_BT2020_TO_XYZ * exp(-color_ATMOSPHERE_DIFFUSE / abs(sunDirectionHeight));
    if(sunDirectionHeight < 0.0) {
        sunLightColor *= (1.0 / color_SUN_LUMINANCE) * moonBrightness; // moon light color
    }
    sunLightColor *= 1.0 - rainStrength;

    #ifdef tsh_VARYING_LightmapCoord

        vec2 lighting = exp2(8.0 * v_LightmapCoord - 8.0) - (1.0 / 256.0);

        vec3 skyLight = color_SRGBEOTF(skyColor);
        skyLight = 0.5 * skyLight + 0.25 * sunLightColor;
        skyLight *= lighting.y;

        vec3 ambientLight = skyLight + color_MINIMUM_LIGHT_COLOR;

        #ifdef tsh_VARYING_AmbientShading
            ambientLight *= tshf_CalcAmbientLight(v_Normal);
        #endif

        #if defined tsh_PROGRAM_gbuffers_terrain || defined tsh_PROGRAM_gbuffers_water
            ambientLight *= v_VertexColor.a;
        #endif

        vec3 blockLight = color_BLOCK_LIGHT_COLOR * lighting.x;

        light = ambientLight + blockLight;

        light += nightVision * 0.0625 * vec3(0.63, 0.81, 2.92);

    #endif

    #if defined tsh_USE_SHADOW

        // ==== get shadow clip position ====

        vec4 shadowPlayerPos = playerPos;

        #if (defined tsh_PROGRAM_gbuffers_hand || defined tsh_PROGRAM_gbuffers_hand_water) && !defined tsh_ORTHOGRAPHIC_PROJECTION
            shadowPlayerPos.xyz *= 1.0 / MC_HAND_DEPTH;
        #endif

        #ifdef tsh_VARYING_BlockId
            bool flip = (blockIdInt == 16385);
        #else
            const bool flip = false;
        #endif

        vec4 shadowClipPos = shadowProjection * shadowModelView * shadowPlayerPos;
        shadowClipPos.xyz += 2.0 * shadow_CalcShadowOffset(shadowClipPos, v_Normal, flip);
        shadowClipPos = shadow_DistortShadowClipPos(shadowClipPos);

        // ==== shadow light process ====

        vec3 shadowLightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
        float dotLN = dot(shadowLightDir, v_Normal);

        vec3 shadowLightColor = vec3(1.0);
        bool shadowClip = shadow_CalcShadowClip(shadowClipPos);
        if(!shadowClip) {shadowLightColor *= shadow_CalcShadowMask(shadowClipPos);}
        #ifdef tsh_VARYING_BlockId
            if(blockIdInt == 16385) {
                shadowLightColor *= abs(dotLN);
            } else if(blockIdInt == 16387) {
                shadowLightColor = vec3(0.0);
            } else {
                shadowLightColor *= 2.0 * max(dotLN, 0.0);
            }
        #elif defined tsh_PROGRAM_gbuffers_clouds
            //shadowLightColor *= 1.0;
        #else
            shadowLightColor *= 2.0 * max(dotLN, 0.0);
        #endif

        #ifdef tsh_VARYING_LightmapCoord
            shadowLightColor *= lighting.y;
        #endif

        shadowLightColor *= sunLightColor;

        // ==== combining shadow light to light ====

        light += shadowLightColor;

    #endif

    #if defined tsh_PROGRAM_gbuffers_textured_lit
        //if(renderStage == MC_RENDER_STAGE_WORLD_BORDER) {light = vec3(1.0);}
    #endif

    #if defined tsh_PROGRAM_gbuffers_entities
        if(entityId == 16384) {light = vec3(1.0);}
    #endif

    // ======== combining diffuse and light to color ========

    #if !(defined tsh_PROGRAM_gbuffers_skybasic || defined tsh_PROGRAM_gbuffers_skytextured)
        //diffuse.rgb = vec3(1.0);
    #endif

    vec4 color = diffuse * vec4(light, 1.0);

    // ======== color process ========

    #if defined tsh_PROGRAM_gbuffers_skytextured
        if(renderStage == MC_RENDER_STAGE_SUN) {color.rgb = color_SUN_LUMINANCE * (1.0 - pow((1.0 - color).rgb, vec3(1.0 / 6.0)));}
    #endif
/*
    #if defined tsh_PROGRAM_gbuffers_block
        if(blockEntityId == 20480) {
            color = endPortal_CalcPortalColor(gtexture, screenPos.xy);
        }
    #endif
*/
    float fogDensity = 0.0;

    #if !defined tsh_PROGRAM_gbuffers_skytextured
        fogDensity = tshf_CalcFogDensity(scenePos, fogStart, fogEnd, fogShape);
    #endif

    #if !defined tsh_PROGRAM_gbuffers_skybasic
        fogDensity *= 0.9;
    #endif

    #if defined tsh_PROGRAM_gbuffers_armor_glint
        color.rgb *= 1.0 - fogDensity;
    #elif defined tsh_PROGRAM_gbuffers_damagedblock
        color.a *= 1.0 - fogDensity;
    #else
        color.rgb = mix(color.rgb, color_SRGBEOTF(fogColor), fogDensity);
    #endif

    // ======== write values to output variables ========

    outColor0 = color;

}