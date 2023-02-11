//-------------------------------------------------------------------------------------------
//                                          High voltage taser shocker
//    cylindrical box
//
// version 1.0 - M.Grimaldi
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
// electrodes
electrode_diam=3;
electrode_spacing=10;
electrode_angle=120;
electrode_length = 11;
electrode_shift = 10;
// housing_pipe 
pipe_ext_diam = 32;
pipe_int_diam = 28;
pipe_length = 210-12;
// battery
battery_length=67;
battery_diam=18.4;
// High voltage module
hv_length=63;
hv_diam=24.5;
// high battery housing
battery_housing_thickness = (pipe_int_diam-battery_diam)/2;
battery_lid_thickness=battery_diam;  // bouchon de batterie
battery_housing_length=battery_length+battery_diam;
// HV module housing
hv_housing_thickness = (pipe_int_diam-hv_diam)/2;
hv_housing_length=hv_length;
// battery contact (Upholsterer's point)
contact_diam = 4;      // visible diameter
contact_height=4;     // spherical part height
// switch and charger lid
switch_lid_length=45;
// charger
charger_width=17;
charger_length=28;
charger_thickness=2;

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
        translate([0,0,h-3])cylinder(h=d, r1=d/2, r2=0, center=false);
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

//-------------------------------------------------------------------------------------
//              housing pipe
module housing_pipe(){
    difference(){
    cylinder(h=pipe_length, d=pipe_ext_diam);
    translate([0,0,-1])cylinder(h=pipe_length+2, d = pipe_int_diam);
    }
}

//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------
//                                 TASER CUSTOM ELEMENTS
//-------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------

module switch_lid(d=pipe_int_diam-1, l=switch_lid_length, dec=8, other_components=true) {   // fond
    dec_interX = -2;     // switch shift along X axis
    dec_chargeurX = 5;   // charger shift along X axis
    XY_thickness = 1.5;  // thickness residu
    color([0.8,0.8,0.8])
    difference(){
        translate([0,0,-0])cylinder(h=l,d=d);   // initial cylinder
        translate([0,0,-30+dec])cylinder(h=30,d=pipe_int_diam-2*XY_thickness); //shift switch & charger usb
        // switch hole
        translate([dec_interX,0,+dec/2])cube([10,14,200], center=true);     
        // charger hole
        translate([dec_chargeurX-1,-(charger_width+1)/2,dec+2])cube([20,charger_width+1,60]);   // emplacement
        translate([dec_chargeurX+1.5,0,2])cube([4.5,8,60],center=true); // connecteur USB
       translate([dec_chargeurX-1,-(charger_width+1)/2,dec+1])cube([charger_thickness+1.5,charger_width+1,60]);
       // just to minimize matter
       translate([-l,0, l+dec])rotate([90,0,0])cylinder(h=d, d=2*l, center=true); 
        //wire path hole
       translate([0,0,l])rotate([0,90,0])cylinder(h=d, d=d/2, center=true);         
        }
if (other_components){
translate([dec_interX,0,dec])rotate([0,90,90])on_off_switch();
translate([dec_chargeurX,0,dec+2])rotate([0,180,180])charger();
}
}

module battery_housing(l = battery_housing_length, ep = battery_housing_thickness){
    //projection(cut=true)translate([0,0,-20])
    color([0.8,0.5,0.8])
    difference(){
    cylinder(h=l, d=pipe_int_diam-1); //base
    translate([0,0,ep])cylinder(h=l, d=battery_diam+1); // hole
    translate([0,0,l])cylinder(h=2*l, d=1.5, center=true);    // contact holes
    translate([battery_diam/2+ep/2,0,0])cube([2*ep,5,500], center=true);
    translate([-battery_diam/2-ep/2,0,0])cube([2*ep,5,500], center=true);
    }   
}

module hv_housing(l = hv_housing_length, ep = hv_housing_thickness){
    //projection(cut=true)translate([0,0,-20])
    difference(){
    cylinder(h=l, d=pipe_int_diam-2*clearance); //base
    translate([0,0,-5*clearance])cylinder(h=l+10*clearance, d=hv_diam+2*clearance); // hole
    }   
}

module battery_lid(h=battery_housing_length-2*contact_height-battery_housing_thickness-battery_length, ep=battery_housing_thickness){
    difference(){
        union(){
        cylinder(h=h+1, d=battery_diam+1);
        translate([0,0,h])cylinder(h=2, d=pipe_int_diam-1);
    }
    translate([battery_diam/2+ep/2,0,0])cube([2*ep,5,500], center=true);
    translate([-battery_diam/2-ep/2,0,0])cube([2*ep,5,500], center=true);
    cylinder(h=500, d=1.5, center=true);    // contact holes
    translate([0,0,h-5])cylinder(h=h, d=pipe_int_diam/2);
    }
}

module electrode_lid(autres=true){
    difference(){
            union(){
            translate([0,0,5])cylinder(h=5, d=pipe_ext_diam+2);
            cylinder(h=10, d=pipe_int_diam-1);
            translate([0,0,10])scale([1,0.3,0.3])sphere(d=pipe_int_diam);    
            }
        translate([0,50+pipe_ext_diam/2,0])cube([100,100,100],center=true);
        translate([0,-50-pipe_ext_diam/2,0])cube([100,100,100],center=true);
        translate([0,0,7])electrodes(alfa=55, ecart=10, h=electrode_length, d=electrode_diam, deb=electrode_shift);
    }
    if (autres)
   translate([0,0,7])color("red")electrodes(alfa=55, ecart=10, h=electrode_length, d=electrode_diam, deb=20);
    }

//*****************************************************************************
//                              main script code
//*****************************************************************************
%housing_pipe();

translate([0,0,battery_housing_length+switch_lid_length])HV();
    
translate([0,0,switch_lid_length+battery_housing_length])
        hv_housing();    
    
translate([0,0,switch_lid_length])battery_housing();
//    
color("green")translate([0,0,battery_housing_thickness+contact_height+switch_lid_length])battery();
//    
translate([0,0,battery_housing_thickness+switch_lid_length])battery_contact();
//    
translate([0,0,battery_housing_thickness+2*contact_height+battery_length+switch_lid_length])rotate([180,0,0])battery_contact();
//    
translate([-pipe_int_diam/2,0,switch_lid_length-5])rotate([0,-90,0])button();
//    
translate([0,0,battery_housing_thickness+2*contact_height+battery_length+switch_lid_length])battery_lid();
//
translate([0,0,0])switch_lid(other_components=false);
//
translate([0,0,battery_housing_length+switch_lid_length+63])electrode_lid(other_components=true);
//    
translate([5,0,15])rotate([180,0,90])charger();    
