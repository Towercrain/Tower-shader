// ======== preprocess ========

#define tsh_PROGRAM_vsh

#include "/lib/gbuffer_preprocess.glsl"

// ======== input ========

in vec3 mc_Entity;

// ======== output ========

out vec4 v_VertexColor;

#ifdef tsh_VARYING_TextureCoord
    out vec2 v_TextureCoord;
#endif
#ifdef tsh_VARYING_LightmapCoord
    out vec2 v_LightmapCoord;
#endif
#ifdef tsh_VARYING_Normal
    out vec3 v_Normal;
#endif
#ifdef tsh_VARYING_BlockId
    out float v_BlockId;
#endif

// ======== uniform ========

uniform vec2 viewResolution;
uniform vec3 chunkOffset;

uniform mat3 normalMatrix;
uniform mat4 gbufferModelViewInverse;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#if defined tsh_PROGRAM_gbuffers_line
    #include "/lib/module/line.glsl"
#endif

void main() {

    #ifdef tsh_ORTHOGRAPHIC_PROJECTION
        #define projectionMatrix mat4( \
            vec4((1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * projectionMatrix[0].x, 0.0, 0.0, 0.0), \
            vec4(0.0, (1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * projectionMatrix[1].y, 0.0, 0.0), \
            vec4(0.0, 0.0, -1.0 / 1024.0, 0.0), \
            vec4(0.0, 0.0, 0.0, 1.0) \
        )
    #endif

    vec4 vertexColor = vec4(color_SRGBEOTF(gl_Color.rgb), gl_Color.a);

    vec3 viewNorm = gl_NormalMatrix * gl_Normal;
    vec3 worldNorm = mat3(gbufferModelViewInverse) * viewNorm;
    vec4 modelPos = gl_Vertex;

    #if defined tsh_PROGRAM_gbuffers_terrain || defined tsh_PROGRAM_gbuffers_water
        modelPos.xyz += chunkOffset;
    #endif

    vec4 clipPos;

    #if defined tsh_PROGRAM_gbuffers_line
        clipPos = line_CalcPosition(gl_ProjectionMatrix, gl_Vertex.xyz, gl_Normal);
    #else
        clipPos = gl_ModelViewProjectionMatrix * modelPos;
    #endif

    // ======== write values to output variables ========

    v_VertexColor = vertexColor;

    #ifdef tsh_VARYING_TextureCoord
        v_TextureCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    #endif

    #ifdef tsh_VARYING_LightmapCoord
        //v_LightmapCoord = (1.0 / 256.0) * vaUV2 + (0.5 / 16.0);
        v_LightmapCoord = clamp((1.0 / 240.0) * gl_MultiTexCoord1.xy, 0.0, 1.0);
    #endif

    #ifdef tsh_VARYING_Normal
        v_Normal = worldNorm;
    #endif

    #ifdef tsh_VARYING_BlockId
        v_BlockId = mc_Entity.x + 0.5;
    #endif

    gl_Position = clipPos;

}