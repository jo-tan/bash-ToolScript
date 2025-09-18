# `massMkdir.sh` - Nested folders create tool

A script to create large number of nested directories.

## Features

- **Indentation with tabs**: It determines the depth of each folder by calculating the indentation level(tabs). The script assumes that every two spaces(This is my computer's default, adjust the rule if you need) represent one level deeper in the hierarchy.

- **Creates Folders**: It uses the `mkdir -p` command to create the directory. This command is safe to use, as it creates parent directories if they don't exist and doesn't throw an error if the folder already exists.


## Usage

To use this script, follow these steps:

### 1. Configure the Root Directory

You **must** edit the script and change the value of the `ROOT_DIR` variable to the absolute path where you want the folders to be created.

**Open `massMkdir.sh` and find this line:**
```bash
# 設定根目錄（請換成你的路徑） Set the root directory (please replace with your path)
ROOT_DIR="/Absolute/Path/to/RootDirectory"
```
**Change it to your desired path, for example:**
```bash
# 設定根目錄（請換成你的路徑） Set the root directory (please replace with your path)
ROOT_DIR="/the/actual/path"
```

### 2. Customize the Folder Structure

You can modify the `FOLDER_STRUCTURE` variable in the script to define your own directory tree. Remember to follow the indentation rule: **2 spaces(a tab) for each level**.

**Example Structure:**
```bash
FOLDER_STRUCTURE="
My Project/
  assets/
    images/
    styles/
  src/
    components/
    lib/
"
```

### 3. Make the Script Executable

In your terminal, run the following command to grant execute permissions to the script:
```sh
chmod +x massMkdir.sh
```

### 4. Run the Script

Execute the script from your terminal:
```sh
./massMkdir.sh
```

The script will then run and create the directories defined in `FOLDER_STRUCTURE` inside your specified `ROOT_DIR`.

---

## Memo

I use it to create nested folders for notes in Obsidian. I ask AI to give me some ideas about how to classify certain subjects and explain why classifying this way. After I'm happy with the structure, I put the structure in this script and VOILÀ~ My notes have their new home and rooms to go 🏨
