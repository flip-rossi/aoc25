namespace eval ::aliases {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]
}

# list aliases ##################################
interp alias {} ::aliases::idx {} lindex
interp alias {} ::aliases::llen {} llength

# string aliases ################################
interp alias {} ::aliases::slen {} string length

namespace eval ::aliases {
    # Export all aliases
    namespace export {*}[string map {::aliases:: {}} [lsearch -all -inline [interp aliases] ::aliases::*]]
    # Export public procs (camelCase name)
    namespace export {*}[lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide aliases $::aliases::version
