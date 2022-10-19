Shader "Custom/TessellationSurfaceLit"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _TessellationEdgeLength ("Tessellation Edge Length", Range(2, 400)) = 20
        _TessellationPhong ("Tessellation Phong", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard nolightmap tessellate: tessellateEdge tessphong: _TessellationPhong

        #include "Tessellation.cginc"

        float _TessellationEdgeLength;
        float _TessellationPhong;

        float4 tessellateEdge(
            appdata_full vertex0,
            appdata_full vertex1,
            appdata_full vertex2
        )
        {
            // can create custom tessellation code here,
            // or use Unity's built in functions
            return UnityEdgeLengthBasedTess(
                vertex0.vertex,
                vertex1.vertex,
                vertex2.vertex,
                _TessellationEdgeLength
            );
        }

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
