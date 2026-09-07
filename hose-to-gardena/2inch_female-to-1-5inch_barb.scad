// ============================================================
// 39.6 mm HOSE BARB -> 2" BSPP (G2) FEMALE SOCKET
// One-piece printable adapter
// Units: mm
//
// Hose side based on measured hose ID = 39.6 mm
// BSP side intended to screw onto a 2" BSP MALE fitting.
//
// IMPORTANT SEALING NOTE:
// G2 / BSPP is a PARALLEL thread. The thread locates and clamps;
// the watertight seal is made by a flat EPDM/rubber washer at the
// bottom of the socket, not by the plastic thread flanks.
// ============================================================

$fn = 180;

// ============================================================
// USER / FIT PARAMETERS
// ============================================================

// Hose measured internal diameter
hose_id = 39.6;

// Maximum requested barb diameter
barb_peak_d = 39.8;

// Diameter between barb crests
barb_root_d = 37.8;

// Easy insertion tip
barb_tip_d = 36.5;

// Full straight hose engagement length, excluding lead-in
barb_total_length = 44;
barb_count = 5;
barb_tip_h = 4.0;

// Constant bore through hose barb
barb_bore_d = 31.0;

// Hose stop
hose_stop_d = 44.0;
hose_stop_h = 4.0;

// Transition into large BSP socket body
transition_h = 12.0;

// ============================================================
// 2" BSPP / G2 THREAD PARAMETERS
// ============================================================
// Nominal G2 / BSPP:
//      11 TPI
//      pitch = 25.4 / 11 = 2.30909 mm
//      male major diameter = 59.614 mm
//      55 degree Whitworth thread form
//
// The printed female thread is deliberately given clearance.
// Change bsp_fit_clearance_radial in 0.05 mm steps after a test
// print if your printer needs more/less fit clearance.
// ============================================================

bsp_tpi = 11;

bsp_pitch =
    25.4
    / bsp_tpi;

bsp_male_major_d = 59.614;


// Practical internal-thread basic minor diameter.

bsp_female_minor_basic_d = 57.10;


// Radial FDM clearance.
//
// 0.25 mm radial means
// +0.50 mm on thread diameters.

bsp_fit_clearance_radial = 0.25;


bsp_female_minor_d =
    bsp_female_minor_basic_d
    + 2 * bsp_fit_clearance_radial;


bsp_female_major_d =
    bsp_male_major_d
    + 2 * bsp_fit_clearance_radial;


// Thread depth

bsp_thread_depth =
    (
        bsp_female_major_d
        - bsp_female_minor_d
    ) / 2;


// Thread engagement length

bsp_thread_length = 20.0;


// Lead-in chamfer

bsp_leadin_h = 2.0;

bsp_mouth_d = 61.5;


// ============================================================
// SOCKET BODY
// ============================================================

// Strong body around large BSP thread

socket_body_d = 72.0;


// Solid floor beneath sealing washer

socket_floor_h = 4.0;


// ============================================================
// GASKET SEAT
// ============================================================
//
// Intended for approximately:
//
// 48 mm ID
// 60 mm OD
// 2 mm thick
//
// soft EPDM / rubber washer.
//
// Measure the actual washer before final production.
// ============================================================

gasket_recess_d = 61.0;

gasket_recess_depth = 2.2;

gasket_nominal_id = 48.0;


// Clearance between gasket pocket
// and beginning of full thread

thread_runout_h = 1.5;


// Total socket height

socket_body_h =
    socket_floor_h
    + gasket_recess_depth
    + thread_runout_h
    + bsp_thread_length
    + bsp_leadin_h;


// Water passage through sealing face

seal_bore_d = 46.0;


EPS = 0.05;


// ============================================================
// DERIVED BARB GEOMETRY
// ============================================================

barb_pitch =
    barb_total_length
    / barb_count;


// Maintain same tooth proportions
// as previous hose barb

barb_ramp_ratio =
    6.5 / 8.5;

barb_drop_ratio =
    2.0 / 8.5;


barb_ramp_h =
    barb_pitch
    * barb_ramp_ratio;


barb_drop_h =
    barb_pitch
    * barb_drop_ratio;


// ============================================================
// DERIVED Z POSITIONS
// ============================================================

barb_end_z =
    barb_tip_h
    + barb_total_length;


stop_z =
    barb_end_z;


transition_z =
    stop_z
    + hose_stop_h;


socket_z =
    transition_z
    + transition_h;


seal_face_z =
    socket_z
    + socket_floor_h;


gasket_top_z =
    seal_face_z
    + gasket_recess_depth;


thread_start_z =
    gasket_top_z
    + thread_runout_h;


thread_end_z =
    thread_start_z
    + bsp_thread_length;


socket_top_z =
    socket_z
    + socket_body_h;


// ============================================================
// HELPER FUNCTIONS
// ============================================================

function polar_pt(r, a) =
[
    r * cos(a),
    r * sin(a)
];


function arc_pts(r, a1, a2, n) =
[
    for (i = [0:n])

        polar_pt(
            r,

            a1
            + (a2 - a1)
            * i / n
        )
];


// ============================================================
// HOSE BARB
// ============================================================

module hose_barb_outer()
{
    union()
    {

        // ----------------------------------------------------
        // INSERTION LEAD-IN
        // ----------------------------------------------------

        cylinder(
            h =
                barb_tip_h
                + EPS,

            d1 = barb_tip_d,
            d2 = barb_root_d
        );


        // ----------------------------------------------------
        // BARB CORE
        // ----------------------------------------------------

        translate([
            0,
            0,
            barb_tip_h - EPS
        ])

            cylinder(
                h =
                    barb_total_length
                    + EPS * 2,

                d =
                    barb_root_d
            );


        // ----------------------------------------------------
        // FIVE COMPLETE BARBS
        // ----------------------------------------------------

        for (
            i = [
                0 :
                barb_count - 1
            ]
        )
        {

            z0 =
                barb_tip_h
                + i * barb_pitch;


            // -----------------------------------------------
            // OUTWARD RAMP
            // -----------------------------------------------

            translate([
                0,
                0,
                z0
            ])

                cylinder(
                    h =
                        barb_ramp_h
                        + EPS,

                    d1 = barb_root_d,
                    d2 = barb_peak_d
                );


            // -----------------------------------------------
            // RETURN TO ROOT
            // -----------------------------------------------

            translate([
                0,
                0,
                z0
                + barb_ramp_h
                - EPS
            ])

                cylinder(
                    h =
                        barb_drop_h
                        + EPS * 2,

                    d1 = barb_peak_d,
                    d2 = barb_root_d
                );
        }
    }
}


// ============================================================
// HELICAL THREAD HELPER
// ============================================================

function helix_pt(
    r,
    a,
    z
) =
[
    r * cos(a),
    r * sin(a),
    z
];


// ============================================================
// 2" BSP FEMALE THREAD CUTTER
// ============================================================
//
// Native OpenSCAD implementation.
//
// No external thread library required.
//
// Thread groove is generated as a closed
// helical polyhedron.
//
// ============================================================

module bsp_female_thread_cutter(
    z_start,
    length,
    minor_d,
    major_d,
    pitch
)
{

    r_inner =
        minor_d / 2;


    r_outer =
        major_d / 2;


    depth =
        r_outer
        - r_inner;


    // --------------------------------------------------------
    // 55 DEGREE WHITWORTH PROFILE
    // --------------------------------------------------------

    flank_axial_growth =
        2
        * depth
        * tan(27.5);


    // Slightly truncated root
    // improves FDM printability

    outer_tip_width_z =
        0.18
        * pitch;


    inner_base_width_z =
        min(
            0.86 * pitch,

            outer_tip_width_z
            + flank_axial_growth
        );


    // --------------------------------------------------------
    // THREAD OVERSHOOT
    // --------------------------------------------------------

    overshoot =
        pitch;


    total_length =
        length
        + 2 * overshoot;


    turns =
        total_length
        / pitch;


    // Smooth helical resolution

    segments_per_turn = 24;


    segments =
        ceil(
            turns
            * segments_per_turn
        );


    z0 =
        z_start
        - overshoot;


    // --------------------------------------------------------
    // HELICAL CROSS-SECTIONS
    //
    // Four points per section:
    //
    // 0 inner lower
    // 1 inner upper
    // 2 outer upper
    // 3 outer lower
    // --------------------------------------------------------

    pts =
    [
        for (
            i = [
                0 :
                segments
            ]
        )

        let(
            f =
                i
                / segments,

            a =
                360
                * turns
                * f,

            zc =
                z0
                + total_length
                * f
        )

        each
        [

            helix_pt(
                r_inner - 0.15,
                a,
                zc
                - inner_base_width_z / 2
            ),


            helix_pt(
                r_inner - 0.15,
                a,
                zc
                + inner_base_width_z / 2
            ),


            helix_pt(
                r_outer + 0.05,
                a,
                zc
                + outer_tip_width_z / 2
            ),


            helix_pt(
                r_outer + 0.05,
                a,
                zc
                - outer_tip_width_z / 2
            )

        ]
    ];


    // --------------------------------------------------------
    // TRIANGULATED HELICAL WALLS
    // --------------------------------------------------------

    side_faces =
    [

        for (
            i = [
                0 :
                segments - 1
            ]
        )

        let(

            b =
                i * 4,

            n =
                (i + 1) * 4

        )

        each
        [

            [
                n + 1,
                n + 0,
                b + 0
            ],

            [
                b + 1,
                n + 1,
                b + 0
            ],


            [
                n + 2,
                n + 1,
                b + 1
            ],

            [
                b + 2,
                n + 2,
                b + 1
            ],


            [
                n + 3,
                n + 2,
                b + 2
            ],

            [
                b + 3,
                n + 3,
                b + 2
            ],


            [
                n + 0,
                n + 3,
                b + 3
            ],

            [
                b + 0,
                n + 0,
                b + 3
            ]

        ]
    ];


    end_base =
        segments * 4;


    faces =
        concat(

            // Start cap

            [
                [3, 2, 1],
                [3, 1, 0]
            ],


            side_faces,


            // End cap

            [
                [
                    end_base + 0,
                    end_base + 1,
                    end_base + 2
                ],

                [
                    end_base + 0,
                    end_base + 2,
                    end_base + 3
                ]
            ]
        );


    union()
    {

        // ----------------------------------------------------
        // BASE FEMALE BORE
        // ----------------------------------------------------

        translate([
            0,
            0,
            z_start - EPS
        ])

            cylinder(
                h =
                    length
                    + EPS * 2,

                d =
                    minor_d
            );


        // ----------------------------------------------------
        // HELICAL THREAD GROOVE
        // ----------------------------------------------------

        polyhedron(
            points = pts,
            faces = faces,
            convexity = 20
        );

    }
}


// ============================================================
// COMPLETE OUTER BODY
// ============================================================

module adapter_outer()
{
    union()
    {

        // ----------------------------------------------------
        // HOSE BARB
        // ----------------------------------------------------

        hose_barb_outer();


        // ----------------------------------------------------
        // HOSE STOP
        // ----------------------------------------------------

        translate([
            0,
            0,
            stop_z - EPS
        ])

            cylinder(
                h =
                    hose_stop_h
                    + EPS * 2,

                d =
                    hose_stop_d
            );


        // ----------------------------------------------------
        // TRANSITION TO BSP SOCKET
        // ----------------------------------------------------

        translate([
            0,
            0,
            transition_z - EPS
        ])

            cylinder(
                h =
                    transition_h
                    + EPS * 2,

                d1 =
                    hose_stop_d,

                d2 =
                    socket_body_d
            );


        // ----------------------------------------------------
        // BSP SOCKET BODY
        // ----------------------------------------------------

        translate([
            0,
            0,
            socket_z - EPS
        ])

            cylinder(
                h =
                    socket_body_h
                    + EPS * 2,

                d =
                    socket_body_d
            );

    }
}


// ============================================================
// INTERNAL WATERWAY + BSP SOCKET
// ============================================================

module internal_cut()
{
    union()
    {

        // ----------------------------------------------------
        // CONSTANT 31 MM HOSE BARB BORE
        // ----------------------------------------------------

        translate([
            0,
            0,
            -1
        ])

            cylinder(
                h =
                    transition_z
                    + 1
                    + EPS,

                d =
                    barb_bore_d
            );


        // ----------------------------------------------------
        // INTERNAL FLOW TRANSITION
        //
        // 31 mm -> 46 mm
        // ----------------------------------------------------

        translate([
            0,
            0,
            transition_z - EPS
        ])

            cylinder(
                h =
                    transition_h
                    + socket_floor_h
                    + EPS * 2,

                d1 =
                    barb_bore_d,

                d2 =
                    seal_bore_d
            );


        // ----------------------------------------------------
        // GASKET RECESS
        // ----------------------------------------------------

        translate([
            0,
            0,
            seal_face_z
        ])

            cylinder(
                h =
                    gasket_recess_depth
                    + EPS,

                d =
                    gasket_recess_d
            );


        // ----------------------------------------------------
        // THREAD RUNOUT POCKET
        // ----------------------------------------------------

        translate([
            0,
            0,
            gasket_top_z - EPS
        ])

            cylinder(
                h =
                    thread_runout_h
                    + EPS * 2,

                d =
                    bsp_female_major_d
                    + 0.6
            );


        // ----------------------------------------------------
        // 2" BSP FEMALE THREAD
        // ----------------------------------------------------

        bsp_female_thread_cutter(

            z_start =
                thread_start_z,

            length =
                bsp_thread_length,

            minor_d =
                bsp_female_minor_d,

            major_d =
                bsp_female_major_d,

            pitch =
                bsp_pitch
        );


        // ----------------------------------------------------
        // THREAD ENTRY CHAMFER
        // ----------------------------------------------------

        translate([
            0,
            0,
            thread_end_z - EPS
        ])

            cylinder(
                h =
                    bsp_leadin_h
                    + EPS * 2,

                d1 =
                    bsp_female_minor_d,

                d2 =
                    bsp_mouth_d
            );


        // ----------------------------------------------------
        // ENSURE TOP IS OPEN
        // ----------------------------------------------------

        translate([
            0,
            0,
            socket_top_z - EPS
        ])

            cylinder(
                h = 1,

                d =
                    bsp_mouth_d
            );

    }
}


// ============================================================
// FINAL MODEL
// ============================================================

module adapter()
{
    difference()
    {

        adapter_outer();

        internal_cut();

    }
}


// ============================================================
// MODEL
// ============================================================

adapter();