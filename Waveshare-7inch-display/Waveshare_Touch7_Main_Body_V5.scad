/*
 Waveshare ESP32-S3-Touch-LCD-7 enclosure - MAIN BODY (V5)
 Standalone OpenSCAD model. No includes, imports or other files needed.
 This file generates ONLY the front bezel + integrated side-wall enclosure.

 Designed to match the V5 rear-door OpenSCAD file supplied alongside it.
 All dimensions are in millimetres.

 NOTE: Mounting references, port positions and depths remain prototype values.
 Test against actual display before committing to a final print.
*/

// --- Glass and viewable opening ---
glass_w = 192.96;
glass_h = 110.76;
active_w = 154.88;
active_h = 86.72;
active_y = -1.02;

// --- Body dimensions ---
case_w = 210;
case_h = 128;
case_corner_r = 8;
body_depth = 32;
front_lip = 2.6;
glass_clearance_per_side = 0.6;
glass_corner_r = 5;
window_margin = 3;

// --- Door insert bores (matching companion rear door) ---
// Verify the pilot diameter against your specific M3 heat-set inserts.
insert_pilot_d = 4.3;
insert_depth = 6.2;
insert_boss_d = 11.0;
insert_boss_height = 8.5;

// --- Side wall access slots (provisional Y positions) ---
left_uart2_y = 23.5;
left_usb_uart1_y = 2.0;
left_usb_native_y = -19.5;
right_sensor_y = 27.0;
right_can_y = 11.0;
right_i2c_y = -5.0;
right_rs485_y = -21.0;
left_uart2_span = 11;
left_usb_span = 16.5;
right_bus_span = 12.7;
port_z_near_front = 9;
port_z_near_rear = body_depth + 0.7;
port_radius = 1.8;

$fn = 56;
eps = 0.08;

// These six fixing positions MUST match the separate rear-door file.
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


// Slot normal to the case's LEFT/RIGHT side wall, not just the rear door.
module side_slot(side,cy,span){
 x=side<0 ? -case_w/2-1 : case_w/2+1;
 ang=side<0 ? 90 : -90;
 translate([x,cy,(port_z_near_front+port_z_near_rear)/2])
  rotate([0,ang,0])
   linear_extrude(height=18)
    rr2d(port_z_near_rear-port_z_near_front,span,port_radius);
}
module cut_side_ports(){
 side_slot(-1,left_uart2_y,left_uart2_span);
 side_slot(-1,left_usb_uart1_y,left_usb_span);
 side_slot(-1,left_usb_native_y,left_usb_span);
 side_slot(+1,right_sensor_y,right_bus_span);
 side_slot(+1,right_can_y,right_bus_span);
 side_slot(+1,right_i2c_y,right_bus_span);
 side_slot(+1,right_rs485_y,right_bus_span);
}


module main_body(){
 difference(){
  union(){
   // Screen pocket is rear-loaded. Front lip overlaps GLASS bezel,
   // not the active pixel area; internal glass fit remains adjustable.
   difference(){
    rr3d(case_w,case_h,case_corner_r,body_depth);
    translate([0,0,front_lip])
      rr3d(glass_w+2*glass_clearance_per_side,
           glass_h+2*glass_clearance_per_side,
           glass_corner_r+glass_clearance_per_side,
           body_depth-front_lip+eps);
    translate([0,active_y,-eps])
      rr3d(active_w+2*window_margin,
           active_h+2*window_margin,2,front_lip+2*eps);
   }
   // Strengthen blind M3 insert holes using collars at REAR of body only.
   // Clip collars to case outer outline, so the outer dimensions stay fixed.
   intersection(){
    rr3d(case_w,case_h,case_corner_r,body_depth);
    union() for(p=door_fixings())
      translate([p[0],p[1],body_depth-insert_boss_height])
       cylinder(d=insert_boss_d,h=insert_boss_height);
   }
  }
  cut_side_ports();
  for(p=door_fixings())
    translate([p[0],p[1],body_depth-insert_depth-eps])
      cylinder(d=insert_pilot_d,h=insert_depth+2*eps);
 }
}


// Export (F6, File > Export > STL)
main_body();
