#version 430 compatibility

in vec3 vaPosition;
in vec4 vaColor;
in vec2 vaUV0;
in ivec2 vaUV1;
in vec3 vaNormal;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;

out vec2 texCoord;
out vec2 lmCoord;
out vec4 vertexColor;
out vec3 normal;
out vec3 worldPos;

void main() {
    vec3 pos = vaPosition;
    
    // Animation subtile des vagues de surface sur l'axe vertical
    if (vaNormal.y > 0.5) {
        float wave = sin(pos.x * 2.0 + frameTimeCounter * 3.0) * cos(pos.z * 2.0 + frameTimeCounter * 2.0) * 0.05;
        pos.y += wave;
    }

    vec4 localPos = modelViewMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * localPos;

    worldPos = (inverse(modelViewMatrix) * localPos).xyz + cameraPosition;
    texCoord = vaUV0;
    lmCoord = vec2(vaUV1) * (1.0 / 255.0);
    vertexColor = vaColor;
    normal = normalize(mat3(modelViewMatrix) * vaNormal);
}
