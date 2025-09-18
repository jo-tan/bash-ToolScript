#!/bin/bash

# --- Configuration & Setup ---

# Declare an array to track the path at each indentation level
declare -a LEVEL_PATHS

# Define the default folder structure (in 'tree' command format)
# The first line determines the root directory name when no path is specified.
DEFAULT_FOLDER_STRUCTURE="
test/
├── manage.py
├── config/
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings/
│   ├── urls.py
│   └── wsgi.py
├── core/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests/
│   │   └── test_models.py
│   ├── views.py
│   ├── urls.py
│   ├── forms.py
│   ├── templates/
│   │   └── core/
│   │       └── home.html
│   └── static/
│       └── core/
│           ├── css/
│           ├── js/
│           └── images/
├── templates/
│   └── base.html
├── static/
│   └── css/
├── media/
├── requirements/
│   ├── base.txt
│   ├── dev.txt
│   └── prod.txt
├── .env
├── .gitignore
├── README.md
└── venv/
"

# --- Helper Functions ---

# Cleans a line from the tree structure to extract the file/folder name.
parse_tree_line() {
    local line="$1"
    # The name is everything after the '├── ' or '└── '.
    local name="${line##*[└├]── }"
    # Clean up comments, trailing indicators from 'tree -F' (*, @, =, |), trailing slashes, and whitespace.
    name=$(echo "$name" | sed -E 's/[[:space:]]*#.*$//' | sed -E 's/[*@=|/[:space:]]*$//')
    echo "$name"
}

# Calculates the indentation level of a line to determine its depth in the structure.
calculate_indent_level() {
    local line="$1"
    # Ignore lines that are not part of the tree structure.
    if [[ "$line" != *"── "* ]]; then
        echo 0
        return
    fi
    # The prefix is the part of the line used for indentation.
    local prefix="${line%%[└├]── *}"
    # The indent level is the length of this prefix string divided by 4.
    local indent=$((${#prefix} / 4))
    echo "$indent"
}

# Creates a directory if it does not already exist.
create_directory() {
    local path="$1"
    if [ ! -d "$path" ]; then
        echo "📁 Creating directory: $path"
        mkdir -p "$path" || { echo "❌ Failed to create directory: $path"; exit 1; }
    else
        echo "✅ Directory already exists: $path"
    fi
}

# Creates a file, ensuring its parent directory exists first.
create_file() {
    local path="$1"
    local dir
    dir=$(dirname "$path")
    
    # Ensure the parent directory exists.
    if [ ! -d "$dir" ]; then
        create_directory "$dir"
    fi
    
    if [ ! -f "$path" ]; then
        echo "📄 Creating file: $path"
        touch "$path" || { echo "❌ Failed to create file: $path"; exit 1; }
    else
        echo "✅ File already exists: $path"
    fi
}

# --- Main Logic ---

# Initialize variables for argument parsing
USER_DEFINED_ROOT=""
INPUT_FILE=""

# Parse command-line arguments for a custom root directory or an input file.
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -d|--directory)
            if [[ -n "$2" ]]; then
                USER_DEFINED_ROOT="$2"
                shift 2
            else
                echo "❌ Error: --directory option requires a path." >&2
                exit 1
            fi
            ;;
        *)
            if [[ -z "$INPUT_FILE" && -f "$1" ]]; then
                INPUT_FILE="$1"
                shift
            else
                echo "❌ Error: Unknown argument or file not found: $1" >&2
                exit 1
            fi
            ;;
    esac
done

# Determine the source of the folder structure (input file or default).
input_structure=""
if [[ -n "$INPUT_FILE" ]]; then
    echo "ℹ️ Reading structure from file: $INPUT_FILE"
    input_structure=$(<"$INPUT_FILE")
else
    echo "ℹ️ Using built-in folder structure."
    input_structure="$DEFAULT_FOLDER_STRUCTURE"
fi

# Determine the root directory for creation.
ROOT_DIR=""
if [[ -n "$USER_DEFINED_ROOT" ]]; then
    ROOT_DIR="$USER_DEFINED_ROOT"
    echo "ℹ️ User-specified root directory: $ROOT_DIR"
else
    # Smart Default: Determine root from the first non-empty line of the structure.
    first_line=$(echo "$input_structure" | awk 'NF {print; exit}')
    
    # Clean the first line to remove comments, trailing slashes, and whitespace.
    cleaned_line=$(echo "$first_line" | sed -E 's/[[:space:]]*#.*$//' | sed -E 's/[/[:space:]]*$//')
    
    # Use basename to safely extract the directory name from a potential path.
    base_name=$(basename "$cleaned_line")

    if [[ "$base_name" == "." ]]; then
        ROOT_DIR="."
        echo "ℹ️ Structure starts with '.', creating in the current directory."
    else
        ROOT_DIR="./$base_name"
        echo "ℹ️ Structure root is '$base_name', creating in './$base_name'."
    fi
fi

echo "🚀 Starting mass directory and file creation..."
echo "📍 Root directory: $ROOT_DIR"
echo ""

# Ensure the root directory exists.
create_directory "$ROOT_DIR"

# Process each line of the structure.
first_line_processed=false
while IFS= read -r raw_line; do
    # Normalize non-breaking spaces to regular spaces.
    normalized_line=$(echo "$raw_line" | sed 's/ / /g')

    # Skip blank lines.
    if [[ -z "$normalized_line" ]]; then
        continue
    fi

    # Skip the first line, as it's only used for determining the root.
    if ! $first_line_processed; then
        first_line_processed=true
        # If the first line is not the root indicator, it might be a file/dir.
        # But our logic uses it as the root, so we skip processing it as a child.
        if [[ "$normalized_line" != *"── "* ]]; then
            continue
        fi
    fi
    
    # Skip lines without tree connectors, as they are not files or directories.
    if [[ "$normalized_line" != *"── "* ]]; then
        continue
    fi

    # Get the clean name of the item.
    clean_name=$(parse_tree_line "$normalized_line")
    if [ -z "$clean_name" ]; then
        continue
    fi

    # Get the indent level.
    indent=$(calculate_indent_level "$normalized_line")
    
    # Store the name at its corresponding level.
    LEVEL_PATHS[$indent]="$clean_name"
    
    # Clear deeper-level paths to ensure the hierarchy is correct.
    for ((i=indent+1; i<${#LEVEL_PATHS[@]}; i++)); do
        unset 'LEVEL_PATHS[$i]'
    done
    
    # Build the full path from the root and the current level paths.
    full_path="$ROOT_DIR"
    for ((i=0; i<=indent; i++)); do
        if [[ -n "${LEVEL_PATHS[$i]}" ]]; then
            full_path="$full_path/${LEVEL_PATHS[$i]}"
        fi
    done
    
    # Check if the item is a directory (has a '/' before any comment) or a file.
    # This regex looks for a '/' that is followed by optional whitespace and an optional comment.
    if [[ "$raw_line" =~ \/[[:space:]]*(#.*)?$ ]]; then
        create_directory "$full_path"
    else
        create_file "$full_path"
    fi
    
done <<< "$input_structure"

echo ""
echo "🎉 Mass directory and file creation complete!"
echo "📊 Summary:"
echo "   - Root directory: $ROOT_DIR"
echo "   - Structure created successfully!"

# Optionally, display the created structure using the 'tree' command if available.
if command -v tree &> /dev/null; then
    echo ""
    echo "📋 Created structure:"
    tree -F "$ROOT_DIR" -a --dirsfirst
else
    echo ""
    echo "💡 Tip: Install 'tree' command to visualize the created structure."
    echo "   On macOS: brew install tree"
    echo "   On Linux (Debian/Ubuntu): sudo apt-get install tree"
fi

