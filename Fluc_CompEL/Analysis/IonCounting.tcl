## To modify this script to fit your system, change the resid numbers
## used in sel in the first line to your desired bounding residues.
## Remember to use VMD's resid value, which should match the residue 
## number in your system pdb file. This also uses all of the atoms of each 
## residue to determine the min/max dimensions, you can modify it to only use 
## specific atoms using standard VMD atom selection syntax.

set sel [atomselect top "resid 83 or resid 84 or resid 165 or resid 214 or resid 230 or resid 209 or resid 210 or resid 39 or resid 88 or resid 104"]
set n [molinfo top get numframes]
set fp [open "F_InPores.dat" w]
for { set i 0 } { $i < $n } { incr i } {
	$sel frame $i
	$sel update
	set coords [$sel get {x y z}]
  	set coord [lvarpop coords]
  	lassign $coord minx miny minz
  	lassign $coord maxx maxy maxz
  	foreach coord $coords {
    	lassign $coord x y z
    	if {$x < $minx} {set minx $x} else {if {$x > $maxx} {set maxx $x}}
    	if {$y < $miny} {set miny $y} else {if {$y > $maxy} {set maxy $y}}
    	if {$z < $minz} {set minz $z} else {if {$z > $maxz} {set maxz $z}}
  	}
  	set selF [atomselect top "resname F and (x>$minx) and (x<$maxx) and (y>$miny) and (y<$maxy) and (z>$minz) and (z<$maxz)"]
  	set nF [$selF num]
  	set info [$selF get resid]
  	puts $fp "$i $nF $info"
}
 
