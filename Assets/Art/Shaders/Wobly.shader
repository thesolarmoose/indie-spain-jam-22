Shader "Wobly"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        
        _speed("speed", Float) = 0.1
        _distortionScale("distortionScale", Range(0, 1)) = 0.5
        _noiseScale("noiseScale", Float) = 8
        
        _Stencil ("Stencil ID", Float) = 0
        _ColorMask ("Color Mask", Float) = 15
        
        [HideInInspector]_BUILTIN_QueueOffset("Float", Float) = 0
        [HideInInspector]_BUILTIN_QueueControl("Float", Float) = -1
    }
    SubShader
    {
        Tags
        {
            // RenderPipeline: <None>
            "RenderType"="Transparent"
            "BuiltInMaterialType" = "Unlit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="BuiltInUnlitSubTarget"
        }
        
        Stencil
        {
            Ref [_Stencil]
            Comp Always
            Pass Replace
            ReadMask 255
            WriteMask 255
        }
        
        Pass
        {
            Name "Pass"
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            
            // Render State
            Cull Off
            Lighting Off
            ZWrite Off
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            ColorMask [_ColorMask]
            
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile_fwdbase
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _speed;
        float _distortionScale;
        float _noiseScale;
        CBUFFER_END
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_PolarCoordinates_float(float2 UV, float2 Center, float RadialScale, float LengthScale, out float2 Out)
        {
            float2 delta = UV - Center;
            float radius = length(delta) * 2 * RadialScale;
            float angle = atan2(delta.x, delta.y) * 1.0/6.28 * LengthScale;
            Out = float2(radius, angle);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4;
            Unity_PolarCoordinates_float(IN.uv0.xy, float2 (0.5, 0.5), 1, 1, _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4);
            float _Split_df66ce0d68ed499898cd8b61660cc161_R_1 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[0];
            float _Split_df66ce0d68ed499898cd8b61660cc161_G_2 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[1];
            float _Split_df66ce0d68ed499898cd8b61660cc161_B_3 = 0;
            float _Split_df66ce0d68ed499898cd8b61660cc161_A_4 = 0;
            float _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0 = _speed;
            float _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2);
            float _Subtract_afd199cf80654337a026e35755444b79_Out_2;
            Unity_Subtract_float(_Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Subtract_afd199cf80654337a026e35755444b79_Out_2);
            float _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2;
            Unity_Modulo_float(_Subtract_afd199cf80654337a026e35755444b79_Out_2, 1, _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2);
            float _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0 = _noiseScale;
            float _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2;
            Unity_GradientNoise_float((_Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2);
            float _Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0 = _distortionScale;
            float _Multiply_0a653dade21644f789c596323c217d7a_Out_2;
            Unity_Multiply_float_float(_Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0, 0.5, _Multiply_0a653dade21644f789c596323c217d7a_Out_2);
            float _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2;
            Unity_Multiply_float_float(_GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2);
            float _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2, _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2);
            float _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2);
            float _Add_bd73c35577b6402cba1a4d793168bd03_Out_2;
            Unity_Add_float(_Add_f5682f49216a491c8c0298cbf09c9d05_Out_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_bd73c35577b6402cba1a4d793168bd03_Out_2);
            float _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2;
            Unity_Modulo_float(_Add_bd73c35577b6402cba1a4d793168bd03_Out_2, 1, _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2);
            float _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2;
            Unity_GradientNoise_float((_Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2);
            float _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2;
            Unity_Multiply_float_float(_GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2);
            float _Add_bbf7114886664206ab5ee96c857177c3_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2);
            float _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2;
            Unity_Multiply_float_float(_Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2);
            float _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3;
            Unity_Smoothstep_float(1, 1, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2, _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3);
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors = float (1);
            Unity_InvertColors_float(_Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1);
            surface.BaseColor = IsGammaSpace() ? float3(1, 1, 1) : SRGBToLinear(float3(1, 1, 1));
            surface.Alpha = _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/UnlitPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_shadowcaster
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define BUILTIN_TARGET_API 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _speed;
        float _distortionScale;
        float _noiseScale;
        CBUFFER_END
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_PolarCoordinates_float(float2 UV, float2 Center, float RadialScale, float LengthScale, out float2 Out)
        {
            float2 delta = UV - Center;
            float radius = length(delta) * 2 * RadialScale;
            float angle = atan2(delta.x, delta.y) * 1.0/6.28 * LengthScale;
            Out = float2(radius, angle);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4;
            Unity_PolarCoordinates_float(IN.uv0.xy, float2 (0.5, 0.5), 1, 1, _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4);
            float _Split_df66ce0d68ed499898cd8b61660cc161_R_1 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[0];
            float _Split_df66ce0d68ed499898cd8b61660cc161_G_2 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[1];
            float _Split_df66ce0d68ed499898cd8b61660cc161_B_3 = 0;
            float _Split_df66ce0d68ed499898cd8b61660cc161_A_4 = 0;
            float _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0 = _speed;
            float _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2);
            float _Subtract_afd199cf80654337a026e35755444b79_Out_2;
            Unity_Subtract_float(_Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Subtract_afd199cf80654337a026e35755444b79_Out_2);
            float _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2;
            Unity_Modulo_float(_Subtract_afd199cf80654337a026e35755444b79_Out_2, 1, _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2);
            float _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0 = _noiseScale;
            float _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2;
            Unity_GradientNoise_float((_Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2);
            float _Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0 = _distortionScale;
            float _Multiply_0a653dade21644f789c596323c217d7a_Out_2;
            Unity_Multiply_float_float(_Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0, 0.5, _Multiply_0a653dade21644f789c596323c217d7a_Out_2);
            float _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2;
            Unity_Multiply_float_float(_GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2);
            float _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2, _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2);
            float _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2);
            float _Add_bd73c35577b6402cba1a4d793168bd03_Out_2;
            Unity_Add_float(_Add_f5682f49216a491c8c0298cbf09c9d05_Out_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_bd73c35577b6402cba1a4d793168bd03_Out_2);
            float _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2;
            Unity_Modulo_float(_Add_bd73c35577b6402cba1a4d793168bd03_Out_2, 1, _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2);
            float _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2;
            Unity_GradientNoise_float((_Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2);
            float _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2;
            Unity_Multiply_float_float(_GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2);
            float _Add_bbf7114886664206ab5ee96c857177c3_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2);
            float _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2;
            Unity_Multiply_float_float(_Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2);
            float _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3;
            Unity_Smoothstep_float(1, 1, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2, _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3);
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors = float (1);
            Unity_InvertColors_float(_Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1);
            surface.Alpha = _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SceneSelectionPass
        #define BUILTIN_TARGET_API 1
        #define SCENESELECTIONPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _speed;
        float _distortionScale;
        float _noiseScale;
        CBUFFER_END
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_PolarCoordinates_float(float2 UV, float2 Center, float RadialScale, float LengthScale, out float2 Out)
        {
            float2 delta = UV - Center;
            float radius = length(delta) * 2 * RadialScale;
            float angle = atan2(delta.x, delta.y) * 1.0/6.28 * LengthScale;
            Out = float2(radius, angle);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4;
            Unity_PolarCoordinates_float(IN.uv0.xy, float2 (0.5, 0.5), 1, 1, _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4);
            float _Split_df66ce0d68ed499898cd8b61660cc161_R_1 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[0];
            float _Split_df66ce0d68ed499898cd8b61660cc161_G_2 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[1];
            float _Split_df66ce0d68ed499898cd8b61660cc161_B_3 = 0;
            float _Split_df66ce0d68ed499898cd8b61660cc161_A_4 = 0;
            float _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0 = _speed;
            float _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2);
            float _Subtract_afd199cf80654337a026e35755444b79_Out_2;
            Unity_Subtract_float(_Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Subtract_afd199cf80654337a026e35755444b79_Out_2);
            float _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2;
            Unity_Modulo_float(_Subtract_afd199cf80654337a026e35755444b79_Out_2, 1, _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2);
            float _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0 = _noiseScale;
            float _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2;
            Unity_GradientNoise_float((_Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2);
            float _Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0 = _distortionScale;
            float _Multiply_0a653dade21644f789c596323c217d7a_Out_2;
            Unity_Multiply_float_float(_Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0, 0.5, _Multiply_0a653dade21644f789c596323c217d7a_Out_2);
            float _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2;
            Unity_Multiply_float_float(_GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2);
            float _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2, _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2);
            float _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2);
            float _Add_bd73c35577b6402cba1a4d793168bd03_Out_2;
            Unity_Add_float(_Add_f5682f49216a491c8c0298cbf09c9d05_Out_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_bd73c35577b6402cba1a4d793168bd03_Out_2);
            float _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2;
            Unity_Modulo_float(_Add_bd73c35577b6402cba1a4d793168bd03_Out_2, 1, _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2);
            float _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2;
            Unity_GradientNoise_float((_Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2);
            float _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2;
            Unity_Multiply_float_float(_GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2);
            float _Add_bbf7114886664206ab5ee96c857177c3_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2);
            float _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2;
            Unity_Multiply_float_float(_Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2);
            float _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3;
            Unity_Smoothstep_float(1, 1, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2, _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3);
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors = float (1);
            Unity_InvertColors_float(_Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1);
            surface.Alpha = _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS ScenePickingPass
        #define BUILTIN_TARGET_API 1
        #define SCENEPICKINGPASS 1
        #define _BUILTIN_SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        #ifdef _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #define _SURFACE_TYPE_TRANSPARENT _BUILTIN_SURFACE_TYPE_TRANSPARENT
        #endif
        #ifdef _BUILTIN_ALPHATEST_ON
        #define _ALPHATEST_ON _BUILTIN_ALPHATEST_ON
        #endif
        #ifdef _BUILTIN_AlphaClip
        #define _AlphaClip _BUILTIN_AlphaClip
        #endif
        #ifdef _BUILTIN_ALPHAPREMULTIPLY_ON
        #define _ALPHAPREMULTIPLY_ON _BUILTIN_ALPHAPREMULTIPLY_ON
        #endif
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Shim/Shims.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/LegacySurfaceVertex.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp0.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _speed;
        float _distortionScale;
        float _noiseScale;
        CBUFFER_END
        
        // Object and Global properties
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // Graph Functions
        
        void Unity_PolarCoordinates_float(float2 UV, float2 Center, float RadialScale, float LengthScale, out float2 Out)
        {
            float2 delta = UV - Center;
            float radius = length(delta) * 2 * RadialScale;
            float angle = atan2(delta.x, delta.y) * 1.0/6.28 * LengthScale;
            Out = float2(radius, angle);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Modulo_float(float A, float B, out float Out)
        {
            Out = fmod(A, B);
        }
        
        
        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            // need full precision, otherwise half overflows when p > 1
            float x = float(34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_InvertColors_float(float In, float InvertColors, out float Out)
        {
            Out = abs(InvertColors - In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float2 _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4;
            Unity_PolarCoordinates_float(IN.uv0.xy, float2 (0.5, 0.5), 1, 1, _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4);
            float _Split_df66ce0d68ed499898cd8b61660cc161_R_1 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[0];
            float _Split_df66ce0d68ed499898cd8b61660cc161_G_2 = _PolarCoordinates_1c53d3731736422f914aa52418f9b6a8_Out_4[1];
            float _Split_df66ce0d68ed499898cd8b61660cc161_B_3 = 0;
            float _Split_df66ce0d68ed499898cd8b61660cc161_A_4 = 0;
            float _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0 = _speed;
            float _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_2c886851cfea48ed8def4fe6772f3e31_Out_0, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2);
            float _Subtract_afd199cf80654337a026e35755444b79_Out_2;
            Unity_Subtract_float(_Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Subtract_afd199cf80654337a026e35755444b79_Out_2);
            float _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2;
            Unity_Modulo_float(_Subtract_afd199cf80654337a026e35755444b79_Out_2, 1, _Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2);
            float _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0 = _noiseScale;
            float _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2;
            Unity_GradientNoise_float((_Modulo_81208c8a5461409fb5840bfde67e01bb_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2);
            float _Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0 = _distortionScale;
            float _Multiply_0a653dade21644f789c596323c217d7a_Out_2;
            Unity_Multiply_float_float(_Property_59a898e38d7f4c73a24bc0e849abc97b_Out_0, 0.5, _Multiply_0a653dade21644f789c596323c217d7a_Out_2);
            float _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2;
            Unity_Multiply_float_float(_GradientNoise_e575b1ecb369458b96a0efd7735aa254_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2);
            float _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_6f11da77b676403d8f2d0421d1f55d2a_Out_2, _Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2);
            float _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_G_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_f5682f49216a491c8c0298cbf09c9d05_Out_2);
            float _Add_bd73c35577b6402cba1a4d793168bd03_Out_2;
            Unity_Add_float(_Add_f5682f49216a491c8c0298cbf09c9d05_Out_2, _Multiply_110adff77ace43bb864a0982633ec3f8_Out_2, _Add_bd73c35577b6402cba1a4d793168bd03_Out_2);
            float _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2;
            Unity_Modulo_float(_Add_bd73c35577b6402cba1a4d793168bd03_Out_2, 1, _Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2);
            float _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2;
            Unity_GradientNoise_float((_Modulo_32b21a8c008e45ce928a730c4d3c493b_Out_2.xx), _Property_fd9d897d4f2341d8a1ba056c4a288527_Out_0, _GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2);
            float _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2;
            Unity_Multiply_float_float(_GradientNoise_6fce4f6bc0894a22803913ec3ef3195c_Out_2, _Multiply_0a653dade21644f789c596323c217d7a_Out_2, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2);
            float _Add_bbf7114886664206ab5ee96c857177c3_Out_2;
            Unity_Add_float(_Split_df66ce0d68ed499898cd8b61660cc161_R_1, _Multiply_2289d836670349c1bd0c8ab2efbb6f83_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2);
            float _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2;
            Unity_Multiply_float_float(_Add_c07d30c5b8e64cab8b0e1a486c3b029c_Out_2, _Add_bbf7114886664206ab5ee96c857177c3_Out_2, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2);
            float _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3;
            Unity_Smoothstep_float(1, 1, _Multiply_392b5084dd2c4c139c3da3ff067d26ea_Out_2, _Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3);
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            float _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors = float (1);
            Unity_InvertColors_float(_Smoothstep_9ccab6b60386432e958e9dd670ca6eb2_Out_3, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_InvertColors, _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1);
            surface.Alpha = _InvertColors_d9bc395690a94a5b86402f0b041f7be0_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
            
        
        
        
        
        
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        void BuildAppDataFull(Attributes attributes, VertexDescription vertexDescription, inout appdata_full result)
        {
            result.vertex     = float4(attributes.positionOS, 1);
            result.tangent    = attributes.tangentOS;
            result.normal     = attributes.normalOS;
            result.texcoord   = attributes.uv0;
            result.vertex     = float4(vertexDescription.Position, 1);
            result.normal     = vertexDescription.Normal;
            result.tangent    = float4(vertexDescription.Tangent, 0);
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
        }
        
        void VaryingsToSurfaceVertex(Varyings varyings, inout v2f_surf result)
        {
            result.pos = varyings.positionCS;
            // World Tangent isn't an available input on v2f_surf
        
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogCoord = varyings.fogFactorAndVertexLight.x;
                COPY_TO_LIGHT_COORDS(result, varyings.fogFactorAndVertexLight.yzw);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(varyings, result);
        }
        
        void SurfaceVertexToVaryings(v2f_surf surfVertex, inout Varyings result)
        {
            result.positionCS = surfVertex.pos;
            // viewDirectionWS is never filled out in the legacy pass' function. Always use the value computed by SRP
            // World Tangent isn't an available input on v2f_surf
        
            #if UNITY_ANY_INSTANCING_ENABLED
            #endif
            #if UNITY_SHOULD_SAMPLE_SH
            #endif
            #if defined(LIGHTMAP_ON)
            #endif
            #ifdef VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
                result.fogFactorAndVertexLight.x = surfVertex.fogCoord;
                COPY_FROM_LIGHT_COORDS(result.fogFactorAndVertexLight.yzw, surfVertex);
            #endif
        
            DEFAULT_UNITY_TRANSFER_VERTEX_OUTPUT_STEREO(surfVertex, result);
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.shadergraph/Editor/Generation/Targets/BuiltIn/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.Rendering.BuiltIn.ShaderGraph.BuiltInUnlitGUI" ""
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}