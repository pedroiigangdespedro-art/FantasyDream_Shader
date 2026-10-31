#version 430 compatibility

// --- OPTIONS DE CONFIGURATION ---
#define ENABLE_EMISSIVE_BLOOM 1
#define FANTASY_COLOR_GRADING 1

in vec2 texCoord;
in vec2 lmCoord;
in vec4 vertexColor;
in vec3 normal;
in vec3 worldPos;

uniform sampler2D texture;
uniform vec3 sunPosition;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragEmissive;

void main() {
    vec4 albedo = texture2D(texture, texCoord) * vertexColor;
    
    // Détection des blocs émissifs (via lightmap torch ou couleur spécifique)
    float emissiveMask = step(0.85, lmCoord.x) * 0.8; // Torches et feux
    
#if FANTASY_COLOR_GRADING
    // Teinte féerique globale : enrichissement des ombres en violet/bleu et hautes lumières dorées
    vec3 fantasyTint = vec3(0.95, 0.92, 1.08);
    albedo.rgb *= fantasyTint;
    
    // Légère lueur magique ambiante sur les zones sombres
    albedo.rgb += vec3(0.05, 0.02, 0.08) * (1.0 - lmCoord.y);
#endif

    fragColor = albedo;
    fragNormal = vec4(normalize(normal) * 0.5 + 0.5, 1.0);
    
#if ENABLE_EMISSIVE_BLOOM
    // Extraction de la lueur pour la passe de composite (Bloom)
    fragEmissive = vec4(albedo.rgb * emissiveMask * 2.5, 1.0);
#else
    fragEmissive = vec4(vec3(0.0), 1.0);
#endif
}
