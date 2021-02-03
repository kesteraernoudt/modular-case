// Unfortunately, customizable parameters have to be in the main file,
// although they are used in the libraries

show_gaps = true;

/* [Case Dimensions] */

// diameter of the base
base_diameter = 52; //[62.8:Small, 80:Medium, 100:Large, 130:XLarge]
// thickness of outer wall
wall_thickness = 2; //[2:0.5:5]
// enable rim
enable_rim = true;
// rim height
rim_height = 1.2; // [.5: .1: 2]

/* [Base Module] */

//type of uC
board = 8; //[0: Custom, 1:Arduino_Nano, 2:Arduino_Mega, 3:Arduino_Uno, 4:Feather_HUZZAH, 5:NodeMCUv2, 6:NodeMCUv3, 7:Raspberry_Pi_ZeroW, 8:WemosD1miniV2]

// width of a PCB (only for Custom)
board_width = 26; //[10:0.1:150]
// length of a PCB  (only for Custom)
board_length = 48; //[10:0.1:150]

/* [Access Port Dimensions (only for Custom)] */

// width of the port hole for e.g. USB access
port_width = 10; //[5:1:50]
// height of the port hole for e.g. USB access
port_height = 6; //[4:1:30]
// position from left edge of board to middle of port
port_ypos = 5; //[0:1:150]
// position from bottom of pcb (negative is below)
port_zpos = 0; //[-25:1:30]

create_base = true;

/* [Empty Module] */

// create an empty module
create_empty = false;

// height of the empty module
empty_height = 30; // [10:1:60]

/* [Led Module] */

// create a led module
create_led = true;
// enable led on front
led_front = true;
// enable led on back
led_back = false;

// height of the led module
led_height = 16; //[12:1:100]

// led diameter
led_diameter = 5;

/* [OLED Module] */
create_oled = true;

// type of display
display = 1; //[0: Custom, 1:OLED 0.96, 2:OLED 1.3]

// width of the display
oled_width = 28; //[10:1:100]
// height of the display
oled_height = 15; //[10:1:100]
// width of the pcb
oled_pcb_width = 29; //[10:1:100]
// height of the pcb
oled_pcb_height = 28; //[10:1:100]
// position of the display (lower edge)
oled_y_position = 6.0;

/* [Sensor Enclosure] */
create_enclosure = true;

// height of the enclosure module
enclosure_module_height = 16; //[16:1:100]
// thickness of outer wall
enclosure_wall_thickness = 1.5; //[2:0.5:5]
// height of the enclosure
enclosure_height = 15; //[12:1:100]
// length of the enclosure
enclosure_length = 40; //[10:1:100]
// width of the enclosure
enclosure_width = 22; //[10:1:100]
// radius of port access
enclosure_port_radius = 4; //[2:1:20]

/* [Dome Cap] */
create_dome_cap = true;

// thickness of dome
cap_dome_thickness = 1.5; //[2:0.5:5]
// height of the dome cap
cap_dome_height = 10; //[10:1:100]
// width of the rest plate
cap_dome_rest_width = 20; //[10:1:80]
// height of the rest plate
cap_dome_rest_height = 2.5; //[1:0.5:10]

/* [Hidden] */

//$fn = 128;
base_radius = base_diameter / 2;
base_color = [1,0.1,0];//"CornflowerBlue";
empty_color = [1,.5,0];
oled_color = [1,.7,0];
led_color = [1,.3,0];
enclosure_color = [1,0,0.5];
//module_color = [0,1,0];//"CornflowerBlue";
cap_color = [1,1,1];//"Snow";

use <base.scad>
use <module_empty.scad>
use <module_oled.scad>
use <module_led.scad>
use <module_enclosure.scad>
use <cap_dome.scad>

gap_height = show_gaps?10:0;
empty_module_start = create_base?base_height()+gap_height:0;
empty_module_height = empty_height;
enclosure_module_start = create_empty?empty_module_start+empty_module_height+gap_height:empty_module_start;
oled_module_start = create_enclosure?enclosure_module_start+enclosure_module_height+gap_height:enclosure_module_start;
oled_module_height = oled_pcb_height + 2*wall_thickness + 1;
led_module_start = create_oled?oled_module_start+oled_module_height+gap_height:oled_module_start;
led_module_height = led_height;
dome_cap_start = create_led?led_module_start+led_module_height+gap_height:led_module_start;

union() {
    if (create_base)
        color(base_color)
            base(base_radius, wall_thickness, board, port_width, port_height, port_ypos, port_zpos);

	if (create_empty)
		translate([0,0,empty_module_start])
			color(empty_color)
				empty(base_radius, empty_height, wall_thickness);

    if (create_enclosure)
		translate([0,0,enclosure_module_start])
			color(enclosure_color)
				sensor_enclosure(enclosure_length, enclosure_width, base_radius, enclosure_module_height, enclosure_height, enclosure_wall_thickness, enclosure_port_radius);

	if (create_oled)
		translate([0,0,oled_module_start])
			color(oled_color)
				oled(base_radius, wall_thickness, display, enable_rim, oled_width, oled_height, oled_pcb_width, oled_pcb_height, oled_y_position);
    
    if (create_led)
		translate([0,0,led_module_start])
			color(led_color)
        led(base_radius, led_module_height, wall_thickness, enable_rim, led_diameter, led_front, led_back);


    if (create_dome_cap)
		translate([0,0,dome_cap_start])
			color(cap_color)
				dome(base_radius, wall_thickness, cap_dome_height, cap_dome_thickness, cap_dome_rest_width, cap_dome_rest_height);
}
