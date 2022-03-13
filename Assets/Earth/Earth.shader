Shader "Custom/Earth"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("Bumpmap", 2D) = "bump" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _RimColor("Rim Color", Color) = (0.17,0.36,0.81,0.0)
        //边缘发光强度 ||Rim Power
        _RimPower("Rim Power", Range(0.6,36.0)) = 8.0
        //边缘发光强度系数 || Rim Intensity Factor
        _RimIntensity("Rim Intensity", Range(0.0,100.0)) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows// vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        //边缘颜色
        float4 _RimColor;
        //边缘颜色强度
        float _RimPower;
        //边缘颜色强度
        float _RimIntensity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        //void vert(inout appdata_full v, out Input o)
        //{
        //    UNITY_INITIALIZE_OUTPUT(Input, o);
        //    o.normal = v.normal.xyz;
        //}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            //边缘颜色  
            half rim = 1 - saturate(dot(normalize(IN.viewDir), normalize(o.Normal)));
            //rim = smoothstep(0.1, 1, rim);

            //o.Normal = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));

            //计算出边缘颜色强度系数  
            o.Emission = _RimColor.rgb * pow(rim, _RimPower)*_RimIntensity;

            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
