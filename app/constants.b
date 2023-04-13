/**
 * System/Window config flags
 */
var FLAG_VSYNC_HINT         = 0x00000040   # Set to try enabling V-Sync on GPU
var FLAG_FULLSCREEN_MODE    = 0x00000002   # Set to run program in fullscreen
var FLAG_WINDOW_RESIZABLE   = 0x00000004   # Set to allow resizable window
var FLAG_WINDOW_UNDECORATED = 0x00000008   # Set to disable window decoration (frame and buttons)
var FLAG_WINDOW_HIDDEN      = 0x00000080   # Set to hide window
var FLAG_WINDOW_MINIMIZED   = 0x00000200   # Set to minimize window (iconify)
var FLAG_WINDOW_MAXIMIZED   = 0x00000400   # Set to maximize window (expanded to monitor)
var FLAG_WINDOW_UNFOCUSED   = 0x00000800   # Set to window non focused
var FLAG_WINDOW_TOPMOST     = 0x00001000   # Set to window always on top
var FLAG_WINDOW_ALWAYS_RUN  = 0x00000100   # Set to allow windows running while minimized
var FLAG_WINDOW_TRANSPARENT = 0x00000010   # Set to allow transparent framebuffer
var FLAG_WINDOW_HIGHDPI     = 0x00002000   # Set to support HighDPI
var FLAG_WINDOW_MOUSE_PASSTHROUGH = 0x00004000 # Set to support mouse passthrough only supported when FLAG_WINDOW_UNDECORATED
var FLAG_MSAA_4X_HINT       = 0x00000020   # Set to try enabling MSAA 4X
var FLAG_INTERLACED_HINT    = 0x00010000    # Set to try enabling interlaced video format (for V3D)


/**
 * Trace log level
 */
var LOG_ALL = 0        # Display all logs
var LOG_TRACE = 1          # Trace logging intended for internal use only
var LOG_DEBUG = 2          # Debug logging used for internal debugging it should be disabled on release builds
var LOG_INFO = 3           # Info logging used for program execution info
var LOG_WARNING = 4        # Warning logging used on recoverable failures
var LOG_ERROR = 5          # Error logging used on unrecoverable failures
var LOG_FATAL = 6          # Fatal logging used to abort program: exit(EXIT_FAILURE)
var LOG_NONE = 7            # Disable logging


/**
 * Keyboard keys (US keyboard layout)
 */
var KEY_NULL            = 0        # Key: NULL used for no key pressed
# Alphanumeric keys
var KEY_APOSTROPHE      = 39       # Key: '
var KEY_COMMA           = 44       # Key: 
var KEY_MINUS           = 45       # Key: -
var KEY_PERIOD          = 46       # Key: .
var KEY_SLASH           = 47       # Key: /
var KEY_ZERO            = 48       # Key: 0
var KEY_ONE             = 49       # Key: 1
var KEY_TWO             = 50       # Key: 2
var KEY_THREE           = 51       # Key: 3
var KEY_FOUR            = 52       # Key: 4
var KEY_FIVE            = 53       # Key: 5
var KEY_SIX             = 54       # Key: 6
var KEY_SEVEN           = 55       # Key: 7
var KEY_EIGHT           = 56       # Key: 8
var KEY_NINE            = 57       # Key: 9
var KEY_SEMICOLON       = 59       # Key: ;
var KEY_EQUAL           = 61       # Key: =
var KEY_A               = 65       # Key: A | a
var KEY_B               = 66       # Key: B | b
var KEY_C               = 67       # Key: C | c
var KEY_D               = 68       # Key: D | d
var KEY_E               = 69       # Key: E | e
var KEY_F               = 70       # Key: F | f
var KEY_G               = 71       # Key: G | g
var KEY_H               = 72       # Key: H | h
var KEY_I               = 73       # Key: I | i
var KEY_J               = 74       # Key: J | j
var KEY_K               = 75       # Key: K | k
var KEY_L               = 76       # Key: L | l
var KEY_M               = 77       # Key: M | m
var KEY_N               = 78       # Key: N | n
var KEY_O               = 79       # Key: O | o
var KEY_P               = 80       # Key: P | p
var KEY_Q               = 81       # Key: Q | q
var KEY_R               = 82       # Key: R | r
var KEY_S               = 83       # Key: S | s
var KEY_T               = 84       # Key: T | t
var KEY_U               = 85       # Key: U | u
var KEY_V               = 86       # Key: V | v
var KEY_W               = 87       # Key: W | w
var KEY_X               = 88       # Key: X | x
var KEY_Y               = 89       # Key: Y | y
var KEY_Z               = 90       # Key: Z | z
var KEY_LEFT_BRACKET    = 91       # Key: [
var KEY_BACKSLASH       = 92       # Key: '\'
var KEY_RIGHT_BRACKET   = 93       # Key: ]
var KEY_GRAVE           = 96       # Key: `
# Function keys
var KEY_SPACE           = 32       # Key: Space
var KEY_ESCAPE          = 256      # Key: Esc
var KEY_ENTER           = 257      # Key: Enter
var KEY_TAB             = 258      # Key: Tab
var KEY_BACKSPACE       = 259      # Key: Backspace
var KEY_INSERT          = 260      # Key: Ins
var KEY_DELETE          = 261      # Key: Del
var KEY_RIGHT           = 262      # Key: Cursor right
var KEY_LEFT            = 263      # Key: Cursor left
var KEY_DOWN            = 264      # Key: Cursor down
var KEY_UP              = 265      # Key: Cursor up
var KEY_PAGE_UP         = 266      # Key: Page up
var KEY_PAGE_DOWN       = 267      # Key: Page down
var KEY_HOME            = 268      # Key: Home
var KEY_END             = 269      # Key: End
var KEY_CAPS_LOCK       = 280      # Key: Caps lock
var KEY_SCROLL_LOCK     = 281      # Key: Scroll down
var KEY_NUM_LOCK        = 282      # Key: Num lock
var KEY_PRINT_SCREEN    = 283      # Key: Print screen
var KEY_PAUSE           = 284      # Key: Pause
var KEY_F1              = 290      # Key: F1
var KEY_F2              = 291      # Key: F2
var KEY_F3              = 292      # Key: F3
var KEY_F4              = 293      # Key: F4
var KEY_F5              = 294      # Key: F5
var KEY_F6              = 295      # Key: F6
var KEY_F7              = 296      # Key: F7
var KEY_F8              = 297      # Key: F8
var KEY_F9              = 298      # Key: F9
var KEY_F10             = 299      # Key: F10
var KEY_F11             = 300      # Key: F11
var KEY_F12             = 301      # Key: F12
var KEY_LEFT_SHIFT      = 340      # Key: Shift left
var KEY_LEFT_CONTROL    = 341      # Key: Control left
var KEY_LEFT_ALT        = 342      # Key: Alt left
var KEY_LEFT_SUPER      = 343      # Key: Super left
var KEY_RIGHT_SHIFT     = 344      # Key: Shift right
var KEY_RIGHT_CONTROL   = 345      # Key: Control right
var KEY_RIGHT_ALT       = 346      # Key: Alt right
var KEY_RIGHT_SUPER     = 347      # Key: Super right
var KEY_KB_MENU         = 348      # Key: KB menu
# Keypad keys
var KEY_KP_0            = 320      # Key: Keypad 0
var KEY_KP_1            = 321      # Key: Keypad 1
var KEY_KP_2            = 322      # Key: Keypad 2
var KEY_KP_3            = 323      # Key: Keypad 3
var KEY_KP_4            = 324      # Key: Keypad 4
var KEY_KP_5            = 325      # Key: Keypad 5
var KEY_KP_6            = 326      # Key: Keypad 6
var KEY_KP_7            = 327      # Key: Keypad 7
var KEY_KP_8            = 328      # Key: Keypad 8
var KEY_KP_9            = 329      # Key: Keypad 9
var KEY_KP_DECIMAL      = 330      # Key: Keypad .
var KEY_KP_DIVIDE       = 331      # Key: Keypad /
var KEY_KP_MULTIPLY     = 332      # Key: Keypad *
var KEY_KP_SUBTRACT     = 333      # Key: Keypad -
var KEY_KP_ADD          = 334      # Key: Keypad +
var KEY_KP_ENTER        = 335      # Key: Keypad Enter
var KEY_KP_EQUAL        = 336      # Key: Keypad =
# Android key buttons
var KEY_BACK            = 4        # Key: Android back button
var KEY_MENU            = 82       # Key: Android menu button
var KEY_VOLUME_UP       = 24       # Key: Android volume up button
var KEY_VOLUME_DOWN     = 25        # Key: Android volume down button

/**
 * Mouse button
 */
var MOUSE_BUTTON_LEFT    = 0       # Mouse button left
var MOUSE_BUTTON_RIGHT   = 1       # Mouse button right
var MOUSE_BUTTON_MIDDLE  = 2       # Mouse button middle (pressed wheel)
var MOUSE_BUTTON_SIDE    = 3       # Mouse button side (advanced mouse device)
var MOUSE_BUTTON_EXTRA   = 4       # Mouse button extra (advanced mouse device)
var MOUSE_BUTTON_FORWARD = 5       # Mouse button forward (advanced mouse device)
var MOUSE_BUTTON_BACK    = 6       # Mouse button back (advanced mouse device)
var MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT
var MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
var MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE


/**
 * Mouse cursor
 */
var MOUSE_CURSOR_DEFAULT       = 0     # Default pointer shape
var MOUSE_CURSOR_ARROW         = 1     # Arrow shape
var MOUSE_CURSOR_IBEAM         = 2     # Text writing cursor shape
var MOUSE_CURSOR_CROSSHAIR     = 3     # Cross shape
var MOUSE_CURSOR_POINTING_HAND = 4     # Pointing hand cursor
var MOUSE_CURSOR_RESIZE_EW     = 5     # Horizontal resize/move arrow shape
var MOUSE_CURSOR_RESIZE_NS     = 6     # Vertical resize/move arrow shape
var MOUSE_CURSOR_RESIZE_NWSE   = 7     # Top-left to bottom-right diagonal resize/move arrow shape
var MOUSE_CURSOR_RESIZE_NESW   = 8     # The top-right to bottom-left diagonal resize/move arrow shape
var MOUSE_CURSOR_RESIZE_ALL    = 9     # The omnidirectional resize/move cursor shape
var MOUSE_CURSOR_NOT_ALLOWED   = 10     # The operation-not-allowed shape

/**
 * Gamepad buttons
 */
var GAMEPAD_BUTTON_UNKNOWN = 0         # Unknown button just for error checking
var GAMEPAD_BUTTON_LEFT_FACE_UP = 1        # Gamepad left DPAD up button
var GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2     # Gamepad left DPAD right button
var GAMEPAD_BUTTON_LEFT_FACE_DOWN = 3      # Gamepad left DPAD down button
var GAMEPAD_BUTTON_LEFT_FACE_LEFT = 4      # Gamepad left DPAD left button
var GAMEPAD_BUTTON_RIGHT_FACE_UP = 5       # Gamepad right button up (i.e. PS3: Triangle Xbox: Y)
var GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6    # Gamepad right button right (i.e. PS3: Square Xbox: X)
var GAMEPAD_BUTTON_RIGHT_FACE_DOWN = 7     # Gamepad right button down (i.e. PS3: Cross Xbox: A)
var GAMEPAD_BUTTON_RIGHT_FACE_LEFT = 8     # Gamepad right button left (i.e. PS3: Circle Xbox: B)
var GAMEPAD_BUTTON_LEFT_TRIGGER_1 = 9      # Gamepad top/back trigger left (first) it could be a trailing button
var GAMEPAD_BUTTON_LEFT_TRIGGER_2 = 10      # Gamepad top/back trigger left (second) it could be a trailing button
var GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = 11     # Gamepad top/back trigger right (one) it could be a trailing button
var GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = 12     # Gamepad top/back trigger right (second) it could be a trailing button
var GAMEPAD_BUTTON_MIDDLE_LEFT = 13         # Gamepad center buttons left one (i.e. PS3: Select)
var GAMEPAD_BUTTON_MIDDLE = 14              # Gamepad center buttons middle one (i.e. PS3: PS Xbox: XBOX)
var GAMEPAD_BUTTON_MIDDLE_RIGHT = 15        # Gamepad center buttons right one (i.e. PS3: Start)
var GAMEPAD_BUTTON_LEFT_THUMB = 16          # Gamepad joystick pressed button left
var GAMEPAD_BUTTON_RIGHT_THUMB = 17          # Gamepad joystick pressed button right

/**
 * Gamepad axis
 */
var GAMEPAD_AXIS_LEFT_X        = 0     # Gamepad left stick X axis
var GAMEPAD_AXIS_LEFT_Y        = 1     # Gamepad left stick Y axis
var GAMEPAD_AXIS_RIGHT_X       = 2     # Gamepad right stick X axis
var GAMEPAD_AXIS_RIGHT_Y       = 3     # Gamepad right stick Y axis
var GAMEPAD_AXIS_LEFT_TRIGGER  = 4     # Gamepad back trigger left pressure level: [1..-1]
var GAMEPAD_AXIS_RIGHT_TRIGGER = 5      # Gamepad back trigger right pressure level: [1..-1]

/**
 * Material map index
 */
var MATERIAL_MAP_ALBEDO = 0        # Albedo material (same as: MATERIAL_MAP_DIFFUSE)
var MATERIAL_MAP_METALNESS = 1         # Metalness material (same as: MATERIAL_MAP_SPECULAR)
var MATERIAL_MAP_NORMAL = 2            # Normal material
var MATERIAL_MAP_ROUGHNESS = 3         # Roughness material
var MATERIAL_MAP_OCCLUSION = 4         # Ambient occlusion material
var MATERIAL_MAP_EMISSION = 5         # Emission material
var MATERIAL_MAP_HEIGHT = 6           # Heightmap material
var MATERIAL_MAP_CUBEMAP = 7          # Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
var MATERIAL_MAP_IRRADIANCE = 8       # Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
var MATERIAL_MAP_PREFILTER = 9        # Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
var MATERIAL_MAP_BRDF = 10              # Brdf material
var MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
var MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS

/**
 * Shader location index
 */
var SHADER_LOC_VERTEX_POSITION = 0 # Shader location: vertex attribute: position
var SHADER_LOC_VERTEX_TEXCOORD01 = 1   # Shader location: vertex attribute: texcoord01
var SHADER_LOC_VERTEX_TEXCOORD02 = 2   # Shader location: vertex attribute: texcoord02
var SHADER_LOC_VERTEX_NORMAL = 3      # Shader location: vertex attribute: normal
var SHADER_LOC_VERTEX_TANGENT = 4     # Shader location: vertex attribute: tangent
var SHADER_LOC_VERTEX_COLOR = 5       # Shader location: vertex attribute: color
var SHADER_LOC_MATRIX_MVP = 6         # Shader location: matrix uniform: model-view-projection
var SHADER_LOC_MATRIX_VIEW = 7        # Shader location: matrix uniform: view (camera transform)
var SHADER_LOC_MATRIX_PROJECTION  = 8  # Shader location: matrix uniform: projection
var SHADER_LOC_MATRIX_MODEL = 9     # Shader location: matrix uniform: model (transform)
var SHADER_LOC_MATRIX_NORMAL = 10   # Shader location: matrix uniform: normal
var SHADER_LOC_VECTOR_VIEW = 11        # Shader location: vector uniform: view
var SHADER_LOC_COLOR_DIFFUSE = 12      # Shader location: vector uniform: diffuse color
var SHADER_LOC_COLOR_SPECULAR  = 13    # Shader location: vector uniform: specular color
var SHADER_LOC_COLOR_AMBIENT = 14      # Shader location: vector uniform: ambient color
var SHADER_LOC_MAP_ALBEDO = 15         # Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
var SHADER_LOC_MAP_METALNESS = 16      # Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
var SHADER_LOC_MAP_NORMAL = 17         # Shader location: sampler2d texture: normal
var SHADER_LOC_MAP_ROUGHNESS = 18      # Shader location: sampler2d texture: roughness
var SHADER_LOC_MAP_OCCLUSION = 19      # Shader location: sampler2d texture: occlusion
var SHADER_LOC_MAP_EMISSION = 20       # Shader location: sampler2d texture: emission
var SHADER_LOC_MAP_HEIGHT = 21         # Shader location: sampler2d texture: height
var SHADER_LOC_MAP_CUBEMAP = 22        # Shader location: samplerCube texture: cubemap
var SHADER_LOC_MAP_IRRADIANCE = 23     # Shader location: samplerCube texture: irradiance
var SHADER_LOC_MAP_PREFILTER = 24      # Shader location: samplerCube texture: prefilter
var SHADER_LOC_MAP_BRDF = 25            # Shader location: sampler2d texture: brdf
var SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
var SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS

/**
 * Shader uniform data type
 */
var SHADER_UNIFORM_FLOAT = 0       # Shader uniform type: float
var SHADER_UNIFORM_VEC2 = 1           # Shader uniform type: vec2 (2 float)
var SHADER_UNIFORM_VEC3 = 2           # Shader uniform type: vec3 (3 float)
var SHADER_UNIFORM_VEC4 = 3           # Shader uniform type: vec4 (4 float)
var SHADER_UNIFORM_INT = 4            # Shader uniform type: int
var SHADER_UNIFORM_IVEC2 = 5          # Shader uniform type: ivec2 (2 int)
var SHADER_UNIFORM_IVEC3 = 6          # Shader uniform type: ivec3 (3 int)
var SHADER_UNIFORM_IVEC4 = 7          # Shader uniform type: ivec4 (4 int)
var SHADER_UNIFORM_SAMPLER2D = 8       # Shader uniform type: sampler2d

/**
 * Shader attribute data type
 */
var SHADER_ATTRIB_FLOAT = 0        # Shader attribute type: float
var SHADER_ATTRIB_VEC2 = 1            # Shader attribute type: vec2 (2 float)
var SHADER_ATTRIB_VEC3 = 2            # Shader attribute type: vec3 (3 float)
var SHADER_ATTRIB_VEC4 = 3             # Shader attribute type: vec4 (4 float)

/**
 * Pixel formats
 */
var PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1 # 8 bit per pixel (no alpha)
var PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA = 2   # 8*2 bpp (2 channels)
var PIXELFORMAT_UNCOMPRESSED_R5G6B5 = 3       # 16 bpp
var PIXELFORMAT_UNCOMPRESSED_R8G8B8 = 4       # 24 bpp
var PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 = 5     # 16 bpp (1 bit alpha)
var PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 = 6     # 16 bpp (4 bit alpha)
var PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 = 7     # 32 bpp
var PIXELFORMAT_UNCOMPRESSED_R32 = 8          # 32 bpp (1 channel - float)
var PIXELFORMAT_UNCOMPRESSED_R32G32B32 = 9    # 32*3 bpp (3 channels - float)
var PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = 10 # 32*4 bpp (4 channels - float)
var PIXELFORMAT_COMPRESSED_DXT1_RGB = 11       # 4 bpp (no alpha)
var PIXELFORMAT_COMPRESSED_DXT1_RGBA = 12      # 4 bpp (1 bit alpha)
var PIXELFORMAT_COMPRESSED_DXT3_RGBA = 13      # 8 bpp
var PIXELFORMAT_COMPRESSED_DXT5_RGBA = 14      # 8 bpp
var PIXELFORMAT_COMPRESSED_ETC1_RGB = 15       # 4 bpp
var PIXELFORMAT_COMPRESSED_ETC2_RGB = 16       # 4 bpp
var PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA = 17  # 8 bpp
var PIXELFORMAT_COMPRESSED_PVRT_RGB = 18       # 4 bpp
var PIXELFORMAT_COMPRESSED_PVRT_RGBA = 19      # 4 bpp
var PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA = 20  # 8 bpp
var PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA = 21   # 2 bpp


/**
 * Texture parameters: filter mode
 * NOTE 1: Filtering considers mipmaps if available in the texture
 * NOTE 2: Filter is accordingly set for minification and magnification
 */
var TEXTURE_FILTER_POINT = 0                   # No filter, just pixel approximation
var TEXTURE_FILTER_BILINEAR = 1                # Linear filtering
var TEXTURE_FILTER_TRILINEAR = 2               # Trilinear filtering (linear with mipmaps)
var TEXTURE_FILTER_ANISOTROPIC_4X = 3          # Anisotropic filtering 4x
var TEXTURE_FILTER_ANISOTROPIC_8X = 4          # Anisotropic filtering 8x
var TEXTURE_FILTER_ANISOTROPIC_16X = 5         # Anisotropic filtering 16x
