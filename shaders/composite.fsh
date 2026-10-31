#version 430 compatibility

// --- CONFIGURATION DES EFFETS ---
#define ENABLE_VOLUMETRIC_FOG 1
#define ENABLE_BLOOM 1

in vec2 texCoord;

uniform sampler2D colortex0; // Couleur
uniform sampler2D colortex2; // Émissif / Bloom mask
uniform float viewWidth;
uniform float viewHeight;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;

#if ENABLE_BLOOM
    // Application d'un flou simple d'échantillonnage pour le Bloom magique
    vec3 bloom = vec3(0.0);
    float weights = 0.0;
    vec2 texelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);
    
    for(int x = -2; x <= 2; x++) {
        for(int y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * texelSize * 2.0;
            bloom += texture2D(colortex2, texCoord + offset).rgb;
            weights += 1.0;
        }
    }
    bloom /= weights;
    color += bloom * 0.8;
#endif

#if ENABLE_VOLUMETRIC_FOG
    // Brouillard volumétrique féerique basé sur les coordonnées UV / profondeur simulée
    float depthFactor = texture2D(colortex0, texCoord).a; // Utilisation de l'alpha ou profondeur
    vec3 fogColor = vec3(0.12, 0.08, 0.22); // Violet mystique des vallées
    float fogDensity = 0.03;
    
    color = mix(color, fogColor, clamp(depthFactor * fogDensity, 0.0, 0.6));
#endif

    // Color Grading final : Contraste riche et saturation fantasy
    color = pow(color, vec3(0.95)); // Léger gamma boost
    color = clamp(color, 0.0, 1.0);

    finalOutput = vec4(color, 1.0);
}
