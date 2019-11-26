precision mediump float;
//uniform float amp;
uniform sampler2D tDiffuse;
varying vec2 p;
uniform float time;
uniform float volume;
uniform vec2 resolution;
uniform sampler2D backbuffer;


float hash21 (vec2 c)
{return fract(sin(dot(c,vec2(21.45,40.49)))*1245.5);}

float sphe (vec3 p, float r)
{return length(p)-r*(1.+volume);}

float g1 = 0.;
float sun (vec3 p)
{
    p.yz -= vec2(0.6, 0.4);
    float d = sphe (p,0.8+sin(time)*0.1+0.15);
    g1 += 0.1/(0.1+d*d);
    return d;
}

float g2 = 0.;
float moon (vec3 p)
{
    p.z += 0.4;
    p.y -= 0.5;
    p.y += clamp(sin(time*0.1)*3.,0.,3.);
    float d = sphe (p, 0.6);
    g2 += 0.1/(0.1+d*d);
    return d;
}

float water (vec3 p)
{
    p.y += 1.5;
    p.y += sin(length(p.xz*3.)-time)*0.1;
    return abs(p.y) -0.2;
}

float SDF (vec3 p)
{
    return min(water(p),min(sun(p), moon(p)));
}


void main() {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = 2.*(gl_FragCoord.xy/resolution.xy)-1.;
	  uv.x *= resolution.x / resolution.y;

    float dither = hash21(uv);

    vec3 ro = vec3(0.001,0.001,-3.),
        p = ro,
        col = vec3(0.),
        rd = normalize(vec3(uv,1.));

    float shad = 0.;

    for (float i=0.; i<64.; i++)
    {
        float d = SDF(p);
        if(d<0.001)
        {
            shad = i/64.;
            break;
        }
        d *= 0.9+dither*0.1;
        p+=d*rd;
    }
    float t = length(ro-p);

    col = vec3(shad)*0.2;

    col += g1*0.15;
    col -= g2*0.05;

    col = mix(col, vec3(0.,0.,0.03),1.-exp(-0.01*t*t));

    gl_FragColor = vec4(col,1.0);
}
