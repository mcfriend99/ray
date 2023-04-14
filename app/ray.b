import clib { * }
import struct as st
import .constants { * }
import reflect
import os

var _bin_path = os.join_paths(os.dir_name(os.dir_name(os.current_file())), 'bin', 'libraylib')
var _machine_type = os.platform == 'windows' ? 'x86_64' : os.info().machine
var _ptr_type = 'Q'


# -------------------------------------------------------------
# RAYLIB TYPES
# -------------------------------------------------------------

# struct types
var _Vector2 = struct(
  float, # x
  float  # y
)
def DeVector2(v) {
  return st.unpack('fx/fy', v)
}

var _Vector3 = struct(
  float, # x
  float, # y
  float  # z
)
def DeVector3(v) {
  return st.unpack('fx/fy/fz', v)
}

var _Vector4 = struct(
  float, # x
  float, # y
  float, # z
  float  # w
)
def DeVector4(v) {
  return st.unpack('fx/fy/fz/fw', v)
}
var _Quaternion = _Vector4
var DeQuaternion = DeVector4

var _Matrix = struct(
  float, float, float, float, # first row
  float, float, float, float, # second row
  float, float, float, float, # third row
  float, float, float, float  # fourth row
)
def DeMatrix(v) {
  st.unpack(
    'fm0/fm4/fm8/fm12' +
    '/fm1/fm5/fm9/fm13' +
    '/fm2/fm6/fm10/fm14' +
    '/fm3/fm7/fm11/fm15', v)
}

var _Color = struct(
  uchar, # r
  uchar, # g
  uchar, # b
  uchar  # a
)
def DeColor(v) {
  return st.unpack('Cr/Cg/Cb/Ca', v)
}

var _Rectangle = struct(
  float, # x
  float, # y
  float, # width
  float  # height
)
def DeRectangle(v) {
  return st.unpack('fx/fy/fwidth/fheight', v)
}

var _Image = struct(
  ptr,   # data
  int,   # width
  int,   # height
  int,   # mipmaps
  int    # format
)
def DeImage(v) {
  return st.unpack('${_ptr_type}data/iwidth/iheight/imipmaps/iformat', v)
}

var _Texture = struct(
  uint,  # id
  int,   # width
  int,   # height
  int,   # mipmaps
  int    # format
)
def DeTexture(v) {
  return st.unpack('Iid/iwidth/iheight/imipmaps/iformat', v)
}
var _Texture2D = _Texture
var _TextureCubemap = _Texture
var DeTexture2D = DeTexture, DeTextureCubemap = DeTexture

var _RenderTexture = struct(
  uint, # id
  _Texture,  # texture
  _Texture   # depth
)
def DeRenderTexture(v) {
  var res = st.unpack('Iid'+
    '/Iid2/iwidth/iheight/imipmaps/iformat'+
    '/Iid3/iwidth2/iheight2/imipmaps2/iformat2', v)
  return {
    id: res.id,
    texture: {
      id: res.id2,
      width: res.width,
      height: res.height,
      mipmaps: res.mipmaps,
      format: res.format,
    },
    depth: {
      id: res.id3,
      width: res.width1,
      height: res.height1,
      mipmaps: res.mipmaps1,
      format: res.format1,
    }
  }
}
var _RenderTexture2D = _RenderTexture
var DeRenderTexture2D = DeRenderTexture

var _NPatchInfo = struct(
  _Rectangle, # source
  int,        # left
  int,        # top
  int,        # right
  int,        # bottom
  int         # layout
)
def DeNPatchInfo(v) {
  var res = st.unpack('fx/fy/fwidth/fheight'+
    '/ileft/itop/iright/ibottom/ilayout', v)
  return {
    source: {
      x: res.x,
      y: res.y,
    },
    left: res.left,
    top: res.top,
    right: res.right,
    bottom: res.bottom,
    layout: res.layout,
  }
}

var _GlyphInfo = struct(
  int,    # value
  int,    # offsetX
  int,    # offsetY
  int,    # advanceX
  _Image  # image
)
def DeGlyphInfo(x) {
  var res = st.unpack('ivalue/ioffsetX/ioffsetY/iadvanceX'+
    '/Idata/iwidth/iheight/imipmaps/iformat', v)
  return {
    value: res.value,
    offsetX: res.offsetX,
    offsetY: res.offsetY,
    advanceX: res.advanceX,
    image: {
      data: res.data,
      width: res.width,
      height: res.height,
      mipmaps: res.mipmaps,
      format: res.format,
    }
  }
}

var _Font = struct(
  int,        # baseSize
  int,        # glyphCount
  int,        # glyphPadding
  _Texture2D, # texture
  ptr,        # recs
  ptr         # glyphs
)
def DeFont(v) {
  var res = st.unpack('ibaseSize/iglyphCount/iglyphPadding'+
    '/Iid/iwidth/iheight/imipmaps/iformat'+
    '/${_ptr_type}recs/${_ptr_type}glyphs', v)
  return {
    baseSize: res.baseSize,
    glyphCount: res.glyphCount,
    glyphPadding: res.glyphPadding,
    texture: {
      id: res.id,
      width: res.width,
      height: res.height,
      mipmaps: res.mipmaps,
      format: res.format,
    },
    recs: res.recs,
    glyphs: res.glyphs,
  }
}

var _Camera2D = struct(
  _Vector2,     # offset
  _Vector2,     # target
  float,   # rotatioon
  float    # zoom
)
def DeCamera2D(v) {
  var res = st.unpack('fx/fy/fx1/fy1/frotation/fzoom', v)
  return {
    offset: {
      x: res.x,
      y: res.y,
    },
    target: {
      x: res.x1,
      y: res.y1,
    },
    rotation: res.rotation,
    zoom: res.zoom,
  }
}

var _Camera3D = struct(
  _Vector3,     # position
  _Vector3,     # target
  _Vector3,     # up
  float,        # fovy
  int           # projection
)
def DeCamera3D(v) {
  var res = st.unpack('fx/fy/fz'+
    '/fx1/fy1/fz1'+
    'fx2/fy2/fz2'+
    'ffovy/iprojection', v)
  return {
    position: {
      x: res.x,
      y: res.y,
      z: res.z,
    },
    target: {
      x: res.x1,
      y: res.y1,
      z: res.z1,
    },
    up: {
      x: res.x2,
      y: res.y2,
      z: res.z2,
    },
    fovy: res.fovy,
    projection: res.projection,
  }
}
var _Camera = _Camera3D
var DeCamera = DeCamera3D

var _Mesh = struct(
  int,  # vertexCount       
  int,  # triangleCount      
  ptr,  # vertices        
  ptr,  # texcoords       
  ptr,  # texcoords2      
  ptr,  # normals         
  ptr,  # tangents        
  ptr,  # colors      
  ptr,  # indices    
  ptr,  # animVertices    
  ptr,  # animNormals     
  ptr,  # boneIds 
  ptr,  # boneWeights     
  uint, # vaoId    
  ptr   # vboId    
)
def DeMesh(v) {
  return st.unpack(
    'ivertexCount/itriangleCount/${_ptr_type}vertices'+
    '/${_ptr_type}texcoords/${_ptr_type}texcoords2'+
    '/${_ptr_type}normals/${_ptr_type}tangents/${_ptr_type}colors'+
    '/${_ptr_type}indices/${_ptr_type}animVertices'+
    '/${_ptr_type}animNormals/${_ptr_type}boneIds/${_ptr_type}boneWeights'+
    '/IvaoId/${_ptr_type}vboId', v)
}

var _Shader = struct(
  uint,    # id
  ptr      # locs
)
def DeShader(v) {
  return st.unpack('Iid/${_ptr_type}locs', v)
}

var _MaterialMap = struct(
  _Texture2D, # texture
  _Color,     # color
  float       # value
)
def DeMaterialMap(v) {
  var res = st.unpack('Iid/iwidth/iheight/imipmaps/iformat/Cr/Cg/Cb/Ca/fvalue', v)
  return {
    texture: {
      id: res.id,
      width: res.width,
      height: res.height,
      mipmaps: res.mipmaps,
      format: res.format,
    },
    color: {
      r: res.r,
      g: res.g,
      b: res.b,
      a: res.a,
    },
    value: res.value
  }
}

var _Material = struct(
  _Shader,        # shader
  ptr,            # maps
  struct(         # params
    float, float, 
    float, float
  )
)
def DeMaterial(v) {
  var res = struct.unpack('Iid/${_ptr_type}locs/${_ptr_type}maps/fp1/fp2/fp3/fp4', v)
  return {
    shader: {
      id: res.id,
      locs: res.locs,
    },
    maps: res.maps,
    params: [
      res.p1, res.p2, 
      res.p3, res.p4
    ],
  }
}

var _Ray = struct(
  _Vector3,    # postition
  _Vector3     # direction
)
def DeRay(v) {
  var res = st.unpack('fx/fy/fz/fx1/fy1/fz1', v)
  return {
    position: {
      x: res.x,
      y: res.y,
      z: res.z,
    },
    direction: {
      x: res.x1,
      y: res.y1,
      z: res.z1,
    },
  }
}

var _float3 = struct( # v
  float,
  float,
  float
)
def Defloat3(v) {
  return st.unpack('f3', v).to_list()[1]
}

var _float16 = struct( # v
  float, float, float, float,
  float, float, float, float,
  float, float, float, float
)
def Defloat16(v) {
  return st.unpack('f16', v).to_list()[1]
}


# -------------------------------------------------------------
# DECLARATIONS
# -------------------------------------------------------------

/**
 * Structs
 */
def Vector2(x, y) {
  return st.pack('f2', x, y)
}

def Vector3(x, y, z) {
  return st.pack('f3', x, y, z)
}

def Vector4(x, y, z, w) {
  return st.pack('f4', x, y, z, w)
}

# Quaternion, 4 components (Vector4 alias)
var Quaternion = Vector4

def Matrix(
  m0, m4, m8, m12,
  m1, m5, m9, m13,
  m2, m6, m10, m14,
  m3, m7, m11, m15
) {
  return st.pack('f16', 
    m0, m4, m8, m12,
    m1, m5, m9, m13,
    m2, m6, m10, m14,
    m3, m7, m11, m15
  )
}

def Color(r, g, b, a) {
  return st.pack('C4', r, g, b, a)
}

def Rectangle(x, y, width, height) {
  return st.pack('f4', x, y, width, height)
}

def Image(data, width, height, mipmaps, format) {
  return st.pack('Ii4', reflect.get_address(data), width, height, mipmaps, format)
}

def Texture(id, width, height, mipmaps, format) {
  return st.pack('Ii4', id, width, height, mipmaps, format)
}

# Texture2D, same as Texture
var Texture2D = Texture
# TextureCubemap, same as Texture
var TextureCubemap = Texture

def RenderTexture(id, texture, depth) {
  return st.pack('IC${texture.length()}C${depth.length()}', id, texture, depth)
}

# RenderTexture2D, same as RenderTexture
var RenderTexture2D = RenderTexture

def NPatchInfo(source, left, top, right, bottom, layout) {
  return st.pack('C${source.length()}i5', source, left, top, right, bottom, layout)
}

def GlyphInfo(value, offsetX, offsetY, advanceX, image) {
  return st.pack('i4C${image.length()}', value, offsetX, offsetY, advanceX, image)
}

def Camera2D(offset, target, rotation, zoom) {
  return st.pack('C${offset.length()}C${offset.length()}f2', offset, target, rotation, zoom)
}

def Font(baseSize, glyphCount, glyptPadding, texture, recs, glyphs) {
  var recs_st = bytes(0)
  var glyphs_st = bytes(0)

  for rec in recs {
    recs_st.extend(st.pack('C*', rec))
  }
  for glyh in glyphs {
    glyphs_st.extend(st.pack('C*', glyh))
  }

  return st.pack('i3C${texture.length()}${_ptr_type}${_ptr_type}', baseSize, glyphCount, glyptPadding, texture, reflect.get_address(recs_st), reflect.get_address(glyphs_st))
}

def Camera3D(position, target, up, fovy, projection) {
  return st.pack('C${position.length()}C${target.length()}C${up.length()}f1i1', position, target, up, fovy, projection)
}

# Camer, same as Camera3D
var Camera = Camera3D

def Mesh(
  vertexCount, 
  triangleCount, 
  vertices, 
  texcoords, 
  texcoords2, 
  normals, 
  tangents, 
  colors, 
  indices, 
  animVertices, 
  animNormals, 
  boneIds, 
  boneWeights, 
  vaoId, 
  vboId
) {
  return st.pack(
    'i2${_ptr_type}11I${_ptr_type}', 
    vertexCount, 
    triangleCount, 
    vertices, 
    texcoords, 
    texcoords2, 
    normals, 
    tangents, 
    colors, 
    indices, 
    animVertices, 
    animNormals, 
    boneIds, 
    boneWeights, 
    vaoId, 
    vboId
  )
}

def Shader(id, locs) {
  return st.pack('I${_ptr_type}', id, get_address(locs))
}

def MaterialMap(texture, color, value) {
  return st.pack('C${texture.length()}C${color.length()}f', texture, color, value)
}

def Material(shader, maps, params) {
  if !is_list(params) params = to_list(params)
  if params.length() < 4 
    params.extend([0] * (4 - params.length()))
  return st.pack('C${shader.length()}${_ptr_type}f4', shader, maps, params)
}

def Ray(position, direction) {
  return st.pack('C${position.length()}C${locs.length()}', id, locs)
}

def float3(floats) {
  if !is_list(params) params = to_list(params)
  if params.length() < 3 
    params.extend([0] * (3 - params.length()))
  return st.pack('f3', params)
}

def float16(floats) {
  if !is_list(params) params = to_list(params)
  if params.length() < 16 
    params.extend([0] * (16 - params.length()))
  return st.pack('f16', params)
}

/**
 * Colors
 */
var LIGHTGRAY = Color(200, 200, 200, 255) # Light Gray
var GRAY = Color(130, 130, 130, 255) # Gray
var DARKGRAY = Color(80, 80, 80, 255) # Dark Gray
var YELLOW = Color(253, 249, 0, 255) # Yellow
var GOLD = Color(255, 203, 0, 255) # Gold
var ORANGE = Color(255, 161, 0, 255) # Orange
var PINK = Color(255, 109, 194, 255) # Pink
var RED = Color(230, 41, 55, 255) # Red
var MAROON = Color(190, 33, 55, 255) # Maroon
var GREEN = Color(0, 228, 48, 255) # Green
var LIME = Color(0, 158, 47, 255) # Lime
var DARKGREEN = Color(0, 117, 44, 255) # Dark Green
var SKYBLUE = Color(102, 191, 255, 255) # Sky Blue
var BLUE = Color(0, 121, 241, 255) # Blue
var DARKBLUE = Color(0, 82, 172, 255) # Dark Blue
var PURPLE = Color(200, 122, 255, 255) # Purple
var VIOLET = Color(135, 60, 190, 255) # Violet
var DARKPURPLE = Color(112, 31, 126, 255) # Dark Purple
var BEIGE = Color(211, 176, 131, 255) # Beige
var BROWN = Color(127, 106, 79, 255) # Brown
var DARKBROWN = Color(76, 63, 47, 255) # Dark Brown
var WHITE = Color(255, 255, 255, 255) # White
var BLACK = Color(0, 0, 0, 255) # Black
var BLANK = Color(0, 0, 0, 0) # Blank (Transparent)
var TRANSPARENT = BLANK
var MAGENTA = Color(255, 0, 255, 255) # Magenta
var RAYWHITE = Color(245, 245, 245, 255) # My own White (raylib logo)


class _Lib {
  _Lib(path) {
    var ray = load(path)

    /**
     * rcore
     */
    # Window-related functions
    self.InitWindow = ray.define('InitWindow', void, int, int, char_ptr)
    self.WindowShouldClose = ray.define('WindowShouldClose', bool)
    self.CloseWindow = @() {
      ray.define('CloseWindow', void)()
      ray.close()
    }
    self.IsWindowReady = ray.define('IsWindowReady', bool)
    self.IsWindowFullscreen = ray.define('IsWindowFullscreen', bool)
    self.IsWindowHidden = ray.define('IsWindowHidden', bool)
    self.IsWindowMinimized = ray.define('IsWindowMinimized', bool)
    self.IsWindowMaximized = ray.define('IsWindowMaximized', bool)
    self.IsWindowFocused = ray.define('IsWindowFocused', bool)
    self.IsWindowResized = ray.define('IsWindowResized', bool)
    self.IsWindowState = ray.define('IsWindowState', bool, uint)
    self.SetWindowState = ray.define('SetWindowState', void, uint)
    self.ClearWindowState = ray.define('ClearWindowState', void, uint)
    self.ToggleFullscreen = ray.define('ToggleFullscreen', void)
    self.MaximizeWindow = ray.define('MaximizeWindow', void)
    self.MinimizeWindow = ray.define('MinimizeWindow', void)
    self.RestoreWindow = ray.define('RestoreWindow', void)
    self.SetWindowIcon = ray.define('SetWindowIcon', void, _Image)
    self.SetWindowIcons = ray.define('SetWindowIcons', ptr, int) # return value must be unpacked into Images
    self.SetWindowTitle = ray.define('SetWindowTitle', void, char_ptr)
    self.SetWindowPosition = ray.define('SetWindowPosition', void, int, int)
    self.SetWindowMonitor = ray.define('SetWindowMonitor', void, int)
    self.SetWindowMinSize = ray.define('SetWindowMinSize', void, int, int)
    self.SetWindowSize = ray.define('SetWindowSize', void, int, int)
    self.SetWindowOpacity = ray.define('SetWindowOpacity', void, float)
    self.GetWindowHandle = ray.define('GetWindowHandle', ptr)
    self.GetScreenWidth = ray.define('GetScreenWidth', int)
    self.GetScreenHeight = ray.define('GetScreenHeight', int)
    self.GetRenderWidth = ray.define('GetRenderWidth', int)
    self.GetRenderHeight = ray.define('GetRenderHeight', int)
    self.GetMonitorCount = ray.define('GetMonitorCount', int)
    self.GetCurrentMonitor = ray.define('GetCurrentMonitor', int)
    self.GetMonitorPosition = ray.define('GetMonitorPosition', uchar_ptr, int) # return must be unpacked into Vector2
    self.GetMonitorWidth = ray.define('GetMonitorWidth', int, int)
    self.GetMonitorHeight = ray.define('GetMonitorHeight', int, int)
    self.GetMonitorPhysicalWidth = ray.define('GetMonitorPhysicalWidth', int, int)
    self.GetMonitorPhysicalHeight = ray.define('GetMonitorPhysicalHeight', int, int)
    self.GetMonitorRefreshRate = ray.define('GetMonitorRefreshRate', int, int)
    self.GetWindowPosition = ray.define('GetWindowPosition', uchar_ptr) # return must be unpacked into Vector2
    self.GetWindowScaleDPI = ray.define('GetWindowScaleDPI', uchar_ptr) # return must be unpacked into Vector2
    self.GetMonitorName = ray.define('GetMonitorName', char_ptr, int)
    self.SetClipboardText = ray.define('SetClipboardText', void, char_ptr)
    self.GetClipboardText = ray.define('GetClipboardText', char_ptr)
    self.EnableEventWaiting = ray.define('EnableEventWaiting', void)
    self.DisableEventWaiting = ray.define('DisableEventWaiting', void)

    # Custom frame control functions
    # NOTE: Those functions are intended for advance users that want full control over the frame processing
    # By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
    self.SwapScreenBuffer = ray.define('SwapScreenBuffer', void)
    self.PollInputEvents = ray.define('PollInputEvents', void)
    self.WaitTime = ray.define('WaitTime', void, double)

    # Cursor-related functions
    self.ShowCursor = ray.define('ShowCursor', void)
    self.HideCursor = ray.define('HideCursor', void)
    self.IsCursorHidden = ray.define('IsCursorHidden', void)
    self.EnableCursor = ray.define('EnableCursor', void)
    self.DisableCursor = ray.define('DisableCursor', void)
    self.IsCursorOnScreen = ray.define('IsCursorOnScreen', void)

    # Drawring-related functions
    self.ClearBackground = ray.define('ClearBackground', void, _Color)
    self.BeginDrawing = ray.define('BeginDrawing', void)
    self.EndDrawing = ray.define('EndDrawing', void)
    self.BeginMode2D = ray.define('BeginMode2D', void, _Camera2D)
    self.EndMode2D = ray.define('EndMode2D', void)
    self.BeginMode3D = ray.define('BeginMode3D', void, _Camera3D)
    self.EndMode3D = ray.define('EndMode3D', void)
    self.BeginTextureMode = ray.define('BeginTextureMode', void, _RenderTexture)
    self.EndTextureMode = ray.define('EndTextureMode', void)
    self.BeginShaderMode = ray.define('BeginShaderMode', void, _Shader)
    self.EndShaderMode = ray.define('EndShaderMode', void)
    self.BeginBlendMode = ray.define('BeginBlendMode', void, int)
    self.EndBlendMode = ray.define('EndBlendMode', void)
    self.BeginScissorMode = ray.define('BeginScissorMode', void, int, int, int, int)
    self.EndScissorMode = ray.define('EndScissorMode', void)
    # var BeginVrStereoMode = ray.define('BeginVrStereoMode', void)
    # var EndVrStereoMode = ray.define('EndVrStereoMode', void)

    # Screen-space-related functions
    self.GetMouseRay = ray.define('GetMouseRay', _Ray, _Vector2, _Camera3D) # return value will have to be unpacked to Ray
    self.GetWorldToScreen = ray.define('GetWorldToScreen', _Vector2, _Vector3, _Camera3D)
    self.GetScreenToWorld2D = ray.define('GetScreenToWorld2D', _Vector2, _Vector2, _Camera2D)
    self.GetWorldToScreenEx = ray.define('GetWorldToScreenEx', _Vector2, _Vector3, _Camera3D, int, int)
    self.GetWorldToScreen2D = ray.define('GetWorldToScreen2D', _Vector2, _Vector2, _Camera2D)

    # Timing-related functions
    self.SetTargetFPS = ray.define('SetTargetFPS', void, int)
    self.GetFPS = ray.define('GetFPS', int)
    self.GetFrameTime = ray.define('GetFrameTime', float)
    self.GetTime = ray.define('GetTime', double)

    # Misc. functions
    self.GetRandomValue = ray.define('GetRandomValue', int, int, int)
    self.SetRandomSeed = ray.define('SetRandomSeed', void, uint)
    self.TakeScreenshot = ray.define('TakeScreenshot', void, char_ptr)
    self.SetConfigFlags = ray.define('SetConfigFlags', void, uint)
    self.SetTraceLogLevel = ray.define('SetTraceLogLevel', void, int)
    self.MemAlloc = ray.define('MemAlloc', ptr, uint)
    self.MemRealloc = ray.define('MemRealloc', ptr, ptr, uint)
    self.MemFree = ray.define('MemFree', void, ptr)
    self.OpenURL = ray.define('OpenURL', void, char_ptr)


    # ------------------------------------------------------------------------------------
    #  Input Handling Functions (Module: core)
    # ------------------------------------------------------------------------------------

    # Input-related functions: keyboard
    self.IsKeyPressed = ray.define('IsKeyPressed', bool, int)
    self.IsKeyDown = ray.define('IsKeyDown', bool, int)
    self.IsKeyReleased = ray.define('IsKeyReleased', bool, int)
    self.IsKeyUp = ray.define('IsKeyUp', bool, int)
    self.SetExitKey = ray.define('SetExitKey', void, int)
    self.GetKeyPressed = ray.define('GetKeyPressed', int)
    self.GetCharPressed = ray.define('GetCharPressed', int)

    # Input-related functions: gamepads
    self.IsGamepadAvailable = ray.define('IsGamepadAvailable', bool, int)
    self.GetGamepadName = ray.define('GetGamepadName', char_ptr, int)
    self.IsGamepadButtonPressed = ray.define('IsGamepadButtonPressed', bool, int, int)
    self.IsGamepadButtonDown = ray.define('IsGamepadButtonDown', bool, int, int)
    self.IsGamepadButtonReleased = ray.define('IsGamepadButtonReleased', bool, int, int)
    self.IsGamepadButtonUp = ray.define('IsGamepadButtonUp', bool, int, int)
    self.GetGamepadButtonPressed = ray.define('GetGamepadButtonPressed', int)
    self.GetGamepadAxisCount = ray.define('GetGamepadAxisCount', int)
    self.GetGamepadAxisMovement = ray.define('GetGamepadAxisMovement', float, int, int)
    self.SetGamepadMappings = ray.define('SetGamepadMappings', int, char_ptr)

    # Input-related functions: mouse
    self.IsMouseButtonPressed = ray.define('IsMouseButtonPressed', bool, int)
    self.IsMouseButtonDown = ray.define('IsMouseButtonDown', bool, int)
    self.IsMouseButtonReleased = ray.define('IsMouseButtonReleased', bool, int)
    self.IsMouseButtonUp = ray.define('IsMouseButtonUp', bool, int)
    self.GetMouseX = ray.define('GetMouseX', int)
    self.GetMouseY = ray.define('GetMouseY', int)
    self.GetMousePosition = ray.define('GetMousePosition', _Vector2)
    self.GetMouseDelta = ray.define('GetMouseDelta', _Vector2)
    self.SetMousePosition = ray.define('SetMousePosition', void, int, int)
    self.SetMouseOffset = ray.define('SetMouseOffset', void, int, int)
    self.SetMouseScale = ray.define('SetMouseScale', void, int, int)
    self.GetMouseWheelMove = ray.define('GetMouseWheelMove', float)
    self.GetMouseWheelMoveV = ray.define('GetMouseWheelMoveV', _Vector2)
    self.SetMouseCursor = ray.define('SetMouseCursor', void, int)

    # Input-related functions: touch
    self.GetTouchX = ray.define('GetTouchX', int)
    self.GetTouchY = ray.define('GetTouchY', int)
    self.GetTouchPosition = ray.define('GetTouchPosition', _Vector2, int)
    self.GetTouchPointId = ray.define('GetTouchPointId', int, int)
    self.GetTouchPointCount = ray.define('GetTouchPointCount', int)


    # ------------------------------------------------------------------------------------
    #  Gestures and Touch Handling Functions (Module: rgestures)
    # ------------------------------------------------------------------------------------
    self.SetGesturesEnabled = ray.define('SetGesturesEnabled', void, uint)
    self.IsGestureDetected = ray.define('IsGestureDetected', bool, uint)
    self.GetGestureDetected = ray.define('GetGestureDetected', int)
    self.GetGestureHoldDuration = ray.define('GetGestureHoldDuration', float)
    self.GetGestureDragVector = ray.define('GetGestureDragVector', _Vector2)
    self.GetGestureDragAngle = ray.define('GetGestureDragAngle', float)
    self.GetGesturePinchVector = ray.define('GetGesturePinchVector', _Vector2)
    self.GetGesturePinchAngle = ray.define('GetGesturePinchAngle', float)


    # ------------------------------------------------------------------------------------
    #  Camera System Functions (Module: rcamera)
    # ------------------------------------------------------------------------------------
    self.UpdateCamera = ray.define('UpdateCamera', void, _Camera3D, int)
    self.UpdateCameraPro = ray.define('UpdateCamera', void, _Camera3D, _Vector3, _Vector3, int)

    /**
     * rshapes
     */
    self.SetShapesTexture = ray.define('SetShapesTexture', void, _Texture, _Rectangle)
    # Basic shape drawing functions
    self.DrawPixel = ray.define('DrawPixel', void, int, int, _Color)
    self.DrawPixelV = ray.define('DrawPixelV', void, _Vector2, _Color)
    self.DrawLine = ray.define('DrawLine', void, int, int, int, int, _Color)
    self.DrawLineV = ray.define('DrawLineV', void, _Vector2, _Vector2, _Color)
    self.DrawLineEx = ray.define('DrawLineEx', void, _Vector2, _Vector2, float, _Color)
    self.DrawLineBezier = ray.define('DrawLineBezier', void, _Vector2, _Vector2, float, _Color)
    self.DrawLineBezierQuad = ray.define('DrawLineBezierQuad', void, _Vector2, _Vector2, _Vector2, float, _Color)
    self.DrawLineBezierCubic = ray.define('DrawLineBezierCubic', void, _Vector2, _Vector2, _Vector2, _Vector2, float, _Color)
    self.DrawLineStrip = ray.define('DrawLineStrip', void, _Vector2, int, _Color)
    self.DrawCircle = ray.define('DrawCircle', void, int, int, int, _Color)
    self.DrawCircleSector = ray.define('DrawCircleSector', void, _Vector2, float, float, float, int, _Color)
    self.DrawCircleSectorLines = ray.define('DrawCircleSectorLines', void, _Vector2, float, float, float, int, _Color)
    self.DrawCircleGradient = ray.define('DrawCircleGradient', void, int, int, float, _Color, _Color)
    self.DrawCircleV = ray.define('DrawCircleV', void, _Vector2, float, _Color)
    self.DrawCircleLines = ray.define('DrawCircleLines', void, int, int, float, _Color)
    self.DrawEllipse = ray.define('DrawEllipse', void, int, int, float, float, _Color)
    self.DrawEllipseLines = ray.define('DrawEllipseLines', void, int, int, float, float, _Color)
    self.DrawRing = ray.define('DrawRing', void, _Vector2, float, float, float, float, int, _Color)
    self.DrawRingLines = ray.define('DrawRingLines', void, _Vector2, float, float, float, float, int, _Color)
    self.DrawRectangle = ray.define('DrawRectangle', void, int, int, int, int, _Color)                        
    self.DrawRectangleV = ray.define('DrawRectangleV', void, _Vector2, _Vector2, _Color)                                  
    self.DrawRectangleRec = ray.define('DrawRectangleRec', void, _Rectangle, _Color)                                                 
    self.DrawRectanglePro = ray.define('DrawRectanglePro', void, _Rectangle, _Vector2, float, _Color)                 
    self.DrawRectangleGradientV = ray.define('DrawRectangleGradientV', void, int, int, int, int, _Color, _Color)
    self.DrawRectangleGradientH = ray.define('DrawRectangleGradientH', void, int, int, int, int, _Color, _Color)
    self.DrawRectangleGradientEx = ray.define('DrawRectangleGradientEx', void, _Rectangle, _Color, _Color, _Color, _Color)       
    self.DrawRectangleLines = ray.define('DrawRectangleLines', void, int, int, int, int, _Color)                   
    self.DrawRectangleLinesEx = ray.define('DrawRectangleLinesEx', void, _Rectangle, float, _Color)                            
    self.DrawRectangleRounded = ray.define('DrawRectangleRounded', void, _Rectangle, float, int, _Color)              
    self.DrawRectangleRoundedLines = ray.define('DrawRectangleRoundedLines', void, _Rectangle, float, int, float, _Color) 
    self.DrawTriangle = ray.define('DrawTriangle', void, _Vector2, _Vector2, _Vector2, _Color)                                
    self.DrawTriangleLines = ray.define('DrawTriangleLines', void, _Vector2, _Vector2, _Vector2, _Color)                           
    self.DrawTriangleFan = ray.define('DrawTriangleFan', void, _Vector2, int, _Color)                                
    self.DrawTriangleStrip = ray.define('DrawTriangleStrip', void, _Vector2, int, _Color)                              
    self.DrawPoly = ray.define('DrawPoly', void, _Vector2, int, float, float, _Color)               
    self.DrawPolyLines = ray.define('DrawPolyLines', void, _Vector2, int, float, float, _Color)          
    self.DrawPolyLinesEx = ray.define('DrawPolyLinesEx', void, _Vector2, int, float, float, float, _Color) 

    # Basic shapes collision detection functions
    self.CheckCollisionRecs = ray.define('CheckCollisionRecs', bool, _Rectangle, _Rectangle)                                           
    self.CheckCollisionCircles = ray.define('CheckCollisionCircles', bool, _Vector2, float, _Vector2, float)        
    self.CheckCollisionCircleRec = ray.define('CheckCollisionCircleRec', bool, _Vector2, float, _Rectangle)                         
    self.CheckCollisionPointRec = ray.define('CheckCollisionPointRec', bool, _Vector2, _Rectangle)                                         
    self.CheckCollisionPointCircle = ray.define('CheckCollisionPointCircle', bool, _Vector2, _Vector2, float)                       
    self.CheckCollisionPointTriangle = ray.define('CheckCollisionPointTriangle', bool, _Vector2, _Vector2, _Vector2, _Vector2)               
    self.CheckCollisionPointPoly = ray.define('CheckCollisionPointPoly', bool, _Vector2, _Vector2, int)                      
    self.CheckCollisionLines = ray.define('CheckCollisionLines', bool, _Vector2, _Vector2, _Vector2, _Vector2, _Vector2) 
    self.CheckCollisionPointLine = ray.define('CheckCollisionPointLine', bool, _Vector2, _Vector2, _Vector2, int)                
    self.GetCollisionRec = ray.define('GetCollisionRec', _Rectangle, _Rectangle, _Rectangle)                                         

    /**
     * rtexture
     */
    # Image loading functions
    # NOTE: These functions do not require GPU access
    self.LoadImage = ray.define('LoadImage', _Image, char_ptr)                                                             
    self.LoadImageRaw = ray.define('LoadImageRaw', _Image, char_ptr, int, int, int, int)       
    self.LoadImageAnim = ray.define('LoadImageAnim', _Image, char_ptr, int)                                            
    self.LoadImageFromMemory = ray.define('LoadImageFromMemory', _Image, char_ptr, char, int)      
    self.LoadImageFromTexture = ray.define('LoadImageFromTexture', _Image, _Texture2D)                                                     
    self.LoadImageFromScreen = ray.define('LoadImageFromScreen', _Image, void)                                                                   
    self.IsImageReady = ray.define('IsImageReady', bool, _Image)                                                                    
    self.UnloadImage = ray.define('UnloadImage', void, _Image)                                                                     
    self.ExportImage = ray.define('ExportImage', bool, _Image, char_ptr)                                               
    self.ExportImageAsCode = ray.define('ExportImageAsCode', bool, _Image, char_ptr)                                         

    # Image generation functions
    self.GenImageColor = ray.define('GenImageColor', _Image, int, int, _Color)                                           
    self.GenImageGradientV = ray.define('GenImageGradientV', _Image, int, int, _Color, _Color)                           
    self.GenImageGradientH = ray.define('GenImageGradientH', _Image, int, int, _Color, _Color)                           
    self.GenImageGradientRadial = ray.define('GenImageGradientRadial', _Image, int, int, float, _Color, _Color)      
    self.GenImageChecked = ray.define('GenImageChecked', _Image, int, int, int, int, _Color, _Color)    
    self.GenImageWhiteNoise = ray.define('GenImageWhiteNoise', _Image, int, int, float)                                     
    self.GenImagePerlinNoise = ray.define('GenImagePerlinNoise', _Image, int, int, int, int, float)           
    self.GenImageCellular = ray.define('GenImageCellular', _Image, int, int, int)                                       
    self.GenImageText = ray.define('GenImageText', _Image, int, int, char_ptr)                                       

    # Image manipulation functions
    self.ImageCopy = ray.define('ImageCopy', _Image, _Image)                                                                      
    self.ImageFromImage = ray.define('ImageFromImage', _Image, _Image, _Rectangle)                                                  
    self.ImageText = ray.define('ImageText', _Image, char_ptr, int, _Color)                                      
    self.ImageTextEx = ray.define('ImageTextEx', _Image, _Font, char_ptr, float, float, _Color)         
    self.ImageFormat = ray.define('ImageFormat', void, ptr, int)  # ptr: Image                                                   
    self.ImageToPOT = ray.define('ImageToPOT', void, ptr, _Color)  # ptr: Image                                                        
    self.ImageCrop = ray.define('ImageCrop', void, ptr, _Rectangle) # ptr: Image                                                     
    self.ImageAlphaCrop = ray.define('ImageAlphaCrop', void, ptr, float)   # ptr: Image                                               
    self.ImageAlphaClear = ray.define('ImageAlphaClear', void, ptr, _Color, float)     # ptr: Image                               
    self.ImageAlphaMask = ray.define('ImageAlphaMask', void, ptr, _Image)    # ptr: Image                                              
    self.ImageAlphaPremultiply = ray.define('ImageAlphaPremultiply', void, ptr)   # ptr: Image                                                          
    self.ImageBlurGaussian = ray.define('ImageBlurGaussian', void, ptr, int)   # ptr: Image                                                
    self.ImageResize = ray.define('ImageResize', void, ptr, int, int)    # ptr: Image                                     
    self.ImageResizeNN = ray.define('ImageResizeNN', void, ptr, int,int)     # ptr: Image                                   
    self.ImageResizeCanvas = ray.define('ImageResizeCanvas', void, ptr, int, int, int, int, _Color)    # ptr: Image
    self.ImageMipmaps = ray.define('ImageMipmaps', void, ptr)   # ptr: Image                                                                   
    self.ImageDither = ray.define('ImageDither', void, ptr, int, int, int, int)                            
    self.ImageFlipVertical = ray.define('ImageFlipVertical', void, ptr)   # ptr: Image                                                              
    self.ImageFlipHorizontal = ray.define('ImageFlipHorizontal', void, ptr)   # ptr: Image                                                            
    self.ImageRotateCW = ray.define('ImageRotateCW', void, ptr)   # ptr: Image                                                                 
    self.ImageRotateCCW = ray.define('ImageRotateCCW', void, ptr)   # ptr: Image                                                                 
    self.ImageColorTint = ray.define('ImageColorTint', void, ptr, _Color)    # ptr: Image                                                  
    self.ImageColorInvert = ray.define('ImageColorInvert', void, ptr)   # ptr: Image                                                               
    self.ImageColorGrayscale = ray.define('ImageColorGrayscale', void, ptr)   # ptr: Image                                                            
    self.ImageColorContrast = ray.define('ImageColorContrast', void, ptr, float)   # ptr: Image                                             
    self.ImageColorBrightness = ray.define('ImageColorBrightness', void, ptr, int)   # ptr: Image                                           
    self.ImageColorReplace = ray.define('ImageColorReplace', void, ptr, _Color, _Color)    # ptr: Image                                
    self.LoadImageColors = ray.define('LoadImageColors', ptr, ptr)   # ptr: Color, Image                                                               
    self.LoadImagePalette = ray.define('LoadImagePalette', ptr, ptr, int, int)    # ptr: Color, Image                       
    self.UnloadImageColors = ray.define('UnloadImageColors', void, ptr)   # ptr: Colors                                                             
    self.UnloadImagePalette = ray.define('UnloadImagePalette', void, ptr)   # ptr: Colors                                                            
    self.GetImageAlphaBorder = ray.define('GetImageAlphaBorder', _Rectangle, _Image, float)                                       
    self.GetImageColor = ray.define('GetImageColor', _Color, _Image, int, int)                                                    

    # Image drawing functions
    # NOTE: Image software-rendering functions (CPU)
    self.ImageClearBackground = ray.define('ImageClearBackground', void, ptr, _Color)  # ptr: Image                                                
    self.ImageDrawPixel = ray.define('ImageDrawPixel', void, ptr, int, int, _Color)  # ptr: Image                                  
    self.ImageDrawPixelV = ray.define('ImageDrawPixelV', void, ptr, _Vector2, _Color)  # ptr: Image                                   
    self.ImageDrawLine = ray.define('ImageDrawLine', void, ptr, int, int, int, int, _Color)  # ptr: Image 
    self.ImageDrawLineV = ray.define('ImageDrawLineV', void, ptr, _Vector2, _Vector2, _Color)   # ptr: Image                         
    self.ImageDrawCircle = ray.define('ImageDrawCircle', void, ptr, int, int, int, _Color)  # ptr: Image               
    self.ImageDrawCircleV = ray.define('ImageDrawCircleV', void, ptr, _Vector2, int, _Color)   # ptr: Image                       
    self.ImageDrawCircleLines = ray.define('ImageDrawCircleLines', void, ptr, int, int, int, _Color)    # ptr: Image        
    self.ImageDrawCircleLinesV = ray.define('ImageDrawCircleLinesV', void, ptr, _Vector2, int, _Color)   # ptr: Image                  
    self.ImageDrawRectangle = ray.define('ImageDrawRectangle', void, ptr, int, int, int, int, _Color)   # ptr: Image      
    self.ImageDrawRectangleV = ray.define('ImageDrawRectangleV', void, ptr, _Vector2, _Vector2, _Color)   # ptr: Image                
    self.ImageDrawRectangleRec = ray.define('ImageDrawRectangleRec', void, ptr, _Rectangle, _Color)   # ptr: Image                               
    self.ImageDrawRectangleLines = ray.define('ImageDrawRectangleLines', void, ptr, _Rectangle, int, _Color)   # ptr: Image                  
    self.ImageDraw = ray.define('ImageDraw', void, ptr, _Image, _Rectangle, _Rectangle, _Color)    # ptr: Image           
    self.ImageDrawText = ray.define('ImageDrawText', void, ptr, char_ptr, int, int, int, _Color)   # ptr: Image  
    self.ImageDrawTextEx = ray.define('ImageDrawTextEx', void, ptr, _Font, char_ptr, _Vector2, float, float, _Color)   # ptr: Image

    # Texture loading functions
    # NOTE: These functions require GPU access
    self.LoadTexture = ray.define('LoadTexture', _Texture2D, char_ptr)                                                       
    self.LoadTextureFromImage = ray.define('LoadTextureFromImage', _Texture2D, _Image)                                                       
    self.LoadTextureCubemap = ray.define('LoadTextureCubemap', _TextureCubemap, _Image, int)                                        
    self.LoadRenderTexture = ray.define('LoadRenderTexture', _RenderTexture2D, int, int)                                          
    self.IsTextureReady = ray.define('IsTextureReady', bool, _Texture2D)                                                            
    self.UnloadTexture = ray.define('UnloadTexture', void, _Texture2D)                                                             
    self.IsRenderTextureReady = ray.define('IsRenderTextureReady', bool, _RenderTexture2D)                                                       
    self.UnloadRenderTexture = ray.define('UnloadRenderTexture', void, _RenderTexture2D)                                                  
    self.UpdateTexture = ray.define('UpdateTexture', void, _Texture2D, ptr)                                         
    self.UpdateTextureRec = ray.define('UpdateTextureRec', void, _Texture2D, _Rectangle, ptr)                       

    # Texture configuration functions
    self.GenTextureMipmaps = ray.define('GenTextureMipmaps', void, ptr)   # ptr: Texture2D                                                        
    self.SetTextureFilter = ray.define('SetTextureFilter', void, _Texture2D, int)                                              
    self.SetTextureWrap = ray.define('SetTextureWrap', void, _Texture2D, int)                                                  

    # Texture drawing functions
    self.DrawTexture = ray.define('DrawTexture', void, _Texture2D, int, int, _Color)                               
    self.DrawTextureV = ray.define('DrawTextureV', void, _Texture2D, _Vector2, _Color)                                
    self.DrawTextureEx = ray.define('DrawTextureEx', void, _Texture2D, _Vector2, float, float, _Color)  
    self.DrawTextureRec = ray.define('DrawTextureRec', void, _Texture2D, _Rectangle, _Vector2, _Color)            
    self.DrawTexturePro = ray.define('DrawTexturePro', void, _Texture2D, _Rectangle, _Rectangle, _Vector2, float, _Color) 
    self.DrawTextureNPatch = ray.define('DrawTextureNPatch', void, _Texture2D, _NPatchInfo, _Rectangle, _Vector2, float, _Color) 

    # Color/pixel related functions
    self.Fade = ray.define('Fade', _Color, _Color, float)                                 
    self.ColorToInt = ray.define('ColorToInt', int, _Color)                                          
    self.ColorNormalize = ray.define('ColorNormalize', _Vector4, _Color)                                  
    self.ColorFromNormalized = ray.define('ColorFromNormalized', _Color, _Vector4)                        
    self.ColorToHSV = ray.define('ColorToHSV', _Vector3, _Color)                                      
    self.ColorFromHSV = ray.define('ColorFromHSV', _Color, float, float, float)         
    self.ColorTint = ray.define('ColorTint', _Color, _Color, _Color)                             
    self.ColorBrightness = ray.define('ColorBrightness', _Color, _Color, float)                     
    self.ColorContrast = ray.define('ColorContrast', _Color, _Color, float)                     
    self.ColorAlpha = ray.define('ColorAlpha', _Color, _Color, float)                           
    self.ColorAlphaBlend = ray.define('ColorAlphaBlend', _Color, _Color, _Color, _Color)              
    self.GetColor = ray.define('GetColor', _Color, uint)                                
    self.GetPixelColor = ray.define('GetPixelColor', _Color, ptr, int)    # ptr: void                      
    self.SetPixelColor = ray.define('SetPixelColor', void, ptr, _Color, int)    # ptr: void          
    self.GetPixelDataSize = ray.define('GetPixelDataSize', int, int, int, int)              

    /**
     * rtext
     */
    # Font loading/unloading functions
    self.GetFontDefault = ray.define('GetFontDefault', _Font)                                                            
    self.LoadFont = ray.define('LoadFont', _Font, char_ptr)                                                  
    self.LoadFontEx = ray.define('LoadFontEx', _Font, char_ptr, int, ptr, int)  
    self.LoadFontFromImage = ray.define('LoadFontFromImage', _Font, _Image, _Color, int)                        
    self.LoadFontFromMemory = ray.define('LoadFontFromMemory', _Font, char_ptr, uchar_ptr, int, int, ptr, int) 
    self.IsFontReady = ray.define('IsFontReady', bool, _Font)                                                          
    self.LoadFontData = ray.define('LoadFontData', ptr, uchar_ptr, int, int, ptr, int, int) # ptr: GlyphInfo, int
    self.GenImageFontAtlas = ray.define('GenImageFontAtlas', _Image, ptr, ptr, int, int, int, int)  # ptr: GlyphInfo, List<Rectangle>
    self.UnloadFontData = ray.define('UnloadFontData', void, ptr, int)                                
    self.UnloadFont = ray.define('UnloadFont', void, _Font)                                                           
    self.ExportFontAsCode = ray.define('ExportFontAsCode', bool, _Font, char_ptr)                               

    #  Text drawing functions
    self.DrawFPS = ray.define('DrawFPS', void, int, int)                                                     
    self.DrawText = ray.define('DrawText', void, char_ptr, int, int, int, _Color)       
    self.DrawTextEx = ray.define('DrawTextEx', void, _Font, char_ptr, _Vector2, float, float, _Color) 
    self.DrawTextPro = ray.define('DrawTextPro', void, _Font, char_ptr, _Vector2, _Vector2, float, float, float, _Color) 
    self.DrawTextCodepoint = ray.define('DrawTextCodepoint', void, _Font, int, _Vector2, float, _Color) 
    self.DrawTextCodepoints = ray.define('DrawTextCodepoints', void, _Font, ptr, int, _Vector2, float, float, _Color) # ptr: int

    #  Text font info functions
    self.MeasureText = ray.define('MeasureText', int, char_ptr, int)                                      
    self.MeasureTextEx = ray.define('MeasureTextEx', _Vector2, _Font, char_ptr, float, float)    
    self.GetGlyphIndex = ray.define('GetGlyphIndex', int, _Font, int)                                          
    self.GetGlyphInfo = ray.define('GetGlyphInfo', _GlyphInfo, _Font, int)                                     
    self.GetGlyphAtlasRec = ray.define('GetGlyphAtlasRec', _Rectangle, _Font, int)                                 

    #  Text codepoints management functions (unicode)
    self.LoadUTF8 = ray.define('LoadUTF8', char_ptr, ptr, int)  # ptr: int              
    self.UnloadUTF8 = ray.define('UnloadUTF8', void, char_ptr)                                      
    self.LoadCodepoints = ray.define('LoadCodepoints', ptr, char_ptr, ptr)                
    self.UnloadCodepoints = ray.define('UnloadCodepoints', void, ptr)                           
    self.GetCodepointCount = ray.define('GetCodepointCount', int, char_ptr)                          
    self.GetCodepoint = ray.define('GetCodepoint', int, char_ptr, ptr)           
    self.GetCodepointNext = ray.define('GetCodepointNext', int, char_ptr, ptr)       
    self.GetCodepointPrevious = ray.define('GetCodepointPrevious', int, char_ptr, ptr)   
    self.CodepointToUTF8 = ray.define('CodepointToUTF8', char_ptr, int, ptr)  # ptr: int       

    #  Text strings management functions (no UTF-8, only byte)
    #  NOTE: Some strings allocate memory internally for returned, just be careful!
    self.TextCopy = ray.define('TextCopy', int, char_ptr, char_ptr)                                             
    self.TextIsEqual = ray.define('TextIsEqual', bool, char_ptr, char_ptr)                               
    self.TextLength = ray.define('TextLength', uint, char_ptr)                                            
    self.TextSubtext = ray.define('TextSubtext', char_ptr, char_ptr, int, int)                  
    self.TextReplace = ray.define('TextReplace', char_ptr, char_ptr, char_ptr, char_ptr)                   
    self.TextInsert = ray.define('TextInsert', char_ptr, char_ptr, char_ptr, int)                 
    self.TextJoin = ray.define('TextJoin', char_ptr, char_ptr, int, char_ptr)        
    self.TextSplit = ray.define('TextSplit', ptr, char_ptr, char, ptr)  # ptr: string, int               
    self.TextAppend = ray.define('TextAppend', void, char_ptr, char_ptr, ptr)                       
    self.TextFindIndex = ray.define('TextFindIndex', int, char_ptr, char_ptr)                                
    self.TextToUpper = ray.define('TextToUpper', char_ptr, char_ptr)                      
    self.TextToLower = ray.define('TextToLower', char_ptr, char_ptr)                      
    self.TextToPascal = ray.define('TextToPascal', char_ptr, char_ptr)                     
    self.TextToInteger = ray.define('TextToInteger', int, char_ptr)  
    
    
    # ----------------------------------------------------------------
    # Math functions (raymath.h)
    # ----------------------------------------------------------------
    self.math = {
      # Utils math
      Clamp: ray.define('Clamp', float, float, float, float),
      Lerp: ray.define('Lerp', float, float, float, float),
      Normalize: ray.define('Normalize', float, float, float, float),
      Remap: ray.define('Remap', float, float, float, float, float, float),
      Wrap: ray.define('Wrap', float, float, float, float),
      FloatEquals: ray.define('FloatEquals', int, float, float),
      # Vector2 math
      Vector2Zero: ray.define('Vector2Zero', _Vector2, void),
      Vector2One: ray.define('Vector2One', _Vector2, void),
      Vector2Add: ray.define('Vector2Add', _Vector2, _Vector2, _Vector2),
      Vector2AddValue: ray.define('Vector2AddValue', _Vector2, _Vector2, float),
      Vector2Subtract: ray.define('Vector2Subtract', _Vector2, _Vector2, _Vector2),
      Vector2SubtractValue: ray.define('Vector2SubtractValue', _Vector2, _Vector2, float),
      Vector2Length: ray.define('Vector2Length', float, _Vector2),
      Vector2LengthSqr: ray.define('Vector2LengthSqr', float, _Vector2),
      Vector2DotProduct: ray.define('Vector2DotProduct', float, _Vector2, _Vector2),
      Vector2Distance: ray.define('Vector2Distance', float, _Vector2, _Vector2),
      Vector2DistanceSqr: ray.define('Vector2DistanceSqr', float, _Vector2, _Vector2),
      Vector2Angle: ray.define('Vector2Angle', float, _Vector2, _Vector2),
      Vector2Scale: ray.define('Vector2Scale', _Vector2, _Vector2, float),
      Vector2Multiply: ray.define('Vector2Multiply', _Vector2, _Vector2, _Vector2),
      Vector2Negate: ray.define('Vector2Negate', _Vector2, _Vector2),
      Vector2Divide: ray.define('Vector2Divide', _Vector2, _Vector2, _Vector2),
      Vector2Normalize: ray.define('Vector2Normalize', _Vector2, _Vector2),
      Vector2Transform: ray.define('Vector2Transform', _Vector2, _Vector2, _Matrix),
      Vector2Lerp: ray.define('Vector2Lerp', _Vector2, _Vector2, _Vector2, float),
      Vector2Reflect: ray.define('Vector2Reflect', _Vector2, _Vector2, _Vector2),
      Vector2Rotate: ray.define('Vector2Rotate', _Vector2, _Vector2, float),
      Vector2MoveTowards: ray.define('Vector2MoveTowards', _Vector2, _Vector2, _Vector2, float),
      Vector2Invert: ray.define('Vector2Invert', _Vector2, _Vector2),
      Vector2Clamp: ray.define('Vector2Clamp', _Vector2, _Vector2, _Vector2, _Vector2),
      Vector2ClampValue: ray.define('Vector2ClampValue', _Vector2, _Vector2, float, float),
      Vector2Equals: ray.define('Vector2Equals', int, _Vector2, _Vector2),
      # Vector3 math
      Vector3Zero: ray.define('Vector3Zero', _Vector3, void),
      Vector3One: ray.define('Vector3One', _Vector3, void),
      Vector3Add: ray.define('Vector3Add', _Vector3, _Vector3, _Vector3),
      Vector3AddValue: ray.define('Vector3AddValue', _Vector3, _Vector3, float),
      Vector3Subtract: ray.define('Vector3Subtract', _Vector3, _Vector3, _Vector3),
      Vector3SubtractValue: ray.define('Vector3SubtractValue', _Vector3, _Vector3, float),
      Vector3Scale: ray.define('Vector3Scale', _Vector3, _Vector3, float),
      Vector3Multiply: ray.define('Vector3Multiply', _Vector3, _Vector3, _Vector3),
      Vector3CrossProduct: ray.define('Vector3CrossProduct', _Vector3, _Vector3, _Vector3),
      Vector3Perpendicular: ray.define('Vector3Perpendicular', _Vector3, _Vector3),
      Vector3Length: ray.define('Vector3Length', float, _Vector3),
      Vector3LengthSqr: ray.define('Vector3LengthSqr', float, _Vector3),
      Vector3DotProduct: ray.define('Vector3DotProduct', float, _Vector3, _Vector3),
      Vector3Distance: ray.define('Vector3Distance', float, _Vector3, _Vector3),
      Vector3DistanceSqr: ray.define('Vector3DistanceSqr', float, _Vector3, _Vector3),
      Vector3Angle: ray.define('Vector3Angle', float, _Vector3, _Vector3),
      Vector3Negate: ray.define('Vector3Negate', _Vector3, _Vector3),
      Vector3Divide: ray.define('Vector3Divide', _Vector3, _Vector3, _Vector3),
      Vector3Normalize: ray.define('Vector3Normalize', _Vector3, _Vector3),
      Vector3OrthoNormalize: ray.define('Vector3OrthoNormalize', void, ptr, ptr), # ptr = Vector3, _Vector3
      Vector3Transform: ray.define('Vector3Transform', _Vector3, _Vector3, _Matrix),
      Vector3RotateByQuaternion: ray.define('Vector3RotateByQuaternion', _Vector3, _Vector3, _Quaternion),
      Vector3RotateByAxisAngle: ray.define('Vector3RotateByAxisAngle', _Vector3, _Vector3, _Vector3, float),
      Vector3Lerp: ray.define('Vector3Lerp', _Vector3, _Vector3, _Vector3, float),
      Vector3Reflect: ray.define('Vector3Reflect', _Vector3, _Vector3, _Vector3),
      Vector3Min: ray.define('Vector3Min', _Vector3, _Vector3, _Vector3),
      Vector3Max: ray.define('Vector3Max', _Vector3, _Vector3, _Vector3),
      Vector3Barycenter: ray.define('Vector3Barycenter', _Vector3, _Vector3, _Vector3, _Vector3, _Vector3),
      Vector3Unproject: ray.define('Vector3Unproject', _Vector3, _Vector3, _Matrix, _Matrix),
      Vector3ToFloatV: ray.define('Vector3ToFloatV', _float3, _Vector3),
      Vector3Invert: ray.define('Vector3Invert', _Vector3, _Vector3),
      Vector3Clamp: ray.define('Vector3Clamp', _Vector3, _Vector3, _Vector3, _Vector3),
      Vector3ClampValue: ray.define('Vector3ClampValue', _Vector3, _Vector3, float, float),
      Vector3Equals: ray.define('Vector3Equals', int, _Vector3, _Vector3),
      Vector3Refract: ray.define('Vector3Refract', _Vector3, _Vector3, _Vector3, float),
      # Matrix math
      MatrixDeterminant: ray.define('MatrixDeterminant', float, _Matrix),
      MatrixTrace: ray.define('MatrixTrace', float, _Matrix),
      MatrixTranspose: ray.define('MatrixTranspose', _Matrix, _Matrix),
      MatrixInvert: ray.define('MatrixInvert', _Matrix, _Matrix),
      MatrixIdentity: ray.define('MatrixIdentity', _Matrix, void),
      MatrixAdd: ray.define('MatrixAdd', _Matrix, _Matrix, _Matrix),
      MatrixSubtract: ray.define('MatrixSubtract', _Matrix, _Matrix, _Matrix),
      MatrixMultiply: ray.define('MatrixMultiply', _Matrix, _Matrix, _Matrix),
      MatrixTranslate: ray.define('MatrixTranslate', _Matrix, float, float, float),
      MatrixRotate: ray.define('MatrixRotate', _Matrix, _Vector3, float),
      MatrixRotateX: ray.define('MatrixRotateX', _Matrix, float),
      MatrixRotateY: ray.define('MatrixRotateY', _Matrix, float),
      MatrixRotateZ: ray.define('MatrixRotateZ', _Matrix, float),
      MatrixRotateXYZ: ray.define('MatrixRotateXYZ', _Matrix, _Vector3),
      MatrixRotateZYX: ray.define('MatrixRotateZYX', _Matrix, _Vector3),
      MatrixScale: ray.define('MatrixScale', _Matrix, float, float, float),
      MatrixFrustum: ray.define('MatrixFrustum', _Matrix, double, double, double, double, double, double),
      MatrixPerspective: ray.define('MatrixPerspective', _Matrix, double, double, double, double),
      MatrixOrtho: ray.define('MatrixOrtho', _Matrix, double, double, double, double, double, double),
      MatrixLookAt: ray.define('MatrixLookAt', _Matrix, _Vector3, _Vector3, _Vector3),
      MatrixToFloatV: ray.define('MatrixToFloatV', _float16, _Matrix),
      # Quaternion math
      QuaternionAdd: ray.define('QuaternionAdd', _Quaternion, _Quaternion, _Quaternion),
      QuaternionAddValue: ray.define('QuaternionAddValue', _Quaternion, _Quaternion, float),
      QuaternionSubtract: ray.define('QuaternionSubtract', _Quaternion, _Quaternion, _Quaternion),
      QuaternionSubtractValue: ray.define('QuaternionSubtractValue', _Quaternion, _Quaternion, float),
      QuaternionIdentity: ray.define('QuaternionIdentity', _Quaternion, void),
      QuaternionLength: ray.define('QuaternionLength', float, _Quaternion),
      QuaternionNormalize: ray.define('QuaternionNormalize', _Quaternion, _Quaternion),
      QuaternionInvert: ray.define('QuaternionInvert', _Quaternion, _Quaternion),
      QuaternionMultiply: ray.define('QuaternionMultiply', _Quaternion, _Quaternion, _Quaternion),
      QuaternionScale: ray.define('QuaternionScale', _Quaternion, _Quaternion, float),
      QuaternionDivide: ray.define('QuaternionDivide', _Quaternion, _Quaternion, _Quaternion),
      QuaternionLerp: ray.define('QuaternionLerp', _Quaternion, _Quaternion, _Quaternion, float),
      QuaternionNlerp: ray.define('QuaternionNlerp', _Quaternion, _Quaternion, _Quaternion, float),
      QuaternionSlerp: ray.define('QuaternionSlerp', _Quaternion, _Quaternion, _Quaternion, float),
      QuaternionFromVector3ToVector3: ray.define('QuaternionFromVector3ToVector3', _Quaternion, _Vector3, _Vector3),
      QuaternionFromMatrix: ray.define('QuaternionFromMatrix', _Quaternion, _Matrix),
      QuaternionToMatrix: ray.define('QuaternionToMatrix', _Matrix, _Quaternion),
      QuaternionFromAxisAngle: ray.define('QuaternionFromAxisAngle', _Quaternion, _Vector3, float),
      QuaternionToAxisAngle: ray.define('QuaternionToAxisAngle', void, _Quaternion, ptr, ptr), # ptr = Vector3, float
      QuaternionFromEuler: ray.define('QuaternionFromEuler', _Quaternion, float, float, float),
      QuaternionToEuler: ray.define('QuaternionToEuler', _Vector3, _Quaternion),
      QuaternionTransform: ray.define('QuaternionTransform', _Quaternion, _Quaternion, _Matrix),
      QuaternionEquals: ray.define('QuaternionEquals', int, _Quaternion, _Quaternion),
    }
  }
}

def Init(debug) {
  # decline unsupported environments
  var error
  using os.platform {
    when 'osx' {
      if _machine_type == 'arm64' {
        # ensure that Rosetta 2 is running
        var check_rosetta2 = os.exec('/usr/bin/pgrep -q oahd && echo yes || echo no')
        if check_rosetta2 and check_rosetta2.trim() != 'yes' {
          error = 'Rosetta 2 must be installed and running to run this application.'
        }
      }
    }
    when 'linux' {
      if _machine_type.starts_with('arm') or _machine_type.starts_with('aarch') {
        error = 'ARM and AARCH environments not supported by this application.'
      } else if !_machine_type.contains('64') {
        error = '64-bit machine required to run application.'
      }
    }
    when 'windows' {
      if _machine_type.starts_with('arm') or !_machine_type.match('64') {
        error = '64-bit non-ARM machine required to run application.'
      }

      # windows require that we are have our directory in the path
      var curr_env = os.get_env('PATH')
      curr_env += os.join_paths(os.dir_name(os.dir_name(os.current_file())), 'bin') + ';'
      os.set_env('PATH', curr_env)
      _bin_path = 'libraylib.dll'
    }
  }

  if error die Exception(error)

  var lib = _Lib(_bin_path)
  if !debug {
    lib.SetTraceLogLevel(LOG_NONE)
  }
  return lib
}

