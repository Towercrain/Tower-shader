// ======== preprocess ========

#define tsh_PROGRAM_fsh

// ======== input ========

in float brightness;
in vec2 texCoord;

// ======== output ========

/* DRAWBUFFERS:01 */
out vec4 outColor0;
out vec4 outColor1;

// ======== uniform ========

uniform vec2 viewResolution;
uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

const bool colortex1Clear = false;

const mat3 sRGBToNLMS = mat3(
    vec3(0.2647600, 0.0921753, 0.0177566),
    vec3(0.6739890, 0.8103780, 0.1094680),
    vec3(0.0612508, 0.0974469, 0.8727750)
);
const mat3 nLMSToSRGB = mat3(
    vec3( 5.312930, -0.600369, -0.0327901),
    vec3(-4.435280,  1.754080, -0.1297700),
    vec3( 0.122349, -0.153713,  1.1625600)
);

float calcExposure(float brightness) {

    return 0.25 / (brightness + tsh_NIGHT_VISION_INTENSITY);

}

float calcVignette(vec2 pos) {

    vec2 a = pos - pos * pos;
    float vignette = (45.0 / 17.0) * (a.x * a.y + 0.35);

    return vignette;

}

void main() {

    vec4 color = texture(colortex0, texCoord);

    float exposure = calcExposure(brightness);
    float vignette = calcVignette(texCoord);

    color.rgb *= exposure * vignette;

    color.rgb = sRGBToNLMS * color.rgb;
    color.rgb = tshf_TowerShaderToneMap(color.rgb);
    color.rgb = nLMSToSRGB * color.rgb;

    // ======== write values to output variables ========

    outColor0 = color;
    outColor1 = vec4(brightness, 0.0, 0.0, 1.0);

}