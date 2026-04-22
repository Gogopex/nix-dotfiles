#!/usr/bin/env bash

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_info() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

usage() {
    echo "Usage: $0 [hostname] [options]"
    echo ""
    echo "Rebuild Nix configuration (Darwin or Home Manager)."
    echo ""
    echo "Arguments:"
    echo "  hostname      The host to build (optional, tries to detect automatically)"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  --ask         Preview changes before applying (requires nh)"
    echo "  --home        Rebuild only Home Manager configuration"
    echo "  --no-nh       Force use of native tools even if nh is available"
    echo "  --profile     Set package profile (core or full)"
    echo "  --            Pass remaining arguments to rebuild tool"
    echo ""
    echo "Examples:"
    echo "  $0                      # Build current host"
    echo "  $0 macbook              # Build specific host"
    echo "  $0 mbp                  # Build the new Mac host"
    echo "  $0 --ask                # Preview changes before applying"
    echo "  $0 --profile full       # Switch package profile and rebuild"
    echo "  $0 -- --show-trace      # Pass extra args to rebuild tool"
}

HOST=""
EXTRA_ARGS=()
PARSE_EXTRA=false
USE_NH=true
ASK_FLAG=false
HOME_ONLY=false
PROFILE=""
EXPECT_PROFILE=false

SYSTEM_TYPE="unknown"
if [[ "$(uname -s)" == "Darwin" ]]; then
    SYSTEM_TYPE="darwin"
elif [[ "$(uname -s)" == "Linux" ]]; then
    SYSTEM_TYPE="linux"
else
    print_error "Unsupported system: $(uname -s)"
    exit 1
fi

for arg in "$@"; do
    if [[ "$PARSE_EXTRA" == "true" ]]; then
        EXTRA_ARGS+=("$arg")
    elif [[ "$EXPECT_PROFILE" == "true" ]]; then
        PROFILE="$arg"
        EXPECT_PROFILE=false
    elif [[ "$arg" == "--" ]]; then
        PARSE_EXTRA=true
    elif [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    elif [[ "$arg" == "--no-nh" ]]; then
        USE_NH=false
    elif [[ "$arg" == "--ask" ]]; then
        ASK_FLAG=true
    elif [[ "$arg" == "--home" ]]; then
        HOME_ONLY=true
    elif [[ "$arg" == "--profile" ]]; then
        EXPECT_PROFILE=true
    elif [[ "$arg" == --profile=* ]]; then
        PROFILE="${arg#--profile=}"
    elif [[ -z "$HOST" ]]; then
        HOST="$arg"
    else
        print_error "Unknown argument: $arg"
        usage
        exit 1
    fi
done

if [[ "$EXPECT_PROFILE" == "true" ]]; then
    print_error "Missing value for --profile"
    usage
    exit 1
fi

if [[ -n "$PROFILE" ]] && [[ "$PROFILE" != "core" ]] && [[ "$PROFILE" != "full" ]]; then
    print_error "Invalid profile: $PROFILE (expected core or full)"
    usage
    exit 1
fi

find_host_dir() {
    local hostname="$1"
    
    if [[ -d "hosts/$hostname" ]]; then
        echo "$hostname"
        return 0
    fi
    
    for dir in hosts/*/; do
        if [[ -d "$dir" ]]; then
            basename_dir=$(basename "$dir")
            if [[ "$hostname" == "$basename_dir"* ]] || [[ "$basename_dir" == "$hostname"* ]]; then
                echo "$basename_dir"
                return 0
            fi
        fi
    done
    
    return 1
}

collect_detected_hosts() {
    local detected_hosts=()
    local candidate=""

    if command -v hostname &> /dev/null; then
        candidate=$(hostname -s 2>/dev/null || true)
        if [[ -n "$candidate" ]]; then
            detected_hosts+=("$candidate")
        fi
    elif [[ -f /etc/hostname ]]; then
        candidate=$(cat /etc/hostname)
        if [[ -n "$candidate" ]]; then
            detected_hosts+=("$candidate")
        fi
    elif command -v hostnamectl &> /dev/null; then
        candidate=$(hostnamectl --static 2>/dev/null || true)
        if [[ -n "$candidate" ]]; then
            detected_hosts+=("$candidate")
        fi
    fi

    if [[ "$SYSTEM_TYPE" == "darwin" ]] && command -v scutil &> /dev/null; then
        candidate=$(scutil --get LocalHostName 2>/dev/null || true)
        if [[ -n "$candidate" ]]; then
            detected_hosts+=("$candidate")
        fi

        candidate=$(scutil --get ComputerName 2>/dev/null || true)
        if [[ -n "$candidate" ]]; then
            detected_hosts+=("$candidate")
        fi
    fi

    printf '%s\n' "${detected_hosts[@]}"
}

if [[ -z "$HOST" ]]; then
    DETECTED_HOSTS=()
    while IFS= read -r detected_host; do
        if [[ -n "$detected_host" ]]; then
            DETECTED_HOSTS+=("$detected_host")
        fi
    done < <(collect_detected_hosts)

    for DETECTED_HOST in "${DETECTED_HOSTS[@]}"; do
        if HOST_DIR=$(find_host_dir "$DETECTED_HOST"); then
            HOST="$HOST_DIR"
            print_info "Auto-detected host configuration: $HOST"
            break
        fi
    done

    if [[ -z "$HOST" ]] && [[ -d "hosts/quietbox" ]]; then
        for DETECTED_HOST in "${DETECTED_HOSTS[@]}"; do
            if [[ "$DETECTED_HOST" == "archlinux" ]]; then
                HOST="quietbox"
                print_info "Detected Arch Linux system, using host configuration: $HOST"
                break
            fi
        done
    fi

    if [[ -z "$HOST" ]] && [[ "$SYSTEM_TYPE" == "darwin" ]] && [[ -d "hosts/macbook" ]]; then
        for DETECTED_HOST in "${DETECTED_HOSTS[@]}"; do
            if [[ "$DETECTED_HOST" == *"MacBook"* ]]; then
                HOST="macbook"
                print_info "Falling back to legacy macOS host configuration: $HOST"
                break
            fi
        done
    fi

    if [[ -z "$HOST" ]]; then
        DETECTED_HOST="${DETECTED_HOSTS[0]:-unknown}"
        print_error "Could not auto-detect host configuration for: $DETECTED_HOST"
        print_info "Available hosts:"
        for dir in hosts/*/; do
            if [[ -d "$dir" ]]; then
                echo "  - $(basename "$dir")"
            fi
        done
        exit 1
    fi
else
    if [[ ! -d "hosts/$HOST" ]]; then
        if HOST_DIR=$(find_host_dir "$HOST"); then
            HOST="$HOST_DIR"
            print_info "Found matching host configuration: $HOST"
        else
            print_error "Host configuration not found: hosts/$HOST"
            print_info "Available hosts:"
            for dir in hosts/*/; do
                if [[ -d "$dir" ]]; then
                    echo "  - $(basename "$dir")"
                fi
            done
            exit 1
        fi
    fi
fi

cd "$SCRIPT_DIR"

if [[ "$HOME_ONLY" == "true" ]]; then
    HOME_CONFIG_NAMES=$(nix eval --json "$SCRIPT_DIR#homeConfigurations" --apply builtins.attrNames 2>/dev/null || true)
    if [[ -z "$HOME_CONFIG_NAMES" ]]; then
        print_error "Unable to read homeConfigurations from flake."
        exit 1
    fi

    if ! echo "$HOME_CONFIG_NAMES" | grep -q "\"$HOST\""; then
        AVAILABLE_HOME_CONFIGS=$(echo "$HOME_CONFIG_NAMES" | tr -d '[]"' | tr ',' ' ')
        print_error "Home-only rebuild requested, but homeConfigurations.$HOST is not defined."
        print_info "Available homeConfigurations: ${AVAILABLE_HOME_CONFIGS:-none}"
        print_info "Run without --home or add a standalone Home Manager config for this host."
        exit 1
    fi
fi

if [[ -n "$PROFILE" ]]; then
    PROFILE_FILE="$SCRIPT_DIR/hosts/$HOST/profile.nix"
    print_info "Setting package profile for $HOST to $PROFILE"
    cat > "$PROFILE_FILE" <<EOF
{ ... }:
{
  packages.profile = "$PROFILE";
}
EOF
fi

if command -v nh &> /dev/null && [[ "$USE_NH" == "true" ]]; then
    print_info "Using nh for rebuild (better UX)..."

    if [[ "$HOME_ONLY" == "true" ]]; then
        NH_ARGS=("home" "switch" ".#homeConfigurations.$HOST.activationPackage")
    elif [[ "$SYSTEM_TYPE" == "darwin" ]]; then
        NH_ARGS=("darwin" "switch" ".#darwinConfigurations.$HOST")
    else
        NH_ARGS=("home" "switch" ".#homeConfigurations.$HOST.activationPackage")
    fi
    
    if [[ "$ASK_FLAG" == "true" ]]; then
        NH_ARGS+=("--ask")
    fi
    
    NIX_ARGS=(
        "--extra-experimental-features" "pipe-operators"
        "--option" "accept-flake-config" "true"
        "--option" "eval-cache" "true"
    )
    
    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
        NIX_ARGS+=("${EXTRA_ARGS[@]}")
    fi
    
    export NH_FLAKE="$SCRIPT_DIR"
    if nh "${NH_ARGS[@]}" -- "${NIX_ARGS[@]}"; then
        print_success "Configuration rebuilt successfully with nh!"
    else
        print_error "Rebuild with nh failed!"
        exit 1
    fi
else
    if [[ "$ASK_FLAG" == "true" ]]; then
        print_warning "--ask flag requires nh, falling back to native tools without preview"
    fi

    if [[ "$HOME_ONLY" == "true" ]]; then
        print_info "Using home-manager..."

        HM_ARGS=(
            "switch"
            "--flake" ".#$HOST"
            "-b" "backup"
        )

        if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
            HM_ARGS+=("${EXTRA_ARGS[@]}")
        fi

        HM_ARGS+=(
            "--extra-experimental-features" "pipe-operators"
            "--option" "accept-flake-config" "true"
            "--option" "eval-cache" "true"
        )

        if home-manager "${HM_ARGS[@]}"; then
            print_success "Home Manager configuration rebuilt successfully!"

            if ! command -v nh &> /dev/null; then
                echo ""
                print_info "Tip: Consider installing nh for better rebuild UX with diffs and --ask flag"
            fi
        else
            print_error "Home Manager rebuild failed!"
            exit 1
        fi
    elif [[ "$SYSTEM_TYPE" == "darwin" ]]; then
        DARWIN_ARGS=(
            "switch"
            "--flake" ".#$HOST"
        )

        NIX_ARGS=(
            "--option" "accept-flake-config" "true"
            "--option" "eval-cache" "true"
            "--option" "experimental-features" "nix-command flakes pipe-operators"
        )

        if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
            NIX_ARGS+=("${EXTRA_ARGS[@]}")
        fi

        if command -v darwin-rebuild &> /dev/null; then
            print_info "Using darwin-rebuild..."
            DARWIN_CMD=(sudo darwin-rebuild)
        else
            print_info "darwin-rebuild not found, bootstrapping via nix run..."
            DARWIN_CMD=(
                sudo
                nix
                "run"
                "nix-darwin/master#darwin-rebuild"
                "--"
            )
        fi

        if "${DARWIN_CMD[@]}" "${DARWIN_ARGS[@]}" "${NIX_ARGS[@]}"; then
            print_success "Darwin configuration rebuilt successfully!"

            if ! command -v nh &> /dev/null; then
                echo ""
                print_info "Tip: nh has been added to your packages but requires a rebuild to activate"
                echo "      After this rebuild, you'll get nice diffs and an --ask flag!"
            fi
        else
            print_error "Darwin rebuild failed!"
            exit 1
        fi
    else
        print_info "Using home-manager..."

        HM_ARGS=(
            "switch"
            "--flake" ".#$HOST"
            "-b" "backup"
        )

        if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
            HM_ARGS+=("${EXTRA_ARGS[@]}")
        fi

        HM_ARGS+=(
            "--extra-experimental-features" "pipe-operators"
            "--option" "accept-flake-config" "true"
            "--option" "eval-cache" "true"
        )

        if home-manager "${HM_ARGS[@]}"; then
            print_success "Home Manager configuration rebuilt successfully!"

            if ! command -v nh &> /dev/null; then
                echo ""
                print_info "Tip: Consider installing nh for better rebuild UX with diffs and --ask flag"
            fi
        else
            print_error "Home Manager rebuild failed!"
            exit 1
        fi
    fi
fi
