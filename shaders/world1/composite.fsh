#version 430 compatibility

in vec2 texCoord;
uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform float frameTimeCounter; // Variable Iris pour animer le ciel en continu

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    float depthFactor = texture2D(colortex0, texCoord).a;

    // Coordonnées centrées pour la projection du ciel cosmique
    vec2 uv = texCoord * 2.0 - 1.0;

    // --- 1. NÉBULEUSE COSMIQUE ANIMÉE ---
    float t = frameTimeCounter * 0.05; // Vitesse de rotation lente et planante de la nébuleuse
    float nebulaWave1 = sin(uv.x * 2.5 + t) * cos(uv.y * 2.5 - t) * 0.5 + 0.5;
    float nebulaWave2 = cos(length(uv) * 3.5 - t * 1.2);
    
    // Palette de couleurs de la nébuleuse (Violet cosmique et Cyan abyssal)
    vec3 nebulaColor = mix(vec3(0.12, 0.02, 0.22), vec3(0.02, 0.15, 0.25), nebulaWave1);
    nebulaColor += vec3(0.25, 0.05, 0.35) * max(0.0, nebulaWave2);

    // --- 2. ÉTOILES SCINTILLANTES ---
    float stars = pow(fract(sin(dot(texCoord * 4.0, vec2(12.9898, 78.233))) * 43758.5453), 25.0);
    vec3 starField = vec3(0.8, 0.95, 1.0) * stars * 2.5;

    // --- 3. FUSION CIEL / ÎLES DE L'END ---
    // Si la profondeur est maximale (le ciel lointain), on affiche le cosmos
    if (depthFactor > 0.95) {
        color = nebulaColor + starField;
    } else {
        // Brouillard ténébreux et mystique autour des structures de l'End
        vec3 endFog = vec3(0.06, 0.02, 0.12);
        color = mix(color, endFog, clamp(depthFactor * 0.045, 0.0, 0.7));
    }

    // Color Grading final pour l'End : contraste profond et lueurs envoûtantes
    color = pow(color, vec3(0.92));
    color = clamp(color, 0.0, 1.0);

    finalOutput = vec4(color, 1.0);
}
