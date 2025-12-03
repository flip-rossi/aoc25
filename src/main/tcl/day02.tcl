#!/usr/bin/env tclsh
################################################################################
#
# Day 2 - Gift Shop
# https://adventofcode.com/2025/day/2
# Start:  2025-12-02 14:28
# Finish: 2025-12-02 16:39
#
################################################################################

package require utils; ::utils::importFrom ::utils \
    TODO id forrange lreduce

package require arith; ::utils::importFrom ::arith \
    + - {\\*} / % seq +1 prev -1

package require aliases; ::utils::importFrom ::aliases \
    idx llen slen


# READ INPUT ###################################################################

proc readInput {} {
    string map {, " " - " "} [gets stdin]
}


# PART 1 #######################################################################

# ~~2s slowww~~
# 0.025s, much better :)
proc part1 {} {
    set ranges [readInput]

    set sum 0

    dict for {lo hi} $ranges {
        set id $lo
        set len [slen $id]
        if {$len % 2 != 0} {
            set half "1[string repeat 0 [expr {$len / 2}]]"
        } else {
            set half [string range $id 0 [expr {$len / 2 - 1}]]
            if {"$half$half" < $id} {
                incr half
            }
        }

        for {set id "$half$half"} {$id <= $hi} {set id "$half$half"} {
            incr sum $id
            incr half
        }
    }

    return $sum
}


# PART 2 #######################################################################

# TODO: 13s even slowwwer
proc part2 {} {
    set ranges [readInput]

    set sum 0

    dict for {lo hi} $ranges {
        forrange id $lo [+1 $hi] {
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


if {[llen $::argv] != 1} {
    puts stderr "Expected exactly 1 argument but got [llen $::argv]."
    exit 1
}
puts [switch -- [lindex $::argv 0] {
    1 {part1}
    2 {part2}
    default {
        puts stderr "Expected first argument to be 1 or 2 but got \"[idx $::argv 0]\"."
        exit 1
    }
}]
