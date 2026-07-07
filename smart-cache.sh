# =======================================
# SMART CACHE SYSTEM - Auto-restore dependencies
# =======================================

# CONFIG: Auto-clean cache on each shell start? (1=yes, 0=no)
AUTO_CLEAN_ON_START=1

# Function: Detect project type in current directory
detect_project_type() {
    if [ -f Cargo.toml ]; then echo "rust"; return 0; fi
    if [ -f package.json ]; then echo "node"; return 0; fi
    if [ -f build.gradle ] || [ -f build.gradle.kts ]; then echo "gradle"; return 0; fi
    if [ -f pom.xml ]; then echo "maven"; return 0; fi
    if [ -f requirements.txt ] || [ -f setup.py ] || [ -f pyproject.toml ]; then echo "python"; return 0; fi
    return 1
}

# Function: Restore dependencies for detected project type (silent, on-demand)
restore_project_deps() {
    local proj_type=$(detect_project_type) || return 0

    case "$proj_type" in
        rust)
            if [ ! -d "$HOME/.cargo/registry/src" ]; then
                echo "🦀 Cargo cache missing - fetching deps..."
                cargo fetch --quiet 2>&1 || true
            fi
            ;;
        node)
            if [ ! -d node_modules ] && [ -f package.json ]; then
                echo "📦 NPM cache missing - installing deps..."
                npm install --loglevel=error --prefer-offline 2>&1 | tail -3 || true
            fi
            ;;
        gradle)
            if [ ! -d "$HOME/.gradle/caches" ]; then
                echo "🐘 Gradle cache missing - downloading deps..."
                gradle --no-daemon dependencies --quiet 2>&1 || true
            fi
            ;;
    esac
}

# Function: Auto-clean caches on shell start (if enabled)
auto_clean_on_start() {
    [ "$AUTO_CLEAN_ON_START" != "1" ] && return 0

    local cleaned=0
    local total=0

    # NPM (cacache + npx + logs)
    if [ -d "$HOME/.npm/_cacache" ]; then
        total=$((total + $(du -s "$HOME/.npm/_cacache" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.npm/_cacache"
        cleaned=1
    fi
    if [ -d "$HOME/.npm/_npx" ]; then
        total=$((total + $(du -s "$HOME/.npm/_npx" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.npm/_npx"
        cleaned=1
    fi
    if [ -d "$HOME/.npm/_logs" ]; then
        total=$((total + $(du -s "$HOME/.npm/_logs" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.npm/_logs"
        cleaned=1
    fi

    # Cargo
    if [ -d "$HOME/.cargo/registry/src" ]; then
        total=$((total + $(du -s "$HOME/.cargo/registry/src" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.cargo/registry/src" "$HOME/.cargo/registry/cache"
        cleaned=1
    fi

    # Gradle (caches + wrapper + daemon)
    if [ -d "$HOME/.gradle/caches" ]; then
        total=$((total + $(du -s "$HOME/.gradle/caches" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.gradle/caches"
        cleaned=1
    fi
    if [ -d "$HOME/.gradle/wrapper" ]; then
        total=$((total + $(du -s "$HOME/.gradle/wrapper" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.gradle/wrapper"
        cleaned=1
    fi
    if [ -d "$HOME/.gradle/daemon" ]; then
        total=$((total + $(du -s "$HOME/.gradle/daemon" 2>/dev/null | cut -f1)))
        rm -rf "$HOME/.gradle/daemon"
        cleaned=1
    fi

    if [ "$cleaned" = "1" ]; then
        echo "🧹 Cache limpo (~$((total / 1024)) MB) - deps serão restauradas sob demanda"
    fi
}

# WRAPPER FUNCTIONS - Transparent command interception
npm() {
    if [ -f package.json ] && [ ! -d node_modules ]; then
        echo "📦 Restaurando NPM deps..."
        command npm install --loglevel=error --prefer-offline 2>&1 | tail -2 || true
    fi
    command npm "$@"
}

cargo() {
    if [ -f Cargo.toml ] && [ ! -d "$HOME/.cargo/registry/src" ]; then
        echo "🦀 Buscando Cargo deps..."
        cargo fetch --quiet 2>&1 || true
    fi
    command cargo "$@"
}

gradle() {
    if [ ! -d "$HOME/.gradle/caches" ]; then
        echo "🐘 Baixando Gradle deps..."
        gradle --no-daemon dependencies --quiet 2>&1 || true
    fi
    command gradle "$@"
}

# Aliases
alias cache-status='(
    echo "=== CACHE STATUS ==="
    [ -d "$HOME/.npm/_cacache" ] && echo "📦 NPM: $(du -sh $HOME/.npm/_cacache 2>/dev/null | cut -f1)" || echo "📦 NPM: (vazio)"
    [ -d "$HOME/.cargo/registry/src" ] && echo "🦀 Cargo: $(du -sh $HOME/.cargo/registry 2>/dev/null | cut -f1)" || echo "🦀 Cargo: (vazio)"
    [ -d "$HOME/.gradle/caches" ] && echo "🐘 Gradle: $(du -sh $HOME/.gradle/caches 2>/dev/null | cut -f1)" || echo "🐘 Gradle: (vazio)"
)'
alias cache-clean='clean_all_caches'

# Auto-clean caches on shell start
auto_clean_on_start

echo "✓ Smart cache loaded - use 'cache-status' para ver status"