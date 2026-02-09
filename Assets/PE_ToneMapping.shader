Shader "PostEffect/ToneMapping"
{
   SubShader
    {
        Tags {  "RenderPipeline" = "UniversalPipeline" }

        Pass
        {
            ZWrite Off
            ZTest Always
            Blend Off
            Cull Off

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #pragma editor_sync_compilation
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"
           half GetLuninance(half3 color){
               return dot(
                  color,half3(0.2126, 0.7512, 0.0722));
               }
               half Linear(half luminance)
               {
                   return luminance;
               }
               half Division(half luminance, half divider)
               {
                   return luminance/divider;
               }
               half Reinhard(half lIn)
               {
                   return lIn / (1 + lIn);
               }
            half4 Frag(Varyings input) : SV_Target
            {

               half4 output = SAMPLE_TEXTURE2D(
                 _BlitTexture,sampler_LinearRepeat,
                 input.texcoord);

                 half lIn = GetLuninance(output.rgb);

                 half lOut = Reinhard(lIn);

                 half4 outputColor =
                 output * lOut / max(lIn, 0.001);

                 outputColor.a = 1;
                   return outputColor;
            }
           ENDHLSL
        }
    }
}
