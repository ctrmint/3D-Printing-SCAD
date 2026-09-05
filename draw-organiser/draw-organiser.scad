// Roller Cab Drawer Separator
// Outer size: 205 mm x 150 mm
// Depth: 50 mm
// Open top and bottom
// Two alignment pins on one LONG side
// Two matching receiving holes on opposite LONG side
// Units: mm

$fn = 64;

// ---------- MAIN PARAMETERS ----------
outer_length = 205;
outer_width  = 150;
height = 50;

wall_thickness = 2;
corner_radius = 4;


// ---------- ALIGNMENT PIN PARAMETERS ----------
pin_diameter = 6;
pin_length = 3;

// Distance of pins/holes from each end of the 205 mm side
pin_end_offset = 40;

// Vertical centre of pins/holes
pin_height = height / 2;


// ---------- RECEIVING HOLE PARAMETERS ----------
hole_diameter = 6;    // exact match to pin diameter
hole_depth = wall_thickness + 1;


// ---------- ROUNDED FRAME WITH RECEIVING HOLES ----------
module separator_frame() {

    difference() {

        // Main hollow frame
        difference() {

            // Outer rounded frame
            linear_extrude(height = height)
                offset(r = corner_radius)
                    square([
                        outer_length - (corner_radius * 2),
                        outer_width  - (corner_radius * 2)
                    ], center = true);

            // Hollow centre
            translate([0, 0, -1])
                linear_extrude(height = height + 2)
                    offset(r = max(corner_radius - wall_thickness, 0.1))
                        square([
                            outer_length
                                - (wall_thickness * 2)
                                - ((corner_radius - wall_thickness) * 2),

                            outer_width
                                - (wall_thickness * 2)
                                - ((corner_radius - wall_thickness) * 2)
                        ], center = true);
        }

        // Receiving hole 1
        receiving_hole(
            -(outer_length / 2 - pin_end_offset)
        );

        // Receiving hole 2
        receiving_hole(
            outer_length / 2 - pin_end_offset
        );
    }
}


// ---------- ALIGNMENT PIN ----------
module alignment_pin(x_position) {

    translate([
        x_position,
        outer_width / 2 - 0.5,
        pin_height
    ])

        rotate([-90, 0, 0])

            cylinder(
                d = pin_diameter,
                h = pin_length + 0.5
            );
}


// ---------- RECEIVING HOLE ----------
module receiving_hole(x_position) {

    translate([
        x_position,
        -(outer_width / 2) - 0.5,
        pin_height
    ])

        rotate([-90, 0, 0])

            cylinder(
                d = hole_diameter,
                h = hole_depth
            );
}


// ---------- COMPLETE MODEL ----------
union() {

    separator_frame();

    // Left pin
    alignment_pin(
        -(outer_length / 2 - pin_end_offset)
    );

    // Right pin
    alignment_pin(
        outer_length / 2 - pin_end_offset
    );
}
// ---------- ALIGNMENT PIN ----------
module alignment_pin(x_position) {

    translate([
        x_position,
        outer_width / 2 - 0.5,
        pin_height
    ])

        rotate([-90, 0, 0])

            cylinder(
                d = pin_diameter,
                h = pin_length + 0.5
            );
}


// ---------- COMPLETE MODEL ----------
union() {

    separator_frame();

    // Left pin on long side
    alignment_pin(
        -(outer_length / 2 - pin_end_offset)
    );

    // Right pin on long side
    alignment_pin(
        outer_length / 2 - pin_end_offset
    );
}
