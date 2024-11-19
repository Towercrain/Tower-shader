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

uniform int isEyeInWater;
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
    uniform sampler2D shadowtex0;
    uniform sampler2D shadowtex1;
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

    vec4 screenPos = vec4(gl_FragCoord.xy / viewResolution, gl_FragCoord.z, 1.0);
    vec4 ndcPos = 2.0 * screenPos - 1.0;
    vec4 viewPos = gbufferProjectionInverse * ndcPos; viewPos /= viewPos.w;
    vec4 playerPos = gbufferModelViewInverse * viewPos;
    vec4 scenePos = vec4(mat3(gbufferModelViewInverse) * viewPos.xyz, 1.0);


    vec4 diffuse; {

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
            diffuse.rgb = mix(diffuse.rgb, color_SRGBEOTF(entityColor.rgb), entityColor.a);
        #endif

    } // vec4 diffuse;


    if(diffuse.a < alphaTestRef) {discard;}

    #if !(defined tsh_PROGRAM_gbuffers_skybasic || defined tsh_PROGRAM_gbuffers_skytextured)
        //diffuse.rgb = vec3(1.0); // whiteworld
    #endif


    vec3 sunLightColor; {

        float sunHeight = dot(gbufferModelView[1].xyz, normalize(sunPosition));

        sunLightColor = color_XYZ_TO_SRGB * color_PRIMARIES_TO_XYZ * exp(-color_ATMOSPHERE_DIFFUSE / abs(sunHeight));

        sunLightColor *= 2.0;

        if(sunHeight < 0.0) {
            sunLightColor *= (1.0 / color_SUN_LUMINANCE) * moonBrightness; // moon light color
        }

        sunLightColor *= 1.0 - rainStrength;
    } // vec3 sunLightColor;


    vec3 light; {

        light = vec3(1.0);

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

            #ifdef tsh_NIGHTVISION_LIGHT
                light += nightVision * color_NIGHT_VISION_COLOR;
            #endif

        #endif

        #if defined tsh_USE_SHADOW

            vec3 shadowLightColor; {

                vec3 shadowMask; {

                    vec4 shadowClipPos; {

                        vec4 shadowPlayerPos; {

                            shadowPlayerPos = playerPos;
                            #if (defined tsh_PROGRAM_gbuffers_hand || defined tsh_PROGRAM_gbuffers_hand_water) && !defined tsh_ORTHOGRAPHIC_PROJECTION
                                shadowPlayerPos.xyz *= 1.0 / MC_HAND_DEPTH;
                            #endif

                        } // vec4 shadowPlayerPos;

                        shadowClipPos = shadowProjection * shadowModelView * shadowPlayerPos;
                        shadowClipPos.xyz += 2.0 * shadow_CalcShadowOffset(shadowClipPos, v_Normal);
                        shadowClipPos = shadow_DistortShadowClipPos(shadowClipPos);

                    } // vec4 shadowClipPos;

                    if(shadow_CalcShadowClip(shadowClipPos)) { // if shadow clipped
                        shadowMask = vec3(0.25);
                    } else {
                        shadowMask = shadow_CalcShadowLight(shadowClipPos);
                    }

                } // vec3 shadowMask;

                float normalLight; {
                    
                    float dotLN; {

                        vec3 shadowLightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
                        dotLN = dot(shadowLightDir, v_Normal);

                    } // float dotLN;

                    #ifdef tsh_VARYING_BlockId
                        #if defined tsh_PROGRAM_gbuffers_water
                            normalLight = 0.5 * abs(dotLN);
                        #else
                            int blockIdInt = int(floor(v_BlockId));
                            if(blockIdInt == 16385) {
                                normalLight = 0.5 * abs(dotLN);
                            } else if(blockIdInt == 16387) {
                                normalLight = 0.0;
                            } else {
                                normalLight = max(dotLN, 0.0);
                            }
                        #endif
                    #elif defined tsh_PROGRAM_gbuffers_clouds
                        normalLight = 0.25;
                    #else
                        normalLight = max(dotLN, 0.0);
                    #endif

                } // float normalLight;

                shadowLightColor = sunLightColor * normalLight * shadowMask;

                #ifdef tsh_VARYING_LightmapCoord
                    //shadowLightColor *= lighting.y;
                #endif

            } // vec3 shadowLightColor;

            light += shadowLightColor;

        #endif

        #if defined tsh_PROGRAM_gbuffers_entities

            if(entityId == 16384) {light = vec3(1.0);}

        #endif

    } // vec3 light;


    vec4 color;{

        float fogDensity; {

            fogDensity = tshf_CalcFogDensity(scenePos, fogStart, fogEnd, fogShape);

            #if !defined tsh_PROGRAM_gbuffers_skybasic
                fogDensity *= 0.9;
            #endif

        } // float fogDensity;


        #if defined tsh_PROGRAM_gbuffers_block
            if(blockEntityId == 20480) {
                //color = endPortal_CalcPortalColor(gtexture, screenPos.xy);
                color = endPortal_CalcPortalColor(gtexture, screenPos.xy * viewResolution / viewResolution.y);
            } else {
                color = diffuse * vec4(light, 1.0);
            }
        #else
            color = diffuse * vec4(light, 1.0);
        #endif

        #if defined tsh_PROGRAM_gbuffers_skytextured

            if(renderStage == MC_RENDER_STAGE_SUN)
            {
                color.rgb *= color_SUN_LUMINANCE * sunLightColor;
            }

        #endif

        #if defined tsh_PROGRAM_gbuffers_armor_glint
            color.rgb *= 1.0 - fogDensity;
        #elif defined tsh_PROGRAM_gbuffers_damagedblock
            color.a *= 1.0 - fogDensity;
        #elif defined tsh_PROGRAM_gbuffers_skytextured
            // nothing to do here
        #else
            color.rgb = mix(color.rgb, color_SRGBEOTF(fogColor), fogDensity);
        #endif

    } // vec4 color;


    // ======== write values to output variables ========

    outColor0 = color;

}