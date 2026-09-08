// ============================================================
// STORAGE BOX - SLIDING LID
// Matches storage_box_base.scad
// Lid enters side grooves AND rear/end receiving groove
// Units: mm
// ============================================================

$fn = 64;

// ============================================================
// MAIN EXTERNAL BOX DIMENSIONS
// Keep these matched to the base file
// ============================================================

box_length = 335;
box_width  = 266;
box_height = 44;

// ============================================================
// STRUCTURE / FIT PARAMETERS
// Keep these matched to the base file
// ============================================================

wall_thickness = 6.0;
corner_radius  = 5.0;

lid_thickness          = 3.5;
lid_side_clearance     = 0.30;
lid_vertical_clearance = 0.40;
lid_end_clearance      = 0.30;

side_groove_depth = 3.0;
rear_groove_depth = 3.0;

upper_lip_thickness = 1.0;

// ============================================================
// DERIVED LID DIMENSIONS
// ============================================================

internal_width = box_width - 2 * wall_thickness;

// Lid extends into both side-wall receiving grooves.
lid_width =
    internal_width
    + 2 * (side_groove_depth - lid_side_clearance);

// Lid now also extends into the rear/end receiving groove.
// With the current values it enters the 3 mm rear channel
// by 2.70 mm, leaving 0.30 mm clearance at the groove bottom.
lid_length =
    box_length
    - wall_thickness
    + rear_groove_depth
    - lid_end_clearance;

lid_corner_radius = 2.0;

// ============================================================
// HELPERS
// ============================================================

module rounded_rectangle_2d(length, width, radius)
{
    r = min(radius, min(length, width) / 2);

    offset(r = r)
        square([
            length - 2 * r,
            width  - 2 * r
        ], center = true);
}

module rounded_box(length, width, height, radius)
{
    linear_extrude(height = height)
        rounded_rectangle_2d(length, width, radius);
}

// ============================================================
// LID
// ============================================================

module storage_box_lid()
{
    rounded_box(
        lid_length,
        lid_width,
        lid_thickness,
        lid_corner_radius
    );
}

// ============================================================
// OUTPUT
// ============================================================

storage_box_lid();
