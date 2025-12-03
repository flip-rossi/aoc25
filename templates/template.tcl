#!/usr/bin/env tclsh
################################################################################
#
# Day ${day} - ${title}
# ${url}
# Start:  ${fetch_time}
# Finish: TODO
#
################################################################################

package require utils 0.1

::utils::importPackage utils 0.1 {
    memoproc
    static TODO
    id
    forrange dowhile
    lreduce lnext lremaining }
::utils::importPackage arith 0.1 { + - \\* / % seq +1 prev -1 }
::utils::importPackage aliases 0.1 { idx llen slen }


# READ INPUT ###################################################################

proc readInput {} {
    TODO
}


# PART 1 #######################################################################

proc part1 {} {
    TODO
}


# PART 2 #######################################################################

proc part2 {} {
    TODO
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
