//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float time;
uniform float value;
uniform float dense;
vec2 resolution = vec2(800, 608);

void main()
{
	vec2 UV = gl_FragCoord.xy / resolution;
	vec2 add = vec2(sin((UV.x + UV.y * 0.5) * dense + time), cos((UV.x * 0.5 + UV.y) * dense + time));
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord + add * value);
}
