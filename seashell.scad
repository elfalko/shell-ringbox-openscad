$fn=10;
/* seashell(life=50,0,$fn=80); */
//hulled_cylinders(r=1, h=.001, $fn=32);
//shell(age=32, $fn=32);

//Rotation, translation, and scaling vectors
kr=.6;
vr=kr*[
  0,
  15,
  0
];

kt=.3;
vt=kt*[
  -0.5,
  0.0, /* side shift, should be 0 */
  -0.5
];

ks=1.00;
vs=ks*[
  1.1125,
  1.065,
  1
];

grow_shell(0);
#grow_shell(30);

module baseshape(){
  spread=160;
  step=10;
  kerneltilt=135+10;
  hk=2;
  hw=sin(kerneltilt-90)*hk;

  tk=1;
  wk=5;

  ox=4;

  translate([ox,0,0]){
    for(ribrot=[-spread:10:spread]){
        rotate([0,0,ribrot]) basekernel(kerneltilt,hk,tk,wk);
    }
    /* hull(){ */
    /*     rotate([0,0,spread+0.95*step]) basekernel(kerneltilt,hk,tk/4,wk); */
    /*     translate([-ox-0.5,0,0]) cylinder(hk/4,d=tk/4); */
    /* } */      
    /* hull(){ */
    /*     rotate([0,0,-(spread+0.95*step)]) basekernel(kerneltilt,hk,tk/4,wk); */
    /*     translate([-ox-0.5,0,0]) cylinder(hk/4,d=tk/4); */
    /* } */      
  }
}

module basekernel(kerneltilt,hk,tk,wk){
  translate([5,0,0]) rotate([0,kerneltilt,0])
    difference(){
      cylinder(h=hk,d=2*tk,center=true);
      translate([wk,0,0]) cube(10,center=true);
    }
}


module grow_shell(max=30){
  for(a=[0:max]){
     echo("step: ",a);
     segment_transform(a) {baseshape();};
  }
}

/* creates donut from both structures */
module shell() {
  /* difference() { */
  /*   hulled_cylinders(r=1, h=.00001); */
  /*   hulled_cylinders(r=.9, h=.0001); */
  /* } */
  hulled_cylinders(r=1, h=.00001);
}

/* creates two cylinders, slightly translated and rotated against each other */
module hulled_cylinders(r, h) {
  hull() {
    cylinder(r=r, h=h, center=true);
    scale(vs)
      translate(vt)
        rotate(vr)
          cylinder(r=r, h=h, center=true);
  }
}

module segment_transform(iteration){
   if (iteration == 0){
     children();
   }else{
     scale(vs) translate(vt) rotate(vr) segment_transform(iteration-1){
       children();
     };
   }
}
