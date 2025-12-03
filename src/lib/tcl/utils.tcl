namespace eval ::utils {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]


    # special proc definitions ######################

    # Description: Define a procedure and export it.
    # Arguments: same as `proc`
    proc exproc {name args body} {
        uplevel 1 \
            [list proc $name $args $body] \;\
            [list namespace export $name]
    }
    namespace export exproc

    # Description: Define an alias within the current namespace and export it.
    # Arguments:
    #   same as `interp alias srcPath srcCmd targetPath targetCmd ?arg arg ...?`
    exproc expalias {srcPath srcCmd targetPath targetCmd args} {
        set ns [uplevel 1 namespace current]
        uplevel 1 \
            [list interp alias $srcPath "${ns}::$srcCmd" $targetPath $targetCmd {*}$args] \;\
            [list namespace export $srcCmd]
    }

    # Description: Define a procedure where each result is memoized into a
    #              hidden static dictionary.
    # Arguments: same as `proc`
    exproc memoproc {name args body} {
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

        uplevel 1 [list proc $name $args [subst -nocommands {
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


    # general utils #################################

    exproc importFrom {namespace args} {
        uplevel 1 namespace import [lmap p $args {id "${namespace}::$p"}]
    }

    # Description: Require a package and import its procedures.
    # Arguments:
    # * `package` - Same as in `package require`
    # * `?requirement...?` - Same as in `package require`
    # * `?-namespace namespace?` - The namespace to import the procedures from.
    #                              Defaults to `::$package`.
    # * `?-force?` - Same as in `namespace import`
    # * `imports` - List of patterns to import, like in `namespace import`, except
    #               each will be prefixed with the package's namespace.
    exproc importPackage {package args} {
        set reqCmd [list package require $package]
        set importCmd [list namespace import]

        set namespace "::$package"

        while {[lremaining $args i] > 1} {
            set opt [lnext $args i]
            switch -- $opt {
                -namespace {
                    set namespace [lnext $args i]
                }
                -force {
                    lappend importCmd -force
                }
                default {
                    # add a requirement to the `package require` command
                    lappend reqCmd $opt
                }
            }
        }

        lappend importCmd {*}[lmap p [lnext $args i] {id "${namespace}::$p"}]

        uplevel 1 $reqCmd
        uplevel 1 $importCmd
    }


    # Description: Create a proc-local static variable and bring it to scope.
    #              I mostly got there by myself but better inspiration was
    #              found in https://wiki.tcl-lang.org/page/static+variables
    # Arguments:
    # * `name`
    # * ?`value`?
    # Returns: The fully qualified name of the variable with namespaces.
    exproc static {args} {
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

    exproc TODO {} {
        return -code error -level 2 \
            "TODO: Not yet implemented."
    }


    # functional utils ##############################

    exproc id {val} {
        return $val
    }


    # control flow utils ############################

    exproc forrange {varName args} {
        if {[lremaining $args a] >= 2} {
            if {[lremaining $args a] >= 3} {
                set start [lnext $args a]
            }
            set end [lnext $args a]
        }
        set body [lnext $args a]

        upvar 1 $varName i

        for {set i $start} {$i < $end} {incr i} {
            uplevel 1 $body
        }
    }

    exproc foripairs {indexName valueName list args} {
        set start 0
        set end [llength $list]

        if {[lremaining $args a] >= 2} {
            if {[lremaining $args a] >= 3} {
                set start [lnext $args a]
            }
            set end [lnext $args a]
            # TODO: `end`, `end-1`, ... syntax from `lrange`
        }
        set body [lnext $args a]

        upvar 1 $indexName i
        upvar 1 $valueName v

        forrange i $start $end {
            set v [lindex $list i]
            uplevel 1 $body
        }
    }

    exproc dowhile {body test} {
        while {true} {
            uplevel 1 $body
            if {[uplevel 1 expr !($test)]} {
                break
            }
        }
    }


    # list utils ####################################

    exproc lreduce {list accName valName init expr} {
        upvar 1 $accName acc
        upvar 1 $valName v

        set acc $init
        foreach v $list {
            set acc [uplevel 1 [list expr $expr]]
        }

        return $acc
    }

    # Intended to be used with `lremaining`, to implement a list iterator
    exproc lnext {list indexVarName} {
        upvar 1 $indexVarName i
        if {![info exists i]} {
            set i -1
        }

        return [lindex $list [incr i]]
    }

    # Intended to be used with `lnext`, to implement a list iterator
    exproc lremaining {list indexVarName} {
        upvar 1 $indexVarName i
        if {[info exists i]} {
            return [expr {max(0, [llength $list] - $i - 1)}]
        } else {
            return [llength $list]
        }
    }

}

package provide utils $::utils::version
