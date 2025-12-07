#!/usr/bin/env tclsh
################################################################################
#
# Day 3 - Lobby
# https://adventofcode.com/2025/day/3
# Start:  2025-12-07 11:11
# Finish: 2025-12-07 12:01
#
################################################################################

package require utils 0.1

::utils::importPackage utils 0.1 {
    memoproc static TODO
    id
    forrange foripairs dowhile
    lreduce lnext lremaining
    forchar
}
::utils::importPackage arith 0.1 { ops::* seq +1 prev -1 }
::utils::importPackage aliases 0.1 { idx llen slen }


# PART 1 #######################################################################

proc part1 {} {
    set total 0
    while {[set bank [gets stdin]] ne ""} {
        set joltl 0
        set joltr 0
        set n [string length $bank]
        for {set i 0} {$i < [-1 $n]} {incr i} {
            set bat [string index $bank $i]
            if {$bat > $joltl} {
                set joltl $bat
                set joltr 0
            } elseif {$bat > $joltr} {
                set joltr $bat
            }
        }
        set bat [string index $bank $i]
        if {$bat > $joltr} {
            set joltr $bat
        }
        incr total $joltl$joltr
    }
    return $total
}


# PART 2 #######################################################################

proc part2 {} {
    set JLEN 12

    set total 0
    while {[set bank [gets stdin]] ne ""} {
        set joltage [lrepeat $JLEN 0]

        set n [string length $bank]
        for {set i 0} {$i < $n} {incr i} {
            set bat [string index $bank $i]
            for {set j [expr {max($JLEN - ($n - $i), 0)}]} {$j < $JLEN} {incr j} {
                if {$bat > [idx $joltage $j]} {
                    lset joltage $j $bat
                    break
                }
            }
            for {incr j} {$j < $JLEN} {incr j} {
                lset joltage $j 0
            }
        }

        incr total [join $joltage ""]
    }
    return $total
}


################################################################################

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
