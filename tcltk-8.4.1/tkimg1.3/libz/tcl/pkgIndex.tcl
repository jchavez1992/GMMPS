# Tcl package index file - handcrafted
#
# $Id: pkgIndex.tcl.in,v 1.1.1.1 2006/01/16 18:06:19 abrighto Exp $

package ifneeded zlibtcl 1.2.1 [list load [file join $dir libzlibtcl1.2.1.dylib]]

# distinguish static and dyn variants, later.
if {0} {
package ifneeded zlibtcl 1.2.1 [string map [list @dir@ $dir] \
"if {[catch {load [file join @dir@ libzlibtcl1.2.1.dylib]}]} {
    load [file join @dir@ libzlibtcl1.2.1.dylib]
}"]
}
