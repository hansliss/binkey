$fn=256;

capWidthBase=18;
capHeightBase=18;

keyHoleWidth=14;
keyHoleLength=14;

boxWidth=80;
boxDepth=40;
boxTopRawHeight=30;

module baseBox() {
        rotate([10, 0, 0])
        difference() {
            union() {
                cube([boxWidth, boxDepth, boxTopRawHeight], center=true);
                translate([-boxWidth/2, boxDepth/2, 0])
                    rotate([0, 90, 0])
                        cylinder(r=boxTopRawHeight/2, h=boxWidth);
                translate([-boxWidth/2, -boxDepth/2, boxTopRawHeight/2 - boxTopRawHeight/4])
                    rotate([0, 90, 0])
                        cylinder(r=boxTopRawHeight/4, h=boxWidth);
            }
            translate([-10, boxDepth/2 - 5, boxTopRawHeight/2 - 1 - 0.3])
                cube([50.5, 5.5, 2], center=true);
            translate([-22, -5, boxTopRawHeight / 2 + 5])
                cube([keyHoleWidth, keyHoleLength, boxTopRawHeight], center=true);
            translate([-22 + capWidthBase + 5, -5, boxTopRawHeight / 2 + 5])
                cube([keyHoleWidth, keyHoleLength, boxTopRawHeight], center=true);
            translate([25, 12, boxTopRawHeight/2 - 5])
                cylinder(r=3.55, h=10);
            union() {
                translate([0, 0, -0.751])
                    cube([boxWidth-3, boxDepth - 3, boxTopRawHeight - 1.5], center=true);
                translate([-(boxWidth-3)/2, boxDepth/2, 0])
                    rotate([0, 90, 0])
                        cylinder(r=boxTopRawHeight/2 - 1.5, h=boxWidth-3);
            }
    }
}

module top() {
    difference() {
        intersection() {
            baseBox();
            translate([0, 0, boxTopRawHeight])
                cube([boxWidth + 1, boxDepth + boxTopRawHeight, boxTopRawHeight * 2], center=true);
        }
        translate([1/2 + boxWidth/2 - 1.5 - 0.01, 0, 5 / 2 - 0.01])
            union() {
                cube([1, 5.2, 5.2], center=true);
                translate([0.2, 0, 1.5])
                    sphere(r=0.7);
            }
        translate([-(1/2 + boxWidth/2 - 1.5) + 0.01, 0, 5 / 2 - 0.01])
            union() {
                cube([1, 5.2, 5.2], center=true);
                translate([-0.2, 0, 1.5])
                    sphere(r=0.7);
            }
        translate([boxWidth / 2 - 7, boxDepth - 5, 0])
            rotate([90, 0, 0])
                cylinder(r=1.7, h=10);
    }
}

module bottom() {
    difference() {
        union() {
            intersection() {
                baseBox();
                translate([0, 0, -(boxDepth/2)*tan(10) / 2])
                    cube([boxWidth + 1, boxDepth + boxTopRawHeight, (boxDepth/2)*tan(10)], center=true);
            }
            translate([0, (boxTopRawHeight - 4) / 4, 1.5 / 2 - (boxDepth/2)*tan(10) + 0.15])
                cube([boxWidth - 3 + 0.02, boxDepth - 3 + boxTopRawHeight / 2 - 2 + 0.02, (boxDepth/2)*tan(10) / 2], center = true);
            translate([1/2 + boxWidth/2 - 1.5, 0, 5 / 2 - 0.01])
                union() {
                    cube([1, 5, 5], center=true);
                    translate([0.2, 0, 1.5])
                        sphere(r=0.7);
                }
            translate([-(1/2 + boxWidth/2 - 1.5), 0, 5 / 2 - 0.01])
                union() {
                    cube([1, 5, 5], center=true);
                    translate([-0.2, 0, 1.5])
                        sphere(r=0.7);
                }
        }
        translate([boxWidth / 2 - 7, boxDepth - 5, 0])
            rotate([90, 0, 0])
                cylinder(r=1.7, h=10);
    }
}

//translate([0, 0, 10])
rotate([170, 0, 0])
    top();

//bottom();