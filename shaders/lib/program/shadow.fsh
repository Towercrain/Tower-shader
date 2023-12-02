// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in vec4 vertexColor;
in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:0 */
out vec4 outColor0;

// ======== uniform ========

uniform float alphaTestRef;

uniform sampler2D gtexture;

uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#include "/lib/module/shadow.glsl"

const int shadowMapResolution = tsh_SHADOW_MAP_RESOLUTION;
const float shadowDistance = tsh_SHADOW_DISTANCE;
const float shadowDistanceRenderMul = 1.0;

void main() {

    vec4 color = vertexColor;

    color *= texture(gtexture, texCoord);

    if(color.a < alphaTestRef) {discard;}

    color.rgb = color_SRGBEOTF(color.rgb);

    color = shadow_CalcShadowColor(color);

    // ======== write values to output variables ========

    outColor0 = color;

}