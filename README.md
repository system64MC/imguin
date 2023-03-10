<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [ImGuin](#imguin)
  - [Usage: Sample program and run](#usage-sample-program-and-run)
    - [Prerequisite](#prerequisite)
    - [Build](#build)
    - [Screen shot](#screen-shot)
  - [Update latest Dear ImGui and CImGui](#update-latest-dear-imgui-and-cimgui)
    - [Prerequisite](#prerequisite-1)
    - [Update ImGui/CImGui](#update-imguicimgui)
  - [Examples notice](#examples-notice)
- [TODO](#todo)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# ImGuin 

[Dear Imgui](https://github.com/ocornut/imgui) wrapper using [CImGui](https://github.com/cimgui/cimgui) and [Futhark](https://github.com/PMunch/futhark) with Nim language.

**Under construction at this moment**

## Usage: Sample program and run

---

### Prerequisite

---
1. Nim-1.6.10 or later
1. Add libraries

   ```sh
   nimble install glfw nimgl
   ```

1. For Linux Debian 11 Bullseye

      ```sh
      $ sudo apt install xorg-dev libopengl-dev ibgl1-mesa-glx libgl1-mesa-dev
      ```
      
      and for glfw3

      ```sh
      $ sudo apt install libglfw3 libglfw3-dev
      ```

### Build  

---

1. First clone this project,

   ```sh
   git clone --recursive https://github.com/dinau/imguin
   ```

1. Sample program is here, [examples](examples).  
For instance, [imguin_glfw_opengl3.nim](examples/glfw_opengl3/imguin_glfw_opengl3.nim):

   ```sh
   cd imguin/examples/glfw_opengl3
   make
   ```

   After build, run `./imguin_glfw_opengl3(.exe)`.

1. For static link, read this [examples/README.md](examples/README.md). 

### Screen shot

---

These are screen shots on Windows10.  

[glfw_opengl3](examples/glfw_opengl3).  
![alt](src/img/screenshot1.png)

[glfw_opengl3_nimgl_imguin_jp](examples/glfw_opengl3_nimgl_imguin_jp).  
![alt](src/img/screenshot2.png)

## Update latest Dear ImGui and CImGui

### Prerequisite

---

1. [Git](https://git-scm.com/) installed.
1. Windows10 or later  
Clang/LLVM refer to [Futhark installation](https://github.com/PMunch/futhark#installation).

   ```sh
   nimble install futhark 
   ```

1. Linux Debian 11 Bullseye

    ```sh
    sudo apt install  libclang-dev
    nimble install --passL:"-L/usr/lib/llvm-11/lib" futhark
    ```

Important Notice: Confirm Futhark version is v0.9.1 or later.

```sh
nimble dump futhark
```

### Update ImGui/CImGui

---

- Update to latest definition files uisng [Futhark](https://github.com/PMunch/futhark),

   ```sh
   pwd
   imguin
   cd src/updater
   make
   ```
   
   ImGui/CImGui version is **v1.89.3** at this time. (2023/03)
- Update/Downgrade to the version that specified tag of CImGui for example,  

   ```sh
   pwd
   imguin
   cd src/updater
   make CIMGUI_TAG=1.86
   ```

## Examples notice

---
- [examples/sdl2_opengl3](examples/sdl2_opengl3)  
   1. If you are on Windows OS **32bit**, you should get `SDL2.dll` for instance from [release-2.26.4](https://github.com/libsdl-org/SDL/releases/tag/release-2.26.4).  
      1. Unzip [SDL2-2.26.4-win32-x86.zip](https://github.com/libsdl-org/SDL/releases/download/release-2.26.4/SDL2-2.26.4-win32-x86.zip)
      1. Copy SDL2.dll to [examples/sdl2_opengl3](examples/sdl2_opengl3) folder.
   1. On Windows OS, it needs dev tool to compile SDL2 app.  
      [SDL2-devel-2.26.4-mingw.zip](https://github.com/libsdl-org/SDL/releases/download/release-2.26.4/SDL2-devel-2.26.4-mingw.zip)  
      for instance "SDL.h","-lSDL2.dll"(libSDL2.dll.a) etc  
      and anywhere else add below description,

      ```nim
      {.passC:"-Id:/msys32/mingw32/include/SDL2".}
      {.passL:"-Ld:/msys32/mingw32/lib -lSDL2.dll".}
      ```

      you need to properly change the folder name depending on your settings.  
      See [src/imguin/sdl2_opengl.nim](src/imguin/sdl2_opengl.nim)


# TODO

---

- First step is done. (2023/03)
1. ~~Add SDL2 example.~~ Done. [examples/sdl2_opengl3](examples/sdl2_opengl3) 
1. Easier compilation for SDL2 app.
1. Whether can it do `nimble install imguin` ?
1. Whether can it use `cimgui.dll` ? (Now it can only be static link)


