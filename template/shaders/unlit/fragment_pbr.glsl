#version 330 core
out vec4 FragColor;

in vec3 o_positionWorld;
in vec3 o_normalWorld;
in vec2 o_uv0;

uniform vec3 viewPos;
vec3 lightColor;
uniform vec3 lightPos;

uniform sampler2D albedoTexture;
uniform sampler2D normalTexture;
uniform sampler2D metallicTexture;
uniform sampler2D roughnessTexture;
uniform sampler2D aoTexture;

const float PI = 3.14159265359f;


vec3 fresnelSchlick(float cosTheta, vec3 F0)
{
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

float distributionGGX(vec3 N, vec3 H, float a)
{
    float a2     = a*a;
    float NdotH  = max(dot(N, H), 0.0);
    float NdotH2 = NdotH*NdotH;
	
    float nom    = a2;
    float denom  = (NdotH2 * (a2 - 1.0) + 1.0);
    denom        = PI * denom * denom;
	
    return nom / denom;
}

float geometryShlickGGX(float NdotV, float k)
{
    float nom   = NdotV;
    float denom = NdotV * (1.0 - k) + k;
	
    return nom / denom;
}
  
float geometrySmith(vec3 N, vec3 V, vec3 L, float k)
{
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx1 = GeometrySchlickGGX(NdotV, k);
    float ggx2 = GeometrySchlickGGX(NdotL, k);
	
    return ggx1 * ggx2;
}

vec3 getNormalFromNormalMap()
{
    vec3 tangentNormal = texture(normalTexture, o_uv0).xyz * 2.0 - 1.0;

    vec3 Q1  = dFdx(o_positionWorld);
    vec3 Q2  = dFdy(o_positionWorld);

    vec2 st1 = dFdx(o_uv0);
    vec2 st2 = dFdy(o_uv0);

    vec3 N   = normalize(o_normalWorld);
    vec3 T  = normalize(Q1*st2.t - Q2*st1.t);
    vec3 B  = -normalize(cross(N, T));

    mat3 TBN = mat3(T, B, N);

    return normalize(TBN * tangentNormal);
}


void main()
{    
    lightColor=vec3(1.,1.,1.);
    vec3 albedo = pow(texture(albedoTexture, o_uv0).rgb, vec3(2.2));
    float metallic = texture(metallicTexture, o_uv0).r;
    float roughness = texture(roughnessTexture, o_uv0).r;
    float ao = texture(aoTexture, o_uv0).r;

    vec3 F0 = mix(vec3(0.04), albedo, metallic);

    vec3 N = getNormalFromNormalMap();
    vec3 V = normalize(viewPos - o_positionWorld);

    vec3 L = normalize(lightPos - o_positionWorld);
    vec3 H = normalize(V + L);

    float distance = length(lightPos - o_positionWorld);
    float attenuation = 1.0/(distance * distance);
    vec3 radiance = lightColor * attenuation;

    vec3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);

    float NDF = distributionGGX(N, H, roughness);
    float G = geometrySmith(N, V, L, roughness);

    vec3 numerator = NDF * G * F;
    float denominator = 4.0 * max(dot(N, V), 0.0) * max(dot(N, L), 0.0) + 0.0001;
    vec3 specular = numerator/denominator;

    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;

    float NdotL = max(dot(N, L), 0.0);
    vec3 Lo = (kD * albedo/PI + specular) * radiance * NdotL;


    vec3 ambient = vec3(0.03) * albedo * ao;
    vec3 color = ambient + Lo;

    color = color / (color + vec3(1.0));
    color = pow(color, vec3(1.0/2.2));

    FragColor = vec4(color, 1.0);
}