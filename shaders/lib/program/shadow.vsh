// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec3 mc_Entity;

// ======== output ========

out vec2 texCoord;
out vec4 vertexColor;

// ======== uniform ========

uniform int entityId;
uniform int blockEntityId;

uniform vec3 chunkOffset;
uniform mat4 textureMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#include "/lib/module/shadow.glsl"

void main() {

    vec4 clipPos = gl_ModelViewProjectionMatrix * (gl_Vertex + vec4(chunkOffset, 0.0));
    clipPos = shadow_DistortShadowClipPos(clipPos);

    if(mc_Entity.x == 16387.0 || blockEntityId == 20480 || entityId == 16384) {clipPos.z = 2.0;}

    // ======== write values to output variables ========

    texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    vertexColor = vec4(color_SRGBEOTF(gl_Color.rgb), gl_Color.a);

    gl_Position = clipPos;

}