#!/bin/bash

# 設定根目錄（請換成你的路徑） Set the root directory (please replace with your path)
ROOT_DIR="/Absolute/Path/to/RootDirectory"

# 宣告一個陣列用來記錄每一層的資料夾名稱 Declare an array to record the name of each level folder
declare -a LEVEL_PATHS

# 定義你的資料夾結構（樹狀結構格式） Define your folder structure (tree structure format)
FOLDER_STRUCTURE="
Software Development/
  Programming Languages/
    C Language/
    C++/
    Python/
    JavaScript/
    Ruby/
    Java/
    Go/
  Algorithms & Data Structures/
    Sorting Algorithms/
    Searching Algorithms/
    Dynamic Programming/
    Graph Algorithms/
    Trees & Graphs/
    Data Structures/
    Advanced Algorithms/
  Software Design/
    Design Patterns/
    SOLID Principles/
    Object-Oriented Design/
    Functional Programming/
    Clean Code/
  Debugging & Testing/
    Debugging/
    Unit Testing/
    Integration & System Testing/
  Development Tools/
    Version Control/
    IDEs & Editors/
    Debugging Tools/
    Automation Tools/
  Coding Challenges & Practice/
    LeetCode/
    HackerRank/
    Codewars/
    Project Euler/
  Common Coding Mistakes/
    C Programming/
    Python Programming/
    JavaScript Programming/
    Memory Management/
    Performance Issues/
  Software Architecture/
    Microservices/
    Monolithic Architecture/
    Event-Driven Architecture/
    Cloud Architecture/
  Algorithms for Data Science/
    Linear Algebra/
    Machine Learning/
    Statistical Methods/
    Neural Networks/
  Computational Mathematics/
    Numerical Methods/
    Discrete Mathematics/
    Optimization/
System & Hardware/
  Operating Systems/
    macOS/
    Linux/
    Windows/
  Shell & Scripting/
    Bash/
    Zsh/
  System Configuration & Hardware/
    Hardware Setup/
    Virtualization/
  Networking/
    TCP/IP/
    DNS/
    HTTP & HTTPS/
    VPN/
"

# 遍歷資料夾結構並創建資料夾 Traverse folder structure and create folders

# 開始處理每一行 Start processing each line
while IFS= read -r raw_line; do
  # 忽略空白行 Ignore empty lines
  [[ -z "$raw_line" ]] && continue

  # 計算縮排層級：每 2 個空格為一層 Calculate indentation level: 2 spaces per level
  indent=$(echo "$raw_line" | sed -E 's/^([ ]*).*/\1/' | awk '{ print length($0)/2 }')

  # 移除行首空格與結尾的 `/` Remove leading spaces and trailing `/`
  folder_name=$(echo "$raw_line" | sed -E 's/^[ ]*//;s:/*$::')

  # 記錄當前層級的資料夾名稱 Record current level folder name
  LEVEL_PATHS[$indent]="$folder_name"

  # 清除更深層資料 Clear deeper layers
  for ((i=indent+1; i<${#LEVEL_PATHS[@]}; i++)); do
    unset LEVEL_PATHS[$i]
  done

  # 拼接完整路徑 Concatenate full path
  full_path="$ROOT_DIR"
  for ((i=0; i<=indent; i++)); do
    full_path="$full_path/${LEVEL_PATHS[$i]}"
  done

  # 建立資料夾（如果不存在） Create folder if it doesn't exist
  if [ ! -d "$full_path" ]; then
    echo "➕ Creating folder: $full_path"
    mkdir -p "$full_path" || { echo "❌ Failed to create: $full_path"; exit 1; }
  else
    echo "✅ Folder already exists: $full_path"
  fi
done <<< "$FOLDER_STRUCTURE"

echo "🎉 Mass mkdir complete!"
