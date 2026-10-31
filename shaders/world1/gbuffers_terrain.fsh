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
    
    // Teinte End : Violet cosmique / Cyan éthéré
    vec3 endTint = vec3(0.7, 0.5, 1.3);
    albedo.rgb *= endTint;
    
    float emissiveMask = step(0.8, lmCoord.x);

    fragColor = albedo;
    fragNormal = vec4(normalize(normal) * 0.5 + 0.5, 1.0);
    fragEmissive = vec4(albedo.rgb * emissiveMask * 2.0, 1.0);
}
