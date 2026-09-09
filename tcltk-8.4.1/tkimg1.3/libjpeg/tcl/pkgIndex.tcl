# Tcl package index file - handcrafted
#
# $Id: pkgIndex.tcl.in,v 1.1.1.1 2006/01/16 18:10:06 abrighto Exp $

package ifneeded jpegtcl 1.0 [list load [file join $dir libjpegtcl1.0.dylib]]

# distinguish static and dyn variants, later.
if {0} {
package ifneeded jpegtcl 1.0 [string map [list @dir@ $dir] \
"if {[catch {load [file join @dir@ libjpegtcl1.0.dylib]}]} {
    load [file join @dir@ libjpegtcl1.0.dylib]
}"]
}
