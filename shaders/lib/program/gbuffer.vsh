// ======== preprocess ========

#define tsh_PROGRAM_vsh

#include "/lib/gbuffer_preprocess.glsl"

// ======== input ========

in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec3 vaNormal;
in vec3 mc_Entity;
in vec4 vaColor;

// ======== output ========

out vec4 v_VertexColor;

#ifdef tsh_VARYING_TextureCoord
    out vec2 v_TextureCoord;
#endif
#ifdef tsh_VARYING_LightmapCoord
    out vec2 v_LightmapCoord;
#endif
#ifdef tsh_VARYING_AmbientShading
    out float v_AmbientShading;
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

uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform mat3 normalMatrix;
uniform mat4 gbufferModelViewInverse;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#if defined tsh_PROGRAM_gbuffers_line
    #include "/lib/module/line.glsl"
#endif

void main() {

    #ifdef tsh_ORTHOGRAPHIC_PROJECTION
        mat4 newProjectionMatrix = mat4(
            vec4((1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * projectionMatrix[0].x, 0.0, 0.0, 0.0),
            vec4(0.0, (1.0 / tsh_ORTHOGRAPHIC_VIEW_DISTANCE) * projectionMatrix[1].y, 0.0, 0.0),
            vec4(0.0, 0.0, -1.0 / 384.0, 0.0),
            vec4(0.0, 0.0, 0.0, 1.0)
        );
    #else
        mat4 newProjectionMatrix = projectionMatrix;
    #endif

    vec4 vertexColor = tshf_ColorDecode(vaColor);

    vec3 viewNorm = normalMatrix * vaNormal;
    vec3 worldNorm = mat3(gbufferModelViewInverse) * viewNorm;
    vec4 modelPos = vec4(vaPosition, 1.0);

    float ambientShading = tshf_CalcAmbientLight(worldNorm);

    #if defined tsh_PROGRAM_gbuffers_terrain || defined tsh_PROGRAM_gbuffers_water
        vertexColor.a = 1.0;
        ambientShading *= vaColor.a;
        modelPos.xyz += chunkOffset;
    #endif

    vec4 clipPos;

    #if defined tsh_PROGRAM_gbuffers_line
        clipPos = line_CalcPosition(newProjectionMatrix, vaPosition, vaNormal);
    #else
        clipPos = newProjectionMatrix * modelViewMatrix * modelPos;
    #endif

    // ======== write values to output variables ========

    v_VertexColor = vertexColor;

    #ifdef tsh_VARYING_TextureCoord
        v_TextureCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    #endif

    #ifdef tsh_VARYING_LightmapCoord
        //v_LightmapCoord = (1.0 / 256.0) * vaUV2 + (0.5 / 16.0);
        v_LightmapCoord = clamp((1.0 / 240.0) * vaUV2, 0.0, 1.0);
    #endif

    #ifdef tsh_VARYING_AmbientShading
        v_AmbientShading = ambientShading;
    #endif

    #ifdef tsh_VARYING_Normal
        v_Normal = worldNorm;
    #endif

    #ifdef tsh_VARYING_BlockId
        v_BlockId = mc_Entity.x + 0.5;
    #endif

    gl_Position = clipPos;

}