use <./seashell.scad>

/* TODO */

/*
* magnets
*/

/* params */

$fn=80;
xo=7.5;
yo=6;
zo=-xo;
tol=0.2;
scaling=0.3;
d_axis=1;

/* t measured across the bottom */
tring=3;
dring=56/3.141;

/* the cutout + bridge shape will limit the opening angle */
max_opening_angle=60;


/* ===== Box ===== */

/* ringcradle(); */
/* bridge(); */

/* translate([0,0,25]) rotate([90,0,90]) ring(); */
/* box(0); */
/* box(60); */
/* box(0,90,false); */
/* box(90); */

rotatable_shell(0);
/* rotatable_shell(90); */

/* translate([0,0,-zo]) bridge(); */

module box(angle_a, angle_b=-1,show_b_shell=false){
  rotatable_shell_for_box(angle_a);
  if(show_b_shell==true){
    if(angle_b==-1){
      rotate([0,0,180]) rotatable_shell_for_box(angle_a);
    }else{
      rotate([0,0,180]) rotatable_shell_for_box(angle_b);
    }
  }

  translate([0,0,-zo]) bridge();
  translate([0,0,-3*zo+2]) ringcradle();
}



/* ===== shell ===== */

/* idea: */ 
/* 1. cuts through the rear part of the shell */
/* 2. hull around to solidify */
/* 3. fit into shell as a hinge support */

/* rotatable_shell(0); */
module shell_hinge_fill(){
  rotate([0,90,0])
  translate([-zo,0,0])
  hull(){
    polygon0();
    polygon5(-5);
    polygon5(5);
  }
}


/* shell_cut(0); */
module polygon0(){
  rotate([90,0,180]) linear_extrude(0.1)
  polygon([ [4.2,-4], [8,-5.5], [11,-3], [12,0], [12.5,7] ]);
}

/* shell_cut(5); */
module polygon5(y=0){
  translate([0,y,0]) rotate([90,0,180]) linear_extrude(0.1)
  polygon([ [4.5,7.5], [4.5,5.5], [3.5,3], [3.5,1], [4.2,-1], [6,-3.5], [9,-3.5], [11.25,0], [12,7] ]);
}

module shell_cut(yoffset=0){
  /* hull() */
  intersection(){
    rotatable_shell(0);
    translate([-8,yoffset,0]) cube([10,0.1,15],center=true);
  }
}


/* align with rotation axis */
module rotatable_shell_for_box(angle=0){
  /* alignment for box */
  rotate([0,-90,0])
  translate([0,0,-zo])
  rotatable_shell(angle);
}

module rotatable_shell(angle=0){
  xmag=14;
  ymag=13.5;
  /* everything below has y axis as rotation axis */
  rotate([0,-angle,0])
  difference(){
    union(){
      translate([xo,0,zo]) scale([scaling,scaling,scaling]) shell_easy_print();
      shell_hinge_fill();
      /* magnets */
      translate([xmag,ymag,zo]) magnet();
      translate([xmag,-ymag,zo]) magnet();
    }
    /* cutout for hinge */
    rotate([0,max_opening_angle-45,0])
    translate([-yo/2-tol+0.5,-(yo+2*tol)/2,-20+yo/2+tol]) 
      cube([20,yo+2*tol,20]);
    /* rotation axis through origin */
    #rotate([90,0,0]) cylinder(80,d=d_axis,center=true);

  }
}

/* cut off uneven shell edges */
module shell_easy_print(){
  intersection(){
    shell();
    translate([0,0,50]) cube([400,400,100],center=true);
  }
}

/* #shell_alignment_test(); */

module shell_alignment_test(){
  intersection(){
    shell();
    translate([0,0,-50]) cube([400,400,100],center=true);
  }
}

module shell(simplified=false){
  if(simplified==false){
    translate([0,0,10]) rotate([0,1,0]) half_shell();
  }else{
    translate([-13.5,-25,0]/scaling) cube([47,50,12.5]/scaling);
  }
}

module magnet(){
  difference(){
    union(){
      cylinder(2,d=5.1+1.6);
      translate([0,0,2]) cylinder(2.5,d1=5.1+1.6,d2=1);
    }
    # cylinder(2,d=5.15);
  }
}

/* Bridge */

module bridge(){
  color("blue")
  difference(){
    union(){
      rotate([-90,0,0]) difference(){
        union(){
          hull(){
            cylinder(yo,d=yo,center=true);
            translate([-xo,xo,0]) cylinder(yo,d=yo,center=true);
          }
          hull(){
            cylinder(yo,d=yo,center=true);
            translate([xo,xo,0]) cylinder(yo,d=yo,center=true);
          }
        }
        /* axis */
        #translate([xo,xo,0]) cylinder(80,d=d_axis,center=true);
        #translate([-xo,xo,0]) cylinder(80,d=d_axis,center=true);
      }
      /* shaft */
      difference(){
        cylinder(yo,d=yo);
        cylinder(yo,d=2*(2+tol));
      }
    }
    /* screw M2.5 sliding*/
    translate([0,0,-2]){
      # cylinder(h=8,d=3);
      # translate([0,0,-8]) cylinder(h=8,d=5);
    }
  }
}

module ringcradle(){
  color("orange")
  union(){
    rotate([0,0,90])
    intersection(){
      rotate([90,0,0])
      difference(){
        cylinder(1.8*tring,d=dring+2*tring,center=true);
        /* goove for ring */
        cylinder(tring+2*tol,d=dring+tring,center=true);
        /* cut out middle */
        cylinder(3*tring,d=dring-tring,center=true);
      }
      /* only lower half of circle */
      translate([0,0,-52]) cube(100,center=true);
    }
    /* joint */
    translate([0,0,-dring/2-6.5])
    difference(){
      cylinder(5,d=4);
      translate([0,0,-0.01]) cylinder(4,d=2.5);
    }
  }
}



/* ===== Ring ===== */


module ring(){
  color("gold")
  difference(){
    cylinder(tring,d=dring+tring,center=true);
    cylinder(tring+1,d=dring,center=true);
  }
  translate([0,dring/2+1,0])
  rotate([90,0,0])
  cylinder(3,d=6,center=true);
}
