$fn=10;
/* seashell(life=50,0,$fn=80); */
//hulled_cylinders(r=1, h=.001, $fn=32);
//shell(age=32, $fn=32);

//Rotation, translation, and scaling vectors
kr=.6;
vr=kr*[
  0,
  20,
  0
];

kt=.3;
vt=kt*[
  0,
  0.0, /* side shift, should be 0 */
  0
];

ks=1.00;
vs=ks*[
  1.1,
  1,
  1
];

module baseshape(){
  /* translate([5,0,0]) cylinder(h=1,d=10); */
  edges=80;
  for(ribrot=[-edges:10:edges]){
    /* echo("rib=",ribrot); */
    rotate([0,0,ribrot]) 
    translate([5,0,0])
    rotate([0,45,0])
    cylinder(h=1,d=1);
  }
}

grow_shell();

module grow_shell(){
  for(a=[0:30]){
     echo("step: ",a);
     segment_transform(a) {baseshape();};
  }
}

/* one age step */
module seashell(age=0,life=30) {
  echo(str("age=", age));
  if(age < life) {
   scale(vs)
    translate(vt)
      rotate(vr)
        seashell(age=age+1);
  }else{
    shell();
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
