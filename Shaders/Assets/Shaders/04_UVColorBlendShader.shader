Shader "Unlit/04_UVColorBlendShader" {
    Properties {
        _ColorA( "Color A", Color ) = ( 1, 1, 1, 1 )
        _ColorB( "Color B", Color ) = ( 0, 0, 0, 1 )
		_ColourStart( "Colour Start", Range( 0, 1 ) ) = 0
        _ColourEnd( "Colour End", Range( 0, 1 ) ) = 1
    }
	
    SubShader  {
        Tags { "RenderType"="Opaque" } // "RenderPipeline"="UniversalPipeline" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _ColourStart;
            float _ColourEnd;

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
                o.uv = v.uv0; // (v.uv0 + _Offset) * _Scale;

                return o;   // the variable o is mostly used for the output
            }


            /*
            * Custom Function
            */
            float InverseLerp( float a, float b, float v ) {
                return (v - a) / (b - a);
            }


            float4 frag( Interpolators i ) : SV_Target { 
                // lerp
                /*
                * It's a way to blend between 2 values based on a 3rd value, usually between 0 to 1.
                */
                /*
                float4 outColour = lerp( _ColorA, _ColorB, i.uv.x );

                return outColour;
                */

                /*
                * Using Inverse lerp to set a beginning and end to the blend
                *
                */
                /*
                float t = InverseLerp( _ColourStart, _ColourEnd, i.uv.x );
                float4 outColour = lerp( _ColorA, _ColorB, t );
                */
                // return outColour;
                


                /*
                * Dealing with out of range (0-1) values
                *
                * frac = v - floor(v)
                *
                * What it does is to repeat the values between 0 and 1
                */
                
                // t = frac(t);



                /*
                *
                * saturate() is a function that clamps values:
                *
                * if a value is less than 0, it converts it to 0
                *  if a value is higher than 1, it makes it converts it to 1
                *
                */

                /*
                float t = saturate(InverseLerp( _ColourStart, _ColourEnd, i.uv.x ));
                t = frac(t);

                return t; // simple floats are automatically casted to float4
                            // by using the same value for x, y, z and w
                */


                /*
                *
                * So this is he final code for color mixing with clamped values:
                * The previous one was for visual debugging, to check if the values
                * were actually being clamped)
                *
                */

                float t = saturate(InverseLerp( _ColourStart, _ColourEnd, i.uv.x ));
                float4 outColour = lerp( _ColorA, _ColorB, t );

                return outColour;

                /*
                * https://developer.download.nvidia.com/cg/index_stdlib.html
                * This link contains the documentation for the default cg language. It's deprecated.
                */

            }
            ENDCG
        }
    }
}
