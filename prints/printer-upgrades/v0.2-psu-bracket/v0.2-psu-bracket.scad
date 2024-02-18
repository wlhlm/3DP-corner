include <BOSL2/std.scad>
// The Belfry OpenSCAD Library V2
// Source: https://github.com/revarbat/BOSL2

////////////////////////////////////////////////////////////////////
// The following section is taken from `hex-grid.scad`
// (source see below) with small modifications
//
// Copyright 2021 @JamesEvansthemnmlMak
// source: https://www.printables.com/model/86604-hexagonal-grid-generator-in-openscad
// licensed under BSD 2-clause

////////////////////////////////////////////////////////////////////
// cell: takes three parameters and returns a single hexagonal cell
//
//   SW_hole: scalar value that specifies the width across the flats
//     of the interior hexagon
//   height: scalar value that specifies the height/depth of the
//     cell (i.e. distance from from front to back
//   wall: scalar vale that specifies the thickness of the wall
//     surrounding the interior hex (hole). e.g. if SW_hole is 8
//     and wall is 2 then the total width across the flats of the
//     cell is 8 + 2(2) = 12.
////////////////////////////////////////////////////////////////////
module cell(SW_hole, height, wall) {
  tol = 0.001; // used to clean up difference artifacts
  difference() {
    cyl(d=SW_hole+2*wall,h=height,$fn=6,circum=true);
    cyl(d=SW_hole,h=height+tol,$fn=6,circum=true);
  }
}

module cell_cutout(SW_hole, height) {
    tol = 0.001;
    cyl(d = SW_hole, h = height + tol, $fn = 6, circum = true);
}

////////////////////////////////////////////////////////////////////
// grid: takes three parameters and returns the initial grid of
//    hexagons
//
//    size: 3-vector (x,y,z) that specifies the  size of the cube
//      that contains the hex grid
//    cell_hole: scalar value specifying width across flats of the
//      interior hexagon (hole)
//    cell_wall: scalar value that specifies wall thickness of the
//      hexagon
////////////////////////////////////////////////////////////////////
module grid(size,cell_hole,cell_wall,cutout=true) {
  dx=cell_hole*sqrt(3)+cell_wall*sqrt(3);
  dy=cell_hole+cell_wall;

  ycopies(spacing=dy,l=size[1])
    xcopies(spacing=dx,l=size[0]) {
      if (cutout) {
        cell(SW_hole=cell_hole,
             height=size[2],
             wall=cell_wall);
      } else {
        cell_cutout(SW_hole = cell_hole, height = size[2]);
      }
      right(dx/2)fwd(dy/2)
      if (cutout) {
        cell(SW_hole=cell_hole,
            height=size[2],
            wall=cell_wall);
      } else {
        cell_cutout(SW_hole = cell_hole, height = size[2]);
      }
    }
 }

////////////////////////////////////////////////////////////////////
// mask: creates a mask that is used by the module create_grid()
//   The mask is used to remove extra cells that are outside the
//   cube that holds the final grid
////////////////////////////////////////////////////////////////////
module mask(size) {
  difference() {
    cuboid(size=2*size);
    cuboid(size=size);
  }
}

////////////////////////////////////////////////////////////////////
// create_grid: creates a rectangular grid of hexagons with a border
//   thickness specified in the parameter (wall).
//
//   size: 3-vector (x,y,z) that specifies the length, width, and
//     depth of the final grid
//   SW: scalar value that specifies the width across the flats of
//     the interior hexagon (the hole)
//   wall: scalar value that specifies the width of each hexagon's
//     wall thickness and the thickness of the surrounding
//     rectangular frame
////////////////////////////////////////////////////////////////////
module create_grid(size,SW,wall,cutout=true,enable_frame=true) {
  b = 2*wall;
  
  if (enable_frame) {
    union() {
      difference () {
        cuboid(size=size);
        cuboid(size=[size[0]-b,size[1]-b,size[2]+b]);
      }
    }
  }

  difference() {
    grid(size=size,cell_hole=SW,cell_wall=wall, cutout=cutout);
    mask(size);
  }
}

////////////////////////////////////////////////////////////////////
// The following code builds the actual V0.2 PSU mounting bracket
//
// Copyright 2024 Wilhelm Schuster
// licensed under GPL-3.0

e = 0.001; // epsilon

module tie_mounting_point() {
    difference() {
        prismoid(size1 = [3, 12], size2 = [3, 4], h = 4);
        down(e) cuboid(size = [3+e, 3+e, 3], anchor = BOTTOM+CENTER);
    }
}

module support_beam(height, thickness, length) {
    r = thickness / 2;
    hull() {
        cylinder(height, r, r);
        right(length) cylinder(height, r, r);
    }
}

module psu_mounting_point(height, width) {
    heatset_hole_radius = 4.7 / 2;
    heatset_wall_thickness = 2;
    support_wall_thickness = 3;
    mounting_point_length = 30;
    
    difference() {
        union() {
            support_beam(height, support_wall_thickness, mounting_point_length);
            cylinder(height, heatset_hole_radius + heatset_wall_thickness, heatset_hole_radius + heatset_wall_thickness);
        }
        down(e) cylinder(height + 2 * e, heatset_hole_radius, heatset_hole_radius);
    }
    right(width) zrot(180) support_beam(height, support_wall_thickness, mounting_point_length);
}

module meanwell_lrs_mount(mount_spacing, support_sides = false) {
    height = 5;
    support_wall_thickness = 3;
    
    psu_mounting_point(height, mount_spacing[0]);
    if (support_sides) {
        back(mount_spacing[1] * 0.15) zrot(90) support_beam(height, support_wall_thickness, mount_spacing[1] * 0.4);
    }
    translate([mount_spacing[0], mount_spacing[1], 0]) zrot(180) {
        psu_mounting_point(height, mount_spacing[0]);
        if (support_sides) {
            back(mount_spacing[1] * 0.15) zrot(90) support_beam(height, support_wall_thickness, mount_spacing[1] * 0.4);
        }
    }
}

difference() {
    $fn=50;
    union() {
        resize([0, 0, 1.4]) bounding_box(excess=2) meanwell_lrs_mount([85, 152.5]);
        union() {
            meanwell_lrs_mount([85, 152.5]); // datasheet value, not ABS-adjusted
            meanwell_lrs_mount([85, 122.5]); // datasheet value, not ABS-adjusted
        }
    }

    translate([36.25, 62, 0]) grid([70, 85, 3], 12, 2.4, cutout = false);
}

right(85 * 0.5) back(142) xcopies(n = 3, l = 85 * 0.75) tie_mounting_point();