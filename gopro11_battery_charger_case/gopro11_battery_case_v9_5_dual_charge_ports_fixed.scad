// GoPro HERO11 / HERO9-12 battery + dual charger storage case
// Parametric OpenSCAD model for FDM 3D printing
// Revision v9.5: v9 baseline + guaranteed matching charging-port oval on BOTH charger short faces
//
// Nominal battery size used: 40.7 x 33.6 x 13.0 mm
// Nominal GoPro ADDBD-211 dual charger size used: 42 x 50 x 32 mm
// Always replace these values with caliper measurements if you want a calibrated fit.

$fn = 48;

// ---------- USER PARAMETERS ----------
part = "both";          // "base", "lid", "both", or "assembled"
slots = 4;              // number of loose batteries

// Battery dimensions in mm
battery_long = 40.7;
battery_height = 33.6;
battery_thick = 13.0;

// Battery fit / print tuning
// 0.15 = very snug, 0.20 = snug, 0.25-0.30 = easier sliding fit
battery_clearance = 0.20;   // clearance on EACH side

// GoPro OEM dual-battery charger (ADDBD-211) dimensions in mm
charger_enabled = true;
charger_x = 42.0;
charger_y = 50.0;
charger_height = 32.0;
charger_clearance = 0.40;   // clearance on EACH side; slightly safer because published dimensions are rounded
charger_corner_radius = 3.0; // conservative pocket radius so the rounded OEM charger corners do not bind

// Charger cable/port access opening
charge_port_enabled = true;
charge_port_width = 7.0;         // horizontal size across charger short face
charge_port_height = 3.6;        // vertical oval height
charge_port_bottom_offset = 2.0; // lower edge of oval above charger base
charge_port_cut_extra = 0.50;    // ensures cutter fully enters charger pocket

// Case structure
lid_clearance = 0.30;       // clearance on EACH side between base and lid
wall = 2.4;
separator = 2.0;
compartment_divider = 2.4;  // divider between loose batteries and charger
floor_thickness = 2.2;
corner_radius = 3.0;

// Base deliberately leaves battery/charger tops exposed for easy removal
base_height = 26.0;

// Lid settings
lid_wall = 2.0;
lid_top = 2.2;
lid_overlap = 6.0;
lid_head_clearance = 1.0;

// Snap-detent lid retention
// v7: low-profile oval detents placed near the BOTTOM of the seated overlap.
// This lets the lid slide ~4.3 mm over the body before the snap starts to deflect.
snap_detents = true;
snap_rx = 3.20;             // half-width along the long sidewall
snap_ry = 1.00;             // half-depth normal to the sidewall
snap_rz = 0.65;             // low vertical profile for a gentle lead-in
snap_protrusion = 0.60;     // physical projection beyond body outside surface
snap_recess_xy_clearance = 0.15;
snap_recess_z_clearance = 0.07;
snap_center_above_lid_bottom = 1.00; // receiver centre in fitted lid, measured from lid lower edge
// Effective interference beyond normal lid clearance:
// snap_protrusion - lid_clearance = 0.30 mm

// Embossed lid text
lid_text_enabled = true;
lid_text = "GoPro";
lid_text_height = 1.0;  // raised lettering height
lid_text_size = 16;
lid_text_font = "Liberation Sans:style=Bold";

// Preview spacing when part="both"
layout_gap = 10;

// ---------- DERIVED DIMENSIONS ----------
battery_pocket_x = battery_long + 2*battery_clearance;
battery_pocket_y = battery_thick + 2*battery_clearance;
battery_pocket_z = battery_height + battery_clearance;

battery_section_y = 2*wall + slots*battery_pocket_y + (slots-1)*separator;

charger_pocket_x = charger_x + 2*charger_clearance;
charger_pocket_y = charger_y + 2*charger_clearance;
charger_pocket_z = charger_height + charger_clearance;
charger_section_y = charger_pocket_y + 2*wall;

// Overall base is a single rounded rectangle. The charger extends the case sideways.
base_x = charger_enabled
    ? wall + battery_pocket_x + compartment_divider + charger_pocket_x + wall
    : battery_pocket_x + 2*wall;
base_y = charger_enabled ? max(battery_section_y, charger_section_y) : battery_section_y;

// Centre both functional sections front-to-back within the common shell.
battery_y_start = (base_y - battery_section_y)/2 + wall;
charger_pocket_x0 = wall + battery_pocket_x + compartment_divider;
charger_pocket_y0 = (base_y - charger_pocket_y)/2;

battery_exposed = max(0, battery_height - (base_height - floor_thickness));
charger_exposed = charger_enabled
    ? max(0, charger_height - (base_height - floor_thickness))
    : 0;
max_stored_exposed = max(battery_exposed, charger_exposed);

lid_inner_h = max_stored_exposed + lid_overlap + lid_head_clearance;
lid_h = lid_top + lid_inner_h;

lid_inner_x = base_x + 2*lid_clearance;
lid_inner_y = base_y + 2*lid_clearance;
lid_outer_x = lid_inner_x + 2*lid_wall;
lid_outer_y = lid_inner_y + 2*lid_wall;

// Lid location when fitted on the base
lid_fit_offset_x = -(lid_wall + lid_clearance);
lid_fit_offset_y = -(lid_wall + lid_clearance);
lid_fit_offset_z = base_height - lid_overlap;

// Snap centres in BASE coordinates.
// The long sidewalls are Y=0 and Y=base_y.
// The snaps sit low in the overlap so the lid is already well located before snapping.
snap_y_embed = snap_ry - snap_protrusion;
detent_x = base_x/2;
detent_front_y = snap_y_embed;
detent_back_y  = base_y - snap_y_embed;
detent_z = lid_fit_offset_z + snap_center_above_lid_bottom;

// Matching receiver centres in LID-LOCAL coordinates are derived directly
// from the fitted-lid translation, so they coincide exactly when fully seated.
recess_front_x = detent_x       - lid_fit_offset_x;
recess_front_y = detent_front_y - lid_fit_offset_y;
recess_back_x  = detent_x       - lid_fit_offset_x;
recess_back_y  = detent_back_y  - lid_fit_offset_y;
recess_z       = detent_z       - lid_fit_offset_z;
recess_rx = snap_rx + snap_recess_xy_clearance;
recess_ry = snap_ry + snap_recess_xy_clearance;
recess_rz = snap_rz + snap_recess_z_clearance;

// Approximate lid insertion before first snap contact.
// The lid's lower edge reaches the top of the bump only after this much overlap.
snap_first_contact_overlap = base_height - (detent_z + snap_rz);

// Charging-port position. The charger rests on the case floor, so charger base Z
// is floor_thickness. The requested 3 mm is measured to the LOWER EDGE of the oval.
charge_port_x_center = charger_pocket_x0 + charger_pocket_x/2;
charge_port_z_bottom = floor_thickness + charge_port_bottom_offset;
charge_port_z_center = charge_port_z_bottom + charge_port_height/2;
// v9.5 dual-port cutter spans the full case depth in Y.
// This guarantees identical openings in both short outer walls.
charge_port_cut_y_start = -0.10;
charge_port_cut_depth = base_y + 0.20;

// ---------- HELPERS ----------
module rounded_box(size=[10,10,10], r=2) {
    x=size[0]; y=size[1]; z=size[2];
    rr = min(r, min(x,y)/2 - 0.01);
    linear_extrude(height=z)
        hull()
            for (ix=[rr, x-rr])
                for (iy=[rr, y-rr])
                    translate([ix,iy]) circle(r=rr);
}

module snap_ellipsoid(rx, ry, rz) {
    scale([rx, ry, rz]) sphere(r=1);
}

// 2D capsule/oval with exact overall width and height, centered at origin.
// For width >= height, this is two semicircular ends joined by a rectangle.
module oval_2d(w, h) {
    r = h/2;
    hull() {
        translate([-(w/2-r), 0]) circle(r=r);
        translate([ +(w/2-r), 0]) circle(r=r);
    }
}

// Cuts the selected charger short-face wall. Geometry is generated in X-Z
// then extruded through Y so the 4.5 x 2.0 mm oval remains dimensionally exact.
module charger_port_cut() {
    if (charger_enabled && charge_port_enabled) {
        // One continuous X-Z oval prism through the entire Y depth of the case.
        // The charger pocket is already hollow, so this only opens the two
        // opposing short walls and guarantees perfect front/back alignment.
        translate([charge_port_x_center, charge_port_cut_y_start, charge_port_z_center])
            rotate([-90,0,0])
                linear_extrude(height=charge_port_cut_depth, center=false)
                    oval_2d(charge_port_width, charge_port_height);
    }
}

module battery_pocket() {
    cube([battery_pocket_x, battery_pocket_y, battery_pocket_z + 2]);
}

module charger_pocket() {
    rounded_box([charger_pocket_x, charger_pocket_y, charger_pocket_z + 2],
                charger_corner_radius);
}

module snap_bumps() {
    if (snap_detents) {
        // Front long side: shallow rounded oval protrusion
        translate([detent_x, detent_front_y, detent_z])
            snap_ellipsoid(snap_rx, snap_ry, snap_rz);
        // Back long side
        translate([detent_x, detent_back_y, detent_z])
            snap_ellipsoid(snap_rx, snap_ry, snap_rz);
    }
}

module embossed_lid_text() {
    if (lid_text_enabled) {
        translate([lid_outer_x/2, lid_outer_y/2, lid_h - 0.01])
            linear_extrude(height=lid_text_height + 0.01)
                text(lid_text,
                     size=lid_text_size,
                     font=lid_text_font,
                     halign="center",
                     valign="center");
    }
}

module base_shell() {
    difference() {
        rounded_box([base_x, base_y, base_height], corner_radius);

        // Four snug loose-battery pockets
        for (i=[0:slots-1]) {
            y0 = battery_y_start + i*(battery_pocket_y + separator);
            translate([wall, y0, floor_thickness])
                battery_pocket();
        }

        // OEM dual-charger storage bay
        if (charger_enabled) {
            translate([charger_pocket_x0, charger_pocket_y0, floor_thickness])
                charger_pocket();
        }

        // Centered oval access opening for the charger's port on its short face.
        charger_port_cut();

        // Finger scallops on the battery side. The inner scallops notch the
        // upper edge of the battery/charger divider without merging the bays.
        for (i=[0:slots-1]) {
            yc = battery_y_start + battery_pocket_y/2 + i*(battery_pocket_y + separator);

            // Outer battery-side wall
            translate([-0.1, yc, base_height])
                rotate([0,90,0]) cylinder(h=wall+0.3, r=5.5, center=false);

            // Divider side of the battery pockets
            if (charger_enabled)
                translate([wall+battery_pocket_x-0.15, yc, base_height])
                    rotate([0,90,0]) cylinder(h=compartment_divider+0.30, r=5.5, center=false);
            else
                translate([base_x-wall-0.2, yc, base_height])
                    rotate([0,90,0]) cylinder(h=wall+0.4, r=5.5, center=false);
        }
    }
}

module base_part() {
    union() {
        base_shell();
        snap_bumps();
    }
}

module lid_shell() {
    difference() {
        rounded_box([lid_outer_x, lid_outer_y, lid_h], corner_radius + lid_wall);

        // Interior opens from the bottom; top thickness remains lid_top.
        translate([lid_wall, lid_wall, -0.1])
            rounded_box([lid_inner_x, lid_inner_y, lid_h - lid_top + 0.1],
                        max(0.8, corner_radius + lid_clearance));

        if (snap_detents) {
            // Matching low-profile oval receivers.  Their centres match
            // the body detents only at the fully seated lid position.
            translate([recess_front_x, recess_front_y, recess_z])
                snap_ellipsoid(recess_rx, recess_ry, recess_rz);
            translate([recess_back_x, recess_back_y, recess_z])
                snap_ellipsoid(recess_rx, recess_ry, recess_rz);
        }
    }
}

module lid_part() {
    union() {
        lid_shell();
        embossed_lid_text();
    }
}

module assembled() {
    base_part();
    translate([lid_fit_offset_x, lid_fit_offset_y, lid_fit_offset_z])
        lid_part();
}

// ---------- OUTPUT ----------
if (part == "base") {
    base_part();
}
else if (part == "lid") {
    lid_part();
}
else if (part == "assembled") {
    assembled();
}
else {
    base_part();
    translate([base_x + layout_gap, 0, 0]) lid_part();
}

// Useful dimensions shown in the OpenSCAD console
echo("BASE outside (mm)", [base_x, base_y, base_height]);
echo("LID outside incl. embossed text (mm)", [lid_outer_x, lid_outer_y, lid_h + lid_text_height]);
echo("Battery pocket XYZ (mm)", [battery_pocket_x, battery_pocket_y, battery_pocket_z]);
echo("Charger pocket XYZ (mm)", [charger_pocket_x, charger_pocket_y, charger_pocket_z]);
echo("Battery exposed above base (mm)", battery_exposed);
echo("Charger exposed above base (mm)", charger_exposed);
echo("Snap physical protrusion beyond base wall (mm)", snap_protrusion);
echo("Snap engagement beyond lid clearance (mm)", snap_protrusion-lid_clearance);
echo("Lid overlap before first snap contact (mm)", snap_first_contact_overlap);
echo("Snap receiver centre above lid bottom (mm)", recess_z);
echo("Front snap BASE centre (mm)", [detent_x, detent_front_y, detent_z]);
echo("Front receiver when lid fitted (mm)", [recess_front_x+lid_fit_offset_x, recess_front_y+lid_fit_offset_y, recess_z+lid_fit_offset_z]);
echo("Back snap BASE centre (mm)", [detent_x, detent_back_y, detent_z]);
echo("Back receiver when lid fitted (mm)", [recess_back_x+lid_fit_offset_x, recess_back_y+lid_fit_offset_y, recess_z+lid_fit_offset_z]);
echo("Embossed lid text height (mm)", lid_text_height);
echo("Charge port oval WH (mm)", [charge_port_width, charge_port_height]);
echo("Charge ports", "both short faces - single through-axis cutter");
echo("Charge port lower edge above charger base (mm)", charge_port_bottom_offset);
echo("Front charge port centre BASE XYZ (mm)", [charge_port_x_center, 0, charge_port_z_center]);
echo("Back charge port centre BASE XYZ (mm)", [charge_port_x_center, base_y, charge_port_z_center]);
