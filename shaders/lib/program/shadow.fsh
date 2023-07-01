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

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

#include "/lib/module/shadow.glsl"

const int shadowMapResolution = 2048;
const float shadowDistance = 160.0;

void main() {

    vec4 color = vertexColor;

    color *= texture(gtexture, texCoord);

    if(color.a < alphaTestRef) {discard;}

    color = tshf_ColorDecode(color);

    color = shadow_CalcShadowColor(color);

    // ======== write values to output variables ========

    outColor0 = color;

}