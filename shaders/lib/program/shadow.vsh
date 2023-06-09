// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec2 vaUV0;
in vec3 vaPosition;
in vec4 vaColor;
in vec3 mc_Entity;

// ======== output ========

out vec2 texCoord;
out vec4 vertexColor;

// ======== uniform ========

uniform int blockEntityId;

uniform vec3 chunkOffset;
uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#include "/lib/module/shadow.glsl"

void main() {

    vec4 modelPos = vec4(vaPosition + chunkOffset, 1.0);

    modelPos.xyz += chunkOffset;

    vec4 clipPos = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0);
    clipPos = shadow_DistortShadowClipPos(clipPos);

    if(mc_Entity.x == 16387.0 || blockEntityId == 20480) {clipPos.z = 2.0;}

    // ======== write values to output variables ========

    texCoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
    vertexColor = vaColor;

    gl_Position = clipPos;

}