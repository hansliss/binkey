/* 
 * Collars for 5mm LEDs to fit in the holes in the binkeybox. These probably need
 * to be printed on a resin printer, but by all means try on an FDM if that's all
 * you have!
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
 $fn=128;


union() {
    difference() {
        union() {
            cylinder(r=6.6 / 2 - 0.05, h=10);
            translate([0, 0, 6.62])
                cylinder(r=8 / 2, h=2);
        }
        translate([0, 0, -0.01])
            cylinder(r=5 / 2, h=10 + 0.02);
        translate([0, 0, 7])
            cylinder(r=5.9 / 2 + 0.2, h=1 + 0.3);
        translate([-10, 0, -0.01])
            cube([20, 20, 20]);
        translate([-8, 0, 4])
            rotate([0, 90, 0])
                cylinder(r=1.05, h=8);
    }
    intersection() {
        translate([0, 0, 4])
            rotate([0, 90, 0])
                cylinder(r=1.03, h=8);
        difference() {
            cylinder(r=6.6 / 2 - 0.05, h=10);
            translate([0, 0, -0.01])
                cylinder(r=5 / 2 + 0.1, h=10 + 0.02);
        }
    }        
}