#version 430 compatibility

#define ENABLE_VOLUMETRIC_FOG 1
#define ENABLE_BLOOM 1
#define ENABLE_GOD_RAYS 1
#define ENABLE_VIGNETTE 1

in vec2 texCoord;

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D depthtex0; // CORRECTIF : Tampon de profondeur officiel d'Iris
uniform float viewWidth;
uniform float viewHeight;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    float rawDepth = texture2D(depthtex0, texCoord).r;
    bool isSky = (rawDepth >= 1.0); // Détection fiable du ciel

#if ENABLE_BLOOM
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
    color += bloom * 1.2;
#endif

#if ENABLE_GOD_RAYS
    // Rayons crépusculaires uniquement sur le ciel
    if (isSky) {
        vec2 rayCoord = texCoord - vec2(0.5, 0.2);
        float rayDist = length(rayCoord);
        vec3 fantasyRayColor = vec3(0.35, 0.25, 0.65);
        color += fantasyRayColor * max(0.0, (1.0 - rayDist * 1.8)) * 0.12;
    }
#endif

#if ENABLE_VOLUMETRIC_FOG
    // Brouillard volumétrique appliqué uniquement sur les blocs/monde (pas sur le ciel)
    if (!isSky) {
        float approxDist = (1.0 - rawDepth) * 45.0; // Conversion propre de la profondeur
        vec3 fogColor = vec3(0.10, 0.06, 0.20); 
        float fogDensity = 0.035;
        
        color = mix(color, fogColor, clamp(approxDist * fogDensity, 0.0, 0.75));
    }
#endif

#if ENABLE_VIGNETTE
    vec2 uv = texCoord * (1.0 - texCoord.yx);
    float vignette = uv.x * uv.y * 16.0;
    vignette = clamp(pow(vignette, 0.25), 0.0, 1.0);
    color *= mix(0.65, 1.0, vignette);
#endif

    color = pow(color, vec3(0.90));
    color = clamp(color, 0.0, 1.0);

    finalOutput = vec4(color, 1.0);
}
