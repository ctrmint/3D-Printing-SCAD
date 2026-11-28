/*
  Parametric rectangular storage pot
  Units: millimetres. Designed to print upright, open side up.
  Edit the parameters below using OpenSCAD's Customizer or source editor.
*/

/* [Overall dimensions] */
outer_length = 80;  // X, maximum outside length
outer_width = 80;  // Y, maximum outside width
pot_height = 68;   // Z, overall height
wall_thickness = 2.3;
base_thickness = 3.2;

/* [Curves and shape] */
corner_radius = 12;       // Plan-view corner radius at the untapered top
bottom_round = 3;         // External base-to-wall fillet
inside_floor_round = 5;   // Internal floor-to-wall fillet
rim_round = 1.1;          // Roundover on both sides of the lip
bottom_taper = 1.5;       // Inset per side at bottom; 0 = straight sides

/* [Surface quality] */
corner_segments = 24;     // Segments per horizontal quarter-circle [8:1:48]
curve_segments = 16;      // Segments per vertical quarter-circle [6:1:32]

/* [Hidden] */
eps = 0.05;

// All slices are concentric. Taper is a linear reduction toward the base.
function taper_at(z) = bottom_taper * max(0, 1 - z/pot_height);

// [height, extra inward offset]; the arcs are tangent to the vertical
// walls and horizontal faces when bottom_taper is zero.
function lower_arc(z0, r) = r == 0 ? [[z0,0]] :
    [for (i=[0:curve_segments])
        let(a=90*i/curve_segments)
        [z0+r*(1-cos(a)), r*(1-sin(a))]];

function upper_arc(z1, r, sign=1) = r == 0 ? [[z1,0]] :
    [for (i=[0:curve_segments])
        let(a=90*i/curve_segments)
        [z1-r+r*sin(a), sign*r*(1-cos(a))]];

// Counterclockwise perimeter, looking down the Z axis. Straight sections
// join true quarter-circle corners; the corner centres stay fixed as the
// profile is offset, keeping the rounded rectangle geometrically consistent.
function rounded_ring(z, inset) =
    let(d=inset+taper_at(z),
        hx=outer_length/2-d, hy=outer_width/2-d,
        r=corner_radius-d,
        centers=[[hx-r,hy-r],[-hx+r,hy-r],[-hx+r,-hy+r],[hx-r,-hy+r]])
    [for(q=[0:3], j=[0:corner_segments])
        let(a=q*90+j*90/corner_segments)
        [centers[q][0]+r*cos(a), centers[q][1]+r*sin(a), z]];

// Build a closed, triangulated solid from a stack of profile rings.
// Winding follows OpenSCAD's left-hand polyhedron convention.
module profile_solid(profiles, inset=0) {
    n=4*(corner_segments+1);
    m=len(profiles);
    pts=[for(p=profiles) each rounded_ring(p[0],inset+p[1])];
    sides=[for(k=[0:m-2], i=[0:n-1])
        let(a=k*n+i,b=k*n+(i+1)%n,c=(k+1)*n+i,d=(k+1)*n+(i+1)%n)
        each [[a,c,d],[a,d,b]]];
    bottom=[for(i=[0:n-1]) i];
    top=[for(i=[n-1:-1:0]) (m-1)*n+i];
    polyhedron(points=pts,faces=concat([bottom],sides,[top]),convexity=10);
}

module storage_pot() {
    assert(outer_length>0 && outer_width>0 && pot_height>0,
           "Overall dimensions must be positive.");
    assert(wall_thickness>0 && base_thickness>0 && base_thickness<pot_height,
           "Invalid wall or base thickness.");
    assert(bottom_taper>=0 && bottom_round>=0 && inside_floor_round>=0 && rim_round>=0,
           "Taper and roundovers must be non-negative.");
    assert(corner_radius<min(outer_length,outer_width)/2,
           "Corner radius must be less than half the shorter outside dimension.");
    assert(corner_radius>bottom_taper+max(bottom_round,wall_thickness+inside_floor_round,wall_thickness),
           "Increase corner_radius or reduce taper, wall thickness or fillet radii.");
    assert(2*rim_round<wall_thickness,
           "Rim roundover must be less than half wall_thickness.");
    assert(base_thickness+inside_floor_round+rim_round<pot_height && bottom_round+rim_round<pot_height,
           "Pot is too shallow for the selected roundovers.");
    assert(corner_segments>=2 && corner_segments==floor(corner_segments) &&
           curve_segments>=2 && curve_segments==floor(curve_segments),
           "Segment counts must be integers >= 2.");

    outer_profile=concat(lower_arc(0,bottom_round),upper_arc(pot_height,rim_round));
    inner_profile=concat(lower_arc(base_thickness,inside_floor_round),
                         upper_arc(pot_height,rim_round,-1),
                         [[pot_height+eps,-rim_round]]);
    difference() {
        profile_solid(outer_profile);
        profile_solid(inner_profile,wall_thickness);
    }
}

storage_pot();
