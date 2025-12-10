#!/usr/bin/env bash

YEAR=2025

SRC_DIR=./src
LIB_DIR=./src/lib
INPUT_DIR=./inputs

RUST_TARGET=./target/rs/debug
OCAML_TARGET=./_build/default/src
JAVA_CLASSPATH=./target/java/classes
JAVA_CLASSPATH_FILE=./target/java/mvn-classpath.txt
CPP_TARGET=./target/cpp
TCL_TARGET=./src

print_help() {
    echo \
"USAGE: $0 [language] [day] <part> [OPTIONS...]

OPTIONS:
    -h       Output this help.
    -e       Read input from $INPUT_DIR/example.txt.
    -i       Read input from standard input.
    -f FILE  Read input from FILE.
    -s       Submit answer
" >&2
    exit $1
}

submit=false

while getopts 'heif:s' flag; do
    case "${flag}" in
        h) print_help 0 ;;
        e) input="$INPUT_DIR/example.txt" ;;
        i) input="/dev/stdin" ;;
        f) input="$OPTARG" ;;
        s) submit=true ;;
        *) print_help 1 ;;
    esac
done
shift $((OPTIND - 1))

msg() {
    echo -e "\033[95m=====> $@\033[0m" >&2
}

is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

if [[ $# -lt 1 ]]; then
    print_help
fi

if ! $(is_number $1); then
    lang=$1
    shift
fi

if [[ $# == 2 ]]; then
    if ! $(is_number $1); then
        print_help
    fi
    printf -v day "%02d" $1
    shift
else
    day=$(TZ='EST5' date +%d)
fi

if [[ ! -v input ]]; then
    input="$INPUT_DIR/input$day.txt"
fi

if ! $(is_number $1); then
    print_help
fi
part=$1
shift

if [[ ! -v lang ]]; then
    src=$(fd "day$day" | head -1)

    if [[ -z "$src" ]]; then
        msg "Didn't find any source files for day $day."
        exit 2
    fi

    lang=${src##*.}
fi

submit_answer() {
    source .env # SESSION_TOKEN
    if [[ ! -v SESSION_TOKEN ]]; then
        msg "SESSION_TOKEN must be set to submit the answer."
    fi

    url="https://adventofcode.com/${YEAR}/day/$((10#$day))/answer"
    msg "Submitting ${day}-${part} answer ${answer} to ${url}..."
    response=$(curl --show-error  -X POST \
        --cookie session="$SESSION_TOKEN" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --data "level=${part}&answer=${answer}" \
        "$url")

        case "$response" in
            *"too recently"*)
                msg "You're on cooldown. Try again in $(
                    grep "You have" <<< "$response" | sed -E 's/.*You have (([0-9]+m )?[0-9]+s).*/\1/')" ;;
            *"That's not the right answer"*)
                case "$response" in
                    *"too high"*) msg "The answer (${answer}) is too high!" ;;
                    *"too low"*)  msg "The answer (${answer}) is too low!" ;;
                    *)            msg "The answer (${answer}) is wrong!" ;;
                esac ;;
            *"Did you already complete it"*) msg "Puzzle already completed." ;;
            *"the instant this puzzle becomes available"*) msg "Puzzle not yet available." ;;
            *"That's the right answer"*) msg "That's the right answer! Part ${part} done." ;;
            *)
                msg "Unexpected server response: $response"
                exit 3
        esac
}

run_solution() {
    msg "time $@ $part < $input"
    answer=$( ( time "$@" "$part" < "$input" ) | tee /dev/tty | tail -1)
    wl-copy -n "$answer"

    if $submit; then
        submit_answer $answer
    fi
}

case "$lang" in
    java|j)
        mvn compile -DincludeScope=compile -Dmdep.outputFile=$JAVA_CLASSPATH_FILE dependency:build-classpath &&
            run_solution java -cp "$JAVA_CLASSPATH:`cat $JAVA_CLASSPATH_FILE`" "Day$day"
        ;;
    rs|r|rust)
        cargo build --bin "day$day" &&
            run_solution "$RUST_TARGET/day$day"
        ;;
    cpp|c|c++)
        make "day$day" &&
            run_solution "$CPP_TARGET/day$day"
        ;;
    ocaml|ml)
        dune build &&
            OCAMLRUNPARAM=b \
            run_solution "$OCAML_TARGET/day$day.exe"
        ;;
    tcl)
        TCLLIBPATH="{$(realpath $LIB_DIR)/tcl} $TCLLIBPATH" \
            run_solution "$TCL_TARGET/day$day.tcl"
        ;;
    *)
        msg "Language '$lang' not supported."
        ;;
esac

