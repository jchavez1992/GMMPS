# Tcl package index file - handcrafted
#
# $Id: pkgIndex.tcl.in,v 1.1.1.1 2006/01/16 18:10:56 abrighto Exp $

package ifneeded tifftcl 3.6.1 [list load [file join $dir libtifftcl3.6.1.dylib]]

# distinguish static and dyn variants, later.
if {0} {
package ifneeded tifftcl 3.6.1 [string map [list @dir@ $dir] \
"if {[catch {load [file join @dir@ libtifftcl3.6.1.dylib]}]} {
    load [file join @dir@ libtifftcl3.6.1.dylib]
}"]
}
