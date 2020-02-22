/*
 * A box for the Binkey binary keyboard. You'll need one bottom and one top. Duh.
 * Just uncomment one at a time at the bottom of the file, render and export to STL.
 * 
 * Copyright (c) 2020, Hans Liss
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
 $fn=256;

capWidthBase=18;
capHeightBase=18;
capWidthEnter=capWidthBase;
capHeightEnter=37;
capWidthBackspace=37;
capHeightBackspace=capHeightBase;
capGap=(capWidthBackspace - 2 * capWidthBase);

key0PosX=capWidthBase / 2;
key0PosY=capHeightBase / 2;
key1PosX=key0PosX + capWidthBase + capGap;
key1PosY=key0PosY;
keyEnterPosX=key1PosX + capWidthBase + capGap;
keyEnterPosY=capHeightEnter / 2;
keyBackspacePosX = capWidthBackspace / 2;
keyBackspacePosY = key0PosY + capHeightBase + capGap;

totKeyCenterDistX = keyEnterPosX - key0PosX;
totKeyCenterDistY = keyBackspacePosY - key0PosY;

edge = 5;
keyOffsetX = 10;
keyOffsetY = edge + 7;

boxWidth=totKeyCenterDistX + capWidthBase + 2 * edge + keyOffsetX + 10;
boxLength=totKeyCenterDistY + capHeightBase + 2 * edge + keyOffsetY;
boxHeight=20;
wallThickness=1.5;


keyHoleWidth=14;
keyHoleLength=14;

notchHeight=4;
botHeight=10;

module top() {
    difference() {
        cube([boxWidth, boxLength, boxHeight], center=true);
        translate([0, 0, -wallThickness/2 - 0.01])
            cube([boxWidth - 2*wallThickness, boxLength - 2*wallThickness, boxHeight - wallThickness + 0.02], center=true);
        translate([edge + keyOffsetX + key0PosX - boxWidth/2, -edge - keyOffsetY - key0PosY + boxLength/2, boxHeight/2 - wallThickness/2])
            cube([keyHoleWidth, keyHoleLength, wallThickness + 0.02], center=true);
        translate([edge + keyOffsetX + key1PosX - boxWidth/2, -edge - keyOffsetY - key1PosY + boxLength/2, boxHeight/2 - wallThickness/2])
            cube([keyHoleWidth, keyHoleLength, wallThickness + 0.02], center=true);
        translate([edge + keyOffsetX + keyEnterPosX - boxWidth/2, -edge - keyOffsetY - keyEnterPosY + boxLength/2, boxHeight/2 - wallThickness/2])
            cube([keyHoleWidth, keyHoleLength, wallThickness + 0.02], center=true);
        translate([edge + keyOffsetX + keyBackspacePosX - boxWidth/2, -edge - keyOffsetY - keyBackspacePosY + boxLength/2, boxHeight/2 - wallThickness/2])
            cube([keyHoleWidth, keyHoleLength, wallThickness + 0.02], center=true);

        for (led = [0 : 1 : 7]) {
            translate([led * 9 + 9/2 + (boxWidth - (8 * 9))/2 - boxWidth/2, -edge + boxLength/2, boxHeight/2 - wallThickness - 0.01])
                cylinder(r = 3.4, h=wallThickness + 0.02);
        } 

        // translate([0, 0, -(boxHeight/2 - wallThickness/2)])
        //    cube([boxWidth + 0.02, boxLength + 0.02, wallThickness + 0.02], center=true);
        translate([-4, boxLength/2 - wallThickness, - (boxHeight/2 - notchHeight)])
            rotate([0, 90, 0])
                cylinder(r=0.75, h=8);
        translate([-4, -(boxLength/2 - wallThickness), - (boxHeight/2 - notchHeight)])
            rotate([0, 90, 0])
                cylinder(r=0.75, h=8);
        translate([boxWidth / 2 - wallThickness - 12/2, boxLength / 2 - wallThickness - 0.01, 12/2 - boxHeight/2 - (botHeight - wallThickness)])
            cube([6.2, 8, 12], center = true);
    }
}

module bottom() {
    difference() {
        union() {
            difference() {
                cube([boxWidth, boxLength, botHeight], center = true);
                translate([0, 0, wallThickness/2 + 0.01])
                    cube([boxWidth - 2 * wallThickness - 0.2, boxLength - 2 * wallThickness - 0.2, botHeight - wallThickness], center = true);
            }
            translate([0, -(boxLength/2 - wallThickness) + wallThickness/2 - 0.2, wallThickness/2])
                cube([boxWidth - 2 * wallThickness - 0.2 + 0.02, wallThickness + 0.2, botHeight - wallThickness], center=true);
            translate([0, -(boxLength/2 - wallThickness) + wallThickness/2 + 0.2, (notchHeight + 2)/2 - 0.01])
                union() {
                    cube([boxWidth - 2 * wallThickness - 0.2 + 0.02, wallThickness, notchHeight + 2 + botHeight - wallThickness], center=true);
                    translate([-6/2, -wallThickness/2, (botHeight - 2) + notchHeight - (notchHeight + 2 + (botHeight - wallThickness))/2])
                        rotate([0, 90, 0])
                            cylinder(r=0.5, h=6);
                }
            translate([0, (boxLength/2 - wallThickness) - wallThickness/2 + 0.2, wallThickness/2])
                cube([boxWidth - 2 * wallThickness - 0.2 + 0.02, wallThickness + 0.2, botHeight - wallThickness], center=true);
            translate([0, (boxLength/2 - wallThickness) - wallThickness/2  - 0.2, (notchHeight + 2)/2 - 0.01])
                union() {
                    cube([boxWidth - 2*wallThickness -0.2 + 0.02, wallThickness, notchHeight + 2 + botHeight - wallThickness], center=true);
                    translate([-6/2, wallThickness/2, (botHeight - 2) + notchHeight - (notchHeight + 2 + (botHeight - wallThickness))/2])
                        rotate([0, 90, 0])
                            cylinder(r=0.5, h=6);
                }
        }
        translate([boxWidth / 2 - wallThickness - 12/2, boxLength / 2 - wallThickness - 0.01, wallThickness + 12/2 - botHeight/2])
            cube([6.2, 8, 12], center = true);
        // Need to remove the top of the cable slot
        translate([boxWidth / 2 - wallThickness - 12/2, boxLength / 2 - wallThickness - 0.01, wallThickness + 12 + 12/2 - botHeight/2 - 0.01])
            cube([6.2, 8, 12], center = true);
   }
}


//translate([0, 0, 30])
//    top();
bottom();