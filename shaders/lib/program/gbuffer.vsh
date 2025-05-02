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
//uniform vec3 chunkOffset;

uniform mat3 normalMatrix;
uniform mat4 gbufferModelViewInverse;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#if defined tsh_PROGRAM_gbuffers_line
    #include "/lib/module/line.glsl"
#endif

#ifdef tsh_ORTHOGRAPHIC_PROJECTION
    #define gl_ProjectionMatrix mat4( \
        vec4((1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * gl_ProjectionMatrix[0].x, 0.0, 0.0, 0.0), \
        vec4(0.0, (1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * gl_ProjectionMatrix[1].y, 0.0, 0.0), \
        vec4(0.0, 0.0, -1.0 / 1024.0, 0.0), \
        vec4(0.0, 0.0, 0.0, 1.0) \
    )
#endif

void main() {

    vec4 vertexColor = vec4(color_SRGBEOTF(gl_Color.rgb), gl_Color.a);

    vec3 viewNorm = gl_NormalMatrix * gl_Normal;
    vec3 worldNorm = mat3(gbufferModelViewInverse) * viewNorm;

    vec4 clipPos;

    #if defined tsh_PROGRAM_gbuffers_line
        clipPos = line_CalcPosition(gl_Vertex.xyz, gl_Normal);
    #else
        clipPos = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    #endif

    // ======== write values to output variables ========

    v_VertexColor = vertexColor;

    #ifdef tsh_VARYING_TextureCoord
        v_TextureCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    #endif

    #ifdef tsh_VARYING_LightmapCoord
        //v_LightmapCoord = (1.0 / 256.0) * vaUV2 + (0.5 / 16.0);
        v_LightmapCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    #endif

    #ifdef tsh_VARYING_Normal
        v_Normal = worldNorm;
    #endif

    #ifdef tsh_VARYING_BlockId
        v_BlockId = mc_Entity.x + 0.5;
    #endif

    gl_Position = clipPos;

}