precision mediump float;
//uniform float amp;
uniform sampler2D tDiffuse;
varying vec2 p;
uniform float time;
uniform float volume;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float Hash21(vec2 p){
	p = fract(p*vec2(235.12, 546.62));
    p += dot (p, p+34.23);
    return fract(p.x * p.y);
}

void main() {
    vec2 uv = (gl_FragCoord.xy-.5*resolution.xy)/resolution.y;
    uv *= 10.;
    vec3 col = vec3(0);
    vec2 gv = fract(uv);
    vec2 id = floor(uv);

    float randPos = Hash21(id);
    float t = time * (-.5-randPos) *0.5;
    float timeId = floor(t);
    float timeSign = -1.;//sign(fract(timeId*.5)-.5);

    float d = length(abs(gv-0.5));
    float innerDiameter = 0.1;
    float outterDiameter = 0.12;

    float mask = smoothstep(.2, -1.02, d-.5);

    float movingD = fract(d + t * timeSign);

    if (movingD> innerDiameter && movingD < outterDiameter && d <.5)
        col = vec3((fract(randPos * 123.46 + gl_FragCoord.x * 100.)*.8+.2) * mask);

    gl_FragColor = vec4(col,1.0);

}
