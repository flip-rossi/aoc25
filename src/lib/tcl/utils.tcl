namespace eval ::utils {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]


    # general utils #################################

    proc id {val} {
        return $val
    }


    # list utils ####################################

    proc lreduce {list accName valName init expr} {
        upvar $accName acc
        upvar $valName v

        set acc $init
        foreach v $list {
            set acc [uplevel [list expr $expr]]
        }

        return $acc
    }


    # control flow utils ############################

    proc forpair {varName1 varName2 list body} {
        upvar $varName1 x
        upvar $varName2 y

        set n [llength $list]
        for {set i 0} {$i < $n} {incr i 2} {
            set x [idx $list $i]
            set y [idx $list [seq $i]]
            uplevel $body
        }
    }

    proc forrange {varName start end body} {
        upvar $varName i
        for {set i $start} {$i < $end} {incr i} {
            uplevel $body
        }
    }

}

namespace eval ::utils {
    # Export all aliases
    namespace export {*}[string map {::utils:: {}} [lsearch -all -inline [interp aliases] ::utils::*]]
    # Export public procs (camelCase name)
    namespace export {*}[lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide utils $::utils::version
