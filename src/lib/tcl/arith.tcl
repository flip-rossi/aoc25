namespace eval ::arith {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    foreach binop {+ - * / %} {
        proc $binop {lhs rhs} [list expr "\$lhs $binop \$rhs"]

        namespace export $binop
    }

}

namespace eval ::arith {
    namespace export [lsearch -all -inline -regexp [info procs] {^[a-z]}]
}
package provide arith 0.1
