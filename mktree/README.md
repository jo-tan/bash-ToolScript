# mktree.sh - Project Scaffolding Tool

A simple Bash script to quickly generate a project's directory and file structure from a `tree`-like text format. It's for bootstrapping new projects and ensuring a consistent setup every time.

## What It Does

It reads a `tree -F` structure and creates all the specified folders and empty files to current directory.

## Features

- **Root Detection:** Automatically determines the project's root folder from your structure file.
- **Flexible Input:** Works with both an input file and a inline hardcoded structure.
- **Customizable Output:** You can specify exactly where you want your project to be created.
- **Comments:** The structure file can have comments to explain what each part is for but won't affect the build.

## Prerequisites

- A Unix-like operating system (Linux, macOS, etc.)
- Bash (Bourne-Again SHell)

## Usage

The easiest way to use `mktree.sh` is to create a text file describing your project structure and then pass it to the script.

**1. Make the script executable:**

First, you need to give your computer permission to run the script.

```bash
chmod +x mktree.sh
```

**2. Create a structure file:**

Create a file named `my_project.txt` with the file structure which you need to create. Few ways to do:

1. Ask the AI(ChatGPT/Gemini/Claude/etc) to create the structure with tree -F style, then copy & paste to the script or a text file

2. To copy from an existing directory:
> `tree -Fa path/of/your/directory >> my_project.txt` #this will copy the tree structure of the directory with -F (all directories will have a slash(/) follow at the end) and -a (include the hidden files)

Here is a sample structure:
```
my-project/  # This will be the main folder
├── images/
├── styles/
│   └── main.css
└── index.html       # The main page
```

**3. Run the script:**

Now, tell `mktree.sh` to build the structure from your file.

With an input file:
```bash
./mktree.sh my_project.txt
```

With inline hardcoded structure:
```bash
./mktree.sh
```

That's it! A new folder named `my-project` has been created in your current directory with all the specified subdirectories and files inside.

## Advanced Usage

### Specifying an Output Directory

If you want to create the project structure in a specific location (and not in your current directory), use the `-d` or `--directory` flag.

```bash
./mktree.sh -d /path/to/your/projects my_project.txt
```
This will create the `my-awesome-project` folder inside `/path/to/your/projects`.

## Structure File Syntax Rules

- **Directories:** Must end with a forward slash (`/`).
- **Files:** Should not have a trailing slash.
- **Comments:** Use a hash symbol (`#`) to add comments. Anything after the `#` on a line will be ignored.
- **Indentation:** Use `│`, `├──`, and `└──` to create the tree structure, just like the `tree` command.

### Example of a complex structure file:

```
project/  # This is the main project folder
├── assets/  # Static assets like images and styles
│   ├── images/
│   │   ├── logo.svg
│   │   └── hero-banner.jpg
│   └── styles/
│       └── main.css  # Main stylesheet
├── src/  # Source code
│   ├── components/
│   │   └── UserProfile.js
│   └── App.js  # Main application entry point
├── scripts/
│   └── deploy.sh*  # Executable deployment script
└── README.md
```

---

## Memo
I copy project structures from AI sometimes and then I thought a script may be useful to auto create the whole structure with 1 script, and here it is 🥴