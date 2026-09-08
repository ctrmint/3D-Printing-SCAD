// ============================================================
// STORAGE BOX - BASE
// Sliding lid grooves cut INTO side walls + rear receiving wall
// Units: mm
// ============================================================

$fn = 64;

// ============================================================
// MAIN EXTERNAL DIMENSIONS
// ============================================================

box_length = 335;       // X
box_width  = 266;       // Y
box_height = 44;        // Z

// ============================================================
// STRUCTURE
// ============================================================

wall_thickness = 6.0;
base_thickness = 4.0;
corner_radius  = 5.0;

// ============================================================
// SLIDING LID / GROOVE PARAMETERS
// ============================================================

lid_thickness          = 3.5;
lid_side_clearance     = 0.30;   // clearance from lid edge to deepest side groove face
lid_vertical_clearance = 0.40;   // total vertical clearance in groove
lid_end_clearance      = 0.30;   // clearance from lid rear edge to rear groove bottom
entry_clearance        = 0.30;   // clearance around front entry opening

side_groove_depth = 3.0;         // cut into each 6 mm side wall
rear_groove_depth = 3.0;         // cut into the 6 mm rear/end wall

upper_lip_thickness = 1.0;       // EXACT retaining lip above all grooves

// ============================================================
// DERIVED DIMENSIONS
// ============================================================

internal_width = box_width - 2 * wall_thickness;

groove_height = lid_thickness + lid_vertical_clearance;
groove_top    = box_height - upper_lip_thickness;
groove_bottom = groove_top - groove_height;

// Lid enters both side-wall channels.
lid_width =
    internal_width
    + 2 * (side_groove_depth - lid_side_clearance);

// Rear groove spans far enough across Y to join both side grooves.
rear_groove_width =
    internal_width
    + 2 * side_groove_depth
    + 0.04;

// Lid front edge is flush with the outer front face when closed.
// Rear edge extends into the rear receiving groove, stopping short
// of the groove bottom by lid_end_clearance.
lid_length =
    box_length
    - wall_thickness
    + rear_groove_depth
    - lid_end_clearance;

entry_slot_width  = lid_width + 2 * entry_clearance;
entry_slot_height = groove_height + 0.10;

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
// SIDE GROOVE
// ============================================================

module side_groove(side)
{
    groove_center_y =
        side * (
            box_width / 2
            - wall_thickness
            + side_groove_depth / 2
        );

    // Opens through the front and reaches the inner face
    // of the rear wall. The rear groove then continues
    // the receiving channel into the end wall.
    groove_front_x = -box_length / 2 - 1;
    groove_rear_x  =  box_length / 2 - wall_thickness + 0.05;

    groove_length   = groove_rear_x - groove_front_x;
    groove_center_x = (groove_front_x + groove_rear_x) / 2;

    translate([
        groove_center_x,
        groove_center_y,
        groove_bottom + groove_height / 2
    ])
        cube([
            groove_length,
            side_groove_depth + 0.02,
            groove_height
        ], center = true);
}

// ============================================================
// REAR / END RECEIVING GROOVE
// ============================================================

module rear_receiving_groove()
{
    // Groove begins at the inner face of the rear wall and
    // cuts rear_groove_depth into the 6 mm wall.
    groove_center_x =
        box_length / 2
        - wall_thickness
        + rear_groove_depth / 2;

    translate([
        groove_center_x,
        0,
        groove_bottom + groove_height / 2
    ])
        cube([
            rear_groove_depth + 0.02,
            rear_groove_width,
            groove_height
        ], center = true);
}

// ============================================================
// FRONT ENTRY SLOT
// ============================================================

module front_entry_slot()
{
    translate([
        -box_length / 2 - 1,
        -entry_slot_width / 2,
        groove_bottom - 0.05
    ])
        cube([
            wall_thickness + 2,
            entry_slot_width,
            entry_slot_height
        ], center = false);
}

// ============================================================
// BASE
// ============================================================

module storage_box_base()
{
    difference()
    {
        // Outer shell
        rounded_box(
            box_length,
            box_width,
            box_height,
            corner_radius
        );

        // Main storage cavity
        translate([0, 0, base_thickness])
            linear_extrude(
                height = box_height - base_thickness + 1
            )
                rounded_rectangle_2d(
                    box_length - 2 * wall_thickness,
                    box_width  - 2 * wall_thickness,
                    max(0.5, corner_radius - wall_thickness)
                );

        // Sliding receiving grooves cut into the walls
        side_groove(-1);
        side_groove(1);
        rear_receiving_groove();

        // Lid insertion opening through front wall
        front_entry_slot();
    }
}

// ============================================================
// OUTPUT
// ============================================================

storage_box_base();
