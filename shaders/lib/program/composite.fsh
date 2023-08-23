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

    color.rgb = tshf_TowerShaderToneMap(color.rgb);

    // ======== write values to output variables ========

    outColor0 = color;
    outColor1 = vec4(brightness, 0.0, 0.0, 1.0);

}