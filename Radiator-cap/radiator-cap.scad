// Radiator valve cap
// Exact-fit internal dimensions
// 1 mm wall thickness
// Fully rounded external shell
//
// Units: mm

$fn = 64;

// --------------------------------------------------
// PARAMETERS
// --------------------------------------------------

wall = 1.0;

// Lower round valve section
lower_diameter = 20.0;
lower_depth    = 16.0;

// Upper square valve section
square_width = 6.0;
square_depth = 8.0;


// --------------------------------------------------
// EXACT INTERNAL VALVE SHAPE
// --------------------------------------------------

module internal_core() {

    union() {

        // Lower round section
        cylinder(
            d = lower_diameter,
            h = lower_depth
        );

        // Upper 5 x 5 mm square section
        translate([
            -square_width / 2,
            -square_width / 2,
            lower_depth
        ])
        cube([
            square_width,
            square_width,
            square_depth
        ]);
    }
}


// --------------------------------------------------
// INTERNAL VOID
//
// The lower cylinder extends below Z=0 so the
// bottom of the finished cap is completely open.
// --------------------------------------------------

module internal_void() {

    union() {

        // Exact 10 mm lower cavity
        translate([0, 0, -2])
        cylinder(
            d = lower_diameter,
            h = lower_depth + 2
        );

        // Exact 5 x 5 mm square cavity
        translate([
            -square_width / 2,
            -square_width / 2,
            lower_depth
        ])
        cube([
            square_width,
            square_width,
            square_depth
        ]);
    }
}


// --------------------------------------------------
// ROUNDED OUTER BODY
//
// Minkowski creates a true 1 mm rounded offset
// around the exact internal dimensions.
// --------------------------------------------------

module rounded_outer_body() {

    minkowski() {

        internal_core();

        sphere(r = wall);
    }
}


// --------------------------------------------------
// FINISHED CAP
// --------------------------------------------------

difference() {

    rounded_outer_body();

    internal_void();
}
