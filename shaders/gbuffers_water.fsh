#version 430 compatibility

in vec2 texCoord;
in vec2 lmCoord;
in vec4 vertexColor;
in vec3 normal;
in vec3 worldPos;

uniform sampler2D texture;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;
layout(location = 2) out vec4 fragEmissive;

void main() {
    vec4 albedo = texture2D(texture, texCoord) * vertexColor;
    
    // Teinte d'eau féerique (bleu lagon mystique / turquoise)
    vec3 fantasyWaterTint = vec3(0.2, 0.7, 0.95);
    albedo.rgb = mix(albedo.rgb, fantasyWaterTint * albedo.rgb, 0.6);
    
    // Transparence caractéristique de l'eau
    albedo.a *= 0.75;

    fragColor = albedo;
    fragNormal = vec4(normalize(normal) * 0.5 + 0.5, 1.0);
    fragEmissive = vec4(vec3(0.0), 1.0);
}
