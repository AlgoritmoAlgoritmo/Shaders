Shader "Unlit/03_UVsShader" {
    Properties {
        _Color( "Color", Color ) = (1,1,1,1)
		_Scale( "UV Scale", Float ) = 1
        _Offset( "Offset", Float ) = 0
        // _MainTex ("Texture", 2D) = "white" {}
    }
	
    SubShader  {
        Tags { "RenderType"="Opaque" } // "RenderPipeline"="UniversalPipeline" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _Color;
            float _Scale;
            float _Offset;

            // automatically filled out by Unity
            struct MeshData {   // per-vertex mesh data
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0;  // UV0 coordinates. Usually albedo/normal maps.
            };


            struct Interpolators { // v2f { <- default name    // It's the data that gets passed from Vertex shader to Fragment shader
                float4 vertex : SV_POSITION;    // clip space position of the vertex
                float3 normal : TEXTCOORD0; // has to be float3 because normals are directional vectors
                                            // they're local space'
                float2 uv : TEXTCOORD1;
            };


            /*
            *
            *   IMPORTANT:
            *   ----------
            *   The vert shader runs once per vertex and the frag shader runs once per pixel.
            *   This means that, for the sake of optimization, it's better to do as much as
            *   possible in the vert shader, since usually objects have more pixels than vertices.
            *
            */


            Interpolators vert( MeshData v ) {
                Interpolators o;
                o.vertex = UnityObjectToClipPos( v.vertex );    // local space to clip space. (multiplies by MVP matrix )
                o.normal = // UnityObjectToWorldNormal( v.normals ); // <- using Unity library
                            // mul( v.normals, (float3x3)unity_WorldToObject ); // <- manual lotal to world normal convertion
                            mul( (float3x3)unity_ObjectToWorld, v.normals ); // <- different method and switching arguments
                            // this conversion can also be done in the frag shader
                o.uv = (v.uv0 + _Offset) * _Scale;

                return o;   // the variable o is mostly used for the output
            }

            float4 frag( Interpolators i ) : SV_Target { // This semantic says that the frag shader
                                                        // should output to the debuffer (SV_Target)
                                                        // Sometimes there can be multiple targets
                return float4( i.uv, 0, 1 );   // automatically populates x, y and z, and sets w to 1
            }
            ENDCG
        }
    }
}
