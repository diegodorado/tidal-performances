
/*
{
  "audio": true,
  "midi": true,
  "osc": 4000,
  IMPORTED: {
    "vid1": {
      "PATH": "./../../vjloops/020.mp4",
       "SPEED": "0.451"
    },
    "vid2": {
      "PATH": "./../../vjloops/006.mp4",
       "SPEED": "0.51"
    },
    "vid3": {
      "PATH": "./../../vjloops/009.mp4",
       "SPEED": "0.51"
    }
  }
}
*/
precision mediump float;
uniform float time;
uniform vec2 resolution;
uniform sampler2D backbuffer;
uniform sampler2D midi;
uniform sampler2D note;
uniform sampler2D spectrum;
uniform sampler2D samples;
uniform float volume;
uniform sampler2D vid1;
uniform sampler2D vid2;
uniform sampler2D vid3;


vec2 rotate(in vec2 p, in float t) {
    t *= .2;
    return mat2(
        cos(t), -sin(t),
        sin(t), cos(t)
    ) * p;
}

float random(in vec2 st) {
    return fract(abs(sin(dot(st, vec2(94.2984, 488.923))) * 234.9892));
}

float rects(in vec2 p, in float t) {
    float s = random(vec2(p.x * .0001 + t * .00008, floor(p.y * 32.)));
    return s;
}


float bandLevel(int index){
  float r=0.0;
  for(int i=0;i<20;i++)
  {
    float x = exp2(float(index)+float(i)/20.0)/exp2(10.);
    r += texture2D(spectrum, vec2(x, .0)).x;
  }
  return r/20.0;
}


void main() {
  float t = time * .3;
  float t2 = time * .5;
  float t3 = time * .8;

  vec2 p = (gl_FragCoord.xy * 2. - resolution) / min(resolution.x, resolution.y);
  float f0 = bandLevel(1);
  float f1 = bandLevel(7);

  vec2 uv = gl_FragCoord.xy / resolution;

  vec4 v1 = texture2D(vid1, uv);
  vec4 v2 = texture2D(vid2, uv);
  vec4 v3 = texture2D(vid3, uv);

  v1 *= (f0-f1)*5.;;
  v2 *= (f1-f0*0.5)*2.;
  v3 *= 1.;


  float n = rects(p, time);
  float l = length(p) * .1;
  float c1 = texture2D(note, vec2(l * 1. +.5, 0.)).r;
  float c2 = texture2D(note, vec2(l * 3. +.5, 0.)).r;

  gl_FragColor = c1*v1 + c2*v1+0.5*v1*f0*(1.-c2)+texture2D(backbuffer, (uv - .5) * 1.02 +.5 ) * .125;


}
