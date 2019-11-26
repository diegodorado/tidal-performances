#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float pi = acos(-1.);
const float pi2 = pi * 2.;

float noise(vec3 p)
{
	vec3 ip=floor(p);
	p-=ip;
	vec3 s=vec3(7, 157, 113);
	vec4 h=vec4(0, s.yz, s.y+s.z)+dot(ip, s);
	p=p*p*(3.-2.*p);
	h=mix(fract(43758.5*sin(h)), fract(43758.5*sin(h+s.x)), p.x);
	h.xy=mix(h.xz, h.yw, p.y);
	return mix(h.x, h.y, p.z);
}


mat2 rot(float a)
{
	float s = sin(a) , c = cos(a);
	return mat2(s,c,-c,s);
}

void dmin(inout vec3 d, float x, float y, float z)
{
	if( x < d.x ) d = vec3(x, y, z);
}


void pR(inout vec2 p, float a)
{
	a *= 6.283;
	p = cos(a)*p+sin(a)*vec2(p.y, -p.x);
}

vec3 rep(vec3 p, float r)
{
	return (fract(p/r-.5)-.5)*r;
}

float vines(vec3 p, float s)
{
	p.y=abs(p.y);
	pR(p.xz, .1*p.y); p=abs(p); p.xz -= .06*s;
	pR(p.xz, -.16*p.y); p=abs(p); p.xz -= .05*s;
	pR(p.xz, .4*p.y);
	return length(abs(p.xz) - .04*(s*.5+.5));
}


float dbox(vec3 p , float s)
{
	p = abs(p)- s;
	return max(max(p.x,p.y),p.z);
}

float sat(float x)
{
	return clamp(x, 0., 1.);
}

float cb(int a){
	return 0.;
}

float dist(vec3 p )
{
	vec3 d = vec3(1, 0, 0), q, t;
	
	float
		a=.5*time*cb(11),
		n0 = noise(73.*p+a),
		n1 = noise(10.*p+a+a),
		n2 = noise(2.*p+a)-.5,
		n3 = noise(.4*p+a)-.5,
		h;
	float
		wn1 = .2*n0+n1,
		wn2 = sat(10.*n2),
		wn3 = sat(10.*n3)*sat(.2*p.x*p.x-.1+.3*n2);
	float wallnoise = wn1*(.02+wn2);


		h = mix(.05*n0+.07*n1+.3*n2+n3,
		.002*n0+.04*n1+.2*n2+.4*n3, cb(11));
	if( cb(3)==0. )
		dmin(d, .8+p.y-.1*wallnoise, .01+.9*wn2, 0.);
	else if( cb(2)==0. )
		dmin(d, 1.2-.6*cb(11)+p.y-h, mix(.8+h*(1.-0.5), .01, cb(11)), 0.);
	else
		dmin(d, .6+p.y-(wn1/3.+n2+.5+3.*sat(4.*n3-1.))*(.02+wn3), .01+.9*wn3, 0.);



			q=rep(abs(p)-1.6, 3.2);
			q.y = abs(p.y)-3.;
			dmin(d,
				max(p.y-3.5, vines(
					q,
					.1+.5+10./pow(1.+.95*q.y*q.y, 1.5)
				) -
					mix(.02+.08, -.1, (.55+p.y/3.)*sat(-15.-p.z))
				), .9, .0);



	return d.x;
}

void main() {

	vec2 p = ( gl_FragCoord.xy * 2. - resolution.xy )/ min(resolution.x,resolution.y);


	vec3 color = vec3(0.);

	float t = time * 3.;
	vec3 cp = vec3(0.,0.,-10.);
	vec3 cd = vec3(0.,0,1.9);
	vec3 cu = vec3(0,9.,0);
	vec3 cs = cross(cd , cu);

	cp += cd * t/3. * 0.5;
	cp += cs * 5.* fract(sin(t/30.));


	float target = 2.5;

	vec3 rd = normalize(vec3(cd * target + cu * p.y + cs * p.x));

	float depth= 0.0;
	float ac = 0.0;

	for(int i = 0; i < 99; i++)
	{
		vec3 rp = cp + rd * depth;
		float d = dist(rp);
		d = max(d,0.01);
		ac += exp(-d * depth);
		depth += d;
	}

	color = vec3(ac/200.);

	gl_FragColor = vec4(color,1.);

}
