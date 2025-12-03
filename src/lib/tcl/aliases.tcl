package require utils 0.1

namespace eval ::aliases {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    ::utils::importFrom ::utils expalias

    # list aliases ##################################
    expalias {} idx {} lindex
    expalias {} llen {} llength

    # string aliases ################################
    expalias {} slen {} string length
}

package provide aliases $::aliases::version
