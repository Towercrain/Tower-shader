// ======== preprocess ========

#define tsh_PROGRAM_vsh

// ======== input ========

in vec2 vaUV0;
in vec3 vaPosition;

// ======== output ========

out float brightness;
out vec2 texCoord;

// ======== uniform ========

uniform float frameTime;
uniform vec4 additiveRandom;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform sampler2D colortex0;
uniform sampler2D colortex1;

// ======== constant and function ========

#include "/lib/constant.glsl"
#include "/lib/function.glsl"

const vec3 srgbWeight = vec3(0.2126, 0.7152, 0.0722);

const float N = 32.0;

float calcWeight(vec2 pos) {

    vec2 a = 1.0 - abs(1.0 - 2.0 * pos);
    float weight = (25.0 / 1.0) * pow(a.x * a.y, 4.0);

    return weight;

}

void main() {

    float averageBrightness = 0.0;
    for(float x = 0.5 / N; x < 1.0; x += 1.0 / N) {
        for(float y = 0.5 / N; y < 1.0; y += 1.0 / N) {
            vec2 sampleCoord = vec2(x,y);
            vec3 sampleColor = texture(colortex0, sampleCoord).rgb;
            float sampleBrightness = dot(tshf_TowerShaderToneMap(sampleColor), srgbWeight);
            float weight = calcWeight(sampleCoord);
            averageBrightness += sampleBrightness * weight;
        }
    }
    averageBrightness *= 1.0 / (N * N);

    float previousBrightness = texture(colortex1, vec2(0.0)).x;
    if(previousBrightness < (1.0 / 131072.0)) {previousBrightness = averageBrightness;}

    float mixedBrightness = mix(averageBrightness, previousBrightness, exp(-frameTime));

    // ======== write values to output variables ========

    brightness = max(mixedBrightness, (1.0 / 65536.0));
    texCoord = vaUV0;

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition, 1.0);

}