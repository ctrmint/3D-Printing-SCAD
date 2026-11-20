/*
    Electronics Parts Pot - Max 74mm, Two Compartments + Smiley Face
    -----------------------------------------------
    Open-topped parts tray with two equal internal compartments separated
    by an integral divider. Designed for support-free FDM printing.
    Units: millimetres.
*/

// ---------- ADJUSTABLE DIMENSIONS ----------
max_outer_width   = 74;     // HARD MAX: includes rim and raised smiley, across X and Y
edge_clearance    = 0.2;    // Extra clearance so printed outside size remains < 74 mm
height           = 30;     // Overall pot height
wall_thickness   = 2.4;    // Outer side walls
base_thickness   = 2.8;    // Flat floor thickness
bottom_bevel     = 1.5;    // External bottom-edge chamfer
inside_bevel     = 2.0;    // Rounded-in floor-to-wall transition (45 degrees)
rim_projection   = 0.8;    // Small outward rim at the top
rim_height       = 2.4;    // Height of upper rim

// Optional raised smiley on the outside front of the pot
show_face        = true;  // Set false for a plain pot
face_depth       = 1.0;   // Raised height of eyes/smile (mm)
face_eye_radius  = 1.55;  // Round eyes
face_mouth_radius = 8.0; // Radius of curved mouth
face_mouth_width = 1.9;  // Mouth stroke thickness

divider_thickness = 2.8;   // Full-length central partition thickness
divider_height    = 24;    // Divider top measured from bottom of pot
                          // (6 mm below the rim for easy finger access)
divider_top_bevel = 0.7;   // Small chamfers on divider's top edges

// Body diameter is calculated so even the rim and smiley stay within max_outer_width.
// The face protrudes on -Y; the rim protrudes all around.
face_extension = show_face ? face_depth : 0;
outer_diameter = max_outer_width - max(2*rim_projection, rim_projection + face_extension) - edge_clearance;

$fn = 144;
assert(outer_diameter + max(2*rim_projection, rim_projection + face_extension) <= max_outer_width,
    "Finished item exceeds maximum outer width.");

// ---------- VALIDATION ----------
assert(outer_diameter > 2*(wall_thickness + inside_bevel) + 6,
    "Outer diameter too small for the selected wall thickness.");
assert(height > base_thickness + inside_bevel + rim_height + 3,
    "Height too small for the selected base/rim.");
assert(divider_thickness >= 1.2 && divider_thickness < outer_diameter / 5,
    "Invalid divider thickness.");
assert(divider_height > base_thickness + 4 && divider_height <= height,
    "Divider height must be above the floor and no taller than pot.");
assert(divider_top_bevel >= 0 && divider_top_bevel < divider_thickness / 2,
    "Divider top bevel out of range.");
assert(face_depth > 0 && face_depth <= 1.8,
    "Face depth should be 0 to 1.8 mm for easy FDM printing.");
assert(rim_projection >= 0 && rim_projection <= rim_height / 2,
    "Rim projection too large for support-free printing.");

// ---------- COMPONENTS ----------
module outer_pot() {
    r = outer_diameter / 2;
    inner_r = r - wall_thickness;

    rotate_extrude(convexity = 10)
        polygon(points = [
            [0, 0],
            [r - bottom_bevel, 0],
            [r, bottom_bevel],
            [r, height - rim_height],
            [r + rim_projection, height - rim_height + rim_projection],
            [r + rim_projection, height],
            [inner_r, height],
            [inner_r, base_thickness + inside_bevel],
            [inner_r - inside_bevel, base_thickness],
            [0, base_thickness]
        ]);
}

module center_divider() {
    // Partition overlaps the floor slightly and intersects the side walls.
    // Clipping to the inner diameter keeps the original exterior unchanged.
    inner_r = outer_diameter / 2 - wall_thickness;
    contact_overlap = 0.5;
    lower_z = base_thickness - 0.35;

    intersection() {
        translate([0, 0, lower_z])
            cylinder(r = inner_r + contact_overlap,
                     h = divider_height - lower_z);

        // Top edges taper inward, avoiding a sharp partition lip.
        // Extruded in X, with the profile defined in Y/Z.
        translate([-outer_diameter / 2, 0, 0])
            rotate([90, 0, 90])
                linear_extrude(height = outer_diameter)
                    polygon(points = [
                        [-divider_thickness / 2, lower_z],
                        [ divider_thickness / 2, lower_z],
                        [ divider_thickness / 2, divider_height - divider_top_bevel],
                        [ divider_thickness / 2 - divider_top_bevel, divider_height],
                        [-divider_thickness / 2 + divider_top_bevel, divider_height],
                        [-divider_thickness / 2, divider_height - divider_top_bevel]
                    ]);
    }
}

// ---------- SMILEY FACE ----------
// The face is a shallow raised relief following the CURVED OUTSIDE WALL.
// It does not obstruct either compartment or change the internal volume.
// Mounted on the -Y side, centered in height, facing outward.
module face_2d() {
    // Positioning coordinates below are X (horizontal) and Z (vertical),
    // relative to the center of the face at z = 15.4 mm.
    translate([-5.6, 4.3]) circle(r = face_eye_radius);
    translate([ 5.6, 4.3]) circle(r = face_eye_radius);

    // Draw the mouth as a continuous, rounded upward-pointing smile.
    translate([0, 0.8])
        for (a = [210:5:325])
            hull() {
                translate([face_mouth_radius*cos(a),
                           face_mouth_radius*sin(a)])
                    circle(r = face_mouth_width/2, $fn=20);
                translate([face_mouth_radius*cos(a+5),
                           face_mouth_radius*sin(a+5)])
                    circle(r = face_mouth_width/2, $fn=20);
            }
}

module raised_face() {
    r = outer_diameter/2;
    face_wall_overlap = 0.45;

    // Clip the face to a narrow cylindrical shell for a conformal relief.
    intersection() {
        difference() {
            cylinder(r = r+face_depth, h = height, $fn=$fn);
            translate([0, 0, -0.05])
                cylinder(r = r-face_wall_overlap,
                         h = height+0.1, $fn=$fn);
        }
        // 2D face in XZ plane, extruded towards -Y, through the shell.
        translate([0, 0, height*0.51])
            rotate([90, 0, 0])
                linear_extrude(height = outer_diameter)
                    face_2d();
    }
}

union() {
    outer_pot();
    center_divider();
    if (show_face) raised_face();
}
