#version 430 compatibility

// --- OPTIONS ÉPIQUES ---
#define ENABLE_VOLUMETRIC_FOG 1
#define ENABLE_BLOOM 1
#define ENABLE_GOD_RAYS 1
#define ENABLE_VIGNETTE 1

in vec2 texCoord;

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform float viewWidth;
uniform float viewHeight;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;

#if ENABLE_BLOOM
    // Extraction et diffusion de la lueur magique (Bloom)
    vec3 bloom = vec3(0.0);
    float weights = 0.0;
    vec2 texelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);
    
    for(int x = -2; x <= 2; x++) {
        for(int y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * texelSize * 2.5;
            bloom += texture2D(colortex2, texCoord + offset).rgb;
            weights += 1.0;
        }
    }
    bloom /= weights;
    color += bloom * 1.2; // Intensité augmentée pour un effet plus magique
#endif

#if ENABLE_GOD_RAYS
    // Simulation de rayons lumineux éthérés convergents vers le haut du ciel
    vec2 rayCoord = texCoord - vec2(0.5, 0.2);
    float rayDist = length(rayCoord);
    vec3 fantasyRayColor = vec3(0.35, 0.25, 0.65); // Lueurs violettes/bleutées douces
    color += fantasyRayColor * max(0.0, (1.0 - rayDist * 1.8)) * 0.12;
#endif

#if ENABLE_VOLUMETRIC_FOG
    // Brouillard volumétrique féerique des vallées
    float depthFactor = texture2D(colortex0, texCoord).a;
    vec3 fogColor = vec3(0.10, 0.06, 0.20); // Violet mystique profond
    float fogDensity = 0.028;
    
    color = mix(color, fogColor, clamp(depthFactor * fogDensity, 0.0, 0.7));
#endif

#if ENABLE_VIGNETTE
    // Effet de vignette cinématographique pour renforcer l'immersion RPG
    vec2 uv = texCoord * (1.0 - texCoord.yx);
    float vignette = uv.x * uv.y * 16.0;
    vignette = clamp(pow(vignette, 0.25), 0.0, 1.0);
    color *= mix(0.65, 1.0, vignette);
#endif

    // Color Grading final : Contrastes riches et dynamiques
    color = pow(color, vec3(0.90));
    color = clamp(color, 0.0, 1.0);

    finalOutput = vec4(color, 1.0);
}
