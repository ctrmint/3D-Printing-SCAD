// Connection board enclosure | all dimensions in mm
// Open in OpenSCAD. Select part: layout, base, lid, assembled.
// Both cable slots open upwards; matching lid tongues close them.
// The lid is printed upside down (exterior face on the print bed).

/* [Output] */
part = "layout"; // [layout,base,lid,assembled]
$fn = 64;

/* [Enclosure] */
internal_length = 91; // 90 mm board plus 1 mm total clearance
internal_width = 23;
internal_height = 11;
wall = 2;
floor_thickness = 2;
lid_thickness = 2;
corner_radius = 2.5;

/* [Left cable] */
left_diameter = 8;
left_clearance = 0.5; // added to diameter, not per side
left_y = 14; // centre from cavity long edge; 10 mm + 8/2
left_z = 6.5; // centre above inside floor; estimated, adjust to suit

/* [Right cable] */
right_diameter = 2;
right_clearance = 0.5;
right_y = 11.5; // centre from same cavity long edge; assumed centred
right_z = 4.5; // centre above inside floor; estimated

/* [Board support] */
rail_height = 2; // board underside above inside floor; estimated
rail_inset = 0.8; // rail extends this far into cavity
rail_end_gap = 8; // avoid ties and wires at ends

/* [Lid fixing] */
// External screw ears preserve the full internal width.
// Designed for M2.5 self-tapping screws for plastic, ~6-8 mm long.
ear_radius = 3.3;
ear_offset = 1.8; // ear centre outside body edge
screw_end_offset = 13;
pilot_diameter = 2.1;
pilot_depth = 7;
screw_clearance = 2.8;
head_diameter = 4.8;
head_recess_depth = 0.9; // conical recess for countersunk screws; 0 disables
slot_fit = 0.20; // clearance each side of lid tongue
plug_inside_extension = 0.30;
print_spacing = 10;

/* [Hidden] */
L = internal_length + 2*wall;
W = internal_width + 2*wall;
B = floor_thickness + internal_height;
H = B + lid_thickness;
eps = 0.02;
left_r = (left_diameter+left_clearance)/2;
right_r = (right_diameter+right_clearance)/2;

assert(wall >= 1.5 && floor_thickness > 0 && lid_thickness > 0);
assert(corner_radius >= 0 && corner_radius <= wall+0.5);
assert(rail_height > 0 && rail_height < internal_height);
assert(rail_end_gap >= 0 && 2*rail_end_gap < internal_length);
assert(pilot_depth > 0 && pilot_depth < B-floor_thickness);
assert(ear_offset < ear_radius && screw_clearance < 2*ear_radius);
assert(head_recess_depth >= 0 && head_recess_depth < lid_thickness);
for (c = [[left_y,left_z,left_r],[right_y,right_z,right_r]]) {
    assert(c[0]-c[2] > 0 && c[0]+c[2] < internal_width,
        "Cable opening must fit inside cavity width");
    assert(c[1]-c[2] >= 0 && c[1]+c[2] <= internal_height,
        "Cable opening must fit within internal height; adjust cable_z");
    assert(c[2] > slot_fit);
}

module rounded_body(h) {
    linear_extrude(height=h)
        if (corner_radius > 0)
            translate([corner_radius,corner_radius])
                offset(r=corner_radius)
                    square([L-2*corner_radius,W-2*corner_radius]);
        else square([L,W]);
}

module ear_positions() {
    for (x=[screw_end_offset,L-screw_end_offset],
         y=[-ear_offset,W+ear_offset]) translate([x,y,0]) children();
}

module shell_outline(h) {
    union() {
        rounded_body(h);
        ear_positions() cylinder(h=h,r=ear_radius);
    }
}

// X-axis cylinder for cable opening.
module x_cylinder(x,y,z,len,r) {
    translate([x,y,z]) rotate([0,90,0]) cylinder(h=len,r=r);
}

// A U-shaped cut, open to the top of the base.
module cable_slot(left,y,z,r) {
    x = left ? -eps : L-wall-eps;
    yy = wall+y;
    zz = floor_thickness+z;
    len = wall+2*eps;
    union() {
        x_cylinder(x,yy,zz,len,r);
        translate([x,yy-r,zz]) cube([len,2*r,B-zz+eps]);
    }
}

// Lid tongue drops into the U-slot, with a concave lower edge.
// This traps the cable in a round opening without clamping it.
module cable_tongue(left,y,z,r) {
    x = left ? 0 : L-wall-plug_inside_extension;
    len = wall+plug_inside_extension;
    yy = wall+y;
    zz = floor_thickness+z;
    difference() {
        translate([x,yy-r+slot_fit,zz])
            cube([len,2*(r-slot_fit),B-zz+eps]);
        x_cylinder(x-eps,yy,zz,len+2*eps,r);
    }
}

module support_rails() {
    for(y=[wall-eps,W-wall-rail_inset])
        translate([wall+rail_end_gap,y,floor_thickness-eps])
            cube([internal_length-2*rail_end_gap,
                  rail_inset+eps,rail_height+eps]);
}

module base() {
    difference() {
        union() {
            difference() {
                shell_outline(B);
                translate([wall,wall,floor_thickness])
                    cube([internal_length,internal_width,internal_height+eps]);
            }
            support_rails();
        }
        cable_slot(true,left_y,left_z,left_r);
        cable_slot(false,right_y,right_z,right_r);
        ear_positions() translate([0,0,B-pilot_depth])
            cylinder(h=pilot_depth+eps,d=pilot_diameter);
    }
}

module lid_assembled() {
    difference() {
        union() {
            translate([0,0,B]) shell_outline(lid_thickness);
            cable_tongue(true,left_y,left_z,left_r);
            cable_tongue(false,right_y,right_z,right_r);
        }
        ear_positions() translate([0,0,B-eps])
            cylinder(h=lid_thickness+2*eps,d=screw_clearance);
        if(head_recess_depth>0)
            ear_positions() translate([0,0,H-head_recess_depth])
                cylinder(h=head_recess_depth+eps,d1=screw_clearance,d2=head_diameter);
    }
}

module lid_print() {
    translate([0,W,H]) rotate([180,0,0]) lid_assembled();
}

if(part=="base") base();
else if(part=="lid") lid_print();
else if(part=="assembled") {
    color("SlateGray") base();
    color("LightSteelBlue",0.65) lid_assembled();
}
else if(part=="layout") {
    base();
    translate([0,W+2*(ear_offset+ear_radius)+print_spacing,0]) lid_print();
}
else assert(false,"Unknown part selection");
