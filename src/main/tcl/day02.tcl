#!/usr/bin/env tclsh
################################################################################
#
# Day 2 - Gift Shop
# https://adventofcode.com/2025/day/2
# Start:  2025-12-02 14:28
# Finish: 2025-12-02 16:39
#
################################################################################

package require utils
namespace import {*}[lmap p {forpair forrange lreduce} {utils::id "::utils::$p"}]

namespace import ::utils::forpair

package require arith
namespace import {*}[lmap op {+ - * / %} {utils::id "::arith::$op"}]

package require aliases
namespace import ::aliases::*


# READ INPUT ###################################################################

proc readInput {} {
    string map {, " " - " "} [gets stdin]
}


# PART 1 #######################################################################

# TODO: 2s slowww
proc part1 {} {
    set ranges [readInput]

    set invalids [list]

    forpair x y $ranges {
        forrange id $x [+1 $y] {
            set mid [/ [slen $id] 2]
            set l [string range $id 0 [prev $mid]]
            set r [string range $id $mid end]

            if {$l eq $r} {
                lappend invalids $id
            }
        }
    }

    return [lreduce $invalids sum v 0 {$sum + $v}]
}


# PART 2 #######################################################################

# TODO: 13s even slowwwer
proc part2 {} {
    set ranges [readInput]

    set sum 0

    forpair x y $ranges {
        forrange id $x [+1 $y] {
            set len [slen $id]
            forrange i 0 [/ $len 2] {
                set sublen [seq $i]
                if {$len % $sublen != 0} {
                    continue
                }

                set sub [string range $id 0 $i]
                if [regexp -- "^($sub){[/ $len $sublen]}\$" $id] {
                    set sum [+ $sum $id]
                    break
                }
            }
        }
    }

    return $sum
}


puts [switch -- [lindex $::argv 0] {
    1 {part1}
    2 {part2}
    default {error "Expected first argument to be 1 or 2 but got [idx $::argv" 0]"}
}]
