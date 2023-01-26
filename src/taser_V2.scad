//-------------------------------------------------------------------------------------------
//                                          High voltage taser shocker
//
// version 2.0 - M.Grimaldi
//
// this code is delivered under "creative commons licence": CC BY-NC-SA
// This license lets others remix, adapt, and build upon your work non-commercially,
// as long as they credit you and license their new creations under the identical terms.
//-------------------------------------------------------------------------------------------
$fn = 128;
// axis directions
No_axis = -1;
X_axis = 0;
Y_axis = 1;
Z_axis = 2;
// electrodes
electrode_diam=3;
electrode_spacing=12;
electrode_angle=60;
electrode_length = 11;
electrode_shift = 20;
// battery
battery_length=67;
battery_diam=18.4;
// high voltage module
hv_length=63;
hv_diam=24.5;
// battery contact (Upholsterer's point))
battery_contact_diam = 4;
battery_contact_height=4;
// usb charger
charger_dim =[17,2, 28];
// mechanical clearance
clearance = 0.2;    
// high lid
high_lid_inclusion = 10;
// low lid
low_lid_inclusion = 10;
// high spacer
high_spacer_height = 3;
// main body 
package_thickness = 4;
package_int_size = [hv_diam+battery_diam+5*package_thickness, 
                    hv_diam+2*package_thickness, 
                    battery_length+high_lid_inclusion+low_lid_inclusion+high_spacer_height+2];
package_boss_diam = 5; 
// position inside main body
battery_X_pos = package_int_size[X_axis]/2-package_thickness/2-battery_diam/2;
hv_X_pos = -package_int_size[X_axis]/2+package_thickness/2+hv_diam/2;
charger_X_pos = 5;

echo(package_int_size);
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//                                  GENERIC ELEMENTS
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------
//              Battery
// h & d = dimensions
// footprint = external enveloppe for 3D volumic subtract
module battery(h=67, d=18.4, footprint=false){
if (footprint){
union(){
    cylinder(h=h+5, d=d+1, center=false);
    translate([-(d+1)/2,0,0])cube([d+1, 100, h+5]);
    }
}
else
    union(){
    cylinder(h=h-1, d=d, center=false);
    translate([0,0,0])cylinder(h=h, d=5, center=false);
    }
}

//-------------------------------------------------------------------------------------
//              usb charger
// dim = [x,y,z] dimensions
// footprint = external enveloppe for 3D volumic subtract
module charger(dim = charger_dim, footprint=false){
if (footprint)translate([0,0,-dim[Z_axis]/2+5])
            union(){
                    cube(dim+[2,2,0],center=true);
                    translate([0,1,12])cube([7.5,3.5,6]+[1,1,0],center=true); // USB con
                    }
                    
else translate([0,0,-dim[Z_axis]/2+5])
            union(){
                    color("blue")cube(dim,center=true);
                    color("white")translate([0,1,12])cube([7.5,3.5,6],center=true); // USB con
                    }
}

//-------------------------------------------------------------------------------------
//              flash button
// footprint = external enveloppe for 3D volumic subtract
module button(footprint=false){
if (!footprint){    
    translate([0,0,-8])
        union(){
            color("white"){ cylinder(h=7, d=7);
            translate([0,0,7])cylinder(h=1, d=10);
            translate([0,0,10])cylinder(h=2, d=11, $fn=6);
            translate([0,0,8])cylinder(h=7, d=7);
            }
        color("red")translate([0,0,7+2])cylinder(h=13, d=6);
        translate([-1.5,0,0])cube([0.5,2,6], center=true);
        translate([+1.5,0,0])cube([0.5,2,6], center=true);
        }
    }
else  cylinder(h=20, d=7+2*clearance, center=true);   
}

//-------------------------------------------------------------------------------------
//              High voltage module
// length & d = dimensions
// footprint = external enveloppe for 3D volumic subtract
module HV(length=63, d=24.5, footprint=false){
rotate([0,0,-90]){
    if (!footprint){
            color("black")difference(){
            cylinder(h=length, d=d, center=false);
            translate([-15,10,-10])cube([30,30, 2*length]);
            }
        }
    else {
        difference(){
            cylinder(h=length+1, d=d+1, length=false);
            translate([-15,10,-10])cube([30,30, 2*length+1]);
            }
        }
    }
}

//-------------------------------------------------------------------------------------
//              ON/OFF switch
module on_off_switch(){
translate([-3.3,0,0])
    union(){
        color("black"){
        cube([8,8,12], center=true);
        translate([4,0,0])cube([1.5,10.5,15.5], center=true);
        }
    translate([-4,0,0])cube([7.5,4,0.5], center=true);
    translate([-4,0,-5])cube([7.5,4,0.5], center=true);
    color("red")translate([3,0,0])rotate([0,10,0])cube([6,6.5,10], center=true);
    }
}

//-------------------------------------------------------------------------------------
//              Electrodes
//  alfa = electrode angle,
//  spacing = electrode_spacing, 
//  h = electrode length, 
//  d=electrode diametre, 
//  deb=electrode Z shift
module electrodes(alfa=electrode_angle, spacing=electrode_spacing, h=electrode_length, d=electrode_diam, deb=electrode_shift){
for (i=[-1,1])union(){
    // the wire holes
    translate([i*h*cos((180-alfa)/2)+i*spacing/2,0,-deb+d/2*sin(alfa)])cylinder(h=deb, d=d, center=false);
    // the electrodes
    translate([i*h*cos((180-alfa)/2)+i*spacing/2,0,0])
    rotate([0,-i*alfa/2,0])union(){
        cylinder(h=h-3, d=d, center=false);
        translate([0,0,h-3])cylinder(h=d, r1=d/2+0.5, r2=0, center=false);
        }
    }
}

//-------------------------------------------------------------------------------------
//              battery contact (Upholsterer's point)
//  d & h = dimensions
module battery_contact(d = battery_contact_diam, h=battery_contact_height){
translate([0,0,h-d])
union(){
    difference(){
        sphere(d=2*d);
        translate([0,0,-5+d/2])cube([10,10,10], center=true);
        }
    translate([0,0,-10+d/2])cylinder(h=10, d=1);
    }
}

//------------------------------------------------------------------------------------------
//  parametric box
//  dim_int = [x,y,z] interior box
//  ep = box thickness
//  aperture_axis = axis direction of the opening
//  lid = lid or body of the box,
//  boss_diam = 4 bosses diameter,
//  full = box is full (no interior),
//  rounded = rounded corners
module box( dim_int = package_int_size,
            ep = package_thickness,
            aperture_axis=Z_axis,
            lid=false,
            boss_diam=package_boss_diam,
            full=false,
            rounded=true){
dim = dim_int+[ep,ep,ep];       // external dim
dim_bos = dim_int-[boss_diam,boss_diam,boss_diam];

translate([lid && aperture_axis==X_axis ? -dim_int[X_axis]/2 : 0, lid && aperture_axis==Y_axis ? -dim_int[Y_axis]/2 : 0, lid && aperture_axis==Z_axis ? -dim_int[Z_axis]/2 : 0])    
    difference(){
    // the main body
    union(){
        cube(dim, center=true);
        // rounded corners
        if (rounded){
            for (x=[-1, +1])
                for (z=[-1,+1]){
                    // flasque coté
                    translate([x*dim[X_axis]/2,0,0])scale([0.1,1,1])
                    cylinder(h=z*dim[Z_axis],d=dim[Y_axis], center=true);
                    // flasque haut/bas
                    translate([0,0,z*dim[Z_axis]/2])rotate([0,90,0])scale([0.1,1,1])
                    cylinder(h=dim[X_axis],d=dim[Y_axis], center=true);
                    //    coin haut gauche
                    translate([x*dim[X_axis]/2,0,z*dim[Z_axis]/2])scale([0.1,1,0.1])sphere(d=dim[Y_axis]);
                    }
            }
        }   // union of main body

    // bosses - interior
    if (!full){
        difference(){
            if (!lid)cube(dim_int, center=true);
            for (i=[-1,1])
                for (j=[1, -1])
                translate([
                            aperture_axis==X_axis ? 0 : (aperture_axis==(X_axis+1)%3 ?-dim_bos[X_axis]/2*i*j : i*dim_bos[X_axis]/2),
                            aperture_axis==Y_axis ? 0 : (aperture_axis==(Y_axis+1)%3 ?-dim_bos[Y_axis]/2*i*j : i*dim_bos[Y_axis]/2),
                            aperture_axis==Z_axis ? 0 : (aperture_axis==(Z_axis+1)%3 ?-dim_bos[Z_axis]/2*i*j : i*dim_bos[Z_axis]/2)])
                                rotate([(aperture_axis==Y_axis ? 90 :0),(aperture_axis==X_axis ? 90 : 0),0])cube([boss_diam+0.1, boss_diam+0.1, dim_int[aperture_axis]], center=true);
            }
        }
    // -----> 4 boss holes
    for (i=[-1,1])
        for (j=[1, -1])
        translate([
                aperture_axis==X_axis ? 0 : (aperture_axis==(X_axis+1)%3 ?-dim_bos[X_axis]/2*i*j : i*dim_bos[X_axis]/2),
                aperture_axis==Y_axis ? 0 : (aperture_axis==(Y_axis+1)%3 ?-dim_bos[Y_axis]/2*i*j : i*dim_bos[Y_axis]/2),
                aperture_axis==Z_axis ? 0 : (aperture_axis==(Z_axis+1)%3 ?-dim_bos[Z_axis]/2*i*j : i*dim_bos[Z_axis]/2)])
                    rotate([(aperture_axis==Y_axis ? 90 :0),(aperture_axis==X_axis ? 90 : 0),0])cylinder(h=dim_int[aperture_axis], d=boss_diam/2, center=true);
    //  -----> box aperture
    if (aperture_axis==X_axis){
        translate([lid ? -100+dim_int[X_axis]/2 : 100+dim_int[X_axis]/2,0,0])cube([200, 2*dim[Y_axis], 2*dim[Z_axis]], center=true);
        }
    if (aperture_axis==Y_axis){
        translate([0,lid ? -100+dim_int[Y_axis]/2 : 100+dim_int[Y_axis]/2,0])cube([2*dim[X_axis], 200, 2*dim[Z_axis]], center=true);
        }
    if (aperture_axis==Z_axis){
        translate([0,0,lid ? -100+dim_int[Z_axis]/2 : 100+dim_int[Z_axis]/2])cube([2*dim[Z_axis], 2*dim[Z_axis],200], center=true);
        }
    }
}

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//                                 TASER CUSTOM ELEMENTS
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
module high_lid(){
dim_bos = package_int_size-[package_boss_diam,package_boss_diam,package_boss_diam];    
difference(){    
    union(){
        // basic cover box
        box(aperture_axis=Z_axis, lid=true);
        // rounded up cover
        translate([0,0,package_thickness])scale([1,1,0.2])rotate([0,90,90])cylinder(d=0.7*package_int_size[X_axis], h=0.7*package_int_size[Y_axis], center=true);
        // inclusion
        translate([0,0,-high_lid_inclusion/2])cube([package_int_size[X_axis]-clearance, package_int_size[Y_axis]-clearance, high_lid_inclusion], center=true);
    }
    // 4 holes   
  for (i=[-1, +1])
     for (j=[-1,+1])
           translate([i*dim_bos[X_axis]/2,-dim_bos[Y_axis]/2*i*j, 0])
     cylinder(h=package_int_size[Z_axis], d=package_boss_diam/2, center=true);
    // electrodes holes
    translate([0,0,package_thickness])electrodes();
     // inclusion
     translate([0,0,-high_lid_inclusion/2-4])cube([package_int_size[X_axis]*0.8, package_int_size[Y_axis]*0.8, high_lid_inclusion], center=true);
    }    
}

//-------------------------------------------------------------------------------------
module main_body(){ 
zshift = 10;    // z shift to be sure to open the holes  
difference(){
    //main box
    translate([0, 0, 0])box(dim_int = package_int_size, aperture_axis=Z_axis, full=true, rounded=true);
    // HV module hole
    translate([hv_X_pos,0,-58])scale([1.05,1.05,4])HV();
    // battery hole
    translate([battery_X_pos,0,100])rotate([180,0,0])scale([1.05,1.05,4])battery();
    // wire path hole
    translate([3,0,0])cube([10,package_int_size[Y_axis],500], center=true);
    // charger hole
     translate([charger_X_pos,0,-package_int_size[Z_axis]/2])rotate([180,0,90])scale([1,1,5])charger(footprint=true);
    // button hole
    translate([3,-package_int_size[Y_axis]/2,package_int_size[Z_axis]/4])rotate([90,0,0])button(true);
    // high lid hole
    translate([0,0,(package_int_size[Z_axis]-high_lid_inclusion-high_spacer_height+zshift)/2-clearance])cube([package_int_size[X_axis], package_int_size[Y_axis], high_lid_inclusion+high_spacer_height+clearance+zshift], center=true);
    // low lid hole
    translate([0,0,-(package_int_size[Z_axis]-low_lid_inclusion+zshift)/2])cube([package_int_size[X_axis], package_int_size[Y_axis], low_lid_inclusion+zshift], center=true);
 }
}

//-------------------------------------------------------------------------------------
module low_lid(){
dim_bos = package_int_size-[package_boss_diam,package_boss_diam,package_boss_diam];    
difference(){
    union(){
        rotate([0,180,0])box(aperture_axis=Z_axis, lid=true);        
    translate([0,0,low_lid_inclusion/2])cube([package_int_size[X_axis]-clearance, package_int_size[Y_axis]-clearance, low_lid_inclusion], center=true);
    }   
      // 4 holes   
  for (i=[-1, +1])
     for (j=[-1,+1])
           translate([i*dim_bos[X_axis]/2,-dim_bos[Y_axis]/2*i*j, 0])cylinder(h=package_int_size[Z_axis], d=package_boss_diam/2, center=true); 
     // on/off switch
     translate([-10,0,0]){
        cube([10,14,200], center=true);
        translate([0,0,-100])cube([20,30,200], center=true);
         }     
     // battery plot
     translate([battery_X_pos,0,low_lid_inclusion])cylinder(h=3,r=2, center=true);    
     // charger
     translate([charger_X_pos,0,2])rotate([180,0,90])charger(footprint=true);  
     // wire path
     translate([0,0,low_lid_inclusion])cylinder(h=5, r=package_int_size[Y_axis]*0.4, center=true);
     translate([battery_X_pos/2-2,0,low_lid_inclusion])cube([battery_X_pos,2,2], center=true);    
    }
}

//-------------------------------------------------------------------------------------
module high_spacer(height = high_spacer_height){
dim_bos = package_int_size-[package_boss_diam,package_boss_diam,package_boss_diam];    
union(){
     difference(){   
     cube([package_int_size[X_axis]-clearance, package_int_size[Y_axis]-clearance, height], center=true);
      // 4 holes   
      for (i=[-1, +1])
         for (j=[-1,+1])
               translate([i*dim_bos[X_axis]/2,-dim_bos[Y_axis]/2*i*j, 0])cylinder(h=package_int_size[Z_axis]/2, d=package_boss_diam/2, center=true); 
        // HV module hole
        translate([hv_X_pos,0,-58])scale([1.05,1.05,4])HV();
        // wire hole
        translate([3,10,0])cylinder(h=200, d=10, center=true); 
        translate([battery_X_pos,4,0])cylinder(h=30,r=1.5, center=true);
        }
        // battery plot
        translate([battery_X_pos,0,-2])cylinder(h=height,r2=2, r1=1.5, center=true);
    } 
}



//*****************************************************************************
//                              main script code
//*****************************************************************************
//difference(){
     %main_body();
    //translate([0,100,0])cube([200,200,200], center=true);
//}

translate([0,0, package_int_size[Z_axis]/2])color("red")high_lid();
//
translate([3,-package_int_size[Y_axis]/2,package_int_size[Z_axis]/4])rotate([90,0,0])button(false);
//
translate([0,0, package_int_size[Z_axis]/2-high_lid_inclusion-2])high_spacer();
//
color("green")translate([battery_X_pos,0, package_int_size[Z_axis]/2-battery_length/2+19])rotate([180,0,0])battery();
//
translate([hv_X_pos,0,-32])HV();
//
translate([-10,0,-package_int_size[Z_axis]/2])rotate([0,90,90])on_off_switch();
translate([0,0,-package_int_size[Z_axis]/2 ]){
   low_lid();
    translate([charger_X_pos,0,2])rotate([180,0,90])charger(footprint=false);    
    }
color("white")translate([0,0,package_int_size[Z_axis]/2+package_thickness])electrodes();
