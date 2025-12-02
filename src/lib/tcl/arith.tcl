namespace eval ::arith {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    foreach binop {+ - * / %} {
        proc $binop {lhs rhs} [list expr "\$lhs $binop \$rhs"]

        namespace export $binop
    }

    proc seq {x} { + $x 1 }
    proc prev {x} { - $x 1 }
}

interp alias {} ::arith::+1 {} seq
interp alias {} ::arith::-1 {} prev

namespace eval ::arith {
    # Export all aliases
    namespace export {*}[string map {::arith:: {}} [lsearch -all -inline [interp aliases] ::arith::*]]
    # Export public procs (camelCase name)
    namespace export {*}[lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide arith $::arith::version
