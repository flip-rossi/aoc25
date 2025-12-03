package require utils 0.1

# See also: ::tcl::mathfunc

namespace eval ::arith {
    variable version 0.1
    variable home [file join [pwd] [file dirname [info script]]]

    ::utils::importFrom ::utils exproc expalias

    namespace eval ops {
        variable unops [list + - ~ !]
        variable binops [list + - * / % ** << >> < > <= >= == != eq ne in ni & ^ | && ||]

        foreach unop $unops {
            ::utils::exproc $unop {operand} [list expr "$unop \$operand"]
        }
        foreach binop $binops {
            ::utils::exproc $binop {lhs rhs} [list expr "\$lhs $binop \$rhs"]
        }
        # + and - can be both unops and binops
        ::utils::exproc + {a {b 0}} { expr {$a + $b} }
        ::utils::exproc - {a {b ""}} {
            if {$b eq ""} {
                expr {- $a}
            } else {
                expr {$a - $b}
            }
        }
    }

    exproc seq {x} { + $x 1 }
    exproc prev {x} { - $x 1 }

    expalias {} +1 {} seq
    expalias {} -1 {} prev
}

package provide arith $::arith::version
