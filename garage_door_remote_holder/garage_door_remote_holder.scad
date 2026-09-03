//
// GARAGE DOOR REMOTE WALL HOLDER
// All dimensions in millimetres
//
// SPDX-FileCopyrightText: ctrmint
// SPDX-License-Identifier: CC-BY-SA-4.0
// Source: https://github.com/ctrmint/3D-Printing-SCAD
// Modify and share freely; credit the original and licence derivatives CC BY-SA 4.0.

$fn = 64;


// ============================================================
// INTERNAL HOLDER DIMENSIONS
// ============================================================

inside_width  = 50;
inside_height = 100;
inside_depth  = 20;


// ============================================================
// WALL THICKNESSES
// ============================================================

side_wall   = 1.5;
front_wall  = 1.5;
rear_wall   = 2.0;
bottom_wall = 1.5;


// Height of front retaining plate
front_height = 50;


// ============================================================
// ROUNDING
// ============================================================

outer_radius = 1.2;

inner_radius = 3;

// Large curves where front plate
// meets the side walls
front_top_radius = 5;


// ============================================================
// FRONT ACCESS CHANNEL
// ============================================================

// Straight channel width
channel_width = 12;

// Radius of rounded bottom
channel_radius = channel_width / 2;

// Radius of curved entry at top
channel_top_radius = 3;


// ============================================================
// REAR MOUNTING HOLES
// ============================================================

screw_hole_d = 4;

screw_head_d = 8;

countersink_depth =
    (screw_head_d - screw_hole_d) / 2;


// ============================================================
// DERIVED DIMENSIONS
// ============================================================

outer_width =
    inside_width +
    (2 * side_wall);

outer_depth =
    rear_wall +
    inside_depth +
    front_wall;

outer_height =
    inside_height +
    bottom_wall;

centre_x =
    outer_width / 2;


// ============================================================
// SCREW POSITIONS
// ============================================================

lower_hole_z = 20;

upper_hole_z =
    outer_height - 20;


// ============================================================
// GENERAL ROUNDED BOX
// ============================================================

module rounded_box(size=[10,10,10], r=1) {

    x = size[0];
    y = size[1];
    z = size[2];

    hull() {

        for (xx = [r, x-r])
        for (yy = [r, y-r])
        for (zz = [r, z-r])

            translate([
                xx,
                yy,
                zz
            ])

            sphere(r=r);
    }
}


// ============================================================
// MAIN OUTER BODY
// ============================================================

module outer_body() {

    rounded_box(
        [
            outer_width,
            outer_depth,
            outer_height
        ],
        outer_radius
    );
}


// ============================================================
// INTERNAL CAVITY
// ============================================================

module inner_cavity() {

    translate([
        side_wall,
        rear_wall,
        bottom_wall
    ])

    rounded_box(
        [
            inside_width,
            inside_depth,
            inside_height + 10
        ],
        inner_radius
    );
}


// ============================================================
// UPPER FRONT OPENING
// ============================================================
//
// Creates the 50 mm high front plate
// and the large rounded transitions
// into the side walls.
//

module upper_front_opening() {

    front_y =
        rear_wall +
        inside_depth;

    r =
        front_top_radius;

    cut_depth =
        front_wall + 3;


    union() {

        // Main upper opening
        translate([
            side_wall,
            front_y - 1,
            front_height + r
        ])

        cube([
            inside_width,
            cut_depth,
            outer_height
        ]);


        // Centre lower portion
        translate([
            side_wall + r,
            front_y - 1,
            front_height
        ])

        cube([
            inside_width - (2 * r),
            cut_depth,
            r + 1
        ]);


        // Left rounded side transition
        translate([
            side_wall + r,
            front_y - 1,
            front_height + r
        ])

        rotate([-90,0,0])

        cylinder(
            h = cut_depth,
            r = r
        );


        // Right rounded side transition
        translate([
            side_wall + inside_width - r,
            front_y - 1,
            front_height + r
        ])

        rotate([-90,0,0])

        cylinder(
            h = cut_depth,
            r = r
        );
    }
}


// ============================================================
// COUNTERSUNK REAR MOUNTING HOLE
// ============================================================

module countersunk_hole(z_position) {

    // Screw shaft
    translate([
        centre_x,
        -1,
        z_position
    ])

    rotate([-90,0,0])

    cylinder(
        h = rear_wall + 3,
        d = screw_hole_d
    );


    // Countersink facing into holder
    translate([
        centre_x,
        rear_wall - countersink_depth,
        z_position
    ])

    rotate([-90,0,0])

    cylinder(
        h  = countersink_depth + 0.2,
        d1 = screw_hole_d,
        d2 = screw_head_d
    );
}


// ============================================================
// LEFT CHANNEL TOP FILLET CUT
// ============================================================
//
// Removes ONLY the small corner outside
// a quarter-circle.
//
// This makes the top opening smoothly flare
// into the straight 8 mm channel.
//

module channel_left_top_fillet() {

    front_y =
        rear_wall +
        inside_depth;

    cut_depth =
        front_wall + 3;

    r =
        channel_top_radius;

    x_left =
        centre_x -
        channel_width / 2;

    z_top =
        front_height;


    difference() {

        // Square containing the corner to remove
        translate([
            x_left - r,
            front_y - 1,
            z_top - r
        ])

        cube([
            r,
            cut_depth,
            r
        ]);


        // Keep the quarter-circle portion
        translate([
            x_left - r,
            front_y - 1.1,
            z_top - r
        ])

        rotate([-90,0,0])

        cylinder(
            h = cut_depth + 0.2,
            r = r
        );
    }
}


// ============================================================
// RIGHT CHANNEL TOP FILLET CUT
// ============================================================

module channel_right_top_fillet() {

    front_y =
        rear_wall +
        inside_depth;

    cut_depth =
        front_wall + 3;

    r =
        channel_top_radius;

    x_right =
        centre_x +
        channel_width / 2;

    z_top =
        front_height;


    difference() {

        // Square containing the corner to remove
        translate([
            x_right,
            front_y - 1,
            z_top - r
        ])

        cube([
            r,
            cut_depth,
            r
        ]);


        // Keep the quarter-circle portion
        translate([
            x_right + r,
            front_y - 1.1,
            z_top - r
        ])

        rotate([-90,0,0])

        cylinder(
            h = cut_depth + 0.2,
            r = r
        );
    }
}


// ============================================================
// FRONT ACCESS CHANNEL
// ============================================================

module front_channel() {

    front_y =
        rear_wall +
        inside_depth;

    cut_depth =
        front_wall + 3;


    union() {

        // ----------------------------------------------------
        // STRAIGHT 8 MM CHANNEL
        // ----------------------------------------------------

        translate([
            centre_x - channel_width/2,
            front_y - 1,
            lower_hole_z
        ])

        cube([
            channel_width,
            cut_depth,
            front_height - lower_hole_z + 3
        ]);


        // ----------------------------------------------------
        // ROUND BOTTOM
        // ----------------------------------------------------

        translate([
            centre_x,
            front_y - 1,
            lower_hole_z
        ])

        rotate([-90,0,0])

        cylinder(
            h = cut_depth,
            d = channel_width
        );


        // ----------------------------------------------------
        // CURVED TOP ENTRY
        // ----------------------------------------------------

        channel_left_top_fillet();

        channel_right_top_fillet();
    }
}


// ============================================================
// FINAL MODEL
// ============================================================

difference() {

    // Complete outer shell
    outer_body();


    // Smooth internal cavity
    inner_cavity();


    // 50 mm front plate
    upper_front_opening();


    // Rear countersunk screw holes
    countersunk_hole(
        lower_hole_z
    );

    countersunk_hole(
        upper_hole_z
    );


    // 8 mm front channel
    // with curved top entrance
    front_channel();
}
