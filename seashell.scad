half_shell();

/* $fn=8; */
module half_shell(){
  scale([1.2,1,0.6])
  grow_shell(42);
}

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
  1.108,
  1.065,
  1
];

/* grow_shell(0); */


module baseshape(){
  spread=165;
  step=15;
  kerneltilt=135+12.5;
  hk=2;
  hw=sin(kerneltilt-90)*hk;

  tk=1;
  wk=5;

  ox=4;

  translate([ox,0,0]){
    for(ribrot=[-spread:step:spread]){
        rotate([0,0,ribrot]) basekernel(kerneltilt,hk,tk,wk);
    }
  }
}

module basekernel(kerneltilt,hk,tk,wk){
  translate([5,0,0]) rotate([0,kerneltilt,0])
    difference(){
      scale([0.6,1,1]) 
      cylinder(h=hk,d=2*tk,center=true);
      translate([wk,0,0]) cube(10,center=true);
    }
}


module grow_shell(max=30){
  union(){
  for(a=[0:max]){
     echo("step: ",a);
     segment_transform(a) {baseshape();};
  }
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
