import clib { * }
import struct as st
import .constants { * }
import reflect
import os
import iters

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
      width: res.width2,
      height: res.height2,
      mipmaps: res.mipmaps2,
      format: res.format2,
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

var _Transform = struct(
  _Vector3,     # translation
  _Quaternion,  # rotation
  _Vector3      # scale
)
def DeTransform(v) {
  var res = st.unpack('fx/fy/fz/fx1/fy1/fz1/fw1/fx2/fy2/fz2', v)
  return {
    translation: {x: res.x, y: res.y, z: res.z},
    rotation: {x: res.x1, y: res.y1, z: res.z1, w: res.w1},
    scale: {x: res.x2, y: res.y2, z: res.z2},
  }
}

var _BoneInfo = struct(
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char,
  int
)
def DeBoneInfo(v) {
  var res = st.unpack('c32/i1parent')
  return {
    name: iters.filter(res, @(_, x){ return !is_string(x) }),
    'parent': res['parent'],
  }
}

var _Model = struct(
  _Matrix,    # transform
  int,        # meshCount
  int,        # materialCount
  ptr,        # meshes
  ptr,        # materials
  ptr,        # meshMaterial
  int,        # boneCount
  ptr,        # bones
  ptr         # bindPose
)
def DeModel(v) {
  var res = st.unpack(
    'fm0/fm4/fm8/fm12' +
    '/fm1/fm5/fm9/fm13' +
    '/fm2/fm6/fm10/fm14' +
    '/fm3/fm7/fm11/fm15' +
    '/imeshCount/imaterialCount' +
    '/${_ptr_type}meshes' +
    '/${_ptr_type}materials' +
    '/${_ptr_type}meshMaterial' +
    '/iboneCount' +
    '/${_ptr_type}bones' +
    '/${_ptr_type}bindPose', v)
    
  return {
    transform: {
      m0: res.m0, m1: res.m1, m2: res.m2, m3: res.m3,
      m4: res.m4, m5: res.m5, m6: res.m6, m7: res.m7,
      m8: res.m8, m9: res.m9, m10: res.m10, m11: res.m11,
      m12: res.m12, m13: res.m13, m14: res.m14, m15: res.m15,
    },
    meshCount: res.meshCount,
    materialCount: res.materialCount,
    meshes: res.meshes,
    materials: res.materials,
    meshMaterial: res.meshMaterial,
    boneCount: res.boneCount,
    bones: res.bones,
    bindPose: res.bindPose,
  }
}

var _ModelAnimation = struct(
  int,  # boneCount
  int,  # frameCount
  ptr,  # bones
  ptr   # framePoses
)
def DeModelAnimation(v) {
  return st.unpack('iboneCount/iframeCount/${_ptr_type}bones/${_ptr_types}framePoses', v)
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

var _RayCollision = struct(
  bool,     # hit
  float,    # distance
  _Vector3, # point
  _Vector3  # point
)
def DeRayCollision(v) {
  var res = st.unpack('chit/fdistance/fx/fy/fz/fx1/fy1/fz1', v)
  return {
    hit: res.hit,
    distance: res.distance,
    point: {
      x: res.x,
      y: res.y,
      z: res.z,
    },
    point: {
      x: res.x1,
      y: res.y1,
      z: res.z1,
    },
  }
}

var _BoundingBox = struct(
  _Vector3,    # min
  _Vector3     # max
)
def DeBoundingBox(v) {
  var res = st.unpack('fx/fy/fz/fx1/fy1/fz1', v)
  return {
    min: {
      x: res.x,
      y: res.y,
      z: res.z,
    },
    max: {
      x: res.x1,
      y: res.y1,
      z: res.z1,
    },
  }
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

def float3(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 3 {
    floats.extend([0] * (3 - floats.length()))
  }
  return st.pack('f3', floats)
}

def float16(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 16 {
    floats.extend([0] * (16 - floats.length()))
  }
  return st.pack('f16', floats)
}

def BoneInfo(name, paren) {
  if !is_list(name) params = to_list(name)
  if name.length() < 32 
  name.extend([0] * (16 - name.length()))
  return st.pack('c32i', name, paren)
}

def Transform(translation, rotation, scale) {
  return st.pack(
    'C${translation.length()}C${rotation.length()}C${scale.length()}',
    translation, rotation, scale
  )
}

def Model(
  transform, meshCount, materialCount, meshes, 
  materials, meshMaterial, boneCount, bones, bindPose
) {
  return st.pack(
    'C${transform.length()}i2${_ptr_type}3i${_ptr_type}2',
    transform, meshCount, materialCount, meshes, 
    materials, meshMaterial, boneCount, bones, bindPose
  )
}

def ModelAnimation(boneCount, frameCount, bones, framePoses) {
  return st.pack('i2${_ptr_type}2', boneCount, frameCount, bones, framePoses)
}

def Ray(position, direction) {
  return st.pack('C${position.length()}C${locs.length()}', position, direction)
}

def RayCollision(hit, distance, point, normal) {
  return st.pack('cfC${point.length()}C${normal.length()}', hit, distance, point, normal)
}

def BoundingBox(min, max) {
  return st.pack('C${min.length()}C${max.length()}', min, max)
}

# ---------------------------------------------------------
# COLORS
# ---------------------------------------------------------

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


/**
 * Init([debug: bool])
 * 
 * Initializes and returns a new ray handle.
 * @return dictionary
 */
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

  var ray = load(_bin_path)

  var SetTraceLogLevel = ray.define('SetTraceLogLevel', void, int)
  
  if !debug {
    SetTraceLogLevel(LOG_NONE)
  }

  return {
    /**
     * rcore
     */
    # Window-related functions
    InitWindow: ray.define('InitWindow', void, int, int, char_ptr),
    WindowShouldClose: ray.define('WindowShouldClose', bool),
    CloseWindow: @() {
      ray.define('CloseWindow', void)()
      ray.close()
    },
    IsWindowReady: ray.define('IsWindowReady', bool),
    IsWindowFullscreen: ray.define('IsWindowFullscreen', bool),
    IsWindowHidden: ray.define('IsWindowHidden', bool),
    IsWindowMinimized: ray.define('IsWindowMinimized', bool),
    IsWindowMaximized: ray.define('IsWindowMaximized', bool),
    IsWindowFocused: ray.define('IsWindowFocused', bool),
    IsWindowResized: ray.define('IsWindowResized', bool),
    IsWindowState: ray.define('IsWindowState', bool, uint),
    SetWindowState: ray.define('SetWindowState', void, uint),
    ClearWindowState: ray.define('ClearWindowState', void, uint),
    ToggleFullscreen: ray.define('ToggleFullscreen', void),
    MaximizeWindow: ray.define('MaximizeWindow', void),
    MinimizeWindow: ray.define('MinimizeWindow', void),
    RestoreWindow: ray.define('RestoreWindow', void),
    SetWindowIcon: ray.define('SetWindowIcon', void, _Image),
    SetWindowIcons: ray.define('SetWindowIcons', ptr, int), # return value must be unpacked into Images
    SetWindowTitle: ray.define('SetWindowTitle', void, char_ptr),
    SetWindowPosition: ray.define('SetWindowPosition', void, int, int),
    SetWindowMonitor: ray.define('SetWindowMonitor', void, int),
    SetWindowMinSize: ray.define('SetWindowMinSize', void, int, int),
    SetWindowSize: ray.define('SetWindowSize', void, int, int),
    SetWindowOpacity: ray.define('SetWindowOpacity', void, float),
    GetWindowHandle: ray.define('GetWindowHandle', ptr),
    GetScreenWidth: ray.define('GetScreenWidth', int),
    GetScreenHeight: ray.define('GetScreenHeight', int),
    GetRenderWidth: ray.define('GetRenderWidth', int),
    GetRenderHeight: ray.define('GetRenderHeight', int),
    GetMonitorCount: ray.define('GetMonitorCount', int),
    GetCurrentMonitor: ray.define('GetCurrentMonitor', int),
    GetMonitorPosition: ray.define('GetMonitorPosition', uchar_ptr, int), # return must be unpacked into Vector2
    GetMonitorWidth: ray.define('GetMonitorWidth', int, int),
    GetMonitorHeight: ray.define('GetMonitorHeight', int, int),
    GetMonitorPhysicalWidth: ray.define('GetMonitorPhysicalWidth', int, int),
    GetMonitorPhysicalHeight: ray.define('GetMonitorPhysicalHeight', int, int),
    GetMonitorRefreshRate: ray.define('GetMonitorRefreshRate', int, int),
    GetWindowPosition: ray.define('GetWindowPosition', uchar_ptr), # return must be unpacked into Vector2
    GetWindowScaleDPI: ray.define('GetWindowScaleDPI', uchar_ptr), # return must be unpacked into Vector2
    GetMonitorName: ray.define('GetMonitorName', char_ptr, int),
    SetClipboardText: ray.define('SetClipboardText', void, char_ptr),
    GetClipboardText: ray.define('GetClipboardText', char_ptr),
    EnableEventWaiting: ray.define('EnableEventWaiting', void),
    DisableEventWaiting: ray.define('DisableEventWaiting', void),

    # Custom frame control functions
    # NOTE: Those functions are intended for advance users that want full control over the frame processing
    # By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
    SwapScreenBuffer: ray.define('SwapScreenBuffer', void),
    PollInputEvents: ray.define('PollInputEvents', void),
    WaitTime: ray.define('WaitTime', void, double),

    # Cursor-related functions
    ShowCursor: ray.define('ShowCursor', void),
    HideCursor: ray.define('HideCursor', void),
    IsCursorHidden: ray.define('IsCursorHidden', void),
    EnableCursor: ray.define('EnableCursor', void),
    DisableCursor: ray.define('DisableCursor', void),
    IsCursorOnScreen: ray.define('IsCursorOnScreen', void),

    # Drawring-related functions
    ClearBackground: ray.define('ClearBackground', void, _Color),
    BeginDrawing: ray.define('BeginDrawing', void),
    EndDrawing: ray.define('EndDrawing', void),
    BeginMode2D: ray.define('BeginMode2D', void, _Camera2D),
    EndMode2D: ray.define('EndMode2D', void),
    BeginMode3D: ray.define('BeginMode3D', void, _Camera3D),
    EndMode3D: ray.define('EndMode3D', void),
    BeginTextureMode: ray.define('BeginTextureMode', void, _RenderTexture),
    EndTextureMode: ray.define('EndTextureMode', void),
    BeginShaderMode: ray.define('BeginShaderMode', void, _Shader),
    EndShaderMode: ray.define('EndShaderMode', void),
    BeginBlendMode: ray.define('BeginBlendMode', void, int),
    EndBlendMode: ray.define('EndBlendMode', void),
    BeginScissorMode: ray.define('BeginScissorMode', void, int, int, int, int),
    EndScissorMode: ray.define('EndScissorMode', void),
    # var BeginVrStereoMode = ray.define('BeginVrStereoMode', void)
    # var EndVrStereoMode = ray.define('EndVrStereoMode', void)

    # Shader management functions
    LoadShader: ray.define('LoadShader', _Shader, char_ptr, char_ptr),
    LoadShaderFromMemory: ray.define('LoadShaderFromMemory', _Shader, char_ptr, char_ptr),
    IsShaderReady: ray.define('IsShaderReady', bool, _Shader),
    GetShaderLocation: ray.define('GetShaderLocation', int, _Shader, char_ptr),
    GetShaderLocationAttrib: ray.define('GetShaderLocationAttrib', int, _Shader, char_ptr),
    SetShaderValue: ray.define('SetShaderValue', void, _Shader, int, ptr, int),
    SetShaderValueV: ray.define('SetShaderValueV', void, _Shader, int, ptr, int, int),
    SetShaderValueMatrix: ray.define('SetShaderValueMatrix', void, _Shader, _Matrix),
    SetShaderValueTexture: ray.define('SetShaderValueTexture', void, _Shader, _Texture2D),
    UnloadShader: ray.define('UnloadShader', void, _Shader),

    # Screen-space-related functions
    GetMouseRay: ray.define('GetMouseRay', _Ray, _Vector2, _Camera3D), # return value will have to be unpacked to Ray
    GetWorldToScreen: ray.define('GetWorldToScreen', _Vector2, _Vector3, _Camera3D),
    GetScreenToWorld2D: ray.define('GetScreenToWorld2D', _Vector2, _Vector2, _Camera2D),
    GetWorldToScreenEx: ray.define('GetWorldToScreenEx', _Vector2, _Vector3, _Camera3D, int, int),
    GetWorldToScreen2D: ray.define('GetWorldToScreen2D', _Vector2, _Vector2, _Camera2D),

    # Timing-related functions
    SetTargetFPS: ray.define('SetTargetFPS', void, int),
    GetFPS: ray.define('GetFPS', int),
    GetFrameTime: ray.define('GetFrameTime', float),
    GetTime: ray.define('GetTime', double),

    # Misc. functions
    GetRandomValue: ray.define('GetRandomValue', int, int, int),
    SetRandomSeed: ray.define('SetRandomSeed', void, uint),
    TakeScreenshot: ray.define('TakeScreenshot', void, char_ptr),
    SetConfigFlags: ray.define('SetConfigFlags', void, uint),
    SetTraceLogLevel,
    MemAlloc: ray.define('MemAlloc', ptr, uint),
    MemRealloc: ray.define('MemRealloc', ptr, ptr, uint),
    MemFree: ray.define('MemFree', void, ptr),
    OpenURL: ray.define('OpenURL', void, char_ptr),


    # ------------------------------------------------------------------------------------
    #  Input Handling Functions (Module: core)
    # ------------------------------------------------------------------------------------

    # Input-related functions: keyboard
    IsKeyPressed: ray.define('IsKeyPressed', bool, int),
    IsKeyDown: ray.define('IsKeyDown', bool, int),
    IsKeyReleased: ray.define('IsKeyReleased', bool, int),
    IsKeyUp: ray.define('IsKeyUp', bool, int),
    SetExitKey: ray.define('SetExitKey', void, int),
    GetKeyPressed: ray.define('GetKeyPressed', int),
    GetCharPressed: ray.define('GetCharPressed', int),

    # Input-related functions: gamepads
    IsGamepadAvailable: ray.define('IsGamepadAvailable', bool, int),
    GetGamepadName: ray.define('GetGamepadName', char_ptr, int),
    IsGamepadButtonPressed: ray.define('IsGamepadButtonPressed', bool, int, int),
    IsGamepadButtonDown: ray.define('IsGamepadButtonDown', bool, int, int),
    IsGamepadButtonReleased: ray.define('IsGamepadButtonReleased', bool, int, int),
    IsGamepadButtonUp: ray.define('IsGamepadButtonUp', bool, int, int),
    GetGamepadButtonPressed: ray.define('GetGamepadButtonPressed', int),
    GetGamepadAxisCount: ray.define('GetGamepadAxisCount', int),
    GetGamepadAxisMovement: ray.define('GetGamepadAxisMovement', float, int, int),
    SetGamepadMappings: ray.define('SetGamepadMappings', int, char_ptr),

    # Input-related functions: mouse
    IsMouseButtonPressed: ray.define('IsMouseButtonPressed', bool, int),
    IsMouseButtonDown: ray.define('IsMouseButtonDown', bool, int),
    IsMouseButtonReleased: ray.define('IsMouseButtonReleased', bool, int),
    IsMouseButtonUp: ray.define('IsMouseButtonUp', bool, int),
    GetMouseX: ray.define('GetMouseX', int),
    GetMouseY: ray.define('GetMouseY', int),
    GetMousePosition: ray.define('GetMousePosition', _Vector2),
    GetMouseDelta: ray.define('GetMouseDelta', _Vector2),
    SetMousePosition: ray.define('SetMousePosition', void, int, int),
    SetMouseOffset: ray.define('SetMouseOffset', void, int, int),
    SetMouseScale: ray.define('SetMouseScale', void, int, int),
    GetMouseWheelMove: ray.define('GetMouseWheelMove', float),
    GetMouseWheelMoveV: ray.define('GetMouseWheelMoveV', _Vector2),
    SetMouseCursor: ray.define('SetMouseCursor', void, int),

    # Input-related functions: touch
    GetTouchX: ray.define('GetTouchX', int),
    GetTouchY: ray.define('GetTouchY', int),
    GetTouchPosition: ray.define('GetTouchPosition', _Vector2, int),
    GetTouchPointId: ray.define('GetTouchPointId', int, int),
    GetTouchPointCount: ray.define('GetTouchPointCount', int),


    # ------------------------------------------------------------------------------------
    #  Gestures and Touch Handling Functions (Module: rgestures)
    # ------------------------------------------------------------------------------------
    SetGesturesEnabled: ray.define('SetGesturesEnabled', void, uint),
    IsGestureDetected: ray.define('IsGestureDetected', bool, uint),
    GetGestureDetected: ray.define('GetGestureDetected', int),
    GetGestureHoldDuration: ray.define('GetGestureHoldDuration', float),
    GetGestureDragVector: ray.define('GetGestureDragVector', _Vector2),
    GetGestureDragAngle: ray.define('GetGestureDragAngle', float),
    GetGesturePinchVector: ray.define('GetGesturePinchVector', _Vector2),
    GetGesturePinchAngle: ray.define('GetGesturePinchAngle', float),


    # ------------------------------------------------------------------------------------
    #  Camera System Functions (Module: rcamera)
    # ------------------------------------------------------------------------------------
    UpdateCamera: ray.define('UpdateCamera', void, ptr, int),
    UpdateCameraPro: ray.define('UpdateCamera', void, ptr, _Vector3, _Vector3, int),

    /**
     * rshapes
     */
    SetShapesTexture: ray.define('SetShapesTexture', void, _Texture, _Rectangle),
    # Basic shape drawing functions
    DrawPixel: ray.define('DrawPixel', void, int, int, _Color),
    DrawPixelV: ray.define('DrawPixelV', void, _Vector2, _Color),
    DrawLine: ray.define('DrawLine', void, int, int, int, int, _Color),
    DrawLineV: ray.define('DrawLineV', void, _Vector2, _Vector2, _Color),
    DrawLineEx: ray.define('DrawLineEx', void, _Vector2, _Vector2, float, _Color),
    DrawLineBezier: ray.define('DrawLineBezier', void, _Vector2, _Vector2, float, _Color),
    DrawLineBezierQuad: ray.define('DrawLineBezierQuad', void, _Vector2, _Vector2, _Vector2, float, _Color),
    DrawLineBezierCubic: ray.define('DrawLineBezierCubic', void, _Vector2, _Vector2, _Vector2, _Vector2, float, _Color),
    DrawLineStrip: ray.define('DrawLineStrip', void, _Vector2, int, _Color),
    DrawCircle: ray.define('DrawCircle', void, int, int, int, _Color),
    DrawCircleSector: ray.define('DrawCircleSector', void, _Vector2, float, float, float, int, _Color),
    DrawCircleSectorLines: ray.define('DrawCircleSectorLines', void, _Vector2, float, float, float, int, _Color),
    DrawCircleGradient: ray.define('DrawCircleGradient', void, int, int, float, _Color, _Color),
    DrawCircleV: ray.define('DrawCircleV', void, _Vector2, float, _Color),
    DrawCircleLines: ray.define('DrawCircleLines', void, int, int, float, _Color),
    DrawEllipse: ray.define('DrawEllipse', void, int, int, float, float, _Color),
    DrawEllipseLines: ray.define('DrawEllipseLines', void, int, int, float, float, _Color),
    DrawRing: ray.define('DrawRing', void, _Vector2, float, float, float, float, int, _Color),
    DrawRingLines: ray.define('DrawRingLines', void, _Vector2, float, float, float, float, int, _Color),
    DrawRectangle: ray.define('DrawRectangle', void, int, int, int, int, _Color),                        
    DrawRectangleV: ray.define('DrawRectangleV', void, _Vector2, _Vector2, _Color),                                  
    DrawRectangleRec: ray.define('DrawRectangleRec', void, _Rectangle, _Color),                                                 
    DrawRectanglePro: ray.define('DrawRectanglePro', void, _Rectangle, _Vector2, float, _Color),                 
    DrawRectangleGradientV: ray.define('DrawRectangleGradientV', void, int, int, int, int, _Color, _Color),
    DrawRectangleGradientH: ray.define('DrawRectangleGradientH', void, int, int, int, int, _Color, _Color),
    DrawRectangleGradientEx: ray.define('DrawRectangleGradientEx', void, _Rectangle, _Color, _Color, _Color, _Color),       
    DrawRectangleLines: ray.define('DrawRectangleLines', void, int, int, int, int, _Color),                   
    DrawRectangleLinesEx: ray.define('DrawRectangleLinesEx', void, _Rectangle, float, _Color),                            
    DrawRectangleRounded: ray.define('DrawRectangleRounded', void, _Rectangle, float, int, _Color),              
    DrawRectangleRoundedLines: ray.define('DrawRectangleRoundedLines', void, _Rectangle, float, int, float, _Color), 
    DrawTriangle: ray.define('DrawTriangle', void, _Vector2, _Vector2, _Vector2, _Color),                                
    DrawTriangleLines: ray.define('DrawTriangleLines', void, _Vector2, _Vector2, _Vector2, _Color),                           
    DrawTriangleFan: ray.define('DrawTriangleFan', void, _Vector2, int, _Color),                                
    DrawTriangleStrip: ray.define('DrawTriangleStrip', void, _Vector2, int, _Color),                              
    DrawPoly: ray.define('DrawPoly', void, _Vector2, int, float, float, _Color),               
    DrawPolyLines: ray.define('DrawPolyLines', void, _Vector2, int, float, float, _Color),          
    DrawPolyLinesEx: ray.define('DrawPolyLinesEx', void, _Vector2, int, float, float, float, _Color), 

    # Basic shapes collision detection functions
    CheckCollisionRecs: ray.define('CheckCollisionRecs', bool, _Rectangle, _Rectangle),                                           
    CheckCollisionCircles: ray.define('CheckCollisionCircles', bool, _Vector2, float, _Vector2, float),        
    CheckCollisionCircleRec: ray.define('CheckCollisionCircleRec', bool, _Vector2, float, _Rectangle),                         
    CheckCollisionPointRec: ray.define('CheckCollisionPointRec', bool, _Vector2, _Rectangle),                                         
    CheckCollisionPointCircle: ray.define('CheckCollisionPointCircle', bool, _Vector2, _Vector2, float),                       
    CheckCollisionPointTriangle: ray.define('CheckCollisionPointTriangle', bool, _Vector2, _Vector2, _Vector2, _Vector2),               
    CheckCollisionPointPoly: ray.define('CheckCollisionPointPoly', bool, _Vector2, _Vector2, int),                      
    CheckCollisionLines: ray.define('CheckCollisionLines', bool, _Vector2, _Vector2, _Vector2, _Vector2, _Vector2), 
    CheckCollisionPointLine: ray.define('CheckCollisionPointLine', bool, _Vector2, _Vector2, _Vector2, int),                
    GetCollisionRec: ray.define('GetCollisionRec', _Rectangle, _Rectangle, _Rectangle),                                         

    /**
     * rtexture
     */
    # Image loading functions
    # NOTE: These functions do not require GPU access
    LoadImage: ray.define('LoadImage', _Image, char_ptr),                                                             
    LoadImageRaw: ray.define('LoadImageRaw', _Image, char_ptr, int, int, int, int),       
    LoadImageAnim: ray.define('LoadImageAnim', _Image, char_ptr, int),                                            
    LoadImageFromMemory: ray.define('LoadImageFromMemory', _Image, char_ptr, char, int),      
    LoadImageFromTexture: ray.define('LoadImageFromTexture', _Image, _Texture2D),                                                     
    LoadImageFromScreen: ray.define('LoadImageFromScreen', _Image, void),                                                                   
    IsImageReady: ray.define('IsImageReady', bool, _Image),                                                                    
    UnloadImage: ray.define('UnloadImage', void, _Image),                                                                     
    ExportImage: ray.define('ExportImage', bool, _Image, char_ptr),                                               
    ExportImageAsCode: ray.define('ExportImageAsCode', bool, _Image, char_ptr),                                         

    # Image generation functions
    GenImageColor: ray.define('GenImageColor', _Image, int, int, _Color),                                           
    GenImageGradientV: ray.define('GenImageGradientV', _Image, int, int, _Color, _Color),                           
    GenImageGradientH: ray.define('GenImageGradientH', _Image, int, int, _Color, _Color),                           
    GenImageGradientRadial: ray.define('GenImageGradientRadial', _Image, int, int, float, _Color, _Color),      
    GenImageChecked: ray.define('GenImageChecked', _Image, int, int, int, int, _Color, _Color),    
    GenImageWhiteNoise: ray.define('GenImageWhiteNoise', _Image, int, int, float),                                     
    GenImagePerlinNoise: ray.define('GenImagePerlinNoise', _Image, int, int, int, int, float),           
    GenImageCellular: ray.define('GenImageCellular', _Image, int, int, int),                                       
    GenImageText: ray.define('GenImageText', _Image, int, int, char_ptr),                                       

    # Image manipulation functions
    ImageCopy: ray.define('ImageCopy', _Image, _Image),                                                                      
    ImageFromImage: ray.define('ImageFromImage', _Image, _Image, _Rectangle),                                                  
    ImageText: ray.define('ImageText', _Image, char_ptr, int, _Color),                                      
    ImageTextEx: ray.define('ImageTextEx', _Image, _Font, char_ptr, float, float, _Color),         
    ImageFormat: ray.define('ImageFormat', void, ptr, int),  # ptr: Image                                                   
    ImageToPOT: ray.define('ImageToPOT', void, ptr, _Color),  # ptr: Image                                                        
    ImageCrop: ray.define('ImageCrop', void, ptr, _Rectangle), # ptr: Image                                                     
    ImageAlphaCrop: ray.define('ImageAlphaCrop', void, ptr, float),   # ptr: Image                                               
    ImageAlphaClear: ray.define('ImageAlphaClear', void, ptr, _Color, float),     # ptr: Image                               
    ImageAlphaMask: ray.define('ImageAlphaMask', void, ptr, _Image),    # ptr: Image                                              
    ImageAlphaPremultiply: ray.define('ImageAlphaPremultiply', void, ptr),   # ptr: Image                                                          
    ImageBlurGaussian: ray.define('ImageBlurGaussian', void, ptr, int),   # ptr: Image                                                
    ImageResize: ray.define('ImageResize', void, ptr, int, int),    # ptr: Image                                     
    ImageResizeNN: ray.define('ImageResizeNN', void, ptr, int,int),     # ptr: Image                                   
    ImageResizeCanvas: ray.define('ImageResizeCanvas', void, ptr, int, int, int, int, _Color),    # ptr: Image
    ImageMipmaps: ray.define('ImageMipmaps', void, ptr),   # ptr: Image                                                                   
    ImageDither: ray.define('ImageDither', void, ptr, int, int, int, int),                            
    ImageFlipVertical: ray.define('ImageFlipVertical', void, ptr),   # ptr: Image                                                              
    ImageFlipHorizontal: ray.define('ImageFlipHorizontal', void, ptr),   # ptr: Image                                                            
    ImageRotateCW: ray.define('ImageRotateCW', void, ptr),   # ptr: Image                                                                 
    ImageRotateCCW: ray.define('ImageRotateCCW', void, ptr),   # ptr: Image                                                                 
    ImageColorTint: ray.define('ImageColorTint', void, ptr, _Color),    # ptr: Image                                                  
    ImageColorInvert: ray.define('ImageColorInvert', void, ptr),   # ptr: Image                                                               
    ImageColorGrayscale: ray.define('ImageColorGrayscale', void, ptr),   # ptr: Image                                                            
    ImageColorContrast: ray.define('ImageColorContrast', void, ptr, float),   # ptr: Image                                             
    ImageColorBrightness: ray.define('ImageColorBrightness', void, ptr, int),   # ptr: Image                                           
    ImageColorReplace: ray.define('ImageColorReplace', void, ptr, _Color, _Color),    # ptr: Image                                
    LoadImageColors: ray.define('LoadImageColors', ptr, ptr),   # ptr: Color, Image                                                               
    LoadImagePalette: ray.define('LoadImagePalette', ptr, ptr, int, int),    # ptr: Color, Image                       
    UnloadImageColors: ray.define('UnloadImageColors', void, ptr),   # ptr: Colors                                                             
    UnloadImagePalette: ray.define('UnloadImagePalette', void, ptr),   # ptr: Colors                                                            
    GetImageAlphaBorder: ray.define('GetImageAlphaBorder', _Rectangle, _Image, float),                                       
    GetImageColor: ray.define('GetImageColor', _Color, _Image, int, int),                                                    

    # Image drawing functions
    # NOTE: Image software-rendering functions (CPU)
    ImageClearBackground: ray.define('ImageClearBackground', void, ptr, _Color),  # ptr: Image                                                
    ImageDrawPixel: ray.define('ImageDrawPixel', void, ptr, int, int, _Color),  # ptr: Image                                  
    ImageDrawPixelV: ray.define('ImageDrawPixelV', void, ptr, _Vector2, _Color),  # ptr: Image                                   
    ImageDrawLine: ray.define('ImageDrawLine', void, ptr, int, int, int, int, _Color),  # ptr: Image 
    ImageDrawLineV: ray.define('ImageDrawLineV', void, ptr, _Vector2, _Vector2, _Color),   # ptr: Image                         
    ImageDrawCircle: ray.define('ImageDrawCircle', void, ptr, int, int, int, _Color),  # ptr: Image               
    ImageDrawCircleV: ray.define('ImageDrawCircleV', void, ptr, _Vector2, int, _Color),   # ptr: Image                       
    ImageDrawCircleLines: ray.define('ImageDrawCircleLines', void, ptr, int, int, int, _Color),    # ptr: Image        
    ImageDrawCircleLinesV: ray.define('ImageDrawCircleLinesV', void, ptr, _Vector2, int, _Color),   # ptr: Image                  
    ImageDrawRectangle: ray.define('ImageDrawRectangle', void, ptr, int, int, int, int, _Color),   # ptr: Image      
    ImageDrawRectangleV: ray.define('ImageDrawRectangleV', void, ptr, _Vector2, _Vector2, _Color),   # ptr: Image                
    ImageDrawRectangleRec: ray.define('ImageDrawRectangleRec', void, ptr, _Rectangle, _Color),   # ptr: Image                               
    ImageDrawRectangleLines: ray.define('ImageDrawRectangleLines', void, ptr, _Rectangle, int, _Color),   # ptr: Image                  
    ImageDraw: ray.define('ImageDraw', void, ptr, _Image, _Rectangle, _Rectangle, _Color),    # ptr: Image           
    ImageDrawText: ray.define('ImageDrawText', void, ptr, char_ptr, int, int, int, _Color),   # ptr: Image  
    ImageDrawTextEx: ray.define('ImageDrawTextEx', void, ptr, _Font, char_ptr, _Vector2, float, float, _Color),   # ptr: Image

    # Texture loading functions
    # NOTE: These functions require GPU access
    LoadTexture: ray.define('LoadTexture', _Texture2D, char_ptr),                                                       
    LoadTextureFromImage: ray.define('LoadTextureFromImage', _Texture2D, _Image),                                                       
    LoadTextureCubemap: ray.define('LoadTextureCubemap', _TextureCubemap, _Image, int),                                        
    LoadRenderTexture: ray.define('LoadRenderTexture', _RenderTexture2D, int, int),                                          
    IsTextureReady: ray.define('IsTextureReady', bool, _Texture2D),                                                            
    UnloadTexture: ray.define('UnloadTexture', void, _Texture2D),                                                             
    IsRenderTextureReady: ray.define('IsRenderTextureReady', bool, _RenderTexture2D),                                                       
    UnloadRenderTexture: ray.define('UnloadRenderTexture', void, _RenderTexture2D),                                                  
    UpdateTexture: ray.define('UpdateTexture', void, _Texture2D, ptr),                                         
    UpdateTextureRec: ray.define('UpdateTextureRec', void, _Texture2D, _Rectangle, ptr),                       

    # Texture configuration functions
    GenTextureMipmaps: ray.define('GenTextureMipmaps', void, ptr),   # ptr: Texture2D                                                        
    SetTextureFilter: ray.define('SetTextureFilter', void, _Texture2D, int),                                              
    SetTextureWrap: ray.define('SetTextureWrap', void, _Texture2D, int),                                                  

    # Texture drawing functions
    DrawTexture: ray.define('DrawTexture', void, _Texture2D, int, int, _Color),                               
    DrawTextureV: ray.define('DrawTextureV', void, _Texture2D, _Vector2, _Color),                                
    DrawTextureEx: ray.define('DrawTextureEx', void, _Texture2D, _Vector2, float, float, _Color),  
    DrawTextureRec: ray.define('DrawTextureRec', void, _Texture2D, _Rectangle, _Vector2, _Color),            
    DrawTexturePro: ray.define('DrawTexturePro', void, _Texture2D, _Rectangle, _Rectangle, _Vector2, float, _Color), 
    DrawTextureNPatch: ray.define('DrawTextureNPatch', void, _Texture2D, _NPatchInfo, _Rectangle, _Vector2, float, _Color), 

    # Color/pixel related functions
    Fade: ray.define('Fade', _Color, _Color, float),                                 
    ColorToInt: ray.define('ColorToInt', int, _Color),                                          
    ColorNormalize: ray.define('ColorNormalize', _Vector4, _Color),                                  
    ColorFromNormalized: ray.define('ColorFromNormalized', _Color, _Vector4),                        
    ColorToHSV: ray.define('ColorToHSV', _Vector3, _Color),                                      
    ColorFromHSV: ray.define('ColorFromHSV', _Color, float, float, float),         
    ColorTint: ray.define('ColorTint', _Color, _Color, _Color),                             
    ColorBrightness: ray.define('ColorBrightness', _Color, _Color, float),                     
    ColorContrast: ray.define('ColorContrast', _Color, _Color, float),                     
    ColorAlpha: ray.define('ColorAlpha', _Color, _Color, float),                           
    ColorAlphaBlend: ray.define('ColorAlphaBlend', _Color, _Color, _Color, _Color),              
    GetColor: ray.define('GetColor', _Color, uint),                                
    GetPixelColor: ray.define('GetPixelColor', _Color, ptr, int),    # ptr: void                      
    SetPixelColor: ray.define('SetPixelColor', void, ptr, _Color, int),    # ptr: void          
    GetPixelDataSize: ray.define('GetPixelDataSize', int, int, int, int),              

    /**
     * rtext
     */
    # Font loading/unloading functions
    GetFontDefault: ray.define('GetFontDefault', _Font),                                                            
    LoadFont: ray.define('LoadFont', _Font, char_ptr),                                                  
    LoadFontEx: ray.define('LoadFontEx', _Font, char_ptr, int, ptr, int),  
    LoadFontFromImage: ray.define('LoadFontFromImage', _Font, _Image, _Color, int),                        
    LoadFontFromMemory: ray.define('LoadFontFromMemory', _Font, char_ptr, uchar_ptr, int, int, ptr, int), 
    IsFontReady: ray.define('IsFontReady', bool, _Font),                                                          
    LoadFontData: ray.define('LoadFontData', ptr, uchar_ptr, int, int, ptr, int, int), # ptr: GlyphInfo, int
    GenImageFontAtlas: ray.define('GenImageFontAtlas', _Image, ptr, ptr, int, int, int, int),  # ptr: GlyphInfo, List<Rectangle>
    UnloadFontData: ray.define('UnloadFontData', void, ptr, int),                                
    UnloadFont: ray.define('UnloadFont', void, _Font),                                                           
    ExportFontAsCode: ray.define('ExportFontAsCode', bool, _Font, char_ptr),                               

    #  Text drawing functions
    DrawFPS: ray.define('DrawFPS', void, int, int),                                                     
    DrawText: ray.define('DrawText', void, char_ptr, int, int, int, _Color),       
    DrawTextEx: ray.define('DrawTextEx', void, _Font, char_ptr, _Vector2, float, float, _Color), 
    DrawTextPro: ray.define('DrawTextPro', void, _Font, char_ptr, _Vector2, _Vector2, float, float, float, _Color), 
    DrawTextCodepoint: ray.define('DrawTextCodepoint', void, _Font, int, _Vector2, float, _Color), 
    DrawTextCodepoints: ray.define('DrawTextCodepoints', void, _Font, ptr, int, _Vector2, float, float, _Color), # ptr: int

    #  Text font info functions
    MeasureText: ray.define('MeasureText', int, char_ptr, int),                                      
    MeasureTextEx: ray.define('MeasureTextEx', _Vector2, _Font, char_ptr, float, float),    
    GetGlyphIndex: ray.define('GetGlyphIndex', int, _Font, int),                                          
    GetGlyphInfo: ray.define('GetGlyphInfo', _GlyphInfo, _Font, int),                                     
    GetGlyphAtlasRec: ray.define('GetGlyphAtlasRec', _Rectangle, _Font, int),                                 

    #  Text codepoints management functions (unicode)
    LoadUTF8: ray.define('LoadUTF8', char_ptr, ptr, int),  # ptr: int              
    UnloadUTF8: ray.define('UnloadUTF8', void, char_ptr),                                      
    LoadCodepoints: ray.define('LoadCodepoints', ptr, char_ptr, ptr),                
    UnloadCodepoints: ray.define('UnloadCodepoints', void, ptr),                           
    GetCodepointCount: ray.define('GetCodepointCount', int, char_ptr),                          
    GetCodepoint: ray.define('GetCodepoint', int, char_ptr, ptr),           
    GetCodepointNext: ray.define('GetCodepointNext', int, char_ptr, ptr),       
    GetCodepointPrevious: ray.define('GetCodepointPrevious', int, char_ptr, ptr),   
    CodepointToUTF8: ray.define('CodepointToUTF8', char_ptr, int, ptr),  # ptr: int       

    #  Text strings management functions (no UTF-8, only byte)
    #  NOTE: Some strings allocate memory internally for returned, just be careful!
    TextCopy: ray.define('TextCopy', int, char_ptr, char_ptr),                                             
    TextIsEqual: ray.define('TextIsEqual', bool, char_ptr, char_ptr),                               
    TextLength: ray.define('TextLength', uint, char_ptr),                                            
    TextSubtext: ray.define('TextSubtext', char_ptr, char_ptr, int, int),                  
    TextReplace: ray.define('TextReplace', char_ptr, char_ptr, char_ptr, char_ptr),                   
    TextInsert: ray.define('TextInsert', char_ptr, char_ptr, char_ptr, int),                 
    TextJoin: ray.define('TextJoin', char_ptr, char_ptr, int, char_ptr),        
    TextSplit: ray.define('TextSplit', ptr, char_ptr, char, ptr),  # ptr: string, int               
    TextAppend: ray.define('TextAppend', void, char_ptr, char_ptr, ptr),                       
    TextFindIndex: ray.define('TextFindIndex', int, char_ptr, char_ptr),                                
    TextToUpper: ray.define('TextToUpper', char_ptr, char_ptr),                      
    TextToLower: ray.define('TextToLower', char_ptr, char_ptr),                      
    TextToPascal: ray.define('TextToPascal', char_ptr, char_ptr),                     
    TextToInteger: ray.define('TextToInteger', int, char_ptr),  

    #  Basic geometric 3D shapes drawing functions
    DrawLine3D: ray.define('DrawLine3D', void, _Vector3, _Vector3, _Color),                                    #  Draw a line in 3D world space
    DrawPoint3D: ray.define('DrawPoint3D', void, _Vector3, _Color),                                                   #  Draw a point in 3D, actually a small line
    DrawCircle3D: ray.define('DrawCircle3D', void, _Vector3, float, _Vector3, float, _Color), #  Draw a circle in 3D world space
    DrawTriangle3D: ray.define('DrawTriangle3D', void, _Vector3, _Vector3, _Vector3, _Color),                              #  Draw a color-filled triangle (vertex in counter-clockwise order!)
    DrawTriangleStrip3D: ray.define('DrawTriangleStrip3D', void, ptr, int, _Color),                            #  Draw a triangle strip defined by points
    DrawCube: ray.define('DrawCube', void, _Vector3, float, float, float, _Color),             #  Draw cube
    DrawCubeV: ray.define('DrawCubeV', void, _Vector3, _Vector3, _Color),                                       #  Draw cube (Vector version)
    DrawCubeWires: ray.define('DrawCubeWires', void, _Vector3, float, float, float, _Color),        #  Draw cube wires
    DrawCubeWiresV: ray.define('DrawCubeWiresV', void, _Vector3, _Vector3, _Color),                                  #  Draw cube wires (Vector version)
    DrawSphere: ray.define('DrawSphere', void, _Vector3, float, _Color),                                     #  Draw sphere
    DrawSphereEx: ray.define('DrawSphereEx', void, _Vector3, float, int, int, _Color),            #  Draw sphere with extended parameters
    DrawSphereWires: ray.define('DrawSphereWires', void, _Vector3, float, int, int, _Color),         #  Draw sphere wires
    DrawCylinder: ray.define('DrawCylinder', void, _Vector3, float, float, float, int, _Color), #  Draw a cylinder/cone
    DrawCylinderEx: ray.define('DrawCylinderEx', void, _Vector3, _Vector3, float, float, int, _Color), #  Draw a cylinder with base at startPos and top at endPos
    DrawCylinderWires: ray.define('DrawCylinderWires', void, _Vector3, float, float, float, int, _Color), #  Draw a cylinder/cone wires
    DrawCylinderWiresEx: ray.define('DrawCylinderWiresEx', void, _Vector3, _Vector3, float, float, int, _Color), #  Draw a cylinder wires with base at startPos and top at endPos
    DrawCapsule: ray.define('DrawCapsule', void, _Vector3, _Vector3, float, int, int, _Color), #  Draw a capsule with the center of its sphere caps at startPos and endPos
    DrawCapsuleWires: ray.define('DrawCapsuleWires', void, _Vector3, _Vector3, float, int, int, _Color), #  Draw capsule wireframe with the center of its sphere caps at startPos and endPos
    DrawPlane: ray.define('DrawPlane', void, _Vector3, _Vector2, _Color),                                      #  Draw a plane XZ
    DrawRay: ray.define('DrawRay', void, _Ray, _Color),                                                                #  Draw a ray line
    DrawGrid: ray.define('DrawGrid', void, int, float),                                                          #  Draw a grid (centered at (0, 0, 0))

    # ------------------------------------------------------------------------------------
    #  Model 3d Loading and Drawing Functions (Module: models)
    # ------------------------------------------------------------------------------------

    #  Model management functions
    LoadModel: ray.define('LoadModel', _Model, char_ptr),                                                #  Load model from files (meshes and materials)
    LoadModelFromMesh: ray.define('LoadModelFromMesh', _Model, _Mesh),                                                   #  Load model from generated mesh (default material)
    IsModelReady: ray.define('IsModelReady', bool, _Model),                                                       #  Check if a model is ready
    UnloadModel: ray.define('UnloadModel', void, _Model),                                                        #  Unload model (including meshes) from memory (RAM and/or VRAM)
    GetModelBoundingBox: ray.define('GetModelBoundingBox', _BoundingBox, _Model),                                         #  Compute model bounding box limits (considers all meshes)

    #  Model drawing functions
    DrawModel: ray.define('DrawModel', void, _Model, _Vector3, float, _Color),               #  Draw a model (with texture if set)
    DrawModelEx: ray.define('DrawModelEx', void, _Model, _Vector3, _Vector3, float, _Vector3, _Color), #  Draw a model with extended parameters
    DrawModelWires: ray.define('DrawModelWires', void, _Model, _Vector3, float, _Color),          #  Draw a model wires (with texture if set)
    DrawModelWiresEx: ray.define('DrawModelWiresEx', void, _Model, _Vector3, _Vector3, float, _Vector3, _Color), #  Draw a model wires (with texture if set) with extended parameters
    DrawBoundingBox: ray.define('DrawBoundingBox', void, _BoundingBox, _Color),                                   #  Draw bounding box (wires)
    DrawBillboard: ray.define('DrawBillboard', void, _Camera, _Texture2D, _Vector3, float, _Color),   #  Draw a billboard texture
    DrawBillboardRec: ray.define('DrawBillboardRec', void, _Camera, _Texture2D, _Rectangle, _Vector3, _Vector2, _Color), #  Draw a billboard texture defined by source
    DrawBillboardPro: ray.define('DrawBillboardPro', void, _Camera, _Texture2D, _Rectangle, _Vector3, _Vector3, _Vector2, _Vector2, float, _Color), #  Draw a billboard texture defined by source and rotation

    #  Mesh management functions
    UploadMesh: ray.define('UploadMesh', void, ptr, bool),                                            #  Upload mesh vertex data in GPU and provide VAO/VBO ids
    UpdateMeshBuffer: ray.define('UpdateMeshBuffer', void, _Mesh, int, ptr, int, int), #  Update mesh vertex data in GPU for a specific buffer index
    UnloadMesh: ray.define('UnloadMesh', void, _Mesh),                                                           #  Unload mesh data from CPU and GPU
    DrawMesh: ray.define('DrawMesh', void, _Mesh, _Material, _Matrix),                        #  Draw a 3d mesh with material and transform
    DrawMeshInstanced: ray.define('DrawMeshInstanced', void, _Mesh, _Material, ptr, int), #  Draw multiple mesh instances with material and different transforms
    ExportMesh: ray.define('ExportMesh', bool, _Mesh, char_ptr),                                     #  Export mesh data to, returns true on success
    GetMeshBoundingBox: ray.define('GetMeshBoundingBox', _BoundingBox, _Mesh),                                            #  Compute mesh bounding box limits
    GenMeshTangents: ray.define('GenMeshTangents', void, ptr),                                                     #  Compute mesh tangents

    # #  Mesh generation functions
    GenMeshPoly: ray.define('GenMeshPoly', _Mesh, int, float),                                            #  Generate polygonal mesh
    GenMeshPlane: ray.define('GenMeshPlane', _Mesh, float, float, int, int),                     #  Generate plane mesh (with subdivisions)
    GenMeshCube: ray.define('GenMeshCube', _Mesh, float, float, float),                            #  Generate cuboid mesh
    GenMeshSphere: ray.define('GenMeshSphere', _Mesh, float, int, int),                              #  Generate sphere mesh (standard sphere)
    GenMeshHemiSphere: ray.define('GenMeshHemiSphere', _Mesh, float, int, int),                          #  Generate half-sphere mesh (no bottom cap)
    GenMeshCylinder: ray.define('GenMeshCylinder', _Mesh, float, float, int),                         #  Generate cylinder mesh
    GenMeshCone: ray.define('GenMeshCone', _Mesh, float, float, int),                             #  Generate cone/pyramid mesh
    GenMeshTorus: ray.define('GenMeshTorus', _Mesh, float, float, int, int),                   #  Generate torus mesh
    GenMeshKnot: ray.define('GenMeshKnot', _Mesh, float, float, int, int),                    #  Generate trefoil knot mesh
    GenMeshHeightmap: ray.define('GenMeshHeightmap', _Mesh, _Image, _Vector3),                                 #  Generate heightmap mesh from image data
    GenMeshCubicmap: ray.define('GenMeshCubicmap', _Mesh, _Image, _Vector3),                               #  Generate cubes-based map mesh from image data

    # #  Material loading/unloading functions
    LoadMaterials: ray.define('LoadMaterials', ptr, char_ptr, ptr),                    #  Load materials from model file
    LoadMaterialDefault: ray.define('LoadMaterialDefault', _Material, void),                                                   #  Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
    IsMaterialReady: ray.define('IsMaterialReady', bool, _Material),                                              #  Check if a material is ready
    UnloadMaterial: ray.define('UnloadMaterial', void, _Material),                                               #  Unload material from GPU memory (VRAM)
    SetMaterialTexture: ray.define('SetMaterialTexture', void, ptr, int, _Texture2D),          #  Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
    SetModelMeshMaterial: ray.define('SetModelMeshMaterial', void, ptr, int, int),                  #  Set material for a mesh

    # #  Model animations loading/unloading functions
    LoadModelAnimations: ray.define('LoadModelAnimations', ptr, char_ptr, ptr),   #  Load model animations from file
    UpdateModelAnimation: ray.define('UpdateModelAnimation', void, _Model, _ModelAnimation, int),               #  Update model animation pose
    UnloadModelAnimation: ray.define('UnloadModelAnimation', void, _ModelAnimation),                                       #  Unload animation data
    UnloadModelAnimations: ray.define('UnloadModelAnimations', void, ptr, int),           #  Unload animation array data
    IsModelAnimationValid: ray.define('IsModelAnimationValid', bool, _Model, _ModelAnimation),                         #  Check model animation skeleton match

    # #  Collision detection functions
    CheckCollisionSpheres: ray.define('CheckCollisionSpheres', bool, _Vector3, float, _Vector3, float),   #  Check collision between two spheres
    CheckCollisionBoxes: ray.define('CheckCollisionBoxes', bool, _BoundingBox, _BoundingBox),                                 #  Check collision between two bounding boxes
    CheckCollisionBoxSphere: ray.define('CheckCollisionBoxSphere', bool, _BoundingBox, _Vector3, float),                  #  Check collision between box and sphere
    GetRayCollisionSphere: ray.define('GetRayCollisionSphere', _RayCollision, _Ray, _Vector3, float),                    #  Get collision info between ray and sphere
    GetRayCollisionBox: ray.define('GetRayCollisionBox', _RayCollision, _Ray, _BoundingBox),                                    #  Get collision info between ray and box
    GetRayCollisionMesh: ray.define('GetRayCollisionMesh', _RayCollision, _Ray, _Mesh, _Matrix),                       #  Get collision info between ray and mesh
    GetRayCollisionTriangle: ray.define('GetRayCollisionTriangle', _RayCollision, _Ray, _Vector3, _Vector3, _Vector3),            #  Get collision info between ray and triangle
    GetRayCollisionQuad: ray.define('GetRayCollisionQuad', _RayCollision, _Ray, _Vector3, _Vector3, _Vector3, _Vector3),    #  Get collision info between ray and quad

    # ----------------------------------------------------------------
    # Math functions (raymath.h)
    # ----------------------------------------------------------------
    math: {
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

  return lib
}

