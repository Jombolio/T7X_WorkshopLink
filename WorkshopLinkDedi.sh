#!/bin/bash
# ============================================================
# Black Ops 3 Workshop Symlink Utility (Linux Dedicated)
# ============================================================

echo "============================================================"
echo "     Black Ops 3 Workshop Symlink Utility (Linux)"
echo "============================================================"
echo

# --- CONFIGURATION -------------------------------------------------------
# Automatically detect paths relative to this script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
GAME_DIR="$SCRIPT_DIR"
WORKSHOP_PATH="$GAME_DIR/../../workshop/content/311210"

# Resolve absolute path
WORKSHOP_PATH="$(realpath "$WORKSHOP_PATH")"

echo "Detected Workshop folder:"
echo "    $WORKSHOP_PATH"
echo

if [ ! -d "$WORKSHOP_PATH" ]; then
    echo "[ERROR] Could not find workshop folder at:"
    echo "        $WORKSHOP_PATH"
    echo "Please ensure this script is in your BO3 folder."
    echo "Example: ~/Steam/steamapps/common/Call of Duty Black Ops III/"
    exit 1
fi

# --- Prepare target directories -----------------------------------------
USERMAPS="$GAME_DIR/usermaps"
MODS="$GAME_DIR/mods"

mkdir -p "$USERMAPS"
mkdir -p "$MODS"

echo "[INFO] Scanning workshop items..."
echo

# --- Iterate through workshop folders -----------------------------------
for DIR in "$WORKSHOP_PATH"/*; do
    [ -d "$DIR" ] || continue
    SHORTNAME="$(basename "$DIR")"
    echo "Checking folder: $SHORTNAME"

    MAPNAME=""
    IS_MOD=0

    # Detect zm_mod.ff, mp_mod.ff, *_core_mod.ff (mods)
    if [ -f "$DIR/zm_mod.ff" ]; then
        MAPNAME="zm_mod"
        IS_MOD=1
    elif [ -f "$DIR/mp_mod.ff" ]; then
        MAPNAME="mp_mod"
        IS_MOD=1
    else
        CORE_MOD=$(find "$DIR" -maxdepth 1 -type f -name "*_core_mod.ff" -print -quit)
        if [ -n "$CORE_MOD" ]; then
            MAPNAME="$(basename "$CORE_MOD" .ff)"
            IS_MOD=1
        fi
    fi

    # Detect zm_*.ff (maps)
    if [ "$IS_MOD" -eq 0 ]; then
        ZM_MAP=$(find "$DIR" -maxdepth 1 -type f -name "zm_*.ff" ! -name "zm_mod.ff" -print -quit)
        if [ -n "$ZM_MAP" ]; then
            MAPNAME="$(basename "$ZM_MAP" .ff)"
        fi
    fi

    # Skip if nothing found
    if [ -z "$MAPNAME" ]; then
        echo "  No zm_*.ff, zm_mod.ff, mp_mod.ff, or *_core_mod.ff found, skipping."
        continue
    fi

    # Set target path
    if [ "$IS_MOD" -eq 1 ]; then
        TARGET="$MODS/${MAPNAME}_${SHORTNAME}"
    else
        TARGET="$USERMAPS/$MAPNAME"
    fi

    # Skip existing links
    if [ -e "$TARGET" ]; then
        echo "  Skipping existing link: $MAPNAME"
        continue
    fi

    echo "  Linking \"$SHORTNAME\" → \"$TARGET\""
    ln -s "$DIR" "$TARGET"

    if [ $? -eq 0 ]; then
        echo "  [OK] Linked successfully."
    else
        echo "  [ERROR] Failed to create symlink."
    fi

    echo
done

echo
echo "[INFO] Done"
echo "------------------------------------"
echo "Usermaps:"
echo "------------------------------------"
ls -1 "$USERMAPS"
echo "------------------------------------"
echo "Mods:"
echo "------------------------------------"
ls -1 "$MODS"
echo "------------------------------------"
