#version 430 compatibility

out vec2 texCoord;

void main() {
    // Génération d'un quad plein écran moderne sans ftransform()
    vec2 pos = vec2((gl_VertexID == 1 || gl_VertexID == 2) ? 1.0 : -1.0, 
                    (gl_VertexID >= 2) ? 1.0 : -1.0);
    gl_Position = vec4(pos, 0.0, 1.0);
    texCoord = (pos + 1.0) * 0.5;
}
