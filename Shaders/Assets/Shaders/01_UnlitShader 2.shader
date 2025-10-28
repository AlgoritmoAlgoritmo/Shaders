Shader "Unlit/UnlitShader2" {
    Properties {
		_Value( "Value", Float ) = 1.0
        _Color( "Color", Color ) = (1,1,1,1)
        // _MainTex ("Texture", 2D) = "white" {}
    }
	
    SubShader  {
        Tags { "RenderType"="Opaque" } // "RenderPipeline"="UniversalPipeline" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _Value;   // Automatically gets the values from the inspector
            float4 _Color;

            // automatically filled out by Unity
            struct MeshData {   // per-vertex mesh data
                float4 vertex : POSITION;   // vertex position
                float3 normals : NORMAL;
                // float3 tangent : TANGENT;
                // float4 color : COLOR;
                float4 uv0 : TEXCOORD0;  // UV0 coordinates. Usually albedo/normal maps.
                // float2 uv1 : TEXCOORD1;  // UV1 coordinates. Usually light map.
                // float4 uv2 : TEXCOORD2;  // UV0 coordinates. Usually albedo/normal maps. Can be float4 for procedural stuff
                // float4 uv3 : TEXCOORD3;  // UV1 coordinates. Usually albedo/normal maps. Can be float4 for procedural stuff
            };


            struct Interpolators { // v2f { <- default name    // It's the data that gets passed from Vertex shader to Fragment shader
                float4 vertex : SV_POSITION;    // clip space position of the vertex
                // float2 uv : TEXCOORD0;  // can be any data, not necesarilly UV

                /*
                * Can add any amount of TEXCOORD as long as they're float type (max float4)
                */
                /*
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float2 uv3 : TEXCOORD3;
                float2 uv4 : TEXCOORD4;
                float2 uv5 : TEXCOORD5;
                float2 uv6 : TEXCOORD6;
                */
            };


            Interpolators vert( MeshData v ) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos( v.vertex );    // local space to clip space. (multiplies by MVP matrix )
                /*
                    An MVP matrix (Model-View-Projection matrix) is a single 4x4 matrix in computer graphics
                    that combines three separate transformations: Model, View, and Projection. This composite
                    matrix transforms an object's vertex coordinates from its local model space to the final
                    screen space, enabling a 3D scene to be rendered on a 2D display
                */

                return o;   // the variable o is mostly used for the output
            }


            // bool 0 (false), 1 (true)
            // int
            // float4 = Vector4 (32 bit float)
            // half (16 bit float)
            // fixed (lower precision). Only useful from -1 to 1 range.
            // float4 -> half4 -> fixed4
            // float4x4 -> half4x4 -> fixed4x4 (C#: Matrix4x4)


            float4 frag (Interpolators i) : SV_Target { // This semantic says that the frag shader
                                                        // should output to the debuffer (SV_Target)
                                                        // Sometimes there can be multiple targets
                float4 myValue;
                float2 anotherValue = myValue.rg;   // = myValue.xy; // = myValue.gr; 
                                                    // How to parse from float4 to float2.
                                                    // It's called swizzling
                                                        


                return _Color;
            }
            ENDCG
        }
    }
}
