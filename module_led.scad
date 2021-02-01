// Creates a led module

/* [Case Dimensions] */

// diameter of the base
base_diameter = 62.8; //[62.8:Small, 80:Medium, 100:Large, 130:XLarge]
// thickness of outer wall
wall_thickness = 2; //[2:0.5:5]
// height of the module
module_height = 20; //[10:5:100]
// enable rim
enable_rim = true;
// rim height
rim_height = 1.2; // [.5: .1: 2]
// led diameter
led_diameter = 5.0;
// enable led on front
led_front = true;
// enable led on back
led_back = false;

/* [Hidden] */

$fn = 128;
base_radius = base_diameter / 2;

use <common.scad>

module led(base_radius, led_height, wall_thickness, enable_rim, led_diameter, led_front, led_back) {
	// outer shell
    difference() {
        shell(base_radius*2, led_height, wall_thickness, false);
        if (led_back)
            translate([base_radius-wall_thickness/2, 0, led_height/2]) rotate([0,90,0]) cylinder(h=wall_thickness*2, d=led_diameter, center=true);
        if (led_front)
            translate([-(base_radius-wall_thickness/2), 0, led_height/2]) rotate([0,90,0]) cylinder(h=wall_thickness*2, d=led_diameter, center=true);
    }

	// male connectors (to module below)
	connectors_male(90, base_radius, wall_thickness);
	connectors_male(270, base_radius, wall_thickness);

	// female connectors (to module above)
	connectors_female(90, base_radius, led_height, wall_thickness);
	connectors_female(270, base_radius, led_height, wall_thickness);

	if (enable_rim) {
		rim(base_radius, led_height, wall_thickness, rim_height);
	}
}

led(base_radius, module_height, wall_thickness, enable_rim, led_diameter, led_front, led_back);
