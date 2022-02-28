#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2120 source=/dev/null

# Enable "strict mode". See: <http://redsymbol.net/articles/unofficial-bash-strict-mode>
set -euo pipefail

# Log level enum values
readonly LOG_NONE=0
readonly LOG_ERROR=1
readonly LOG_INFO=2
readonly LOG_DEBUG=3
readonly LOG_TRACE=4
# Terminal color codes
readonly BOLD="\033[1m"
readonly CLEAR="\033[0m"
readonly GRAY="\033[0;37m"
readonly RED="\033[0;31m"
readonly GREEN="\033[0;32m"
readonly CYAN="\033[0;36m"
readonly MAGENTA="\033[0;35m"
# Exit code for failures that aren't panics
readonly NO_PANIC=255
# Command line arguments
readonly ARGS=("$@")

# Displays a panic message when an error occurs
trap 'status="${?:-?}"; panic_handler "$(fn 0)" "$LINENO" "$status"' ERR EXIT
panic_handler() {
    local fn="${1:-?}"
    local line="${2:-?}"
    local status="${3:-?}"
    if [ "$status" != "0" ] && [ "$status" != "$NO_PANIC" ]; then
        log panic "$fn" "$line" "command failed with exit status $status at $fn:$line, aborting"
        exit $NO_PANIC
    fi
}

# Displays the help for this program
help() {
    printf '%s\n' \
        'Nix installer for macOS' \
        '' \
        'USAGE:' \
        '    install.sh [OPTIONS]' \
        '' \
        'OPTIONS:' \
        '    -h, --help                Print help information' \
        '    -l, --log <LEVEL>         Set the log level: none, error, info, debug, trace [default: info]' \
        '    -q, --quiet               Disable non-error logs; alias of `--log error`' \
        '    -s, --silent              Disable all logs; alias of `--log none`' \
        '    -v, --verbose             Enable all logs; alias of `--log trace`' \
        '' \
        '    --config                  Set the Nix config [default: reimu]' \
        '    --username                Set the user username' \
        '    --home                    Set the user home path' \
        '    --name                    Set the user name' \
        '    --email                   Set the user email' \
        '    --no-install-xcode        Do not install Xcode cli tools' \
        '    --no-install-nix          Do not install Nix' \
        '    --no-install-nix-darwin   Do not install nix-darwin' \
        '    --no-config               Do not generate config file' \
        '    --no-bootstrap            Do not bootstrap system' \
        '    --force-bootstrap         Forcibly bootstrap the system'
}

# Initialize the program options
init_options() {
    START_TIME="$(now)"
    LOG=$LOG_INFO
    CONFIG="reimu"
    CONFIG_USERNAME="$(id -un)"
    CONFIG_HOME="$HOME"
    CONFIG_NAME="$(id -F)"
    CONFIG_EMAIL=""
    INSTALL_XCODE=true
    INSTALL_NIX=true
    INSTALL_NIX_DARWIN=true
    MAKE_CONFIG=true
    SHOULD_BOOTSTRAP=true
    FORCE_BOOTSTRAP=false
    SRC_PATH="$(cd -- "$(dirname "$0")" >/dev/null 2>&1 && pwd -P)"
}

# Parses the command line arguments
parse_args() {
    local positional_args=()

    while [[ $# -gt 0 ]]; do
        case $1 in
        -h | --help)
            help && exit
            ;;
        -l | --log)
            if [ -z "${2:-}" ]; then error "expected log level" && exit $NO_PANIC; fi
            local level
            { level=$(log_value "$2" | tee /dev/fd/3); } 3>&1
            LOG="$level"
            shift && shift
            ;;
        -v | --verbose)
            LOG="$LOG_TRACE" && shift
            ;;
        -q | --quiet)
            LOG="$LOG_ERROR" && shift
            ;;
        -s | --silent)
            LOG="$LOG_NONE" && shift
            ;;
        --config)
            if [ -z "${2:-}" ]; then error "expected config" && exit $NO_PANIC; fi
            CONFIG="$2" && shift && shift
            ;;
        --username)
            if [ -z "${2:-}" ]; then error "expected username" && exit $NO_PANIC; fi
            CONFIG_USERNAME="$2" && shift && shift
            ;;
        --home)
            if [ -z "${2:-}" ]; then error "expected home" && exit $NO_PANIC; fi
            CONFIG_HOME="$2" && shift && shift
            ;;
        --name)
            if [ -z "${2:-}" ]; then error "expected name" && exit $NO_PANIC; fi
            CONFIG_NAME="$2" && shift && shift
            ;;
        --email)
            if [ -z "${2:-}" ]; then error "expected email" && exit $NO_PANIC; fi
            CONFIG_EMAIL="$2" && shift && shift
            ;;
        --no-install-xcode)
            INSTALL_XCODE=false && shift
            ;;
        --no-install-nix)
            INSTALL_NIX=false && shift
            ;;
        --no-install-nix-darwin)
            INSTALL_NIX_DARWIN=false && shift
            ;;
        --no-bootstrap)
            SHOULD_BOOTSTRAP=false && shift
            ;;
        --force-bootstrap)
            FORCE_BOOTSTRAP=true && shift
            ;;
        --no-config)
            MAKE_CONFIG=false && shift
            ;;
        --* | -*)
            error "unknown option '$1'" && help && exit $NO_PANIC
            ;;
        *)
            positional_args+=("$1") && shift
            ;;
        esac
    done

    debug "parsed command line arguments"
    trace "log=$LOG"
    trace "config='$CONFIG'"
    trace "username='$CONFIG_USERNAME'"
    trace "home='$CONFIG_HOME'"
    trace "name='$CONFIG_NAME'"
    trace "email='$CONFIG_EMAIL'"
    trace "make_config=$MAKE_CONFIG"
    trace "should_bootstrap=$SHOULD_BOOTSTRAP"
    trace "force_bootstrap=$FORCE_BOOTSTRAP"
    trace "src_path='$SRC_PATH'"
}

# Logs an event with the specified log level
error() { log error "$(fn)" "$(line)" "$@"; }
info() { log info "$(fn)" "$(line)" "$@"; }
debug() { log debug "$(fn)" "$(line)" "$@"; }
trace() { log trace "$(fn)" "$(line)" "$@"; }

# Logs an event; it's displayed if the global log level is at least the message log level
log() {
    local log_level
    local elapsed_time
    local log_name="$1"
    local fn="$2"
    local line="$3"
    local msg="${*:4}"
    log_level="$(log_value "$log_name")"
    elapsed_time=$(printf "%s" "$(($(now) - START_TIME)))" | awk '{printf "%02d:%02d:%02d",$0/3600,$0%3600/60,$0%60}')

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
        printf "$GRAY$elapsed_time$CLEAR $color$BOLD%5s$CLEAR $BOLD%s:%s:$CLEAR %s\n" "$log_name" "$fn" "$line" "$msg"
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

# Returns the current time in seconds
now() { date -u '+%s'; }
# Returns the function name the specified number of callstacks up
fn() { echo "${FUNCNAME[((${1:-1} + 1))]:-install.sh}"; }
# Returns the line number the specified number of callstacks up
line() { echo "${BASH_LINENO[((${1:-0} + 1))]:-?}"; }

# Checks the installation requirements are met
check_requirements() {
    local os
    local cpu_arch
    os="$(uname -s)"
    cpu_arch="$(uname -m)"

    case "$os" in
    Darwin) ;;
    *) error "unsupported operating system '$os'" && exit $NO_PANIC ;;
    esac

    case "$cpu_arch" in
    arm64 | x86_64) ;;
    *) error "unsupported cpu architecture '$cpu_arch'" && exit $NO_PANIC ;;
    esac

    debug "os='$os', cpu_arch='$cpu_arch'"
}

# Installs XCode CLI tools
install_xcode_cli_tools() {
    if ! $INSTALL_XCODE; then
        debug 'user disabled installing xcode cli tools, skipping'
        return
    fi

    if xcode-select -p 1>/dev/null; then
        debug 'xcode cli tools already installed, skipping'
        return
    fi

    info 'fetching latest xcode cli tools version'
    local xcode_version
    xcode_version="$(
        softwareupdate --list |
            grep --extended-regexp --only-matching "Command Line Tools for Xcode-\d+\.\d+" |
            head --lines 1
    )"
    info "got '$xcode_version', installing..."
    run "softwareupdate --install '$xcode_version'"
}

# Installs Nix
install_nix() {
    if ! $INSTALL_NIX; then
        debug 'user disabled installing nix, skipping'
        return
    fi

    if command -v nix &>/dev/null; then
        debug 'nix already installed, skipping'
        return
    fi

    local path
    path="$(mktemp -d)"
    local profile='/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    info 'installing nix...'
    debug "changing directory path='$path'" && cd "$path"
    run 'curl --proto =https --tlsv1.2 -sfSL https://nixos.org/nix/install >nix-installer'
    run 'chmod +x nix-installer'
    run 'true | ./nix-installer'

    set +u && . $profile && set -u
    debug "nix sourced profile='$profile' PATH='$PATH'"
}

# Ensures /etc/nix/nix.conf is a symlink
check_nix_conf_is_symlink() {
    if [ ! -L /etc/nix/nix.conf ]; then
        info "moving nix config from /etc/nix/nix.conf to /etc/nix/nix.conf.old"
        run 'sudo mv -n /etc/nix/nix.conf /etc/nix/nix.conf.old'
    else
        debug '/etc/nix/nix.conf is a symlink, skipping'
    fi
}

# Installs nix-darwin
install_nix_darwin() {
    if ! $INSTALL_NIX_DARWIN; then
        debug 'user disabled installing nix-darwin, skipping'
        return
    fi

    if command -v darwin-rebuild &>/dev/null; then
        debug 'nix-darwin already installed, skipping'
        return
    fi

    info 'installing nix-darwin...'

    local path
    path="$(mktemp -d)"
    local profile='/etc/static/bashrc'
    debug "changing directory path='$path'" && cd "$path"
    run "nix-build --quiet --no-build-output https://github.com/LnL7/nix-darwin/archive/master.tar.gz --attr installer"
    debug "changing directory path='$path/result/bin'" && cd "$path/result/bin"
    check_nix_conf_is_symlink
    run "true | ./darwin-installer"
    set +u && . $profile && set -u
    debug "nix-darwin sourced profile='$profile' PATH='$PATH'"
}

# Creates the system config file
make_config() {
    if ! $MAKE_CONFIG; then
        debug 'user disabled `config.toml` generation, skipping'
        return
    elif [ -s config.toml ]; then
        debug '`config.toml` is not empty, skipping'
        return
    fi

    info 'generating config file `config.toml`'
    run "cat <<EOF > '$SRC_PATH/config.toml'
# User configuration
[user]
username = \"$CONFIG_USERNAME\" # Your user name
home = \"$CONFIG_HOME\" # Your home path
name = \"$CONFIG_NAME\" # Your name
email = \"$CONFIG_EMAIL\" # Your email
useVim = false # Whether to enable vim mode
EOF"
    run "git -C '$SRC_PATH' add config.toml"
}

# Bootstraps the system
bootstrap_system() {
    if ! $SHOULD_BOOTSTRAP; then
        debug 'user disabled bootstrapping, skipping'
        return
    fi

    if ! $FORCE_BOOTSTRAP && [ -d "/etc/profiles/per-user/$CONFIG_USERNAME" ]; then
        debug 'system already bootstrapped, skipping'
        return
    fi

    local config="$1"
    info "building system '$config'..."
    debug "changing directory path='$SRC_PATH'" && cd "$SRC_PATH"
    run "nix build .#darwinConfigurations.$config.system --extra-experimental-features 'nix-command flakes'"
    info "bootstrapping system '$config'..."
    check_nix_conf_is_symlink
    run "./result/sw/bin/darwin-rebuild switch --flake .#$config"
}

main() {
    init_options
    parse_args "${ARGS[@]}"
    check_requirements
    install_xcode_cli_tools
    install_nix
    install_nix_darwin
    make_config
    bootstrap_system "$CONFIG"
    info "done!"
}

main
