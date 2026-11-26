/*
 Waveshare ESP32-S3-Touch-LCD-7 enclosure - REAR DOOR (V5)
 Standalone OpenSCAD model. No includes, imports or other files needed.
 This file generates ONLY the screw-fastened rear door with four
 integrated M3 screen mounting posts.

 Designed to match the V5 main-body OpenSCAD file supplied alongside it.
 All dimensions are in millimetres.

 IMPORTANT: glass-to-mount reference and hole-centre offsets were inferred
 from a third-party STL and remain UNVERIFIED against the physical screen.
 Perform dry fit and check screw length before installing a display.
*/

// --- Display mounting pattern (from supplied reference STL) ---
mount_pitch_x = 126.20;
mount_pitch_y = 65.65;
mount_offset_x = 1.485;  // Check direction/orientation on actual board
mount_offset_y = 0.975;
front_to_mount_ref = 15.50; // Estimate, NOT actual measured panel stack-up

// --- Geometry, shared with companion main body ---
case_w = 210;
case_h = 128;
case_corner_r = 8;
body_depth = 32;
front_lip = 2.6;
front_gasket_allowance = 0.5;
rear_door_thickness = 3.2;

// Face where display mounting points must land (assembly Z reference).
mount_face_z = front_lip + front_gasket_allowance + front_to_mount_ref;
mount_pillar_height = body_depth - mount_face_z;
mount_pillar_diameter = 10.6;
mount_pillar_base_diameter = 14.0;

// --- Case and display screws ---
door_screw_clearance_d = 3.5;
door_screw_head_d = 6.6;
door_screw_head_depth = 2.0;
screen_screw_clearance_d = 3.5;
screen_screw_head_d = 6.6;
screen_screw_head_depth = 2.0;

// --- Optional rear features ---
rear_ventilation = true;
rear_cable_passages = false;
rear_cable_width = 18;
rear_cable_height = 8;
rear_cable_y = 0;
rear_cable_x = [-76,76];

$fn = 56;
eps = 0.08;

function screen_mounts() = [for(x=[-1,1],y=[-1,1])
 [mount_offset_x+x*mount_pitch_x/2, mount_offset_y+y*mount_pitch_y/2]];

// These six fixing positions MUST match the separate main-body file.
function door_fixings() = [
 [-98.5,-57.5], [98.5,-57.5],
 [-98.5,57.5],  [98.5,57.5],
 [0,-58.5], [0,58.5]
];

module rr2d(w,h,r=2){
 assert(w>2*r && h>2*r);
 offset(r=r) square([w-2*r,h-2*r], center=true);
}
module rr3d(w,h,r,th){linear_extrude(height=th) rr2d(w,h,r);}


module rear_door(){
 difference(){
  union(){
   // Entire rear closes in ONE part. No separate rear frame/hatch/plates.
   rr3d(case_w,case_h,case_corner_r,rear_door_thickness);
   // Mounting pillars project from INSIDE of door towards front of screen.
   // Slightly wider feet reduce stress at the plate-to-pillar transition.
   for(p=screen_mounts()){
     translate([p[0],p[1],rear_door_thickness-eps])
       cylinder(d1=mount_pillar_base_diameter,
                d2=mount_pillar_diameter,h=2.0+eps);
     translate([p[0],p[1],rear_door_thickness+1.9])
       cylinder(d=mount_pillar_diameter,
                h=mount_pillar_height-1.9+eps);
   }
  }
  // Six case screws accessible from REAR with shallow head counterbores.
  for(p=door_fixings()){
    translate([p[0],p[1],-eps])
      cylinder(d=door_screw_clearance_d,h=rear_door_thickness+2*eps);
    translate([p[0],p[1],-eps])
      cylinder(d=door_screw_head_d,h=door_screw_head_depth+eps);
  }
  // Four display-to-door screws accessible from rear, passing through posts.
  for(p=screen_mounts()){
    translate([p[0],p[1],-eps])
      cylinder(d=screen_screw_clearance_d,
               h=rear_door_thickness+mount_pillar_height+2*eps);
    translate([p[0],p[1],-eps])
      cylinder(d=screen_screw_head_d,h=screen_screw_head_depth+eps);
  }
  if(rear_ventilation)
    for(yy=[-49.5,49.5],xx=[-76,-64,-52,-40,40,52,64,76])
      translate([xx,yy,-eps]) rr3d(6.0,2.4,1.0,rear_door_thickness+2*eps);
  if(rear_cable_passages)
    for(xx=rear_cable_x)
      translate([xx,rear_cable_y,-eps])
       rr3d(rear_cable_width,rear_cable_height,2,
            rear_door_thickness+2*eps);
 }
}


// Export (F6, File > Export > STL)
rear_door();
