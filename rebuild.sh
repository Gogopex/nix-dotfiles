set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Function to print colored output
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
    echo "Rebuild Darwin configuration with enhanced features."
    echo ""
    echo "Arguments:"
    echo "  hostname      The host to build (optional, tries to detect automatically)"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  --ask         Preview changes before applying (requires nh)"
    echo "  --no-nh       Force use of darwin-rebuild even if nh is available"
    echo "  --            Pass remaining arguments to darwin-rebuild/nh"
    echo ""
    echo "Examples:"
    echo "  $0                      # Build current host"
    echo "  $0 macbook              # Build specific host"
    echo "  $0 --ask                # Preview changes before applying"
    echo "  $0 -- --show-trace      # Pass extra args to darwin-rebuild/nh"
}

HOST=""
EXTRA_ARGS=()
PARSE_EXTRA=false
USE_NH=true
ASK_FLAG=false

for arg in "$@"; do
    if [[ "$PARSE_EXTRA" == "true" ]]; then
        EXTRA_ARGS+=("$arg")
    elif [[ "$arg" == "--" ]]; then
        PARSE_EXTRA=true
    elif [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
        usage
        exit 0
    elif [[ "$arg" == "--no-nh" ]]; then
        USE_NH=false
    elif [[ "$arg" == "--ask" ]]; then
        ASK_FLAG=true
    elif [[ -z "$HOST" ]]; then
        HOST="$arg"
    else
        print_error "Unknown argument: $arg"
        usage
        exit 1
    fi
done

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

if [[ -z "$HOST" ]]; then
    DETECTED_HOST=$(hostname -s)
    
    if [[ "$DETECTED_HOST" == *"MacBook"* ]] && [[ -d "hosts/macbook" ]]; then
        HOST="macbook"
        print_info "Detected macOS system, using host configuration: $HOST"
    elif HOST_DIR=$(find_host_dir "$DETECTED_HOST"); then
        HOST="$HOST_DIR"
        print_info "Auto-detected host configuration: $HOST"
    else
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

if command -v nh &> /dev/null && [[ "$USE_NH" == "true" ]]; then
    print_info "Using nh for rebuild (better UX)..."
    
    NH_ARGS=("darwin" "switch" "." "--hostname" "$HOST")
    
    if [[ "$ASK_FLAG" == "true" ]]; then
        NH_ARGS+=("--ask")
    fi
    
    NIX_ARGS=(
        "--option" "accept-flake-config" "true"
        "--option" "eval-cache" "false"
    )
    
    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
        NIX_ARGS+=("${EXTRA_ARGS[@]}")
    fi
    
    export NH_FLAKE="$SCRIPT_DIR"
    if nh "${NH_ARGS[@]}" -- "${NIX_ARGS[@]}"; then
        print_success "Darwin configuration rebuilt successfully with nh!"
    else
        print_error "Darwin rebuild with nh failed!"
        exit 1
    fi
else
    if [[ "$ASK_FLAG" == "true" ]]; then
        print_warning "--ask flag requires nh, falling back to darwin-rebuild without preview"
    fi
    
    print_info "Using darwin-rebuild..."
    
    DARWIN_ARGS=(
        "switch"
        "--flake" ".#$HOST"
    )
    
    NIX_ARGS=(
        "--option" "accept-flake-config" "true"
        "--option" "eval-cache" "false"
        "--option" "experimental-features" "nix-command flakes pipe-operators"
    )
    
    if [[ ${#EXTRA_ARGS[@]} -gt 0 ]]; then
        NIX_ARGS+=("${EXTRA_ARGS[@]}")
    fi
    
    if sudo darwin-rebuild "${DARWIN_ARGS[@]}" "${NIX_ARGS[@]}"; then
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
fi
