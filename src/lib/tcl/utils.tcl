namespace eval ::utils {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]


    # general utils #################################

    proc id {val} {
        return $val
    }

    proc importFrom {namespace args} {
        uplevel namespace import {*}[lmap p $args {id "${namespace}::$p"}]
    }

    # Description: Create a proc-local static variable and bring it to scope.
    #              I mostly got there by myself but better inspiration was
    #              found in https://wiki.tcl-lang.org/page/static+variables
    # Arguments:
    # * `name`
    # * ?`value`?
    # Returns: The fully qualified name of the variable with namespaces.
    proc static {args} {
        set varName [lindex $args 0]

        set ns "[namespace current]::Static"
        append ns "::[string trim [uplevel namespace current] :]"
        append ns "::[namespace tail [lindex [info level -1] 0]]"
        set qualifiedName "${ns}::$varName"

        if {![info exists $qualifiedName]} {
            namespace eval $ns [list variable {*}$args]
        }

        uplevel 1 upvar #0 $qualifiedName $varName

        return $qualifiedName
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

    proc TODO {} {
        return -code error -level 2 \
            "TODO: Not yet implemented."
    }
    namespace export TODO

    proc forrange {varName start end body} {
        upvar $varName i
        for {set i $start} {$i < $end} {incr i} {
            uplevel $body
        }
    }

    proc dowhile {body test} {
        while {true} {
            uplevel $body
            if {[uplevel expr !($test)]} {
                break
            }
        }
    }

    # Description: Create a new procedure where each result is memoized into a
    #              hidden static dictionary.
    # Arguments: same as `proc`
    proc memoproc {name args body} {
        set memosName [static memos]

        set arrKey "[string trimright [uplevel 1 namespace current] :]::$name"
        array set memos [list $arrKey [dict create]]
        set memoName ${memosName}($arrKey)

        set sArgs ""
        foreach arg $args {
            if {[llength $arg] == 1} {
                append sArgs " \${$arg}"
            } else {
                append sArgs " \${[lindex $arg 0]}"
            }
        }

        uplevel [list proc $name $args [subst -nocommands {
            if {[dict exists [set {$memoName}] [list $sArgs]]} {
                set result [dict get [set {$memoName}] [list $sArgs]]
                return [set result]
            } else {
                set result [apply {{$args} {$body}} $sArgs]
                dict set {$memoName} [list $sArgs] [set result]
                return [set result]
            }
        }]]
    }

}

namespace eval ::utils {
    # Export all aliases
    namespace export {*}[string map {"::[namespace current]::" {}} \
        [lsearch -all -inline [interp aliases] "::[namespace current]::*"]]
    # Export public procs (camelCase name)
    namespace export {*}[lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide utils $::utils::version
