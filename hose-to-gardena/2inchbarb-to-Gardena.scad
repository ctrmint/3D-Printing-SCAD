// ============================================================
// 2" HOSE BARB -> GARDENA-STYLE MALE QUICK CONNECT
// One-piece printable adapter
// Units: mm
//
// REVISION:
// - 2" hose barb extended by 10 mm
// - Five complete barbs over full hose engagement length
// - Smooth $fn = 240 geometry
// - Gardena mating profile reconstructed from supplied STL:
//      "obj_2_IBC Gardena Std.stl"
// - Gardena main internal bore = 9.0 mm
// - Final 0.5 mm of Gardena tip flares from 9.0 to 10.0 mm
// ============================================================


// ============================================================
// SURFACE QUALITY
// ============================================================

$fn = 240;


// ============================================================
// 2" HOSE BARB
// ============================================================
//
// Intended for approximately 2" / 50.8 mm internal-diameter hose.
//

hose_id = 50.8;


// Outside diameters

barb_tip_d  = 48.0;
barb_root_d = 50.4;
barb_peak_d = 54.5;


// Original barb section = 34 mm
// Additional requested length = 10 mm

barb_original_length = 34;
barb_extension       = 10;

barb_total_length =
    barb_original_length
    + barb_extension;


// Five complete barbs over the full 44 mm length

barb_count = 5;

barb_pitch =
    barb_total_length
    / barb_count;


// Maintain approximately the original tooth proportions

barb_ramp_ratio = 6.5 / 8.5;
barb_drop_ratio = 2.0 / 8.5;

barb_ramp_h =
    barb_pitch
    * barb_ramp_ratio;

barb_drop_h =
    barb_pitch
    * barb_drop_ratio;


// Hose insertion lead-in

barb_tip_h = 4.0;


// ============================================================
// HOSE STOP / MAIN TRANSITION
// ============================================================

hose_stop_d = 59.0;
hose_stop_h = 4.0;


// Transition from 2" hose barb to Gardena fitting

transition_h = 14.0;


// Reference Gardena profile begins at approximately 20 mm OD

transition_top_d = 20.0;


// ============================================================
// INTERNAL WATERWAY
// ============================================================

// Hose-end internal bore

barb_bore_d = 40.0;


// Reference Gardena connector main internal bore

gardena_bore_d = 9.0;


// Reference STL has a small flare at the very end

gardena_tip_bore_d = 10.0;

gardena_tip_bore_flare_h = 0.5;


// Gardena profile length reconstructed from STL

gardena_profile_length = 20.75;


// Small overlap to avoid coincident surfaces

EPS = 0.05;


// ============================================================
// DERIVED POSITIONS
// ============================================================

// End of complete hose barb section

barb_end_z =
    barb_tip_h
    + barb_total_length;


// Hose-stop position

stop_z =
    barb_end_z;


// Main transition position

transition_z =
    stop_z
    + hose_stop_h;


// Gardena fitting starts here

gardena_z =
    transition_z
    + transition_h;


// Start of the final internal tip flare

gardena_tip_flare_z =
    gardena_z
    + gardena_profile_length
    - gardena_tip_bore_flare_h;


// ============================================================
// 2" HOSE BARB
// ============================================================

module hose_barb_outer()
{
    union()
    {

        // ----------------------------------------------------
        // HOSE LEAD-IN
        // ----------------------------------------------------

        cylinder(
            h  = barb_tip_h + EPS,
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

                d = barb_root_d
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
            // RETURN FROM BARB PEAK TO ROOT
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
// This rotational profile is reconstructed from the supplied
// reference STL.
//
// Main measured / extracted dimensions:
//
// Base diameter:
//      approximately 20.0 mm
//
// Neck:
//      approximately 14.0 mm OD
//
// Locking collar:
//      approximately 17.0 mm OD
//      approximately 2.0 mm long
//
// Seal land:
//      approximately 15.6 mm OD
//
// O-ring groove root:
//      approximately 11.6 mm OD
//
// Nose:
//      approximately 15.8 mm OD
//
// Overall mating profile:
//      approximately 20.75 mm
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
        // CURVED COLLAR RETURN
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
        // 2" HOSE BARB
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
        // REINFORCED REDUCTION
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
        // REFERENCE GARDENA CONNECTOR
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
        // HOSE-END BORE
        //
        // Smoothly reduces from 40 mm at the hose end
        // to 9 mm at the Gardena fitting.
        // ====================================================

        translate([
            0,
            0,
            -1
        ])

            cylinder(
                h =
                    gardena_z
                    + 2,

                d1 = barb_bore_d,
                d2 = gardena_bore_d
            );


        // ====================================================
        // 9 MM MAIN GARDENA BORE
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
        // FINAL INTERNAL TIP FLARE
        //
        // Reference STL:
        //
        // 9.0 mm bore
        // expands to
        // 10.0 mm bore
        //
        // over final 0.5 mm.
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
        // TINY EXTENSION THROUGH TIP
        //
        // Ensures subtraction fully opens the end face.
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