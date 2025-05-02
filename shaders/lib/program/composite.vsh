// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

// ======== output ========

out float brightness;
out vec2 texCoord;

// ======== uniform ========

uniform float nightVision;
uniform float frameTime;
uniform vec4 additiveRandom;

uniform sampler2D colortex0;
uniform sampler2D colortex1;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

float calcWeight(vec2 pos) {

    vec2 a = 1.0 - abs(2.0 * pos - 1.0);
    float b = a.x * a.y;
    float weight = 9.0 * b * b;

    return weight;

}

void main() {

    #define N 32.0

    float previousBrightness = texture(colortex1, vec2(0.0)).x;

    float meanBrightness = 0.0;
    for(float x = 0.5 / N; x < 1.0; x += 1.0 / N) {
        for(float y = 0.5 / N; y < 1.0; y += 1.0 / N) {
            vec2 sampleCoord = vec2(x, y);
            vec3 sampleColor = texture(colortex0, sampleCoord).rgb;
            float sampleBrightness = clamp(dot(
                sampleColor,
                vec3(color_SRGB_TO_XYZ[0].y, color_SRGB_TO_XYZ[1].y, color_SRGB_TO_XYZ[2].y)
            ), 0.0, 1.0 / tshf_CalcExposure(previousBrightness));
            float weight = calcWeight(sampleCoord);
            meanBrightness += sampleBrightness * weight;
        }
    }
    meanBrightness *= 1.0 / (N * N);

    if(previousBrightness < 0.0) {previousBrightness = meanBrightness;}

    float mixedBrightness = mix(meanBrightness, previousBrightness, exp(-2.0 * frameTime));

    // ======== write values to output variables ========

    brightness = mixedBrightness;
    texCoord = gl_MultiTexCoord0.xy;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;

}