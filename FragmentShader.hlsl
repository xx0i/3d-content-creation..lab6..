// an ultra simple hlsl fragment shader
struct OUTPUT2
{
    float4 posH : SV_POSITION;
    float3 posW : WORLD;
    float3 normW : NORMAL;
    float2 texCoord : TEXCOORD;
    float4 tangents : TANGENT;
};

cbuffer other_data
{
    matrix worldMatrix, viewMatrix, perspectiveMatrix;
    vector lightColour;
    vector lightDir, camPos;
};

Texture2D texture0 : register(t0, space2);
SamplerState sampler0 : register(s0, space2);

float4 main(OUTPUT2 input) : SV_TARGET
{
    //temp hard coded data - till the texture data is used in lab 6
    //static float4 diffuse = { 1.0f, 1.0f, 1.0f, 0.0f };
    static float4 specular = { 1.0f, 1.0f, 1.0f, 1.0f };
    static float4 emissive = { 0.0f, 0.0f, 0.0f, 1.0f };
    static float4 ambient = { 0.1f, 0.1f, 0.1f, 1.0f };
    static float ns = 140.0f;
    
    float4 textureColour = texture0.Sample(sampler0, input.texCoord.xy);
    
    float3 norm = normalize(input.normW);
    float3 lightDirection = normalize(lightDir);
    float diffuseIntensity = saturate(dot(norm, -lightDirection));
    float4 finalColour = (diffuseIntensity + ambient) * textureColour * lightColour;
    
    //half-vector method
    float3 viewDir = normalize(camPos.xyz - input.posW);
    float3 halfVect = normalize(-lightDirection.xyz + viewDir);
    float intensity = pow(saturate(dot(norm, halfVect)), ns);
    float3 reflected = lightColour.xyz * (float3) specular * intensity;
    finalColour += float4(reflected, 1.0f);

    return finalColour;
}