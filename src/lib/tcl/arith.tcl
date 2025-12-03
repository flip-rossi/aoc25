package require utils 0.1

namespace eval ::arith {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    ::utils::importFrom ::utils exproc expalias

    foreach binop {+ - * / %} {
        exproc $binop {lhs rhs} [list expr "\$lhs $binop \$rhs"]
    }

    exproc seq {x} { + $x 1 }
    exproc prev {x} { - $x 1 }

    expalias {} +1 {} seq
    expalias {} -1 {} prev
}

package provide arith $::arith::version
