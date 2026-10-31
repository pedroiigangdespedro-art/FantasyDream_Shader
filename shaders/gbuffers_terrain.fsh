#version 430 compatibility

// --- OPTIONS DE LUMIÈRE AVANCÉE ---
#define ENABLE_EMISSIVE_BLOOM 1
#define FANTASY_COLOR_GRADING 1
#define DYNAMIC_TORCH_PULSE 1

in vec2 texCoord;
in vec2 lmCoord;
in vec4 vertexColor;
in vec3 normal;
in vec3 worldPos;

uniform sampler2D texture;
uniform float frameTimeCounter; // Variable pour animer la lumière des torches

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragEmissive;

void main() {
    vec4 albedo = texture2D(texture, texCoord) * vertexColor;
    
    // Extraction des axes de la lightmap de Minecraft
    float blockLight = lmCoord.x; // Torches, redstone, lanternes, minerais lumineux
    float skyLight = lmCoord.y;   // Soleil / Lune

#if DYNAMIC_TORCH_PULSE
    // Effet de "respiration" magique sur les sources de lumière des torches
    float pulse = sin(frameTimeCounter * 3.5 + worldPos.x * 0.5 + worldPos.z * 0.5) * 0.07 + 0.93;
#else
    float pulse = 1.0;
#endif

    // --- SYSTÈME DE COULEURS DE LUMIÈRE FANTASY ---
    // Lumière du ciel : Froide, mystique et bleutée
    vec3 coolSkyLight = vec3(0.85, 0.92, 1.15) * skyLight;
    
    // Lumière des torches / blocs : Ambre magique, dorée et vibrante
    vec3 warmTorchLight = vec3(1.5, 0.75, 0.25) * (blockLight * blockLight) * pulse;

    // Fusion dynamique des éclairages sur le bloc
    vec3 customLighting = coolSkyLight + warmTorchLight;
    
    // Application de l'éclairage avec une lueur ambiante féerique dans les creux (évite le noir absolu)
    albedo.rgb *= (customLighting + 0.18);

#if FANTASY_COLOR_GRADING
    // Teinte globale féerique sur les textures
    vec3 fantasyTint = vec3(0.95, 0.92, 1.05);
    albedo.rgb *= fantasyTint;
#endif

    fragColor = albedo;
    fragNormal = vec4(normalize(normal) * 0.5 + 0.5, 1.0);
    
#if ENABLE_EMISSIVE_BLOOM
    // Masque émissif intelligent : cible uniquement les blocs très lumineux (torches, portails, redstone)
    float emissiveMask = step(0.75, blockLight);
    vec3 emissionColor = albedo.rgb * emissiveMask * warmTorchLight * 4.0;
    fragEmissive = vec4(emissionColor, 1.0);
#else
    fragEmissive = vec4(vec3(0.0), 1.0);
#endif
}
