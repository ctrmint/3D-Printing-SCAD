// ============================================================
// picture_frame_v2_5
// PORTRAIT PARAMETRIC ART FRAME
//
// 3 mm recessed horizontal rear bridge
// Central triangular hanger
// NO corner pins / standoffs
//
// Artwork:
//      213 mm wide
//      307 mm high
//
// Raised visible section:
//      197 mm wide
//      291 mm high
//
// Flat lip:
//      8 mm all around
//
// Outer frame border:
//      5 mm
//
// All dimensions in mm
// ============================================================

$fn = 72;


// ============================================================
// ARTWORK DIMENSIONS
// ============================================================

art_length = 307;
art_width = 213;
art_thickness = 4;


// ============================================================
// RAISED / VISIBLE ARTWORK SECTION
// ============================================================

raised_visible_length = 291;
raised_visible_width = 197;


// ============================================================
// EXISTING ARTWORK LIP
// ============================================================

art_existing_lip_width = 12;
art_existing_lip_height = 3;


// ============================================================
// ARTWORK FIT
// ============================================================

// Clearance on EACH side
art_clearance = 0.30;

// Extra depth in artwork pocket
depth_clearance = 0.40;


// ============================================================
// FRONT OPENING CLEARANCE
// ============================================================

raised_section_clearance = 0;


// ============================================================
// OUTER FRAME BORDER
// ============================================================

// Amount outside artwork on EACH side
frame_border_width = 5;


// ============================================================
// FRONT RETAINING LIP
// ============================================================

front_lip_thickness = 2;


// ============================================================
// REAR FRAME STRUCTURE
// ============================================================

rear_wall_thickness = 3;


// ============================================================
// FRONT MOULDING
// ============================================================

front_curve_height = 10;

curve_steps = 28;

curve_squareness = 3.5;

top_flat_amount = 2;


// ============================================================
// CORNER RADII
// ============================================================

outer_corner_radius = 8;

visible_corner_radius = 3;

pocket_corner_radius = 2;


// ============================================================
// RECESSED REAR BRIDGE
// ============================================================
//
// Bridge occupies the 3 mm rear structural depth.
//
// Rear surface = Z 0
//
// Bridge extends forwards from:
// Z = 0
// to
// Z = 3
//

bridge_width = 12;

bridge_thickness = 3;


// Vertical bridge position.
//
// 0 = centre of frame
// Positive = upward
// Negative = downward
//
bridge_y_position = 95;


// Amount bridge enters each side rail
bridge_side_overlap = 4;


// ============================================================
// CENTRAL TRIANGULAR HANGER
// ============================================================

triangle_width = 32;

triangle_height = 28;


// Triangle projects this far behind rear surface
triangle_thickness = 2;


// Rounded triangle corners
triangle_corner_radius = 2;


// Amount triangle overlaps the horizontal bridge
//
// Ensures a strong physical connection.
//
triangle_bridge_overlap = 15;


// ============================================================
// HANGING HARDWARE HOLE
// ============================================================

hanger_hole_diameter = 5;


// Distance down from triangle tip
// to centre of hanging hole
hanger_hole_top_offset = 9;


// ============================================================
// DERIVED OUTER FRAME SIZE
// ============================================================

frame_outer_x =
    art_width
    + (frame_border_width * 2);

frame_outer_y =
    art_length
    + (frame_border_width * 2);


// Current:
// 223 mm wide
// 317 mm high


// ============================================================
// ARTWORK POCKET
// ============================================================

pocket_x =
    art_width
    + (art_clearance * 2);

pocket_y =
    art_length
    + (art_clearance * 2);

pocket_depth =
    art_thickness
    + depth_clearance;


// Current:
//
// 213.6 mm wide
// 307.6 mm high
// 4.4 mm deep


// ============================================================
// VISIBLE OPENING
// ============================================================

opening_x =
    raised_visible_width
    + (raised_section_clearance * 2);

opening_y =
    raised_visible_length
    + (raised_section_clearance * 2);


// Current:
//
// 197 x 291 mm


// ============================================================
// FLAT LIP
// ============================================================

flat_lip_left_right =
    (art_width - opening_x) / 2;

flat_lip_top_bottom =
    (art_length - opening_y) / 2;


// Current:
//
// Left/right = 8 mm
// Top/bottom = 8 mm


// ============================================================
// Z POSITIONS
// ============================================================

artwork_front_z =
    rear_wall_thickness
    + pocket_depth;


front_lip_top_z =
    artwork_front_z
    + front_lip_thickness;


frame_total_depth =
    rear_wall_thickness
    + pocket_depth
    + front_lip_thickness
    + front_curve_height;


// ============================================================
// BRIDGE DERIVED DIMENSIONS
// ============================================================

bridge_length =
    min(
        frame_outer_x,

        pocket_x
        + (bridge_side_overlap * 2)
    );


// ============================================================
// TRIANGLE POSITIONS
// ============================================================

triangle_base_y =
    bridge_y_position
    + (bridge_width / 2)
    - triangle_bridge_overlap;


triangle_tip_y =
    triangle_base_y
    + triangle_height;


hanger_hole_y =
    triangle_tip_y
    - hanger_hole_top_offset;


// ============================================================
// INFORMATION
// ============================================================

echo("==========================================");
echo("picture_frame_v2_5");
echo("==========================================");

echo(
    "Outer frame:",
    frame_outer_x,
    "x",
    frame_outer_y
);

echo(
    "Artwork:",
    art_width,
    "x",
    art_length
);

echo(
    "Raised visible section:",
    raised_visible_width,
    "x",
    raised_visible_length
);

echo(
    "Flat lip left/right:",
    flat_lip_left_right
);

echo(
    "Flat lip top/bottom:",
    flat_lip_top_bottom
);

echo(
    "Bridge thickness:",
    bridge_thickness
);

echo(
    "Bridge width:",
    bridge_width
);

echo(
    "Triangle rear projection:",
    triangle_thickness
);


// ============================================================
// SAFETY CHECKS
// ============================================================

assert(
    bridge_thickness <= rear_wall_thickness,
    "Bridge thickness exceeds rear wall thickness."
);


assert(
    raised_visible_width <= art_width,
    "Visible artwork width exceeds artwork."
);


assert(
    raised_visible_length <= art_length,
    "Visible artwork length exceeds artwork."
);


// ============================================================
// ROUNDED RECTANGLE 2D
// ============================================================

module rounded_rectangle_2d(
    w,
    h,
    r
)
{
    rr =
        max(
            0.01,

            min(
                r,
                min(w, h) / 2 - 0.01
            )
        );


    offset(r = rr)

        square(
            [
                w - (2 * rr),
                h - (2 * rr)
            ],
            center = true
        );
}


// ============================================================
// ROUNDED BOX
// ============================================================

module rounded_box(
    w,
    h,
    d,
    r
)
{
    linear_extrude(
        height = d
    )

        rounded_rectangle_2d(
            w,
            h,
            r
        );
}


// ============================================================
// FRAME RING
// ============================================================

module frame_ring(
    outer_x,
    outer_y,

    inner_x,
    inner_y,

    depth,

    outer_radius,
    inner_radius
)
{
    difference()
    {
        rounded_box(
            outer_x,
            outer_y,
            depth,
            outer_radius
        );


        translate([
            0,
            0,
            -0.1
        ])

            rounded_box(
                inner_x,
                inner_y,
                depth + 0.2,
                inner_radius
            );
    }
}


// ============================================================
// FRONT PROFILE
// ============================================================

function profile_shrink(t) =

    front_curve_height *

    (
        1 -

        pow(
            max(
                0,

                1 -
                pow(
                    t,
                    curve_squareness
                )
            ),

            1 / curve_squareness
        )
    );


// ============================================================
// CURVED FRONT MOULDING
// ============================================================

module curved_front()
{
    step_height =
        front_curve_height
        / curve_steps;


    for(i = [0 : curve_steps - 1])
    {
        t1 =
            i / curve_steps;

        t2 =
            (i + 1) / curve_steps;


        s1 =
            max(
                0,

                profile_shrink(t1)
                - top_flat_amount
            );


        s2 =
            max(
                0,

                profile_shrink(t2)
                - top_flat_amount
            );


        z1 =
            front_lip_top_z
            + (i * step_height);


        z2 =
            front_lip_top_z
            + ((i + 1) * step_height);


        hull()
        {
            // LOWER PROFILE SLICE
            translate([
                0,
                0,
                z1
            ])

                linear_extrude(
                    height = 0.05
                )

                    difference()
                    {
                        rounded_rectangle_2d(
                            frame_outer_x
                            - (2 * s1),

                            frame_outer_y
                            - (2 * s1),

                            max(
                                1,
                                outer_corner_radius
                                - s1
                            )
                        );


                        rounded_rectangle_2d(
                            opening_x
                            + (2 * s1),

                            opening_y
                            + (2 * s1),

                            visible_corner_radius
                            + s1
                        );
                    }


            // UPPER PROFILE SLICE
            translate([
                0,
                0,
                z2
            ])

                linear_extrude(
                    height = 0.05
                )

                    difference()
                    {
                        rounded_rectangle_2d(
                            frame_outer_x
                            - (2 * s2),

                            frame_outer_y
                            - (2 * s2),

                            max(
                                1,
                                outer_corner_radius
                                - s2
                            )
                        );


                        rounded_rectangle_2d(
                            opening_x
                            + (2 * s2),

                            opening_y
                            + (2 * s2),

                            visible_corner_radius
                            + s2
                        );
                    }
        }
    }
}


// ============================================================
// ROUNDED TRIANGULAR HANGER
// ============================================================
//
// Constructed using three circles joined with hull().
//

module hanger_triangle_2d()
{
    r =
        triangle_corner_radius;


    hull()
    {
        // LOWER LEFT
        translate([
            -triangle_width / 2 + r,
            triangle_base_y + r
        ])

            circle(r = r);


        // LOWER RIGHT
        translate([
            triangle_width / 2 - r,
            triangle_base_y + r
        ])

            circle(r = r);


        // TOP
        translate([
            0,
            triangle_tip_y - r
        ])

            circle(r = r);
    }
}


// ============================================================
// RECESSED HORIZONTAL BRIDGE
// ============================================================
//
// Rear surface = Z 0.
//
// Bridge sits entirely within the
// 3 mm rear structural thickness.
//

module recessed_bridge()
{
    translate([
        0,
        bridge_y_position,
        0
    ])

        rounded_box(
            bridge_length,
            bridge_width,
            bridge_thickness,

            min(
                2,
                bridge_width / 4
            )
        );
}


// ============================================================
// REAR TRIANGULAR HANGER
// ============================================================
//
// Triangle projects backwards from the frame.
//
// An extra 0.3 mm overlaps into the bridge/frame
// to give a robust union.
//

module rear_triangle_hanger()
{
    difference()
    {
        translate([
            0,
            0,
            -triangle_thickness
        ])

            linear_extrude(
                height =
                    triangle_thickness
                    + 0.3
            )

                hanger_triangle_2d();


        // Hanging hardware hole
        translate([
            0,
            hanger_hole_y,
            -triangle_thickness - 0.1
        ])

            cylinder(
                d =
                    hanger_hole_diameter,

                h =
                    triangle_thickness
                    + 0.5
            );
    }
}


// ============================================================
// BASIC FRAME
// ============================================================

module basic_frame()
{
    difference()
    {
        union()
        {
            // =================================================
            // REAR FRAME SURROUND
            // =================================================

            frame_ring(
                frame_outer_x,
                frame_outer_y,

                pocket_x,
                pocket_y,

                artwork_front_z,

                outer_corner_radius,
                pocket_corner_radius
            );


            // =================================================
            // FRONT RETAINING LIP
            // =================================================

            translate([
                0,
                0,
                artwork_front_z
            ])

                frame_ring(
                    frame_outer_x,
                    frame_outer_y,

                    opening_x,
                    opening_y,

                    front_lip_thickness,

                    outer_corner_radius,
                    visible_corner_radius
                );


            // =================================================
            // CURVED FRONT
            // =================================================

            curved_front();


            // =================================================
            // 3 mm RECESSED HORIZONTAL BRIDGE
            // =================================================

            recessed_bridge();
        }


        // =====================================================
        // REAR ARTWORK POCKET
        // =====================================================

        translate([
            0,
            0,
            rear_wall_thickness
        ])

            rounded_box(
                pocket_x,
                pocket_y,

                pocket_depth + 0.2,

                pocket_corner_radius
            );


        // =====================================================
        // FRONT DISPLAY OPENING
        // =====================================================

        translate([
            0,
            0,
            artwork_front_z - 0.1
        ])

            rounded_box(
                opening_x,
                opening_y,

                frame_total_depth + 5,

                visible_corner_radius
            );
    }
}


// ============================================================
// COMPLETE FRAME
// ============================================================

module picture_frame()
{
    union()
    {
        basic_frame();

        rear_triangle_hanger();
    }
}


// ============================================================
// FINAL MODEL
// ============================================================

picture_frame();
