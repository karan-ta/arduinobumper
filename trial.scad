
use <threads-library-by-cuiso-v1.scad>
pcbHeight = 1.7;
headerWidth = 2.54;
headerHeight = 9;
HEADER_F = 0;
USB = 2;
POWER = 3;

ngComponents = [
	[[1.27, 17.526, 0], [headerWidth, headerWidth * 10, headerHeight], [0, 0, 1], HEADER_F, "Black" ],
	[[1.27, 44.45, 0], [headerWidth, headerWidth * 8, headerHeight ], [0, 0, 1], HEADER_F, "Black" ],
	[[49.53, 26.67, 0], [headerWidth, headerWidth * 8, headerHeight ], [0, 0, 1], HEADER_F, "Black" ],
	[[49.53, 49.53, 0], [headerWidth, headerWidth * 6, headerHeight ], [0, 0, 1], HEADER_F, "Black" ],
	[[9.34, 0, 0],[12, 16, 11],[0, -1, 0], USB, "LightGray" ],
	[[40.7, 0, 0], [9.0, 13.2, 10.9], [0, -1, 0], POWER, "Black" ]
	];
    
boardshape = [[  0.0, 0.0 ],
		[  53.34, 0.0 ],
		[  53.34, 66.04 ],
		[  50.8, 66.04 ],
		[  48.26, 69.2 ],
		[  15.24, 69.2 ],
		[  12.7, 67.0 ],
		[  1.27, 67.0 ],
		[  0.0, 65.0 ]
		] ;

    



//mypcbdim =  pcbDimensions(boardshape);
//echo (mypcbdim);

module roundedCube( dimensions = [10,10,10], cornerRadius = 1, faces=32 ) {
	hull() cornerCylinders( dimensions = dimensions, cornerRadius = cornerRadius, faces=faces ); 
}

module cornerCylinders( dimensions = [10,10,10], cornerRadius = 1, faces=32 ) {
	translate([ cornerRadius, cornerRadius, 0]) {
		cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		translate([dimensions[0] - cornerRadius * 2, 0, 0]) cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		translate([0, dimensions[1] - cornerRadius * 2, 0]) {
			cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
			translate([dimensions[0] - cornerRadius * 2, 0, 0]) cylinder( r = cornerRadius, $fn = faces, h = dimensions[2] );
		}
	}
}
//roundedCube ();





module drawboardshapemodule (offset = 0, height = 1.7) {

myboardDimensions = [53.34, 68.58, 12.7];
  
xScale = (myboardDimensions[0] + offset * 2) / myboardDimensions[0];
yScale = (myboardDimensions[1] + offset * 2) / myboardDimensions[1];
translate([-offset, -offset, 0])
scale([xScale, yScale, 1.0])
			linear_extrude(height = height) 
				polygon(points = boardshape);

}
module holePlacement(boardType = UNO ) {
	for(i = boardHoles[boardType] ) {
		translate(i)
			child(0);
	}
}

module main ()
{
difference (){
//base and outer edge , 3.4 width , 4.2 height of outer edge, 2 height of inner base
union (){
    //outer edge 1.4 width , 4.2 height
difference (){
    drawboardshapemodule (1.4,4.2);
    translate([0,0,-0.1])
    drawboardshapemodule(0, height = 4.4);
    
}
//inner base 3 width , 2 height
difference (){
    drawboardshapemodule (1,2);
    translate([0,0,-0.1])
    drawboardshapemodule(-2, height = 4.4);
    
}
//opaque cylinder for outer edge of mounting hole
holePlacement()
        cylinder(r = mountingHoleRadius + 1.5, h = 2, $fn = 32);
translate([2,30,0])
cube([51,10,2]);
translate([25,35,-4])
difference(){
cylinder(d=8,h=4,$fn=120);
 thread_for_nut(diameter=4,length=4.1);
}

}
//transparent inner hole.
	translate([0,0,-0.5])
		holePlacement()
			cylinder(r = mountingHoleRadius, h = 4.2, $fn = 32);	
//cubes for usb and power jack
//USB
translate([11,-1.5,2])
color("LightGray")
cube ([13,1.6,2.3]);
//power jack
translate([41,-1.5,2])
color("Black")
cube ([9,1.6,2.3]);
}
}
main ();
//mycomps = componentsPosition ();
//mycompsdimensions = componentsDimensions ();

