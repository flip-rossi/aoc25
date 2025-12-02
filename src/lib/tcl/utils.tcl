namespace eval ::utils {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    proc id {val} {
        return $val
    }
}

namespace eval ::utils {
    namespace export [lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide utils $::utils::version
