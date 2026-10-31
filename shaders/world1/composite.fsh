#version 430 compatibility

in vec2 texCoord;
uniform sampler2D colortex0;
uniform sampler2D colortex2;

layout(location = 0) out vec4 finalOutput;

void main() {
    vec3 color = texture2D(colortex0, texCoord).rgb;
    
    // Brouillard ténébreux et stellaire de l'End
    vec3 endFog = vec3(0.08, 0.03, 0.15);
    float depthFactor = texture2D(colortex0, texCoord).a;
    
    color = mix(color, endFog, clamp(depthFactor * 0.04, 0.0, 0.65));
    color = pow(color, vec3(0.95));

    finalOutput = vec4(color, 1.0);
}
