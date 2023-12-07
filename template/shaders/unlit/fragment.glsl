#version 330 core

in vec3 o_positionWorld;
in vec3 o_normalWorld;
in vec2 o_uv0;
in mat3 o_TBN;


out vec4 FragColor;


uniform vec4 color;
uniform vec3 lightPos;
uniform vec3 viewPos;


uniform sampler2D normalMap;
uniform sampler2D colorTexture;


void main() {
    vec3 lightPosTang=o_TBN*lightPos;
    vec3 viewPosTang=o_TBN*viewPos;
    vec3 posTang=o_TBN*vec3(o_positionWorld);

    vec3 normal = texture(normalMap,o_uv0 ).rgb;
    normal = (2.0*normal) - vec3(1.0);   
    normal = normalize(o_TBN * normal); 

    vec3 L,R,V;
    L=normalize(lightPosTang-posTang);

    float LN,RV;
    LN=dot(L,normal); 
    R=2*dot(normal,L)*normal-L;
    V=viewPosTang-posTang;  
    normalize(V);normalize(R);          
    RV=dot(R,V);
    if(LN<0)LN=0;
    if(LN>1)LN=1;
    if(RV<0)RV=0;
    if(RV>1)RV=1;
    vec3 lightcolor=vec3(1.,1.,1.);
    vec3 ambiant=lightcolor;
    vec3 diffuse=LN*lightcolor;
    vec3 spec=pow(RV,32)*lightcolor;
    vec3 colorPhong=(1*ambiant+1*diffuse+0.2*spec)*texture(colorTexture, o_uv0).rgb;

    //FragColor = color;
    //FragColor = texture(colorTexture, o_uv0) * color;
    FragColor =vec4(colorPhong,1.0);


    // DEBUG: position
    //FragColor = vec4(o_positionWorld, 1.0);
    // DEBUG: normal
    //FragColor =vec4(0.5 * o_normalWorld + vec3(0.5) , 1.0);
    // DEBUG: uv0
    // FragColor = vec4(o_uv0, 1.0);
}


