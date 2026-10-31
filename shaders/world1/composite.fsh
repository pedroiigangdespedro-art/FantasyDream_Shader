#version 430 compatibility

in vec2 texCoord;
uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D depthtex0; // CORRECTIF : Tampon de profondeur officiel d'Iris
uniform float frameTimeCounter;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    float rawDepth = texture2D(depthtex0, texCoord).r;
    bool isSky = (rawDepth >= 1.0);

    vec2 uv = texCoord * 2.0 - 1.0;

    // --- 1. NÉBULEUSE COSMIQUE ANIMÉE ---
    float t = frameTimeCounter * 0.05;
    float nebulaWave1 = sin(uv.x * 2.5 + t) * cos(uv.y * 2.5 - t) * 0.5 + 0.5;
    float nebulaWave2 = cos(length(uv) * 3.5 - t * 1.2);
    
    vec3 nebulaColor = mix(vec3(0.12, 0.02, 0.22), vec3(0.02, 0.15, 0.25), nebulaWave1);
    nebulaColor += vec3(0.25, 0.05, 0.35) * max(0.0, nebulaWave2);

    // --- 2. ÉTOILES SCINTILLANTES ---
    float stars = pow(fract(sin(dot(texCoord * 4.0, vec2(12.9898, 78.233))) * 43758.5453), 25.0);
    vec3 starField = vec3(0.8, 0.95, 1.0) * stars * 2.5;

    // --- 3. FUSION CIEL / ÎLES DE L'END ---
    if (isSky) {
        color = nebulaColor + starField;
    } else {
        vec3 endFog = vec3(0.06, 0.02, 0.12);
        float approxDist = (1.0 - rawDepth) * 40.0;
        color = mix(color, endFog, clamp(approxDist * 0.05, 0.0, 0.7));
    }

    color = pow(color, vec3(0.92));
    color = clamp(color, 0.0, 1.0);

    finalOutput = vec4(color, 1.0);
}
