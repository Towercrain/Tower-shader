// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec2 vaUV0;
in vec3 vaPosition;

// ======== output ========

out float brightness;
out vec2 texCoord;

// ======== uniform ========

uniform float nightVision;
uniform float frameTime;
uniform vec4 additiveRandom;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform sampler2D colortex0;
uniform sampler2D colortex1;

// ======== constant and function ========

#include "/lib/color.glsl"
#include "/lib/constant.glsl"
#include "/lib/function.glsl"

float calcWeight(vec2 pos) {

    vec2 a = 1.0 - abs(1.0 - 2.0 * pos);
    float weight = (25.0 / 1.0) * pow(a.x * a.y, 4.0);

    return weight;

}

void main() {

    #define N 32.0

    float averageBrightness = 0.0;
    for(float x = 0.5 / N; x < 1.0; x += 1.0 / N) {
        for(float y = 0.5 / N; y < 1.0; y += 1.0 / N) {
            vec2 sampleCoord = vec2(x,y);
            vec3 sampleColor = texture(colortex0, sampleCoord).rgb;
            float sampleBrightness = dot(
                color_TowerShaderToneMap(sampleColor),
                vec3(color_BT2020_TO_XYZ[0].y, color_BT2020_TO_XYZ[1].y, color_BT2020_TO_XYZ[2].y)
            );
            float weight = calcWeight(sampleCoord);
            averageBrightness += sampleBrightness * weight;
        }
    }
    averageBrightness *= 1.0 / (N * N);

    float previousBrightness = texture(colortex1, vec2(0.0)).x;

    float mixedBrightness = mix(averageBrightness, previousBrightness, exp(-(2.0 + 2.0 * nightVision) * frameTime));

    // ======== write values to output variables ========

    brightness = mixedBrightness;
    texCoord = vaUV0;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);

}