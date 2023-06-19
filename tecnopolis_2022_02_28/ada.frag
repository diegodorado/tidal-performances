#version 130

#ifdef GL_ES
precision highp float;
#endif

#define RULE 30 

uniform sampler2D   u_buffer0;
uniform sampler2D   u_buffer1;

uniform sampler2D u_tex0;
uniform vec2 u_tex0Resolution;


uniform vec2        u_resolution;
uniform int         u_frame;
uniform float       u_time;

// OSC
uniform vec2 knit; // (cycle,knit)


//vec2 cells = vec2(56,24);
vec2 cells = vec2(48,24);
float zoom = 2.;
float cycleSpeed = (1./8.);
int framesPerCycle = 48;
// screen will be 1408x512, @32x32 cells, that is 88x32px each cell

// online converter 
// https://airtightinteractive.com/util/hex-to-glsl/
vec3 colorA0 = vec3(0.882,0.384,0.329);
vec3 colorA1 = vec3(0.588,0.102,0.047);
vec3 colorB0 = vec3(0.945,1.,0.588); // #f0ff95
vec3 colorB1 = vec3(0.882,0.847,0.675);


out vec4            o_color;

const mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );
const float PI = 3.1415926535;

float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0;

    return mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
               mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
}

float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.50000*noise( p ); p = m*p*2.02;
    f += 0.25000*noise( p ); p = m*p*2.03;
    f += 0.12500*noise( p ); p = m*p*2.01;
    f += 0.06250*noise( p ); p = m*p*2.04;
    f += 0.03125*noise( p );

    return f/0.984375;
}

float random (vec2 st) {
  return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}


void main() {
  vec2 st = gl_FragCoord.xy/ u_resolution;
  vec3 color = vec3(0.);

  ivec2 icells = ivec2(cells.x,cells.y);

  int cycle = int(knit.x*framesPerCycle*cycleSpeed);
  int y = (cycle/icells.x) % icells.y;
  int x = cycle % icells.x;

#ifdef BUFFER_0

  vec2 _st = st*cells;
  // get indexed position
  ivec2 ist = ivec2(floor(_st.x), floor(_st.y));


  color = texture2D(u_buffer1, st).rgb;

  if( (y + icells.y - ist.y) % icells.y > (icells.y-3) ){
    color = vec3(0.);
  }

  if(ist.x == x && ist.y == y ){

    float z = (1. -knit.y);
    float tt = 0.5*sin(u_time*0.1);
    vec3 colorA = mix(colorA0, colorA1, tt);
    vec3 colorB = mix(colorB0, colorB1, tt);

    color = mix(colorA, colorB, z);
  }

#elif defined( BUFFER_1 )
  color = texture2D(u_buffer0, st).rgb;

#else

  // Main Buffer

  // scroll weave
  //st.x += 1./cells.x*(x+2);
  st *=zoom;
  st.y += 1./cells.y*(y+2);


  st *=cells;

  // wooble yarn a bit
  st.x += (0.5-fbm(st*0.2))*0.25;
  st.y += (0.5-fbm(st*0.4))*0.25;

  // add spikes
  //st.x += 0.5*min(fract(st.y),1.-fract(st.y)) - 0.125;
  st.y += 0.5*min(fract(st.x),1.-fract(st.x)) - 0.125;

  vec2 _st = fract(st); // Wrap around 1.0
  //_st = rotate(_st,PI * 0.5);

  vec2 middle = ( floor(st) + vec2(0.5)) / cells;
  vec3 pixel = texture2D(u_buffer1, middle).rgb;

  //st.y += 0.5*min(_st.x,1.-_st.x) - 0.5;
  float _x = 0.4 +  sqrt(abs(cos(_st.x*PI)*sin(_st.x*PI)));
  float _y = 0.4 +  sqrt(abs(sin(_st.y*PI)));
  color = vec3(0.1) + vec3( _x*_y);

  // add whool fibers effect
  float a = step(0.5,_st.x)* PI * 0.5;
  vec2 fiberDir = rotate(vec2(0.5, 10.0),a);
  float fiber = 0.8 + 0.6* fbm( fiberDir*st );
  //fiber = smoothstep( 0.3, 1.0, fiber );
  color *= vec3(fiber);
  color *= 0.4 + 0.2* fbm( st ) + 0.2* fbm( st * 0.222 );
  color *= pixel;
  
  // reset st to make a fade out
  st = gl_FragCoord.xy/ u_resolution;
  //color *= smoothstep(0.,0.1,st.x);
  color *= 0.9*smoothstep(0.4,0.6,st.x);
  //color *= smoothstep(0.5,0.7,st.y);

#endif

  o_color = vec4(color, 1.);

}
