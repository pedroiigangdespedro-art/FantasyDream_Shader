#version 430 compatibility

in vec2 texCoord;
uniform sampler2D colortex0;
uniform sampler2D colortex2;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    
    // Brouillard lourd et rougeoyant du Nether
    vec3 netherFog = vec3(0.25, 0.05, 0.02);
    float depthFactor = texture2D(colortex0, texCoord).a;
    
    color = mix(color, netherFog, clamp(depthFactor * 0.05, 0.0, 0.75));
    color = pow(color, vec3(0.9));

    finalOutput = vec4(color, 1.0);
}
