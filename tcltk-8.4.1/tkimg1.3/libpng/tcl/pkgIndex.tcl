# Tcl package index file - handcrafted
#
# $Id: pkgIndex.tcl.in,v 1.1.1.1 2006/01/16 18:16:15 abrighto Exp $

package ifneeded pngtcl 1.2.6 [list load [file join $dir libpngtcl1.2.6.dylib]]

# distinguish static and dyn variants, later.
if {0} {
package ifneeded pngtcl 1.2.6 [string map [list @dir@ $dir] \
"if {[catch {load [file join @dir@ libpngtcl1.2.6.dylib]}]} {
    load [file join @dir@ libpngtcl1.2.6.dylib]
}"]
}
