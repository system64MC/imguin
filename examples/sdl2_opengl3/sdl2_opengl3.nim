import glad/gl
import sdl2_nim/sdl

import imguin/[sdl2_opengl]
import imguin/lang/imgui_ja_gryph_ranges

include ../utils/setupFonts
include imguin/simple

proc main() =
  if sdl.init(sdl.InitVideo) != 0:
    echo "ERROR: Can't initialize SDL: ", sdl.getError()
    quit -1

  discard sdl.glSetAttribute(GLattr.GL_CONTEXT_FLAGS, 0)
  discard sdl.glSetAttribute(GLattr.GL_CONTEXT_PROFILE_MASK, GL_CONTEXT_PROFILE_CORE)
  discard sdl.glSetAttribute(GLattr.GL_CONTEXT_MAJOR_VERSION, 3)
  discard sdl.glSetAttribute(GLattr.GL_CONTEXT_MINOR_VERSION, 3)

  discard sdl.setHint(HINT_RENDER_DRIVER, "opengl")
  discard sdl.glSetAttribute(GLattr.GL_DEPTH_SIZE, 24)
  discard sdl.glSetAttribute(GLattr.GL_STENCIL_SIZE, 8)
  discard sdl.glSetAttribute(GLattr.GL_DOUBLEBUFFER, 1)

  # Basic IME support. App needs to call 'SDL_SetHint(SDL_HINT_IME_SHOW_UI, "1");'
  # before SDL_CreateWindow()!.
  discard sdl.setHint("SDL_IME_SHOW_UI", "1") # SDL2: must be v2.0.18 or later

  var current: DisplayMode
  discard sdl.getCurrentDisplayMode(0, addr current)

  var window = sdl.createWindow(
        "Hello", 30, 30, 1024, 800,
        WINDOW_SHOWN or WINDOW_OPENGL or WINDOW_RESIZABLE)
  if isNil window:
    echo "Fail to create window: ", sdl.getError()
    quit -1
  defer:sdl.destroyWindow(window)

  var gl_context = glCreateContext(window)
  defer:sdl.glDeleteContext(gl_context)

  discard glSetSwapInterval(1)

  if not gladLoadGL(glGetProcAddress):
    sdl.log("opengl version: ", glGetString(GL_VERSION))
    quit "Error initialising OpenGL"

  # setup imgui
  igCreateContext(nil)
  defer: igDestroyContext(nil)

  var pio = sdl2_opengl.igGetIO()

  var glsl_version: cstring = "#version 150"
  doAssert ImGui_ImplSdl2_InitForOpenGL(cast[ptr SdlWindow](window)
                                      , addr glsl_version)
  defer: ImGui_ImplSDL2_Shutdown()

  doAssert ImGui_ImplOpenGL3_Init(glsl_version)
  defer: ImGui_ImplOpenGL3_Shutdown()

  igStyleColorsDark(nil)

  var
    showDemoWindow = true
    showAnotherWindow = false
    clearColor = ccolor(elm:(x:0.45f, y:0.55f, z:0.60f, w:1.0f))

    fval = 0.5f
    counter = 0
    xQuit: bool
    sBuf = newString(200)

  # Add multibyte font
  var (fExistMultbytesFonts, sActiveFontName, sActiveFontTitle) = setupFonts()

  # Main loop
  while not xQuit:
    var event: Event
    while 0 != sdl.pollevent(addr event):
      ImGui_ImplSDL2_ProcessEvent(cast[ptr SdlEvent](addr event))
      if event.kind == QUIT:
        xQuit = true
      if event.kind == WINDOWEVENT and event.window.event ==
          WINDOWEVENT_CLOSE and
        event.window.windowID == sdl.getWindowID(window):
        xQuit = true

    # start imgui frame
    ImGui_ImplOpenGL3_NewFrame()
    ImGui_ImplSdl2_NewFrame()
    igNewFrame()

    if showDemoWindow:
      igShowDemoWindow(addr showDemoWindow)

    # show a simple window that we created ourselves.
    block:
      igBegin("Nim: Dear ImGui test with Futhark", nil, 0)
      defer: igEnd()
      igText("This is some useful text")
      igInputTextWithHint("InputText" ,"Input text here" ,sBuf.cstring ,sBuf.len.csize_t ,0.ImguiInputTextFlags,nil,nil)
      igCheckbox("Demo window", addr showDemoWindow)
      igCheckbox("Another window", addr showAnotherWindow)
      igSliderFloat("Float", addr fval, 0.0f, 1.5f, "%.3f", 0)
      igColorEdit3("clear color", clearColor.array3, ImGuiColorEditFlags_None.ImGuiColorEditFlags)

      if igButton("Button", ImVec2(x: 0.0f, y: 0.0f)):
        inc counter
      igSameLine(0.0f, -1.0f)
      igText("counter = %d", counter)
      igText("Application average %.3f ms/frame (%.1f FPS)",
             1000.0f / pio.Framerate, pio.Framerate)
      #
      igSeparatorText(ICON_FA_WRENCH & " Icon font test ")
      igText(ICON_FA_TRASH_CAN & " Trash")
      igText(ICON_FA_MAGNIFYING_GLASS_PLUS &
        " " & ICON_FA_POWER_OFF &
        " " & ICON_FA_MICROPHONE &
        " " & ICON_FA_MICROCHIP &
        " " & ICON_FA_VOLUME_HIGH &
        " " & ICON_FA_SCISSORS &
        " " & ICON_FA_SCREWDRIVER_WRENCH &
        " " & ICON_FA_BLOG)

    # show further samll window
    if showAnotherWindow:
      igBegin("imgui Another Window", addr showAnotherWindow, 0)
      igText("Hello from imgui")
      if igButton("Close me", ImVec2(x: 0.0f, y: 0.0f)):
        showAnotherWindow = false
      igEnd()

    # render
    igRender()
    discard sdl.glMakeCurrent(window, gl_context)
    glViewport(0, 0, (pio.DisplaySize.x).GLsizei, (pio.DisplaySize.y).GLsizei)
    glClearColor(clearColor.elm.x, clearColor.elm.y, clearColor.elm.z, clearColor.elm.w)
    glClear(GL_COLOR_BUFFER_BIT)
    ImGui_ImplOpenGL3_RenderDrawData(igGetDrawData())
    sdl.glSwapWindow(window)

  sdl.quit()

main()
