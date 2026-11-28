// Connection board enclosure | external snap-fit revision | all dimensions in mm
// Open in OpenSCAD. Select part: layout, base, lid, assembled.
// Both cable slots open upwards; matching lid tongues close them.
// The lid is printed upside down (exterior face on the print bed).

/* [Output] */
part = "layout"; // [layout,base,lid,assembled,interference]
$fn = 64;

/* [Enclosure] */
internal_length = 91; // 90 mm board plus 1 mm total clearance
internal_width = 26;
internal_height = 15;
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
rail_height = 1; // board underside above inside floor; estimated
rail_inset = 0.8; // rail extends this far into cavity
rail_end_gap = 8; // avoid ties and wires at ends

/* [External snap clips] */
// Four outside spring arms engage raised catches on the base.
// No screws, holes, inserts or loss of internal clearance.
clip_end_offset = 13;
clip_width = 10;
clip_arm_thickness = 1.4;
clip_wall_gap = 1.00; // free clearance between arm and body
clip_tip_z = 2.2; // bottom of arm, above outside base floor
clip_hook_depth = 0.80; // inward projection from arm inner face
clip_hook_start_z = 3.0; // start of lead-in ramp
clip_hook_peak_z = 3.9;
clip_hook_return_z = 4.75; // printable upper hook slope
catch_projection = 0.85;
catch_bottom_z = 4.15;
catch_lower_ramp = 0.65;
catch_flat_height = 0.50;
catch_upper_ramp = 1.35;
catch_side_clearance = 0.5; // each end of catch narrower than arm
clip_root_overlap = 1.0; // how far lid bridge overlaps body
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
assert(clip_end_offset-clip_width/2 > corner_radius &&
       2*clip_end_offset+clip_width < L);
assert(clip_arm_thickness > 0 && clip_wall_gap > clip_hook_depth && clip_hook_depth > 0);
assert(catch_projection <= clip_wall_gap &&
       catch_projection > clip_wall_gap-clip_hook_depth,
       "Catch must overlap hook but clear the relaxed arm");
assert(clip_tip_z >= 0 && clip_tip_z < clip_hook_start_z &&
       clip_hook_start_z < clip_hook_peak_z && clip_hook_peak_z < clip_hook_return_z);
assert(clip_hook_return_z < B-2 && catch_bottom_z > clip_hook_peak_z);
assert(catch_lower_ramp > 0 && catch_flat_height > 0 && catch_upper_ramp > 0);
assert(catch_bottom_z+catch_lower_ramp+catch_flat_height+catch_upper_ramp < B);
assert(clip_width > 2*catch_side_clearance && clip_root_overlap > 0 && clip_root_overlap <= wall);
// Check that relaxed hook and catch do not intersect at full closure.
// Both profiles are linear in the only possible overlap region.
assert(clip_hook_return_z <= catch_bottom_z ||
       (catch_projection/catch_lower_ramp)*
       max(0,min(catch_lower_ramp,clip_hook_return_z-catch_bottom_z)) <= clip_wall_gap,
       "Adjust hook/catch heights to avoid assembled interference");
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

// Profile coordinates are [outward distance from side wall, assembled Z].
// Extrusion runs along X; mirror the near-side mechanism onto far side.
module side_profile(x, width, points) {
    translate([x+width/2,0,0])
        rotate([0,-90,0]) rotate([0,0,-90])
            linear_extrude(height=width,convexity=4) polygon(points);
}
module side_pair() {
    children();
    translate([0,W,0]) mirror([0,1,0]) children();
}
module base_catches() {
    for(x=[clip_end_offset,L-clip_end_offset]) side_pair()
        side_profile(x,clip_width-2*catch_side_clearance,[
            [-eps,catch_bottom_z],
            [0,catch_bottom_z],
            [catch_projection,catch_bottom_z+catch_lower_ramp],
            [catch_projection,catch_bottom_z+catch_lower_ramp+catch_flat_height],
            [0,catch_bottom_z+catch_lower_ramp+catch_flat_height+catch_upper_ramp],
            [-eps,catch_bottom_z+catch_lower_ramp+catch_flat_height+catch_upper_ramp]
        ]);
}
module lid_clips() {
    u=clip_wall_gap;
    o=u+clip_arm_thickness;
    for(x=[clip_end_offset,L-clip_end_offset]) side_pair()
        side_profile(x,clip_width,[
            [-clip_root_overlap,B],
            [u,B],
            [u,clip_hook_return_z],
            [u-clip_hook_depth,clip_hook_peak_z],
            [u,clip_hook_start_z],
            [u,clip_tip_z],
            [o-0.25,clip_tip_z],
            [o,clip_tip_z+0.3],
            [o,H],
            [-clip_root_overlap,H]
        ]);
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
                rounded_body(B);
                translate([wall,wall,floor_thickness])
                    cube([internal_length,internal_width,internal_height+eps]);
            }
            support_rails();
            base_catches();
        }
        cable_slot(true,left_y,left_z,left_r);
        cable_slot(false,right_y,right_z,right_r);
    }
}

module lid_assembled() {
    union() {
        translate([0,0,B]) rounded_body(lid_thickness);
        cable_tongue(true,left_y,left_z,left_r);
        cable_tongue(false,right_y,right_z,right_r);
        lid_clips();
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
else if(part=="interference") intersection() { base(); lid_assembled(); }
else if(part=="layout") {
    base();
    translate([0,W+2*(clip_wall_gap+clip_arm_thickness)+print_spacing,0]) lid_print();
}
else assert(false,"Unknown part selection");
