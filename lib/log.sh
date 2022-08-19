#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2120 source=/dev/null

# Enable "strict mode". See: <http://redsymbol.net/articles/unofficial-bash-strict-mode>
set -euo pipefail
# Setup panic handler
trap 'status="${?:-?}"; panic_handler "$(fn 0)" "$LINENO" "$status"' ERR EXIT

# Log level enum values
readonly LOG_NONE=0
readonly LOG_ERROR=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3
readonly LOG_TRACE=4
# Terminal color codes
readonly BOLD="\033[1m"
readonly CLEAR="\033[0m"
readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly CYAN="\033[0;36m"
readonly MAGENTA="\033[0;35m"
# Exit code for failures that aren't panics
readonly NO_PANIC=255

# Displays a panic message when an error occurs
panic_handler() {
    local fn="${1:-?}"
    local line="${2:-?}"
    local status="${3:-?}"
    if [ "$status" != "0" ] && [ "$status" != "$NO_PANIC" ]; then
        log panic "$fn" "$line" "command failed with exit status $status at $fn:$line, aborting"
        exit $NO_PANIC
    fi
}

# Initialize the program options
init_options() {
    LOG=$LOG_INFO
}

# Logs an event with the specified log level
error() { log error "$(fn)" "$(line)" "$@"; }
info() { log info "$(fn)" "$(line)" "$@"; }
debug() { log debug "$(fn)" "$(line)" "$@"; }
trace() { log trace "$(fn)" "$(line)" "$@"; }

# Logs an event; it's displayed if the global log level is at least the message log level
log() {
    local log_level
    local log_name="$1"
    local fn="$2"
    local line="$3"
    local msg="${*:4}"
    log_level="$(log_value "$log_name")"

    if [ "$LOG" -lt "$log_level" ]; then
        return
    fi

    local color
    case "$log_level" in
    "$LOG_INFO") color="$GREEN" ;;
    "$LOG_DEBUG") color="$CYAN" ;;
    "$LOG_TRACE") color="$MAGENTA" ;;
    "$LOG_ERROR") color="$RED" ;;
    *) error "invalid log level '$log_level'" && exit $NO_PANIC ;;
    esac

    if [ "$LOG" -ge "$LOG_DEBUG" ]; then
        printf "$color$BOLD%5s$CLEAR $BOLD%s:%s:$CLEAR %s\n" "$log_name" "$fn" "$line" "$msg"
    else
        printf "$color$BOLD%s$CLEAR %s\n" "$log_name" "$msg"
    fi
}

# Maps log level enum names to values
log_value() {
    local name="$1"

    local value
    case "$name" in
    none) value="$LOG_NONE" ;;
    error | panic) value="$LOG_ERROR" ;;
    info) value="$LOG_INFO" ;;
    debug) value="$LOG_DEBUG" ;;
    trace) value="$LOG_TRACE" ;;
    *) error "invalid log level '$name'" && exit $NO_PANIC ;;
    esac

    echo "$value"
}

# Runs a command, displaying it if the global log level is `trace`
run() {
    if [ "$LOG" -ge "$LOG_DEBUG" ]; then
        local fn="${FUNCNAME[1]}"
        local line="${BASH_LINENO[0]}"
        local prefix
        prefix="$(log trace "$fn:$*" "$line" '')"
        prefix="${prefix//$'\n'/}" # Remove newlines or awk gets grumpy
        log debug "$fn" "$line" "running \`$*\`"
        eval "$*" 2>&1 | awk -v prefix="$prefix" '{ print prefix, $0 }'
    else
        eval "$*" &>/dev/null
    fi
}

# Returns the function name the specified number of callstacks up
fn() { echo "${FUNCNAME[((${1:-1} + 1))]:-install.sh}"; }
# Returns the line number the specified number of callstacks up
line() { echo "${BASH_LINENO[((${1:-0} + 1))]:-?}"; }

init_options
