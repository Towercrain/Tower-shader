//uniform vec2 viewResolution;

const float line_LINE_WIDTH = 2.5;
const float line_VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 line_VIEW_SCALE = mat4(
    vec4(line_VIEW_SHRINK, 0.0, 0.0, 0.0),
    vec4(0.0, line_VIEW_SHRINK, 0.0, 0.0),
    vec4(0.0, 0.0, line_VIEW_SHRINK, 0.0),
    vec4(0.0, 0.0, 0.0, 1.0)
);

vec4 line_CalcPosition(vec3 modelPos, vec3 modelNorm) {

    vec4 modelStartPos = vec4(modelPos, 1.0);
    vec4 clipStartPos = gl_ProjectionMatrix * line_VIEW_SCALE * gl_ModelViewMatrix * modelStartPos;
    vec4 ndcStartPos = clipStartPos / clipStartPos.w;

    vec4 modelEndPos = vec4(modelPos + modelNorm, 1.0);
    vec4 clipEndPos = gl_ProjectionMatrix * line_VIEW_SCALE * gl_ModelViewMatrix * modelEndPos;
    vec4 ndcEndPos = clipEndPos / clipEndPos.w;

    vec2 dir = normalize((ndcEndPos - ndcStartPos).xy * viewResolution);

    vec2 posOffset = vec2(-dir.y, dir.x) / viewResolution * line_LINE_WIDTH; // (-y, x) : left rotation

    if(posOffset.x < 0.0 ^^ gl_VertexID % 2 == 1) {
        posOffset *= -1.0;
    }

    vec4 ndcPos = ndcStartPos + vec4(posOffset, 0.0, 0.0);
    vec4 clipPos = ndcPos * clipStartPos.w;

    return clipPos;

}
