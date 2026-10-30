/*
    Painter's Guard / Paint Shield

    All dimensions in millimetres. Parametric OpenSCAD model.
    Print blade-side down; the handle bridge may need supports.
*/

// ===== Guard =====
guard_length        = 215;
guard_width         = 25;
guard_thickness     = 2;
chamfer_width       = 5;       // Distance back from long working edge
chamfer_tip         = 0.45;    // Thickness at the chamfered edge

// ===== Compact central bridge handle =====
handle_length       = 44;      // Maximum overall length along the guard
handle_width        = 6;       // Width across the guard (Y)
handle_height       = 13;      // Maximum total height from blade underside
handle_foot_overlap = 0.4;     // Intersection with blade ensures a solid union

assert(guard_length > handle_length, "Handle must fit along the blade");
assert(handle_width <= guard_width - 2*chamfer_width,
       "Centred handle must remain clear of the chamfered edge");
assert(handle_length >= 35, "This grip profile requires at least 35 mm length");
assert(handle_height >= 13, "This grip profile requires at least 13 mm height");
assert(chamfer_width > 0 && chamfer_width < guard_width,
       "Chamfer width must fit within blade");
assert(chamfer_tip > 0 && chamfer_tip < guard_thickness,
       "Chamfer tip must be thinner than the guard");

// Flat bottom (Z=0). The top surface slopes down to Y=0.
module guard_blade() {
    rotate([0, 0, 90])
        rotate([90, 0, 0])
            linear_extrude(height=guard_length, center=true, convexity=10)
                polygon(points=[
                    [0,             0],
                    [guard_width,   0],
                    [guard_width,   guard_thickness],
                    [chamfer_width, guard_thickness],
                    [0,             chamfer_tip]
                ]);
}

// Compact arched grip. A finger recess is formed by the inner contour.
// Outer limits remain strictly within handle_length and handle_height.
module central_handle() {
    half = handle_length / 2;
    base = guard_thickness - handle_foot_overlap;
    zscale = (handle_height - base) / (15 - 1.6);

    // Geometry defined relative to the centre; scale the vertical profile
    // to respect the chosen overall handle height.
    translate([0, (guard_width + handle_width)/2 + 3, 0])
        rotate([90, 0, 0])
            linear_extrude(height=handle_width, convexity=10)
                polygon(points=[
                    [-half,       base],
                    [-half+1,     base + 4.4*zscale],
                    [-half+3.5,   base + 10.4*zscale],
                    [-half+6.5,   handle_height],
                    [ half-6.5,   handle_height],
                    [ half-3.5,   base + 10.4*zscale],
                    [ half-1,     base + 4.4*zscale],
                    [ half,       base],
                    // Return around inner (finger-clearance) opening.
                    [ half-5,     base],
                    [ half-7.5,   base + 3.9*zscale],
                    [ half-8.5,   base + 8.9*zscale],
                    [-half+8.5,   base + 8.9*zscale],
                    [-half+7.5,   base + 3.9*zscale],
                    [-half+5,     base]
                ]);
}

union() {
    guard_blade();
    central_handle();
}
