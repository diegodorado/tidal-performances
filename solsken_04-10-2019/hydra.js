msg.setPort(6666)
p = new Array(8).fill(0)
msg.on('/rms', (args) => {
  // ["/rms", synthID, orbitIndex, peak1, power1, peak2, power2, …]
  const b = Buffer.from(args[0].data);
  const i = b.readInt32BE(20)
  p[i] = b.readFloatBE(24)
})



osc(100,0.01).mult(osc(50,0.001))
  // .pixelate(100)
  .thresh(()=>0.2+p[0]*2)
  .modulateScale(
     solid(5,0.01)
     .pixelate(1)
     .thresh(()=>p[1]*5)
     .rotate(3.14*0.51,0.501)
     .kaleid(1000)
     .modulateScale(noise(()=>p[2]*4))
   ).out()




osc(100,0).mult(osc(19,0).rotate(3.14/2,0.1))
  .scrollY(()=>p[0]*0.7525)
  .pixelate(160,90)
  // .pixelate(11020)
  .thresh(()=>p[2]*0.3+0.8)
  .modulateScale(
     // noise(1,0.11)
     osc(10,0.1).rotate(3.14/2,0.1)
   )
   .contrast(100)
   .out()








noise(3).thresh(()=>p[0]*0.51+0.1).out(o1)

src(o1).diff(src(o1).scrollX(0.01).scrollY(0.01))
.contrast(1)
.scale(()=>p[2]*1+1)
.out()


src(o1).diff(src(o1).scrollX(0.01).scrollY(()=>p[1]*0.2))
.contrast(1)
.scale(()=>p[0]*1+1)
.out()




s0.initCam()


src(s0).thresh().kaleid(8).scale(()=>p[0]*0.2+0.6).out()


src(s0)
// osc(20)
  // .kaleid(()=>4+p[0]*4)
  // .modulateScale(noise(5))
  // .scrollX(1,0.1)
  .modulateScale(
    osc(10,0,10)
    .saturate(()=>p[0]*4)
  )
  .thresh(()=>p[2]*0.7+0.5)
  .kaleid(6)
  .scrollX(1,0.1)
  .scrollY(1,0.1)
  .out()



osc().kaleid(2).thresh(()=>1-p[1]*2.5).modulateScale(noise(5)).scale(()=>p[0]*1+1).out()


noise(5)
.thresh(0.8)
.scale(()=>p[2]*0.15+0.1).rotate(()=>p[4]*2).blend(solid(0,0,1).color(0,0,1),()=>p[0]).out()

osc().out()
dsdsf
src(s0).out()
