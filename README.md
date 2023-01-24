#Electric Shocker

Electric shock weapons are an increasingly popular form of non lethal self defense. Due to their accessibility and reliability, they are used worldwide by both the police force and average civilians.

The project involves the design and creation of a portable device that can deliver a strong electrical shock for self defense purposes. 

![device](images/device.png)

**The device includes :**
a rechargeable 18650 Lithium-Ion battery, 3.7V, 2200mAh
![battery](images/battery.png)
a battery charging circuit
![charger](images/charger.png)
a DC 3V-6V bis 400kV Boost Step up Power Module High Voltage Generator
![HVM](images/high_voltage.png)
an on/off switch and an activation button.
![switchs](images/switchs.png)


**The mechanical housing consists of 4 parts :**
the main body containning the battery and the high voltage module
![main](images/main.png)
the top cover on which the electrodes are positioned
![top](images/top.png)
the bottom cover on which are positionned the ON/OFF switch and the usb battery charger
![bottom](images/bottom.png)
a spacer. 
![sparce](images/spacer.png)

It is designed as a full parametric 3D model under [OpenSCAD](https://openscad.org).

You can tune the model adjusting the dimensions of:
- the electrodes
	- electrode_diam=3;
	- electrode_spacing=12;
	- electrode_angle=60;
	- electrode_length = 11;
	- electrode_shift = 20;
- the battery
	- battery_length=67;
	- battery_diam=18.4;
- the high voltage module
	- hv_length=63;
	- hv_diam=24.5;
- the battery contact (Upholsterer's point))
	- battery_contact_diam = 4;
	- battery_contact_height=4;
- the usb charger
	- charger_dim =[17,2, 28];
- the mechanical clearance
	- clearance = 0.2;    
- the high lid
	- high_lid_inclusion = 10;
- the low lid
	- low_lid_inclusion = 10;
- the spacer
	- high_spacer_height = 3;
- the main body 
	- package_thickness = 4;
	- package_int_size = [hv_diam+battery_diam+5*package_thickness, 
						hv_diam+2*package_thickness, 
						battery_length+high_lid_inclusion+low_lid_inclusion+high_spacer_height+2];
	- package_boss_diam = 5; 
- the positions inside main body
	- battery_X_pos = package_int_size[X_axis]/2-package_thickness/2-battery_diam/2;
	- hv_X_pos = -package_int_size[X_axis]/2+package_thickness/2+hv_diam/2;
	- charger_X_pos = 5;
 
The electrical design includes the integration of all components and the implementation of safety features to prevent accidental discharge. 

The goal of this project is to create a practical and easy-to-use self defense tool that can provide a strong electrical shock to an attacker.


     
