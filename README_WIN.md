# Building ML-KEM Native Shared Library (.dll) on Windows

## Introduction
This guide is written for developers (such as Delphi, C#, or Python developers) who need to compile the `mlkem-native` cryptographic project into a Windows Dynamic Link Library (`.dll`), but have **zero prior experience** with C, C++, or CMake. 

By following this guide on a freshly installed Windows machine, you will successfully produce `.dll` files that you can load into your own projects.

---

## Step 1: Install Required Tools

To compile code on Windows, you must download a few standard development tools. All of these tools are completely free.

### 1. Install Git
Git allows you to download (or "clone") the source code repository to your machine.
1. Download Git for Windows from: [https://gitforwindows.org/](https://gitforwindows.org/)
2. Run the installer and keep all default settings by clicking **Next** until it installs.

### 2. Install Visual Studio Build Tools (C++ Compiler)
Because `mlkem-native` is written in C, you need Microsoft's official C/C++ compiler to turn it into a `.dll`. **You do not need to install the massive Visual Studio IDE**, just the build tools.
1. Download **Build Tools for Visual Studio 2022** from: [https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)
2. Run the installer. 
3. When the window opens asking what workloads to install, check the box that says **"Desktop development with C++"**.
4. Click **Install**. (This may take several minutes to download and install).

### 3. Install CMake
CMake is a tool that reads the project's blueprints and sets up the compiler instructions automatically.
1. Download the Windows x64 Installer (e.g., `cmake-3.XX.X-windows-x64.msi`) from: [https://cmake.org/download/](https://cmake.org/download/)
2. Run the installer.
3. **CRITICAL STEP:** During installation, when asked about the system path, select **"Add CMake to the system PATH for all users"** or **"Add CMake to the system PATH for the current user"**. If you skip this, your terminal won't know what `cmake` is!

---

## Step 2: Download the Source Code

1. Open your Start Menu and search for **"Command Prompt"**, then open it.
2. Navigate to a folder where you want to download the code. For example, your Documents folder:
   ```cmd
   cd %USERPROFILE%\Documents
   ```
3. Download the repository by typing exactly this:
   ```cmd
   git clone https://github.com/pq-code-package/mlkem-native.git
   ```
4. Enter the newly downloaded directory:
   ```cmd
   cd mlkem-native
   ```

---

## Step 3: Choose Your Target Architecture (x64 vs 32-bit)

Depending on your target application (e.g., a 32-bit or 64-bit Delphi application), you need to compile the library for your specific architecture.

1. Find the file named `build_shared_lib.cmd` inside the `mlkem-native` folder.
2. Open this file in **Notepad** (Right-click -> Open With -> Notepad).
3. Near the top of the file, you will see these lines:

```bat
REM Uncomment one of the following lines to select the target architecture
set ARCH=x64
REM set ARCH=Win32
```

*   **For 64-bit (x64) applications:** Leave everything as is (`set ARCH=x64` should not have a `REM` in front of it).
*   **For 32-bit (x86) applications:** Change the lines to look like this:
    ```bat
    REM set ARCH=x64
    set ARCH=Win32
    ```
    *(The word `REM` stands for "Remark" and tells the script to ignore that line).*
4. Save the file and close Notepad.

---

## Step 4: Compile the .dll

1. Go back to your Command Prompt (ensure you are still inside the `mlkem-native` directory from Step 2).
2. Run the script by simply typing its name:
   ```cmd
   build_shared_lib.cmd
   ```
3. You will see a bunch of text fly by as CMake inspects your compiler and compiles the C code into machine code. 
4. Once it finishes (it usually takes less than a minute), the process is complete!

---

## Step 5: Locate your Compiled Library

Your compiled `.dll` library is now ready to use! You can find it safely tucked into the newly created folders.

*   If you built the **64-bit (x64)** version, the library is located at:
    `mlkem-native\build\Release\mlkem_native_lib.dll`
*   If you built the **32-bit (Win32)** version, the library is located at:
    `mlkem-native\build32\Release\mlkem_native_lib.dll`

*Note: Depending on how the repository is structured, it may also output inside a `Debug` folder instead of `Release`.*

You can now copy `mlkem_native_lib.dll` entirely out of this directory and place it next to your Delphi executable, or wherever your application loads its external libraries from. To use the library, you'll cross-reference the C syntax from `mlkem_native.h` and translate the API function signatures to your preferred programming language.
