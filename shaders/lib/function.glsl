
// ======== mathematic functions ========

float tshf_SoftMax(float x) {

    return log(exp(x) + 1.0);

}

float tshf_SoftMaxSafe(float x) {

    float a = abs(x);
    return log(exp(-a) + 1.0) + 0.5 * (a + x);

}

float tshf_SoftSign(float x, float bias) {

    return x / (abs(x) + bias);

}

// ======== hashing noise ========

vec4 tshf_Noise(vec4 seed) {

    const mat4 twist = 1024.0 * mat4(
        vec4( 17.9372511447, 73.0893577486, 51.7678136984, 43.4480503234),
        vec4( 46.1706005536, 39.0308818528,-138.808470264, 80.6686435337),
        vec4( 156.858669531,-16.8653315872, 15.5314527305,-54.8923698381),
        vec4(-39.5710626039, 172.612482823,-73.1978029373,-186.821943331)
    );
    const vec4 warp = 1024.0 * vec4(77.4258539818, 53.963230926, 52.2459110524, 18.8120883769);
    return fract(cos(twist * seed + warp) * 4627.88359419);

} vec4 tshf_Noise(vec3 seed) {

    const mat3x4 twist = 1024.0 * mat3x4(
        vec4( 17.9372511447, 73.0893577486, 51.7678136984, 43.4480503234),
        vec4( 46.1706005536, 39.0308818528,-138.808470264, 80.6686435337),
        vec4( 156.858669531,-16.8653315872, 15.5314527305,-54.8923698381)
    );
    const vec4 warp = 1024.0 * vec4(77.4258539818, 53.963230926, 52.2459110524, 18.8120883769);
    return fract(cos(twist * seed + warp) * 4627.88359419);

} vec4 tshf_Noise(vec2 seed) {

    const mat2x4 twist = 1024.0 * mat2x4(
        vec4( 17.9372511447, 73.0893577486, 51.7678136984, 43.4480503234),
        vec4( 46.1706005536, 39.0308818528,-138.808470264, 80.6686435337)
    );
    const vec4 warp = 1024.0 * vec4(77.4258539818, 53.963230926, 52.2459110524, 18.8120883769);
    return fract(cos(twist * seed + warp) * 4627.88359419);

} vec4 tshf_Noise(float seed) {

    const vec4 twist = 1024.0 * vec4( 17.9372511447, 73.0893577486, 51.7678136984, 43.4480503234);
    const vec4 warp = 1024.0 * vec4(77.4258539818, 53.963230926, 52.2459110524, 18.8120883769);
    return fract(cos(twist * seed + warp) * 4627.88359419);

}

// ======== ambient light ========

float tshf_CalcAmbientLight(vec3 normal) {

    float light = max(dot(normal, tsh_AMBIENT_LIGHT_POS_0), 0.0)
                + max(dot(normal, tsh_AMBIENT_LIGHT_POS_1), 0.0);
    light = 0.5 * light + 0.5;
    light = min(light, 1.0);
    return light;

}

// ======== fog ========

float tshf_CalcFogDist(vec4 scenePos, int fogShape) {

    if(fogShape == 0) {
        return length(scenePos.xyz);
    } else {
        return max(length(scenePos.xz), abs(scenePos.y));
    }

}

float tshf_CalcFogDensity(vec4 scenePos, float fogStart, float fogEnd, int fogShape) {

    float fogDist = tshf_CalcFogDist(scenePos, fogShape);
    float fogDensity = smoothstep(fogStart, fogEnd, fogDist);
    //float fogDensity = 1.0 / (1.0 / pow(2.0 * fogDist / (fogStart + fogEnd), 2.0 * ((fogStart + fogEnd) / (fogEnd - fogStart))) + 1.0);
    return fogDensity;

}

// ======== depth transformation ========

float tshf_CalcProjDepth(mat4 projectionMatrix, float linearDepth) {

    return 0.5 * (-projectionMatrix[2].z - projectionMatrix[3].z / linearDepth) + 0.5;

}

float tshf_CalcLinearDepth(mat4 projectionMatrix, float depth) {

    return -projectionMatrix[3].z / (2.0 * depth - 1.0 + projectionMatrix[2].z);

}

// ======== exposure ========

float tshf_CalcExposure(float brightness) {

    return sqrt(0.25 / brightness);

}
