#!/usr/bin/env tclsh
################################################################################
#
# Day 4 - Printing Department
# https://adventofcode.com/2025/day/4
# Start:  2025-12-07 12:17 (but actually 15:36)
# Finish: 2025-12-07 16:27
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


# READ INPUT ###################################################################

proc readInput {} {
    set map [list]
    while {[set row [gets stdin]] ne ""} {
        lappend map [lmap x [split $row ""] {string map {. 0 @ 1} $x}]
    }
    #puts [join $map \n]
    return $map
}


# PART 1 #######################################################################

# 140ms
proc part1 {} {
    set LIMIT 4

    set count 0

    set map [readInput]
    set n [llen $map]
    set m [llen [lindex $map 0]]

    #set dbg $map

    for {set i 0} {$i < $n} {incr i} {
        for {set j 0} {$j < $m} {incr j} {
            if {[lindex $map $i $j]} {
                try {
                    set neighbors 0
                    for {set ii [expr {max(0, $i - 1)}]} {$ii < min($i + 2, $n)} {incr ii} {
                        for {set jj [expr {max(0, $j - 1)}]} {$jj < min($j + 2, $n)} {incr jj} {
                            if {[incr neighbors [lindex $map $ii $jj]] > $LIMIT} {
                                return  -level 0 -code 10
                            }
                        }
                    }
                    #lset dbg $i $j {X}
                    incr count
                } on 10 {} {}
            }
        }
    }

    #puts [join $dbg \n]

    return $count
}


# PART 2 #######################################################################

# 2,200ms 🤪
proc part2 {} {
    set LIMIT 4

    set count 0

    set map [readInput]
    set n [llen $map]
    set m [llen [lindex $map 0]]

    dowhile {
        set lastRemoved 0
        for {set i 0} {$i < $n} {incr i} {
            for {set j 0} {$j < $m} {incr j} {
                if {[lindex $map $i $j]} {
                    try {
                        set neighbors 0
                        for {set ii [expr {max(0, $i - 1)}]} {$ii < min($i + 2, $n)} {incr ii} {
                            for {set jj [expr {max(0, $j - 1)}]} {$jj < min($j + 2, $n)} {incr jj} {
                                if {[incr neighbors [lindex $map $ii $jj]] > $LIMIT} {
                                    return  -level 0 -code 10
                                }
                            }
                        }
                        #lset dbg $i $j {X}
                        lset map $i $j 0
                        incr count
                        set lastRemoved 1
                    } on 10 {} {
                    }
                }
            }
        }
    } {$lastRemoved != 0}

    #puts [join $dbg \n]

    return $count
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
