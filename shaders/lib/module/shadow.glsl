//uniform mat4 gbufferModelViewInverse;
//uniform vec3 sunPosition;
//uniform mat4 shadowModelView;
//uniform mat4 shadowProjection;
//uniform sampler2DShadow shadowtex0;
//uniform sampler2DShadow shadowtex1;
//uniform sampler2D shadowcolor0;

float shadow_CalcShadowDistortion(vec2 shadowClipPos) {

    const float a = 1.0 / (2.0 * tsh_SHADOW_DISTORTION - 1.0);
    float b = (1.0 - a) * length(shadowClipPos) + a;
    float c = 0.5 * (1.0 / b) + 0.5;

    return c;

}

vec4 shadow_DistortShadowClipPos(vec4 shadowClipPos) {

    shadowClipPos.xy *= shadow_CalcShadowDistortion(shadowClipPos.xy);
    shadowClipPos.z *= 0.25;

    return shadowClipPos;

}

vec4 shadow_CalcShadowColor(vec4 color) {

    float a = (1.0 - color.a);
    vec3 b = color.a * sqrt(color.rgb) + a;
    vec3 shadowColor = a * pow(b, vec3(4.0));

    return vec4(shadowColor, 1.0);

}

float shadow_CalcDistortionGradient(vec2 shadowClipPos) {

    const float a = 2.0 * tsh_SHADOW_DISTORTION - 1.0;
    float x = length(shadowClipPos);
    float b = (a - 1.0) * x + 1.0;
    float c = 0.5 * (a / (b * b)) + 0.5;

    return c;

}

bool shadow_CalcShadowClip(vec4 shadowClipPos) {

    const float clipThreshold = 1.0 - 2.0 / tsh_SHADOW_MAP_RESOLUTION;
    bool shadowClip = (
        0.5 < dot(vec3(lessThan(vec3(clipThreshold), abs(shadowClipPos.xyz))), vec3(1.0))
    );

    return shadowClip;

}

#if defined tsh_PROGRAM_fsh && defined tsh_PROGRAM_gbuffers

vec3 shadow_CalcShadowOffset(vec4 shadowClipPos, vec3 normal) {

    const float texelSize = 2.0 * tsh_SHADOW_DISTANCE / tsh_SHADOW_MAP_RESOLUTION;

    float gradient = shadow_CalcDistortionGradient(shadowClipPos.xy);
    vec3 shadowViewNorm = mat3(shadowModelView) * normal;
    vec3 shadowPosOffset = mat3(shadowProjection) * shadowViewNorm * texelSize / gradient;
    shadowPosOffset *= sign(shadowViewNorm.z);

    return shadowPosOffset;

}

vec3 shadow_CalcShadowLight(vec4 shadowClipPos) {

    vec4 shadowScreenPos = 0.5 * shadowClipPos + 0.5;

    ivec2 shadowTexelCoord = ivec2(floor(shadowScreenPos.xy * tsh_SHADOW_MAP_RESOLUTION));

    vec2 shadowTexOffset = vec2(1.0 / tsh_SHADOW_MAP_RESOLUTION, 0.0);

    mat4x3 shadowTexCoord = mat4x3(
        shadowScreenPos.xyz + shadowTexOffset.xyy,
        shadowScreenPos.xyz - shadowTexOffset.xyy,
        shadowScreenPos.xyz + shadowTexOffset.yxy,
        shadowScreenPos.xyz - shadowTexOffset.yxy
    );

    vec4 shadowMapDepth0 = vec4(
        texture(shadowtex0, shadowTexCoord[0]),
        texture(shadowtex0, shadowTexCoord[1]),
        texture(shadowtex0, shadowTexCoord[2]),
        texture(shadowtex0, shadowTexCoord[3])
    );
    vec4 shadowMapDepth1 = vec4(
        texture(shadowtex1, shadowTexCoord[0]),
        texture(shadowtex1, shadowTexCoord[1]),
        texture(shadowtex1, shadowTexCoord[2]),
        texture(shadowtex1, shadowTexCoord[3])
    );
    mat4x3 shadowMapColor = mat4x3(
        texture(shadowcolor0, shadowTexCoord[0].xy).rgb,
        texture(shadowcolor0, shadowTexCoord[1].xy).rgb,
        texture(shadowcolor0, shadowTexCoord[2].xy).rgb,
        texture(shadowcolor0, shadowTexCoord[3].xy).rgb
    );

    vec4 shadowMask0 = vec4(lessThan(vec4(shadowScreenPos.z), shadowMapDepth0));
    vec4 shadowMask1 = vec4(lessThan(vec4(shadowScreenPos.z), shadowMapDepth1));

    vec3 shadowLightColor = shadowMapColor * (shadowMask1 - shadowMask0) * 0.25 + dot(shadowMask0, vec4(0.25));

    return shadowLightColor;

}

#endif
