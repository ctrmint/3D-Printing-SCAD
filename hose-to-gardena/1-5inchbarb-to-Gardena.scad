// ============================================================
// 39.6 MM HOSE -> GARDENA-STYLE MALE QUICK CONNECT
// One-piece printable adapter
// Units: mm
//
// HOSE MEASURED ID:
//      39.6 mm
//
// REDESIGNED BARB:
//      Maximum crest OD = 39.8 mm
//      Root OD          = 37.8 mm
//      Lead-in OD       = 36.5 mm
//
// Gardena mating profile reconstructed from supplied STL:
//      "obj_2_IBC Gardena Std.stl"
//
// ============================================================


// ============================================================
// SURFACE QUALITY
// ============================================================

$fn = 240;


// ============================================================
// HOSE BARB
// ============================================================

hose_measured_id = 39.6;


// ------------------------------------------------------------
// BARB OUTSIDE DIAMETERS
// ------------------------------------------------------------

// Easy insertion lead-in

barb_tip_d = 36.5;


// Diameter between barb teeth

barb_root_d = 37.8;


// ABSOLUTE MAXIMUM BARB DIAMETER

barb_peak_d = 39.8;


// ------------------------------------------------------------
// BARB LENGTH
// ------------------------------------------------------------

// Full requested hose engagement length

barb_total_length = 44;


// Five complete barb teeth

barb_count = 5;


// Each barb occupies the complete available length

barb_pitch =
    barb_total_length
    / barb_count;


// Maintain the previous tooth proportions

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


// Initial tapered insertion section

barb_tip_h = 4.0;


// ============================================================
// HOSE STOP
// ============================================================

hose_stop_d = 44.0;

hose_stop_h = 4.0;


// ============================================================
// TRANSITION TO GARDENA
// ============================================================

transition_h = 14.0;


// Gardena reference profile starts at 20 mm OD

transition_top_d = 20.0;


// ============================================================
// INTERNAL WATERWAY
// ============================================================

// Constant bore through complete hose barb.
//
// This gives:
//
// Root wall:
// (37.8 - 31) / 2 = 3.4 mm
//
// Peak wall:
// (39.8 - 31) / 2 = 4.4 mm
//

barb_bore_d = 31.0;


// Reference Gardena main bore

gardena_bore_d = 9.0;


// Tip flare from supplied reference

gardena_tip_bore_d = 10.0;

gardena_tip_bore_flare_h = 0.5;


// Gardena profile length

gardena_profile_length = 20.75;


// Small overlap to avoid coincident surfaces

EPS = 0.05;


// ============================================================
// DERIVED POSITIONS
// ============================================================

barb_end_z =
    barb_tip_h
    + barb_total_length;


stop_z =
    barb_end_z;


transition_z =
    stop_z
    + hose_stop_h;


gardena_z =
    transition_z
    + transition_h;


gardena_tip_flare_z =
    gardena_z
    + gardena_profile_length
    - gardena_tip_bore_flare_h;


// ============================================================
// HOSE BARB
// ============================================================

module hose_barb_outer()
{
    union()
    {

        // ====================================================
        // LEAD-IN
        // ====================================================

        cylinder(
            h = barb_tip_h + EPS,

            d1 = barb_tip_d,
            d2 = barb_root_d
        );


        // ====================================================
        // BARB CORE
        // ====================================================

        translate([
            0,
            0,
            barb_tip_h - EPS
        ])

            cylinder(
                h =
                    barb_total_length
                    + EPS * 2,

                d = barb_root_d
            );


        // ====================================================
        // FIVE COMPLETE BARBS
        // ====================================================

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


            // ------------------------------------------------
            // GRADUAL OUTWARD RAMP
            // ------------------------------------------------

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


            // ------------------------------------------------
            // RETURN TO ROOT
            // ------------------------------------------------

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
// GARDENA MALE CONNECTOR
// ============================================================
//
// Rotational profile reconstructed from the supplied
// reference STL.
//
// Approximate extracted dimensions:
//
// Base:
//      20.0 mm
//
// Neck:
//      14.0 mm
//
// Locking collar:
//      17.0 mm
//
// Seal land:
//      15.6 mm
//
// O-ring groove root:
//      11.6 mm
//
// Nose:
//      15.8 mm
//
// Main bore:
//      9.0 mm
//
// Tip bore:
//      10.0 mm
//
// ============================================================

module gardena_reference_outer()
{

    profile = [

        // ====================================================
        // BASE
        // ====================================================

        [0.0000, 0.0000],

        [10.0000, 0.0000],


        // ====================================================
        // CURVED REDUCTION TO 14 MM NECK
        // ====================================================

        [9.3743, 0.6716],
        [8.8134, 1.3976],
        [8.3215, 2.1720],
        [7.9026, 2.9883],
        [7.5603, 3.8394],
        [7.2974, 4.7184],
        [7.1162, 5.6178],
        [7.0182, 6.5300],
        [6.9995, 7.1414],


        // ====================================================
        // 14 MM NECK
        // ====================================================

        [6.9983, 9.4000],


        // ====================================================
        // 17 MM LOCKING COLLAR
        // ====================================================

        [8.4996, 9.4000],

        [8.4999, 11.4000],


        // ====================================================
        // ROUNDED COLLAR RETURN
        // ====================================================

        [8.3162, 11.5041],
        [8.0829, 11.7158],
        [7.9617, 11.8877],
        [7.8405, 12.1785],
        [7.7994, 12.4909],


        // ====================================================
        // 15.6 MM LAND
        // ====================================================

        [7.7977, 14.4000],


        // ====================================================
        // ROUNDED ENTRY TO O-RING GROOVE
        // ====================================================

        [6.7018, 14.4048],
        [6.4171, 14.4761],
        [6.1654, 14.6270],
        [6.0246, 14.7686],
        [5.8759, 15.0173],
        [5.8046, 15.3020],


        // ====================================================
        // 11.6 MM O-RING GROOVE ROOT
        // ====================================================

        [5.8046, 16.6980],


        // ====================================================
        // ROUNDED EXIT FROM O-RING GROOVE
        // ====================================================

        [5.8759, 16.9827],
        [5.9684, 17.1556],
        [6.0927, 17.3071],
        [6.3284, 17.4819],
        [6.6047, 17.5808],
        [6.7998, 17.6000],


        // ====================================================
        // 15.8 MM NOSE
        // ====================================================

        [7.8977, 17.6000],

        [7.8992, 19.2500],


        // ====================================================
        // ROUNDED INSERTION TIP
        // ====================================================

        [7.8804, 19.4847],
        [7.8255, 19.7135],
        [7.7354, 19.9310],
        [7.5637, 20.1935],
        [7.3731, 20.3906],
        [7.1827, 20.5290],
        [6.8626, 20.6766],
        [6.6337, 20.7315],
        [6.3991, 20.7500],


        // ====================================================
        // RETURN TO AXIS
        // ====================================================

        [0.0000, 20.7500]

    ];


    translate([
        0,
        0,
        gardena_z - EPS
    ])

        rotate_extrude(
            convexity = 10
        )

            polygon(
                points = profile
            );
}


// ============================================================
// COMPLETE OUTER BODY
// ============================================================

module adapter_outer()
{
    union()
    {

        // ====================================================
        // HOSE BARB
        // ====================================================

        hose_barb_outer();


        // ====================================================
        // HOSE STOP FLANGE
        // ====================================================

        translate([
            0,
            0,
            stop_z - EPS
        ])

            cylinder(
                h =
                    hose_stop_h
                    + EPS * 2,

                d = hose_stop_d
            );


        // ====================================================
        // REDUCING TRANSITION
        // ====================================================

        translate([
            0,
            0,
            transition_z - EPS
        ])

            cylinder(
                h =
                    transition_h
                    + EPS * 2,

                d1 = hose_stop_d,
                d2 = transition_top_d
            );


        // ====================================================
        // GARDENA CONNECTOR
        // ====================================================

        gardena_reference_outer();

    }
}


// ============================================================
// INTERNAL WATERWAY
// ============================================================

module waterway()
{
    union()
    {

        // ====================================================
        // CONSTANT 31 MM BORE THROUGH HOSE BARB
        // ====================================================

        translate([
            0,
            0,
            -1
        ])

            cylinder(
                h =
                    stop_z
                    + hose_stop_h
                    + 1
                    + EPS,

                d = barb_bore_d
            );


        // ====================================================
        // REDUCTION THROUGH TRANSITION
        //
        // 31 mm -> 9 mm
        // ====================================================

        translate([
            0,
            0,
            transition_z - EPS
        ])

            cylinder(
                h =
                    transition_h
                    + EPS * 2,

                d1 = barb_bore_d,
                d2 = gardena_bore_d
            );


        // ====================================================
        // 9 MM GARDENA BORE
        // ====================================================

        translate([
            0,
            0,
            gardena_z - EPS
        ])

            cylinder(
                h =
                    gardena_profile_length
                    + EPS * 2,

                d = gardena_bore_d
            );


        // ====================================================
        // FINAL 0.5 MM TIP FLARE
        //
        // 9 mm -> 10 mm
        // ====================================================

        translate([
            0,
            0,
            gardena_tip_flare_z - EPS
        ])

            cylinder(
                h =
                    gardena_tip_bore_flare_h
                    + EPS * 2,

                d1 = gardena_bore_d,
                d2 = gardena_tip_bore_d
            );


        // ====================================================
        // ENSURE TIP IS COMPLETELY OPEN
        // ====================================================

        translate([
            0,
            0,
            gardena_z
            + gardena_profile_length
            - EPS
        ])

            cylinder(
                h = 1,

                d = gardena_tip_bore_d
            );

    }
}


// ============================================================
// FINAL ADAPTER
// ============================================================

module adapter()
{
    difference()
    {

        adapter_outer();

        waterway();

    }
}


// ============================================================
// MODEL
// ============================================================

adapter();