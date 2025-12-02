#!/usr/bin/env tclsh
################################################################################
#
# Day 2 - Gift Shop
# https://adventofcode.com/2025/day/2
# Start:  2025-12-02 14:28
# Finish: TODO
#
################################################################################

package require utils
package require arith
namespace import {*}[lmap op {+ - * / %} {utils::id "::arith::$op"}]

proc idx {list index} {
    lindex $list $index
}

proc seq {x} {
    + $x 1
}
proc prev {x} {
    - $x 1
}

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


proc lreduce {list accName valName init expr} {
    upvar $accName acc
    upvar $valName v

    set acc $init
    foreach v $list {
        set acc [uplevel [list expr $expr]]
    }

    return $acc
}


# READ INPUT ###################################################################

proc readInput {} {
    string map {, " " - " "} [gets stdin]
}


# PART 1 #######################################################################

proc part1 {} {
    # TODO: 2s slowww
    set ranges [readInput]

    set invalids [list]

    forpair x y $ranges {
        forrange id $x $y {
            set mid [/ [string length $id] 2]
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

proc part2 {} {
    error "TODO: part 1 not done"
}


puts [switch -- [lindex $::argv 0] {
    1 {part1}
    2 {part2}
    default {error "Expected first argument to be 1 or 2 but got [idx $::argv" 0]"}
}]
