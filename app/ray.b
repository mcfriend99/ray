import clib { * }
import struct as st
import .constants { * }
import reflect
import os

var _bin_path = os.join_paths(os.dir_name(os.dir_name(__file__)), 'bin', 'libraylib')
var _machine_type = os.platform == 'windows' ? 'x86_64' : os.info().machine
var _ptr_type = 'Q'


# -------------------------------------------------------------
# RAYLIB TYPES
# -------------------------------------------------------------

# struct types
var Vector2Type = named_struct({
  x: float,
  y: float,
})
def DeVector2(v) {
  return get(Vector2Type, v)
}

var Vector3Type = named_struct({
  x: float,
  y: float,
  z: float,
})
def DeVector3(v) {
  return get(Vector3Type, v)
}

var Vector4Type = named_struct({
  x: float,
  y: float,
  z: float,
  w: float,
})
def DeVector4(v) {
  return get(Vector4Type, v)
}
var QuaternionType = Vector4Type
var DeQuaternion = DeVector4

var MatrixType = named_struct({
  m0: float, m4: float, m8:  float, m12: float,
  m1: float, m5: float, m9:  float, m13: float,
  m2: float, m6: float, m10: float, m14: float,
  m3: float, m7: float, m11: float, m15: float,
})
def DeMatrix(v) {
  return get(MatrixType, v)
}

var ColorType = named_struct({
  r: uchar,
  g: uchar,
  b: uchar,
  a: uchar,
})
def DeColor(v) {
  return get(ColorType, v)
}

var RectangleType = named_struct({
  x:      float,
  y:      float,
  width:  float,
  height: float,
})
def DeRectangle(v) {
  return get(RectangleType, v)
}

var ImageType = named_struct({
  data:     ptr,
  width:    int,
  height:   int,
  mipmaps:  int,
  format:   int,
})
def DeImage(v) {
  return get(ImageType, v)
}

var TextureType = named_struct({
  id:       uint,
  width:    int,
  height:   int,
  mipmaps:  int,
  format:   int,
})
def DeTexture(v) {
  return get(TextureType, v)
}
var Texture2DType = TextureType
var TextureCubemapType = TextureType
var DeTexture2D = DeTexture, DeTextureCubemap = DeTexture

var RenderTextureType = named_struct({
  id:       uint,
  texture:  TextureType,
  depth:    TextureType,
})
def DeRenderTexture(v) {
  var res = get(RenderTextureType, v)
  res.texture = get(TextureType, res.texture)
  res.depth = get(TextureType, res.depth)
  return res
}
var RenderTexture2DType = RenderTextureType
var DeRenderTexture2D = DeRenderTexture

var NPatchInfoType = named_struct({
  source: RectangleType,
  left:   int,
  top:    int,
  right:  int,
  bottom: int,
  layout: int,
})
def DeNPatchInfo(v) {
  var res = get(NPatchInfoType, v)
  res.source = get(RectangleType, res.source)
  return res
}

var GlyphInfoType = named_struct({
  value:    int,
  offsetX:  int,
  offsetY:  int,
  advanceX: int,
  image:    ImageType,
})
def DeGlyphInfo(x) {
  var res = get(GlyphInfoType, v)
  res.image = get(ImageType, res.image)
  return res
}

var FontType = named_struct({
  baseSize:     int,
  glyphCount:   int,
  glyphPadding: int,
  texture:      Texture2DType,
  recs:         ptr,
  glyphs:       ptr,
})
def DeFont(v) {
  var res = get(FontType, v)
  res.texture = get(TextureType, res.texture)
  return res
}

var Camera2DType = named_struct({
  offset:     Vector2Type,
  target:     Vector2Type,
  rotatioon:  float,
  zoom:       float,
})
def DeCamera2D(v) {
  var res = get(Camera2DType, v)
  res.offset = get(Vector2Type, res.offset)
  res.target = get(Vector2Type, res.target)
  return res
}

var Camera3DType = named_struct({
  position:   Vector3Type,
  target:     Vector3Type,
  up:         Vector3Type,
  fovy:       float,
  projection: int,
})
def DeCamera3D(v) {
  var res = get(Camera3DType, v)
  res.position = get(Vector3Type, res.position)
  res.target = get(Vector3Type, res.target)
  res.up = get(Vector3Type, res.up)
  return res
}
var CameraType = Camera3DType
var DeCamera = DeCamera3D

var MeshType = named_struct({
  vertexCount:    int,
  triangleCount:  int,
  vertices:       ptr,
  texcoords:      ptr,
  texcoords2:     ptr,
  normals:        ptr,
  tangents:       ptr,
  colors:         ptr,
  indices:        ptr,
  animVertices:   ptr,
  animNormals:    ptr,
  boneIds:        ptr,
  boneWeights:    ptr,
  vaoId:          uint,
  vboId:          ptr,
})
def DeMesh(v) {
  return get(MeshType, v)
}

var ShaderType = named_struct({
  id:   uint,
  locs: ptr,
})
def DeShader(v) {
  return get(ShaderType, v)
}

var MaterialMapType = named_struct({
  texture:  Texture2DType,
  color:    ColorType,
  value:    float,
})
def DeMaterialMap(v) {
  var res = get(MaterialMapType, v)
  res.texture = get(Texture2DType, res.texture)
  res.color = get(ColorType, res.color)
  return res
}

# only used by Material, VrStereoConfig and VrDeviceInfo so far...
var float2Type = struct(float, float)
var float4Type = struct(float, float, float, float)
var Matrix2Type = struct(MatrixType, MatrixType)
def DeMatrix2(v) {
  var res = get(Matrix2Type, v)
  res[0] = get(MatrixType, res[0])
  res[1] = get(MatrixType, res[1])
  return res
}

var MaterialType = named_struct({
  shader: ShaderType,
  maps:   ptr,
  params: float4Type,
})
def DeMaterial(v) {
  var res = get(MaterialType, v)
  res.shader = get(ShaderType, res.shader)
  res.params = get(float4Type, res.params)
  return res
}

var float3Type = struct(
  float,
  float,
  float
)
def Defloat3(v) {
  return get(float3Type, v)
}

var float16Type = struct(
  float, float, float, float,
  float, float, float, float,
  float, float, float, float
)
def Defloat16(v) {
  return get(float16Type, v)
}

var TransformType = named_struct({
  translation:  Vector3Type,
  rotation:     QuaternionType,
  scale:        Vector3Type,
})
def DeTransform(v) {
  var res = get(TransformType, v)
  res.translation = get(Vector3Type, res.translation)
  res.rotation = get(QuaternionType, res.rotation)
  res.scale = get(Vector3Type, res.scale)
  return res
}

var _c32 = struct(
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char,
  char, char, char, char, char, char, char, char
)
var BoneInfoType = named_struct({
  name: _c32,
  'parent': int,
})
def DeBoneInfo(v) {
  var res = get(BoneInfoType, v)
  res.name = get(_c32, res.name)
  return res
}

var ModelType = named_struct({
  transform:      MatrixType,
  meshCount:      int,
  materialCount:  int,
  meshes:         ptr,
  materials:      ptr,
  meshMaterial:   ptr,
  boneCount:      int,
  bones:          ptr,
  bindPose:       ptr,
})
def DeModel(v) {
  var res = get(ModelType, v)
  res.transform = get(MatrixType, res.transform)
  return res
}

var ModelAnimationType = named_struct({
  boneCount:  int,
  frameCount: int,
  bones:      ptr,
  framePoses: ptr,
})
def DeModelAnimation(v) {
  return get(ModelAnimationType, v)
}

var RayType = named_struct({
  postition: Vector3Type,
  direction: Vector3Type,
})
def DeRay(v) {
  var res = get(RayType, v)
  res.postition = get(Vector3Type, res.postition)
  res.direction = get(Vector3Type, res.direction)
  return res
}

var RayCollisionType = named_struct({
  hit:      bool,
  distance: float,
  point:    Vector3Type,
  normal:   Vector3Type  # point
})
def DeRayCollision(v) {
  var res = get(RayCollisionType, v)
  res.point = get(Vector3Type, res.point)
  res.normal = get(Vector3Type, res.normal)
  return res
}

var BoundingBoxType = named_struct({
  min: Vector3Type,
  max: Vector3Type,
})
def DeBoundingBox(v) {
  var res = get(BoundingBoxType, v)
  res.min = get(Vector3Type, res.min)
  res.normal = get(Vector3Type, res.normal)
  return res
}

var WaveType = named_struct({
  frameCount: uint,
  sampleRate: uint,
  sampleSize: uint,
  channels:   uint,
  data:       ptr,
})
def DeWave(v) {
  return get(WaveType, v)
}

var AudioStreamType = named_struct({
  buffer:     ptr,
  processor:  ptr,
  sampleRate: uint,
  sampleSize: uint,
  channels:   uint,
})
def DeAudioStream(v) {
  return get(AudioStreamType, v)
}

var SoundType = named_struct({
  stream: AudioStreamType,
  frameCount: uint,
})
def DeSound(v) {
  var res = get(SoundType, v)
  res.stream = get(AudioStreamType, res.stream)
  return res
}

var MusicType = named_struct({
  stream: AudioStreamType,
  frameCount: uint,
  looping: bool,
  ctxType: int,
  ctxData: ptr,
})
def DeMusic(v) {
  var res = get(MusicType, v)
  res.stream = get(AudioStreamType, res.stream)
  return res
}

var VrDeviceInfoType = named_struct({
  hResolution:            int,                
  vResolution:            int,                
  hScreenSize:            float,              
  vScreenSize:            float,              
  vScreenCenter:          float,            
  eyeToScreenDistance:    float,      
  lensSeparationDistance: float,   
  interpupillaryDistance: float,   
  lensDistortionValues:   float4Type,  
  chromaAbCorrection:     float4Type,    
})
def DeVrDeviceInfo(v) {
  var res = get(VrDeviceInfoType, v)
  res.lensDistortionValues = get(float4Type, res.lensDistortionValues)
  res.chromaAbCorrection = get(float4Type, res.chromaAbCorrection)
  return res
}

var VrStereoConfigType = named_struct({
  projection:         Matrix2Type,           
  viewOffset:         Matrix2Type,           
  leftLensCenter:     float2Type,        
  rightLensCenter:    float2Type,       
  leftScreenCenter:   float2Type,      
  rightScreenCenter:  float2Type,     
  scale:              float2Type,                 
  scaleIn:            float2Type,               
})
def DeVrStereoConfig(v) {
  var res = get(VrStereoConfigType, v)
  res.projection = get(Matrix2Type, res.projection)
  res.viewOffset = get(Matrix2Type, res.viewOffset)
  res.leftLensCenter = get(float2Type, res.leftLensCenter)
  res.rightLensCenter = get(float2Type, res.rightLensCenter)
  res.leftScreenCenter = get(float2Type, res.leftScreenCenter)
  res.rightScreenCenter = get(float2Type, res.rightScreenCenter)
  res.scale = get(float2Type, res.scale)
  res.scaleIn = get(float2Type, res.scaleIn)
  return res
}

var FilePathListType = named_struct({
  capacity: uint,
  count:    uint,
  paths:    ptr,
})
def DeFilePathList(v) {
  return get(FilePathListType, v)
}

# -------------------------------------------------------------
# DECLARATIONS
# -------------------------------------------------------------

/**
 * Structs
 */
def Vector2(x, y) {
  return new(Vector2Type, x, y)
}

def Vector3(x, y, z) {
  return new(Vector3Type, x, y, z)
}

def Vector4(x, y, z, w) {
  return new(Vector4Type, x, y, z, w)
}

# Quaternion, 4 components (Vector4 alias)
var Quaternion = Vector4

def Matrix(
  m0, m4, m8, m12,
  m1, m5, m9, m13,
  m2, m6, m10, m14,
  m3, m7, m11, m15
) {
  return new(MatrixType, 
    m0, m4, m8, m12,
    m1, m5, m9, m13,
    m2, m6, m10, m14,
    m3, m7, m11, m15
  )
}

def Color(r, g, b, a) {
  return new(ColorType, r, g, b, a)
}

def Rectangle(x, y, width, height) {
  return new(RectangleType, x, y, width, height)
}

def Image(data, width, height, mipmaps, format) {
  return new(ImageType, reflect.get_address(data), width, height, mipmaps, format)
}

def Texture(id, width, height, mipmaps, format) {
  return new(TextureType, id, width, height, mipmaps, format)
}

# Texture2D, same as Texture
var Texture2D = Texture
# TextureCubemap, same as Texture
var TextureCubemap = Texture

def RenderTexture(id, texture, depth) {
  return new(RenderTextureType, id, texture, depth)
}

# RenderTexture2D, same as RenderTexture
var RenderTexture2D = RenderTexture

def NPatchInfo(source, left, top, right, bottom, layout) {
  return new(NPatchInfoType, source, left, top, right, bottom, layout)
}

def GlyphInfo(value, offsetX, offsetY, advanceX, image) {
  return new(GlyphInfoType, value, offsetX, offsetY, advanceX, image)
}

def Camera2D(offset, target, rotation, zoom) {
  return new(Camera2DType, offset, target, rotation, zoom)
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

  return new(FontType, baseSize, glyphCount, glyptPadding, texture, reflect.get_address(recs_st), reflect.get_address(glyphs_st))
}

def Camera3D(position, target, up, fovy, projection) {
  return new(Camera3DType, position, target, up, fovy, projection)
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
  return new(
    MeshType, 
    vertexCount, 
    triangleCount, 
    reflect.get_address(vertices), 
    reflect.get_address(texcoords), 
    reflect.get_address(texcoords2), 
    reflect.get_address(normals), 
    reflect.get_address(tangents), 
    reflect.get_address(colors), 
    reflect.get_address(indices), 
    reflect.get_address(animVertices), 
    reflect.get_address(animNormals), 
    reflect.get_address(boneIds), 
    reflect.get_address(boneWeights), 
    vaoId, 
    reflect.get_address(vboId)
  )
}

def Shader(id, locs) {
  return new(ShaderType, id, reflect.get_address(locs))
}

def MaterialMap(texture, color, value) {
  return new(MaterialMapType, texture, color, value)
}

def Material(shader, maps, params) {
  if !is_list(params) params = to_list(params)
  if params.length() < 4 
    params.extend([0] * (4 - params.length()))
  return new(MaterialType, shader, reflect.get_address(maps), params)
}

def float2(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 2 {
    floats.extend([0] * (2 - floats.length()))
  }
  return new(float2Type, floats)
}

def float3(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 3 {
    floats.extend([0] * (3 - floats.length()))
  }
  return new(float3Type, floats)
}

def float4(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 4 {
    floats.extend([0] * (4 - floats.length()))
  }
  return new(float4Type, floats)
}

def float16(floats) {
  if !is_list(floats) floats = to_list(floats)
  if floats.length() < 16 {
    floats.extend([0] * (16 - floats.length()))
  }
  return new(float16Type, floats)
}

def BoneInfo(name, paren) {
  if !is_list(name) params = to_list(name)
  if name.length() < 32 {
    name.extend([0] * (16 - name.length()))
  }
  return new(BoneInfoType, name, paren)
}

def Transform(translation, rotation, scale) {
  return new(TransformType, translation, rotation, scale)
}

def Model(
  transform, meshCount, materialCount, meshes, 
  materials, meshMaterial, boneCount, bones, bindPose
) {
  return new(ModelType,
    transform, meshCount, materialCount, reflect.get_address(meshes), 
    reflect.get_address(materials), reflect.get_address(meshMaterial), 
    boneCount, reflect.get_address(bones), reflect.get_address(bindPose)
  )
}

def ModelAnimation(boneCount, frameCount, bones, framePoses) {
  return new(ModelAnimationType, boneCount, frameCount, reflect.get_address(bones), reflect.get_address(framePoses))
}

def Ray(position, direction) {
  return new(RayType, position, direction)
}

def RayCollision(hit, distance, point, normal) {
  return new(RayCollisionType, hit, distance, point, normal)
}

def BoundingBox(min, max) {
  return new(BoundingBoxType, min, max)
}

def Wave(frameCount, sampleRate, sampleSize, channels, data) {
  return new(WaveType, frameCount, sampleRate, sampleSize, channels, reflect.get_address(data))
}

def AudioStream(buffer, processor, sampleRate, sampleSize, channels) {
  return new(AudioStreamType, reflect.get_address(buffer), reflect.get_address(processor), sampleRate, sampleSize, channels)
}

def Sound(stream, frameCount) {
  return new(SoundType, stream, frameCount)
}

def Music(stream, frameCount, looping, ctxType, ctxData) {
  return new(MusicType, stream, frameCount, looping, ctxType, reflect.get_address(ctxData))
}

def VrDeviceInfo(
  hResolution,
  vResolution,
  hScreenSize,
  vScreenSize,
  vScreenCenter,
  eyeToScreenDistance,
  lensSeparationDistance,
  interpupillaryDistance,
  lensDistortionValues,
  chromaAbCorrection
) {
  return new(
    VrDeviceInfoType, 
    hResolution,
    vResolution,
    hScreenSize,
    vScreenSize,
    vScreenCenter,
    eyeToScreenDistance,
    lensSeparationDistance,
    interpupillaryDistance,
    lensDistortionValues,
    chromaAbCorrection
  )
}

def VrStereoConfig(
  projection,
  viewOffset,
  leftLensCenter,
  rightLensCenter,
  leftScreenCenter,
  rightScreenCenter,
  scale,
  scaleIn
) {
  return new(
    VrStereoConfigType,
    projection,
    viewOffset,
    leftLensCenter,
    rightLensCenter,
    leftScreenCenter,
    rightScreenCenter,
    scale,
    scaleIn
  )
}

def FilePathList(capacity, count, paths) {
  return new(FilePathListType, capacity, count, paths)
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


# -----------------------------------------------------
# DEFINITIONS
# -----------------------------------------------------
var PI = 3.14159265358979323846
var DEG2RAD = PI/180
var RAD2DEG = 180/PI


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
      curr_env += os.join_paths(os.dir_name(os.dir_name(__file__)), 'bin') + ';'
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
    SetWindowIcon: ray.define('SetWindowIcon', void, ImageType),
    SetWindowIcons: ray.define('SetWindowIcons', ptr, int),
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
    GetMonitorPosition: ray.define('GetMonitorPosition', uchar_ptr, int),
    GetMonitorWidth: ray.define('GetMonitorWidth', int, int),
    GetMonitorHeight: ray.define('GetMonitorHeight', int, int),
    GetMonitorPhysicalWidth: ray.define('GetMonitorPhysicalWidth', int, int),
    GetMonitorPhysicalHeight: ray.define('GetMonitorPhysicalHeight', int, int),
    GetMonitorRefreshRate: ray.define('GetMonitorRefreshRate', int, int),
    GetWindowPosition: ray.define('GetWindowPosition', uchar_ptr),
    GetWindowScaleDPI: ray.define('GetWindowScaleDPI', uchar_ptr),
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
    ClearBackground: ray.define('ClearBackground', void, ColorType),
    BeginDrawing: ray.define('BeginDrawing', void),
    EndDrawing: ray.define('EndDrawing', void),
    BeginMode2D: ray.define('BeginMode2D', void, Camera2DType),
    EndMode2D: ray.define('EndMode2D', void),
    BeginMode3D: ray.define('BeginMode3D', void, Camera3DType),
    EndMode3D: ray.define('EndMode3D', void),
    BeginTextureMode: ray.define('BeginTextureMode', void, RenderTextureType),
    EndTextureMode: ray.define('EndTextureMode', void),
    BeginShaderMode: ray.define('BeginShaderMode', void, ShaderType),
    EndShaderMode: ray.define('EndShaderMode', void),
    BeginBlendMode: ray.define('BeginBlendMode', void, int),
    EndBlendMode: ray.define('EndBlendMode', void),
    BeginScissorMode: ray.define('BeginScissorMode', void, int, int, int, int),
    EndScissorMode: ray.define('EndScissorMode', void),
    BeginVrStereoMode: ray.define('BeginVrStereoMode', void, VrStereoConfigType),
    EndVrStereoMode: ray.define('EndVrStereoMode', void),

    # VR stereo config functions for VR simulator
    LoadVrStereoConfig: ray.define('LoadVrStereoConfig', VrStereoConfigType, VrDeviceInfoType),
    UnloadVrStereoConfig: ray.define('UnloadVrStereoConfig', void, VrStereoConfigType),

    # Shader management functions
    LoadShader: ray.define('LoadShader', ShaderType, char_ptr, char_ptr),
    LoadShaderFromMemory: ray.define('LoadShaderFromMemory', ShaderType, char_ptr, char_ptr),
    IsShaderReady: ray.define('IsShaderReady', bool, ShaderType),
    GetShaderLocation: ray.define('GetShaderLocation', int, ShaderType, char_ptr),
    GetShaderLocationAttrib: ray.define('GetShaderLocationAttrib', int, ShaderType, char_ptr),
    SetShaderValue: ray.define('SetShaderValue', void, ShaderType, int, ptr, int),
    SetShaderValueV: ray.define('SetShaderValueV', void, ShaderType, int, ptr, int, int),
    SetShaderValueMatrix: ray.define('SetShaderValueMatrix', void, ShaderType, MatrixType),
    SetShaderValueTexture: ray.define('SetShaderValueTexture', void, ShaderType, Texture2DType),
    UnloadShader: ray.define('UnloadShader', void, ShaderType),

    # Screen-space-related functions
    GetMouseRay: ray.define('GetMouseRay', RayType, Vector2Type, Camera3DType),
    GetCameraMatrix: ray.define('GetCameraMatrix', MatrixType, CameraType),
    GetCameraMatrix2D: ray.define('GetCameraMatrix2D', MatrixType, Camera2DType),
    GetWorldToScreen: ray.define('GetWorldToScreen', Vector2Type, Vector3Type, Camera3DType),
    GetScreenToWorld2D: ray.define('GetScreenToWorld2D', Vector2Type, Vector2Type, Camera2DType),
    GetWorldToScreenEx: ray.define('GetWorldToScreenEx', Vector2Type, Vector3Type, Camera3DType, int, int),
    GetWorldToScreen2D: ray.define('GetWorldToScreen2D', Vector2Type, Vector2Type, Camera2DType),

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

    # Files management functions
    IsFileDropped: ray.define('IsFileDropped', bool),
    LoadDroppedFiles: ray.define('LoadDroppedFiles', FilePathListType),
    UnloadDroppedFiles: ray.define('UnloadDroppedFiles', void, FilePathListType),


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
    GetMousePosition: ray.define('GetMousePosition', Vector2Type),
    GetMouseDelta: ray.define('GetMouseDelta', Vector2Type),
    SetMousePosition: ray.define('SetMousePosition', void, int, int),
    SetMouseOffset: ray.define('SetMouseOffset', void, int, int),
    SetMouseScale: ray.define('SetMouseScale', void, int, int),
    GetMouseWheelMove: ray.define('GetMouseWheelMove', float),
    GetMouseWheelMoveV: ray.define('GetMouseWheelMoveV', Vector2Type),
    SetMouseCursor: ray.define('SetMouseCursor', void, int),

    # Input-related functions: touch
    GetTouchX: ray.define('GetTouchX', int),
    GetTouchY: ray.define('GetTouchY', int),
    GetTouchPosition: ray.define('GetTouchPosition', Vector2Type, int),
    GetTouchPointId: ray.define('GetTouchPointId', int, int),
    GetTouchPointCount: ray.define('GetTouchPointCount', int),


    # ------------------------------------------------------------------------------------
    #  Gestures and Touch Handling Functions (Module: rgestures)
    # ------------------------------------------------------------------------------------
    SetGesturesEnabled: ray.define('SetGesturesEnabled', void, uint),
    IsGestureDetected: ray.define('IsGestureDetected', bool, uint),
    GetGestureDetected: ray.define('GetGestureDetected', int),
    GetGestureHoldDuration: ray.define('GetGestureHoldDuration', float),
    GetGestureDragVector: ray.define('GetGestureDragVector', Vector2Type),
    GetGestureDragAngle: ray.define('GetGestureDragAngle', float),
    GetGesturePinchVector: ray.define('GetGesturePinchVector', Vector2Type),
    GetGesturePinchAngle: ray.define('GetGesturePinchAngle', float),


    # ------------------------------------------------------------------------------------
    #  Camera System Functions (Module: rcamera)
    # ------------------------------------------------------------------------------------
    UpdateCamera: ray.define('UpdateCamera', void, ptr, int),
    UpdateCameraPro: ray.define('UpdateCamera', void, ptr, Vector3Type, Vector3Type, int),

    /**
     * rshapes
     */
    SetShapesTexture: ray.define('SetShapesTexture', void, TextureType, RectangleType),
    # Basic shape drawing functions
    DrawPixel: ray.define('DrawPixel', void, int, int, ColorType),
    DrawPixelV: ray.define('DrawPixelV', void, Vector2Type, ColorType),
    DrawLine: ray.define('DrawLine', void, int, int, int, int, ColorType),
    DrawLineV: ray.define('DrawLineV', void, Vector2Type, Vector2Type, ColorType),
    DrawLineEx: ray.define('DrawLineEx', void, Vector2Type, Vector2Type, float, ColorType),
    DrawLineBezier: ray.define('DrawLineBezier', void, Vector2Type, Vector2Type, float, ColorType),
    DrawLineBezierQuad: ray.define('DrawLineBezierQuad', void, Vector2Type, Vector2Type, Vector2Type, float, ColorType),
    DrawLineBezierCubic: ray.define('DrawLineBezierCubic', void, Vector2Type, Vector2Type, Vector2Type, Vector2Type, float, ColorType),
    DrawLineStrip: ray.define('DrawLineStrip', void, Vector2Type, int, ColorType),
    DrawCircle: ray.define('DrawCircle', void, int, int, float, ColorType),
    DrawCircleSector: ray.define('DrawCircleSector', void, Vector2Type, float, float, float, int, ColorType),
    DrawCircleSectorLines: ray.define('DrawCircleSectorLines', void, Vector2Type, float, float, float, int, ColorType),
    DrawCircleGradient: ray.define('DrawCircleGradient', void, int, int, float, ColorType, ColorType),
    DrawCircleV: ray.define('DrawCircleV', void, Vector2Type, float, ColorType),
    DrawCircleLines: ray.define('DrawCircleLines', void, int, int, float, ColorType),
    DrawEllipse: ray.define('DrawEllipse', void, int, int, float, float, ColorType),
    DrawEllipseLines: ray.define('DrawEllipseLines', void, int, int, float, float, ColorType),
    DrawRing: ray.define('DrawRing', void, Vector2Type, float, float, float, float, int, ColorType),
    DrawRingLines: ray.define('DrawRingLines', void, Vector2Type, float, float, float, float, int, ColorType),
    DrawRectangle: ray.define('DrawRectangle', void, int, int, int, int, ColorType),                        
    DrawRectangleV: ray.define('DrawRectangleV', void, Vector2Type, Vector2Type, ColorType),                                  
    DrawRectangleRec: ray.define('DrawRectangleRec', void, RectangleType, ColorType),                                                 
    DrawRectanglePro: ray.define('DrawRectanglePro', void, RectangleType, Vector2Type, float, ColorType),                 
    DrawRectangleGradientV: ray.define('DrawRectangleGradientV', void, int, int, int, int, ColorType, ColorType),
    DrawRectangleGradientH: ray.define('DrawRectangleGradientH', void, int, int, int, int, ColorType, ColorType),
    DrawRectangleGradientEx: ray.define('DrawRectangleGradientEx', void, RectangleType, ColorType, ColorType, ColorType, ColorType),       
    DrawRectangleLines: ray.define('DrawRectangleLines', void, int, int, int, int, ColorType),                   
    DrawRectangleLinesEx: ray.define('DrawRectangleLinesEx', void, RectangleType, float, ColorType),                            
    DrawRectangleRounded: ray.define('DrawRectangleRounded', void, RectangleType, float, int, ColorType),              
    DrawRectangleRoundedLines: ray.define('DrawRectangleRoundedLines', void, RectangleType, float, int, float, ColorType), 
    DrawTriangle: ray.define('DrawTriangle', void, Vector2Type, Vector2Type, Vector2Type, ColorType),                                
    DrawTriangleLines: ray.define('DrawTriangleLines', void, Vector2Type, Vector2Type, Vector2Type, ColorType),                           
    DrawTriangleFan: ray.define('DrawTriangleFan', void, Vector2Type, int, ColorType),                                
    DrawTriangleStrip: ray.define('DrawTriangleStrip', void, Vector2Type, int, ColorType),                              
    DrawPoly: ray.define('DrawPoly', void, Vector2Type, int, float, float, ColorType),               
    DrawPolyLines: ray.define('DrawPolyLines', void, Vector2Type, int, float, float, ColorType),          
    DrawPolyLinesEx: ray.define('DrawPolyLinesEx', void, Vector2Type, int, float, float, float, ColorType), 

    # Basic shapes collision detection functions
    CheckCollisionRecs: ray.define('CheckCollisionRecs', bool, RectangleType, RectangleType),                                           
    CheckCollisionCircles: ray.define('CheckCollisionCircles', bool, Vector2Type, float, Vector2Type, float),        
    CheckCollisionCircleRec: ray.define('CheckCollisionCircleRec', bool, Vector2Type, float, RectangleType),                         
    CheckCollisionPointRec: ray.define('CheckCollisionPointRec', bool, Vector2Type, RectangleType),                                         
    CheckCollisionPointCircle: ray.define('CheckCollisionPointCircle', bool, Vector2Type, Vector2Type, float),                       
    CheckCollisionPointTriangle: ray.define('CheckCollisionPointTriangle', bool, Vector2Type, Vector2Type, Vector2Type, Vector2Type),               
    CheckCollisionPointPoly: ray.define('CheckCollisionPointPoly', bool, Vector2Type, Vector2Type, int),                      
    CheckCollisionLines: ray.define('CheckCollisionLines', bool, Vector2Type, Vector2Type, Vector2Type, Vector2Type, Vector2Type), 
    CheckCollisionPointLine: ray.define('CheckCollisionPointLine', bool, Vector2Type, Vector2Type, Vector2Type, int),                
    GetCollisionRec: ray.define('GetCollisionRec', RectangleType, RectangleType, RectangleType),                                         

    /**
     * rtexture
     */
    # Image loading functions
    # NOTE: These functions do not require GPU access
    LoadImage: ray.define('LoadImage', ImageType, char_ptr),                                                             
    LoadImageRaw: ray.define('LoadImageRaw', ImageType, char_ptr, int, int, int, int),       
    LoadImageAnim: ray.define('LoadImageAnim', ImageType, char_ptr, int),                                            
    LoadImageFromMemory: ray.define('LoadImageFromMemory', ImageType, char_ptr, char, int),      
    LoadImageFromTexture: ray.define('LoadImageFromTexture', ImageType, Texture2DType),                                                     
    LoadImageFromScreen: ray.define('LoadImageFromScreen', ImageType, void),                                                                   
    IsImageReady: ray.define('IsImageReady', bool, ImageType),                                                                    
    UnloadImage: ray.define('UnloadImage', void, ImageType),                                                                     
    ExportImage: ray.define('ExportImage', bool, ImageType, char_ptr),                                               
    ExportImageAsCode: ray.define('ExportImageAsCode', bool, ImageType, char_ptr),                                         

    # Image generation functions
    GenImageColor: ray.define('GenImageColor', ImageType, int, int, ColorType),                                           
    GenImageGradientV: ray.define('GenImageGradientV', ImageType, int, int, ColorType, ColorType),                           
    GenImageGradientH: ray.define('GenImageGradientH', ImageType, int, int, ColorType, ColorType),                           
    GenImageGradientRadial: ray.define('GenImageGradientRadial', ImageType, int, int, float, ColorType, ColorType),      
    GenImageChecked: ray.define('GenImageChecked', ImageType, int, int, int, int, ColorType, ColorType),    
    GenImageWhiteNoise: ray.define('GenImageWhiteNoise', ImageType, int, int, float),                                     
    GenImagePerlinNoise: ray.define('GenImagePerlinNoise', ImageType, int, int, int, int, float),           
    GenImageCellular: ray.define('GenImageCellular', ImageType, int, int, int),                                       
    GenImageText: ray.define('GenImageText', ImageType, int, int, char_ptr),                                       

    # Image manipulation functions
    ImageCopy: ray.define('ImageCopy', ImageType, ImageType),                                                                      
    ImageFromImage: ray.define('ImageFromImage', ImageType, ImageType, RectangleType),                                                  
    ImageText: ray.define('ImageText', ImageType, char_ptr, int, ColorType),                                      
    ImageTextEx: ray.define('ImageTextEx', ImageType, FontType, char_ptr, float, float, ColorType),         
    ImageFormat: ray.define('ImageFormat', void, ptr, int),
    ImageToPOT: ray.define('ImageToPOT', void, ptr, ColorType),
    ImageCrop: ray.define('ImageCrop', void, ptr, RectangleType),
    ImageAlphaCrop: ray.define('ImageAlphaCrop', void, ptr, float),
    ImageAlphaClear: ray.define('ImageAlphaClear', void, ptr, ColorType, float),
    ImageAlphaMask: ray.define('ImageAlphaMask', void, ptr, ImageType),
    ImageAlphaPremultiply: ray.define('ImageAlphaPremultiply', void, ptr),
    ImageBlurGaussian: ray.define('ImageBlurGaussian', void, ptr, int),
    ImageResize: ray.define('ImageResize', void, ptr, int, int),
    ImageResizeNN: ray.define('ImageResizeNN', void, ptr, int,int),
    ImageResizeCanvas: ray.define('ImageResizeCanvas', void, ptr, int, int, int, int, ColorType),
    ImageMipmaps: ray.define('ImageMipmaps', void, ptr),
    ImageDither: ray.define('ImageDither', void, ptr, int, int, int, int),                            
    ImageFlipVertical: ray.define('ImageFlipVertical', void, ptr),
    ImageFlipHorizontal: ray.define('ImageFlipHorizontal', void, ptr),
    ImageRotateCW: ray.define('ImageRotateCW', void, ptr),
    ImageRotateCCW: ray.define('ImageRotateCCW', void, ptr),
    ImageColorTint: ray.define('ImageColorTint', void, ptr, ColorType),
    ImageColorInvert: ray.define('ImageColorInvert', void, ptr),
    ImageColorGrayscale: ray.define('ImageColorGrayscale', void, ptr),
    ImageColorContrast: ray.define('ImageColorContrast', void, ptr, float),
    ImageColorBrightness: ray.define('ImageColorBrightness', void, ptr, int),
    ImageColorReplace: ray.define('ImageColorReplace', void, ptr, ColorType, ColorType),
    LoadImageColors: ray.define('LoadImageColors', ptr, ptr),
    LoadImagePalette: ray.define('LoadImagePalette', ptr, ptr, int, int),
    UnloadImageColors: ray.define('UnloadImageColors', void, ptr),
    UnloadImagePalette: ray.define('UnloadImagePalette', void, ptr),
    GetImageAlphaBorder: ray.define('GetImageAlphaBorder', RectangleType, ImageType, float),                                       
    GetImageColor: ray.define('GetImageColor', ColorType, ImageType, int, int),                                                    

    # Image drawing functions
    # NOTE: Image software-rendering functions (CPU)
    ImageClearBackground: ray.define('ImageClearBackground', void, ptr, ColorType),
    ImageDrawPixel: ray.define('ImageDrawPixel', void, ptr, int, int, ColorType),
    ImageDrawPixelV: ray.define('ImageDrawPixelV', void, ptr, Vector2Type, ColorType),
    ImageDrawLine: ray.define('ImageDrawLine', void, ptr, int, int, int, int, ColorType),
    ImageDrawLineV: ray.define('ImageDrawLineV', void, ptr, Vector2Type, Vector2Type, ColorType),
    ImageDrawCircle: ray.define('ImageDrawCircle', void, ptr, int, int, int, ColorType),
    ImageDrawCircleV: ray.define('ImageDrawCircleV', void, ptr, Vector2Type, int, ColorType),
    ImageDrawCircleLines: ray.define('ImageDrawCircleLines', void, ptr, int, int, int, ColorType),
    ImageDrawCircleLinesV: ray.define('ImageDrawCircleLinesV', void, ptr, Vector2Type, int, ColorType),
    ImageDrawRectangle: ray.define('ImageDrawRectangle', void, ptr, int, int, int, int, ColorType),
    ImageDrawRectangleV: ray.define('ImageDrawRectangleV', void, ptr, Vector2Type, Vector2Type, ColorType),
    ImageDrawRectangleRec: ray.define('ImageDrawRectangleRec', void, ptr, RectangleType, ColorType),
    ImageDrawRectangleLines: ray.define('ImageDrawRectangleLines', void, ptr, RectangleType, int, ColorType),
    ImageDraw: ray.define('ImageDraw', void, ptr, ImageType, RectangleType, RectangleType, ColorType),
    ImageDrawText: ray.define('ImageDrawText', void, ptr, char_ptr, int, int, int, ColorType),
    ImageDrawTextEx: ray.define('ImageDrawTextEx', void, ptr, FontType, char_ptr, Vector2Type, float, float, ColorType),

    # Texture loading functions
    # NOTE: These functions require GPU access
    LoadTexture: ray.define('LoadTexture', Texture2DType, char_ptr),                                                       
    LoadTextureFromImage: ray.define('LoadTextureFromImage', Texture2DType, ImageType),                                                       
    LoadTextureCubemap: ray.define('LoadTextureCubemap', TextureCubemapType, ImageType, int),                                        
    LoadRenderTexture: ray.define('LoadRenderTexture', RenderTexture2DType, int, int),                                          
    IsTextureReady: ray.define('IsTextureReady', bool, Texture2DType),                                                            
    UnloadTexture: ray.define('UnloadTexture', void, Texture2DType),                                                             
    IsRenderTextureReady: ray.define('IsRenderTextureReady', bool, RenderTexture2DType),                                                       
    UnloadRenderTexture: ray.define('UnloadRenderTexture', void, RenderTexture2DType),                                                  
    UpdateTexture: ray.define('UpdateTexture', void, Texture2DType, ptr),                                         
    UpdateTextureRec: ray.define('UpdateTextureRec', void, Texture2DType, RectangleType, ptr),                       

    # Texture configuration functions
    GenTextureMipmaps: ray.define('GenTextureMipmaps', void, ptr),
    SetTextureFilter: ray.define('SetTextureFilter', void, Texture2DType, int),                                              
    SetTextureWrap: ray.define('SetTextureWrap', void, Texture2DType, int),                                                  

    # Texture drawing functions
    DrawTexture: ray.define('DrawTexture', void, Texture2DType, int, int, ColorType),                               
    DrawTextureV: ray.define('DrawTextureV', void, Texture2DType, Vector2Type, ColorType),                                
    DrawTextureEx: ray.define('DrawTextureEx', void, Texture2DType, Vector2Type, float, float, ColorType),  
    DrawTextureRec: ray.define('DrawTextureRec', void, Texture2DType, RectangleType, Vector2Type, ColorType),            
    DrawTexturePro: ray.define('DrawTexturePro', void, Texture2DType, RectangleType, RectangleType, Vector2Type, float, ColorType), 
    DrawTextureNPatch: ray.define('DrawTextureNPatch', void, Texture2DType, NPatchInfoType, RectangleType, Vector2Type, float, ColorType), 

    # Color/pixel related functions
    Fade: ray.define('Fade', ColorType, ColorType, float),                                 
    ColorToInt: ray.define('ColorToInt', int, ColorType),                                          
    ColorNormalize: ray.define('ColorNormalize', Vector4Type, ColorType),                                  
    ColorFromNormalized: ray.define('ColorFromNormalized', ColorType, Vector4Type),                        
    ColorToHSV: ray.define('ColorToHSV', Vector3Type, ColorType),                                      
    ColorFromHSV: ray.define('ColorFromHSV', ColorType, float, float, float),         
    ColorTint: ray.define('ColorTint', ColorType, ColorType, ColorType),                             
    ColorBrightness: ray.define('ColorBrightness', ColorType, ColorType, float),                     
    ColorContrast: ray.define('ColorContrast', ColorType, ColorType, float),                     
    ColorAlpha: ray.define('ColorAlpha', ColorType, ColorType, float),                           
    ColorAlphaBlend: ray.define('ColorAlphaBlend', ColorType, ColorType, ColorType, ColorType),              
    GetColor: ray.define('GetColor', ColorType, uint),                                
    GetPixelColor: ray.define('GetPixelColor', ColorType, ptr, int),
    SetPixelColor: ray.define('SetPixelColor', void, ptr, ColorType, int),
    GetPixelDataSize: ray.define('GetPixelDataSize', int, int, int, int),              

    /**
     * rtext
     */
    # Font loading/unloading functions
    GetFontDefault: ray.define('GetFontDefault', FontType),                                                            
    LoadFont: ray.define('LoadFont', FontType, char_ptr),                                                  
    LoadFontEx: ray.define('LoadFontEx', FontType, char_ptr, int, ptr, int),  
    LoadFontFromImage: ray.define('LoadFontFromImage', FontType, ImageType, ColorType, int),                        
    LoadFontFromMemory: ray.define('LoadFontFromMemory', FontType, char_ptr, uchar_ptr, int, int, ptr, int), 
    IsFontReady: ray.define('IsFontReady', bool, FontType),                                                          
    LoadFontData: ray.define('LoadFontData', ptr, uchar_ptr, int, int, ptr, int, int),
    GenImageFontAtlas: ray.define('GenImageFontAtlas', ImageType, ptr, ptr, int, int, int, int),
    UnloadFontData: ray.define('UnloadFontData', void, ptr, int),                                
    UnloadFont: ray.define('UnloadFont', void, FontType),                                                           
    ExportFontAsCode: ray.define('ExportFontAsCode', bool, FontType, char_ptr),                               

    #  Text drawing functions
    DrawFPS: ray.define('DrawFPS', void, int, int),                                                     
    DrawText: ray.define('DrawText', void, char_ptr, int, int, int, ColorType),       
    DrawTextEx: ray.define('DrawTextEx', void, FontType, char_ptr, Vector2Type, float, float, ColorType), 
    DrawTextPro: ray.define('DrawTextPro', void, FontType, char_ptr, Vector2Type, Vector2Type, float, float, float, ColorType), 
    DrawTextCodepoint: ray.define('DrawTextCodepoint', void, FontType, int, Vector2Type, float, ColorType), 
    DrawTextCodepoints: ray.define('DrawTextCodepoints', void, FontType, ptr, int, Vector2Type, float, float, ColorType),

    #  Text font info functions
    MeasureText: ray.define('MeasureText', int, char_ptr, int),                                      
    MeasureTextEx: ray.define('MeasureTextEx', Vector2Type, FontType, char_ptr, float, float),    
    GetGlyphIndex: ray.define('GetGlyphIndex', int, FontType, int),                                          
    GetGlyphInfo: ray.define('GetGlyphInfo', GlyphInfoType, FontType, int),                                     
    GetGlyphAtlasRec: ray.define('GetGlyphAtlasRec', RectangleType, FontType, int),                                 

    #  Text codepoints management functions (unicode)
    LoadUTF8: ray.define('LoadUTF8', char_ptr, ptr, int),
    UnloadUTF8: ray.define('UnloadUTF8', void, char_ptr),                                      
    LoadCodepoints: ray.define('LoadCodepoints', ptr, char_ptr, ptr),                
    UnloadCodepoints: ray.define('UnloadCodepoints', void, ptr),                           
    GetCodepointCount: ray.define('GetCodepointCount', int, char_ptr),                          
    GetCodepoint: ray.define('GetCodepoint', int, char_ptr, ptr),           
    GetCodepointNext: ray.define('GetCodepointNext', int, char_ptr, ptr),       
    GetCodepointPrevious: ray.define('GetCodepointPrevious', int, char_ptr, ptr),   
    CodepointToUTF8: ray.define('CodepointToUTF8', char_ptr, int, ptr),

    #  Text strings management functions (no UTF-8, only byte)
    #  NOTE: Some strings allocate memory internally for returned, just be careful!
    TextCopy: ray.define('TextCopy', int, char_ptr, char_ptr),                                             
    TextIsEqual: ray.define('TextIsEqual', bool, char_ptr, char_ptr),                               
    TextLength: ray.define('TextLength', uint, char_ptr),                                            
    TextSubtext: ray.define('TextSubtext', char_ptr, char_ptr, int, int),                  
    TextReplace: ray.define('TextReplace', char_ptr, char_ptr, char_ptr, char_ptr),                   
    TextInsert: ray.define('TextInsert', char_ptr, char_ptr, char_ptr, int),                 
    TextJoin: ray.define('TextJoin', char_ptr, char_ptr, int, char_ptr),        
    TextSplit: ray.define('TextSplit', ptr, char_ptr, char, ptr),
    TextAppend: ray.define('TextAppend', void, char_ptr, char_ptr, ptr),                       
    TextFindIndex: ray.define('TextFindIndex', int, char_ptr, char_ptr),                                
    TextToUpper: ray.define('TextToUpper', char_ptr, char_ptr),                      
    TextToLower: ray.define('TextToLower', char_ptr, char_ptr),                      
    TextToPascal: ray.define('TextToPascal', char_ptr, char_ptr),                     
    TextToInteger: ray.define('TextToInteger', int, char_ptr),  

    #  Basic geometric 3D shapes drawing functions
    DrawLine3D: ray.define('DrawLine3D', void, Vector3Type, Vector3Type, ColorType),
    DrawPoint3D: ray.define('DrawPoint3D', void, Vector3Type, ColorType),
    DrawCircle3D: ray.define('DrawCircle3D', void, Vector3Type, float, Vector3Type, float, ColorType),
    DrawTriangle3D: ray.define('DrawTriangle3D', void, Vector3Type, Vector3Type, Vector3Type, ColorType),
    DrawTriangleStrip3D: ray.define('DrawTriangleStrip3D', void, ptr, int, ColorType),
    DrawCube: ray.define('DrawCube', void, Vector3Type, float, float, float, ColorType),
    DrawCubeV: ray.define('DrawCubeV', void, Vector3Type, Vector3Type, ColorType),
    DrawCubeWires: ray.define('DrawCubeWires', void, Vector3Type, float, float, float, ColorType),
    DrawCubeWiresV: ray.define('DrawCubeWiresV', void, Vector3Type, Vector3Type, ColorType),
    DrawSphere: ray.define('DrawSphere', void, Vector3Type, float, ColorType),
    DrawSphereEx: ray.define('DrawSphereEx', void, Vector3Type, float, int, int, ColorType),
    DrawSphereWires: ray.define('DrawSphereWires', void, Vector3Type, float, int, int, ColorType),
    DrawCylinder: ray.define('DrawCylinder', void, Vector3Type, float, float, float, int, ColorType),
    DrawCylinderEx: ray.define('DrawCylinderEx', void, Vector3Type, Vector3Type, float, float, int, ColorType),
    DrawCylinderWires: ray.define('DrawCylinderWires', void, Vector3Type, float, float, float, int, ColorType),
    DrawCylinderWiresEx: ray.define('DrawCylinderWiresEx', void, Vector3Type, Vector3Type, float, float, int, ColorType),
    DrawCapsule: ray.define('DrawCapsule', void, Vector3Type, Vector3Type, float, int, int, ColorType),
    DrawCapsuleWires: ray.define('DrawCapsuleWires', void, Vector3Type, Vector3Type, float, int, int, ColorType),
    DrawPlane: ray.define('DrawPlane', void, Vector3Type, Vector2Type, ColorType),
    DrawRay: ray.define('DrawRay', void, RayType, ColorType),
    DrawGrid: ray.define('DrawGrid', void, int, float),

    # ------------------------------------------------------------------------------------
    #  Model 3d Loading and Drawing Functions (Module: models)
    # ------------------------------------------------------------------------------------

    #  Model management functions
    LoadModel: ray.define('LoadModel', ModelType, char_ptr),
    LoadModelFromMesh: ray.define('LoadModelFromMesh', ModelType, MeshType),
    IsModelReady: ray.define('IsModelReady', bool, ModelType),
    UnloadModel: ray.define('UnloadModel', void, ModelType),
    GetModelBoundingBox: ray.define('GetModelBoundingBox', BoundingBoxType, ModelType),

    #  Model drawing functions
    DrawModel: ray.define('DrawModel', void, ModelType, Vector3Type, float, ColorType),
    DrawModelEx: ray.define('DrawModelEx', void, ModelType, Vector3Type, Vector3Type, float, Vector3Type, ColorType),
    DrawModelWires: ray.define('DrawModelWires', void, ModelType, Vector3Type, float, ColorType),
    DrawModelWiresEx: ray.define('DrawModelWiresEx', void, ModelType, Vector3Type, Vector3Type, float, Vector3Type, ColorType),
    DrawBoundingBox: ray.define('DrawBoundingBox', void, BoundingBoxType, ColorType),
    DrawBillboard: ray.define('DrawBillboard', void, CameraType, Texture2DType, Vector3Type, float, ColorType),
    DrawBillboardRec: ray.define('DrawBillboardRec', void, CameraType, Texture2DType, RectangleType, Vector3Type, Vector2Type, ColorType),
    DrawBillboardPro: ray.define('DrawBillboardPro', void, CameraType, Texture2DType, RectangleType, Vector3Type, Vector3Type, Vector2Type, Vector2Type, float, ColorType),

    #  Mesh management functions
    UploadMesh: ray.define('UploadMesh', void, ptr, bool),
    UpdateMeshBuffer: ray.define('UpdateMeshBuffer', void, MeshType, int, ptr, int, int),
    UnloadMesh: ray.define('UnloadMesh', void, MeshType),
    DrawMesh: ray.define('DrawMesh', void, MeshType, MaterialType, MatrixType),
    DrawMeshInstanced: ray.define('DrawMeshInstanced', void, MeshType, MaterialType, ptr, int),
    ExportMesh: ray.define('ExportMesh', bool, MeshType, char_ptr),
    GetMeshBoundingBox: ray.define('GetMeshBoundingBox', BoundingBoxType, MeshType),
    GenMeshTangents: ray.define('GenMeshTangents', void, ptr),

    # #  Mesh generation functions
    GenMeshPoly: ray.define('GenMeshPoly', MeshType, int, float),
    GenMeshPlane: ray.define('GenMeshPlane', MeshType, float, float, int, int),
    GenMeshCube: ray.define('GenMeshCube', MeshType, float, float, float),
    GenMeshSphere: ray.define('GenMeshSphere', MeshType, float, int, int),
    GenMeshHemiSphere: ray.define('GenMeshHemiSphere', MeshType, float, int, int),
    GenMeshCylinder: ray.define('GenMeshCylinder', MeshType, float, float, int),
    GenMeshCone: ray.define('GenMeshCone', MeshType, float, float, int),
    GenMeshTorus: ray.define('GenMeshTorus', MeshType, float, float, int, int),
    GenMeshKnot: ray.define('GenMeshKnot', MeshType, float, float, int, int),
    GenMeshHeightmap: ray.define('GenMeshHeightmap', MeshType, ImageType, Vector3Type),
    GenMeshCubicmap: ray.define('GenMeshCubicmap', MeshType, ImageType, Vector3Type),

    # #  Material loading/unloading functions
    LoadMaterials: ray.define('LoadMaterials', ptr, char_ptr, ptr),
    LoadMaterialDefault: ray.define('LoadMaterialDefault', MaterialType, void),
    IsMaterialReady: ray.define('IsMaterialReady', bool, MaterialType),
    UnloadMaterial: ray.define('UnloadMaterial', void, MaterialType),
    SetMaterialTexture: ray.define('SetMaterialTexture', void, ptr, int, Texture2DType),
    SetModelMeshMaterial: ray.define('SetModelMeshMaterial', void, ptr, int, int),

    # #  Model animations loading/unloading functions
    LoadModelAnimations: ray.define('LoadModelAnimations', ptr, char_ptr, ptr),
    UpdateModelAnimation: ray.define('UpdateModelAnimation', void, ModelType, ModelAnimationType, int),
    UnloadModelAnimation: ray.define('UnloadModelAnimation', void, ModelAnimationType),
    UnloadModelAnimations: ray.define('UnloadModelAnimations', void, ptr, int),
    IsModelAnimationValid: ray.define('IsModelAnimationValid', bool, ModelType, ModelAnimationType),

    # #  Collision detection functions
    CheckCollisionSpheres: ray.define('CheckCollisionSpheres', bool, Vector3Type, float, Vector3Type, float),
    CheckCollisionBoxes: ray.define('CheckCollisionBoxes', bool, BoundingBoxType, BoundingBoxType),
    CheckCollisionBoxSphere: ray.define('CheckCollisionBoxSphere', bool, BoundingBoxType, Vector3Type, float),
    GetRayCollisionSphere: ray.define('GetRayCollisionSphere', RayCollisionType, RayType, Vector3Type, float),
    GetRayCollisionBox: ray.define('GetRayCollisionBox', RayCollisionType, RayType, BoundingBoxType),
    GetRayCollisionMesh: ray.define('GetRayCollisionMesh', RayCollisionType, RayType, MeshType, MatrixType),
    GetRayCollisionTriangle: ray.define('GetRayCollisionTriangle', RayCollisionType, RayType, Vector3Type, Vector3Type, Vector3Type),
    GetRayCollisionQuad: ray.define('GetRayCollisionQuad', RayCollisionType, RayType, Vector3Type, Vector3Type, Vector3Type, Vector3Type),

    # ----------------------------------------------------------------
    # AUDIO
    # ----------------------------------------------------------------
    # Audio device management functions
    InitAudioDevice: ray.define('InitAudioDevice', void),
    CloseAudioDevice: ray.define('CloseAudioDevice', void),
    IsAudioDeviceReady: ray.define('IsAudioDeviceReady', bool),
    SetMasterVolume: ray.define('SetMasterVolume', void, float),

    # Wave/Sound loading/unloading functions
    LoadWave: ray.define('LoadWave', WaveType, char_ptr),
    LoadWaveFromMemory: ray.define('LoadWaveFromMemory', WaveType, char_ptr, uchar_ptr, int),
    IsWaveReady: ray.define('IsWaveReady', bool, WaveType),
    LoadSound: ray.define('LoadSound', SoundType, char_ptr),
    LoadSoundFromWave: ray.define('LoadSoundFromWave', SoundType, WaveType),
    IsSoundReady: ray.define('IsSoundReady', bool, SoundType),
    UpdateSound: ray.define('UpdateSound', void, SoundType, ptr, int),
    UnloadWave: ray.define('UnloadWave', void, WaveType),
    UnloadSound: ray.define('UnloadSound', void, SoundType),
    ExportWave: ray.define('ExportWave', bool, WaveType, char_ptr),
    ExportWaveAsCode: ray.define('ExportWaveAsCode', bool, WaveType, char_ptr),

    # Wave/Sound management functions
    PlaySound: ray.define('PlaySound', void, SoundType),
    StopSound: ray.define('StopSound', void, SoundType),
    PauseSound: ray.define('PauseSound', void, SoundType),
    ResumeSound: ray.define('ResumeSound', void, SoundType),
    IsSoundPlaying: ray.define('IsSoundPlaying', bool, SoundType),
    SetSoundVolume: ray.define('SetSoundVolume', void, SoundType, float),
    SetSoundPitch: ray.define('SetSoundPitch', void, SoundType, float),
    SetSoundPan: ray.define('SetSoundPan', void, SoundType, float),
    WaveCopy: ray.define('WaveCopy', WaveType, WaveType),
    WaveCrop: ray.define('WaveCrop', void, ptr, int, int),
    WaveFormat: ray.define('WaveFormat', void, ptr, int, int, int),
    LoadWaveSamples: ray.define('LoadWaveSamples', ptr, WaveType),
    UnloadWaveSamples: ray.define('UnloadWaveSamples', void, ptr),

    # Music management functions
    LoadMusicStream: ray.define('LoadMusicStream', MusicType, char_ptr),
    LoadMusicStreamFromMemory: ray.define('LoadMusicStreamFromMemory', MusicType, char_ptr, uchar_ptr, int),
    IsMusicReady: ray.define('IsMusicReady', bool, MusicType),
    UnloadMusicStream: ray.define('UnloadMusicStream', void, MusicType),
    PlayMusicStream: ray.define('PlayMusicStream', void, MusicType),
    IsMusicStreamPlaying: ray.define('IsMusicStreamPlaying', bool, MusicType),
    UpdateMusicStream: ray.define('UpdateMusicStream', void, MusicType),
    StopMusicStream: ray.define('StopMusicStream', void, MusicType),
    PauseMusicStream: ray.define('PauseMusicStream', void, MusicType),
    ResumeMusicStream: ray.define('ResumeMusicStream', void, MusicType),
    SeekMusicStream: ray.define('SeekMusicStream', void, MusicType, float),
    SetMusicVolume: ray.define('SetMusicVolume', void, MusicType, float),
    SetMusicPitch: ray.define('SetMusicPitch', void, MusicType, float),
    SetMusicPan: ray.define('SetMusicPan', void, MusicType, float),
    GetMusicTimeLength: ray.define('GetMusicTimeLength', float, MusicType),
    GetMusicTimePlayed: ray.define('GetMusicTimePlayed', float, MusicType),

    # AudioStream management functions
    LoadAudioStream: ray.define('LoadAudioStream', AudioStreamType, uint, uint, uint),
    IsAudioStreamReady: ray.define('IsAudioStreamReady', bool, AudioStreamType),
    UnloadAudioStream: ray.define('UnloadAudioStream', void, AudioStreamType),
    UpdateAudioStream: ray.define('UpdateAudioStream', void, AudioStreamType, ptr, int),
    IsAudioStreamProcessed: ray.define('IsAudioStreamProcessed', bool, AudioStreamType),
    PlayAudioStream: ray.define('PlayAudioStream', void, AudioStreamType),
    PauseAudioStream: ray.define('PauseAudioStream', void, AudioStreamType),
    ResumeAudioStream: ray.define('ResumeAudioStream', void, AudioStreamType),
    IsAudioStreamPlaying: ray.define('IsAudioStreamPlaying', bool, AudioStreamType),
    StopAudioStream: ray.define('StopAudioStream', void, AudioStreamType),
    SetAudioStreamVolume: ray.define('SetAudioStreamVolume', void, AudioStreamType, float),
    SetAudioStreamPitch: ray.define('SetAudioStreamPitch', void, AudioStreamType, float),
    SetAudioStreamPan: ray.define('SetAudioStreamPan', void, AudioStreamType, float),
    SetAudioStreamBufferSizeDefault: ray.define('SetAudioStreamBufferSizeDefault', void, int),


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
      Vector2Zero: ray.define('Vector2Zero', Vector2Type, void),
      Vector2One: ray.define('Vector2One', Vector2Type, void),
      Vector2Add: ray.define('Vector2Add', Vector2Type, Vector2Type, Vector2Type),
      Vector2AddValue: ray.define('Vector2AddValue', Vector2Type, Vector2Type, float),
      Vector2Subtract: ray.define('Vector2Subtract', Vector2Type, Vector2Type, Vector2Type),
      Vector2SubtractValue: ray.define('Vector2SubtractValue', Vector2Type, Vector2Type, float),
      Vector2Length: ray.define('Vector2Length', float, Vector2Type),
      Vector2LengthSqr: ray.define('Vector2LengthSqr', float, Vector2Type),
      Vector2DotProduct: ray.define('Vector2DotProduct', float, Vector2Type, Vector2Type),
      Vector2Distance: ray.define('Vector2Distance', float, Vector2Type, Vector2Type),
      Vector2DistanceSqr: ray.define('Vector2DistanceSqr', float, Vector2Type, Vector2Type),
      Vector2Angle: ray.define('Vector2Angle', float, Vector2Type, Vector2Type),
      Vector2Scale: ray.define('Vector2Scale', Vector2Type, Vector2Type, float),
      Vector2Multiply: ray.define('Vector2Multiply', Vector2Type, Vector2Type, Vector2Type),
      Vector2Negate: ray.define('Vector2Negate', Vector2Type, Vector2Type),
      Vector2Divide: ray.define('Vector2Divide', Vector2Type, Vector2Type, Vector2Type),
      Vector2Normalize: ray.define('Vector2Normalize', Vector2Type, Vector2Type),
      Vector2Transform: ray.define('Vector2Transform', Vector2Type, Vector2Type, MatrixType),
      Vector2Lerp: ray.define('Vector2Lerp', Vector2Type, Vector2Type, Vector2Type, float),
      Vector2Reflect: ray.define('Vector2Reflect', Vector2Type, Vector2Type, Vector2Type),
      Vector2Rotate: ray.define('Vector2Rotate', Vector2Type, Vector2Type, float),
      Vector2MoveTowards: ray.define('Vector2MoveTowards', Vector2Type, Vector2Type, Vector2Type, float),
      Vector2Invert: ray.define('Vector2Invert', Vector2Type, Vector2Type),
      Vector2Clamp: ray.define('Vector2Clamp', Vector2Type, Vector2Type, Vector2Type, Vector2Type),
      Vector2ClampValue: ray.define('Vector2ClampValue', Vector2Type, Vector2Type, float, float),
      Vector2Equals: ray.define('Vector2Equals', int, Vector2Type, Vector2Type),
      # Vector3 math
      Vector3Zero: ray.define('Vector3Zero', Vector3Type),
      Vector3One: ray.define('Vector3One', Vector3Type),
      Vector3Add: ray.define('Vector3Add', Vector3Type, Vector3Type, Vector3Type),
      Vector3AddValue: ray.define('Vector3AddValue', Vector3Type, Vector3Type, float),
      Vector3Subtract: ray.define('Vector3Subtract', Vector3Type, Vector3Type, Vector3Type),
      Vector3SubtractValue: ray.define('Vector3SubtractValue', Vector3Type, Vector3Type, float),
      Vector3Scale: ray.define('Vector3Scale', Vector3Type, Vector3Type, float),
      Vector3Multiply: ray.define('Vector3Multiply', Vector3Type, Vector3Type, Vector3Type),
      Vector3CrossProduct: ray.define('Vector3CrossProduct', Vector3Type, Vector3Type, Vector3Type),
      Vector3Perpendicular: ray.define('Vector3Perpendicular', Vector3Type, Vector3Type),
      Vector3Length: ray.define('Vector3Length', float, Vector3Type),
      Vector3LengthSqr: ray.define('Vector3LengthSqr', float, Vector3Type),
      Vector3DotProduct: ray.define('Vector3DotProduct', float, Vector3Type, Vector3Type),
      Vector3Distance: ray.define('Vector3Distance', float, Vector3Type, Vector3Type),
      Vector3DistanceSqr: ray.define('Vector3DistanceSqr', float, Vector3Type, Vector3Type),
      Vector3Angle: ray.define('Vector3Angle', float, Vector3Type, Vector3Type),
      Vector3Negate: ray.define('Vector3Negate', Vector3Type, Vector3Type),
      Vector3Divide: ray.define('Vector3Divide', Vector3Type, Vector3Type, Vector3Type),
      Vector3Normalize: ray.define('Vector3Normalize', Vector3Type, Vector3Type),
      Vector3OrthoNormalize: ray.define('Vector3OrthoNormalize', void, ptr, ptr),
      Vector3Transform: ray.define('Vector3Transform', Vector3Type, Vector3Type, MatrixType),
      Vector3RotateByQuaternion: ray.define('Vector3RotateByQuaternion', Vector3Type, Vector3Type, QuaternionType),
      Vector3RotateByAxisAngle: ray.define('Vector3RotateByAxisAngle', Vector3Type, Vector3Type, Vector3Type, float),
      Vector3Lerp: ray.define('Vector3Lerp', Vector3Type, Vector3Type, Vector3Type, float),
      Vector3Reflect: ray.define('Vector3Reflect', Vector3Type, Vector3Type, Vector3Type),
      Vector3Min: ray.define('Vector3Min', Vector3Type, Vector3Type, Vector3Type),
      Vector3Max: ray.define('Vector3Max', Vector3Type, Vector3Type, Vector3Type),
      Vector3Barycenter: ray.define('Vector3Barycenter', Vector3Type, Vector3Type, Vector3Type, Vector3Type, Vector3Type),
      Vector3Unproject: ray.define('Vector3Unproject', Vector3Type, Vector3Type, MatrixType, MatrixType),
      Vector3ToFloatV: ray.define('Vector3ToFloatV', float3Type, Vector3Type),
      Vector3Invert: ray.define('Vector3Invert', Vector3Type, Vector3Type),
      Vector3Clamp: ray.define('Vector3Clamp', Vector3Type, Vector3Type, Vector3Type, Vector3Type),
      Vector3ClampValue: ray.define('Vector3ClampValue', Vector3Type, Vector3Type, float, float),
      Vector3Equals: ray.define('Vector3Equals', int, Vector3Type, Vector3Type),
      Vector3Refract: ray.define('Vector3Refract', Vector3Type, Vector3Type, Vector3Type, float),
      # Matrix math
      MatrixDeterminant: ray.define('MatrixDeterminant', float, MatrixType),
      MatrixTrace: ray.define('MatrixTrace', float, MatrixType),
      MatrixTranspose: ray.define('MatrixTranspose', MatrixType, MatrixType),
      MatrixInvert: ray.define('MatrixInvert', MatrixType, MatrixType),
      MatrixIdentity: ray.define('MatrixIdentity', MatrixType, void),
      MatrixAdd: ray.define('MatrixAdd', MatrixType, MatrixType, MatrixType),
      MatrixSubtract: ray.define('MatrixSubtract', MatrixType, MatrixType, MatrixType),
      MatrixMultiply: ray.define('MatrixMultiply', MatrixType, MatrixType, MatrixType),
      MatrixTranslate: ray.define('MatrixTranslate', MatrixType, float, float, float),
      MatrixRotate: ray.define('MatrixRotate', MatrixType, Vector3Type, float),
      MatrixRotateX: ray.define('MatrixRotateX', MatrixType, float),
      MatrixRotateY: ray.define('MatrixRotateY', MatrixType, float),
      MatrixRotateZ: ray.define('MatrixRotateZ', MatrixType, float),
      MatrixRotateXYZ: ray.define('MatrixRotateXYZ', MatrixType, Vector3Type),
      MatrixRotateZYX: ray.define('MatrixRotateZYX', MatrixType, Vector3Type),
      MatrixScale: ray.define('MatrixScale', MatrixType, float, float, float),
      MatrixFrustum: ray.define('MatrixFrustum', MatrixType, double, double, double, double, double, double),
      MatrixPerspective: ray.define('MatrixPerspective', MatrixType, double, double, double, double),
      MatrixOrtho: ray.define('MatrixOrtho', MatrixType, double, double, double, double, double, double),
      MatrixLookAt: ray.define('MatrixLookAt', MatrixType, Vector3Type, Vector3Type, Vector3Type),
      MatrixToFloatV: ray.define('MatrixToFloatV', float16Type, MatrixType),
      # Quaternion math
      QuaternionAdd: ray.define('QuaternionAdd', QuaternionType, QuaternionType, QuaternionType),
      QuaternionAddValue: ray.define('QuaternionAddValue', QuaternionType, QuaternionType, float),
      QuaternionSubtract: ray.define('QuaternionSubtract', QuaternionType, QuaternionType, QuaternionType),
      QuaternionSubtractValue: ray.define('QuaternionSubtractValue', QuaternionType, QuaternionType, float),
      QuaternionIdentity: ray.define('QuaternionIdentity', QuaternionType, void),
      QuaternionLength: ray.define('QuaternionLength', float, QuaternionType),
      QuaternionNormalize: ray.define('QuaternionNormalize', QuaternionType, QuaternionType),
      QuaternionInvert: ray.define('QuaternionInvert', QuaternionType, QuaternionType),
      QuaternionMultiply: ray.define('QuaternionMultiply', QuaternionType, QuaternionType, QuaternionType),
      QuaternionScale: ray.define('QuaternionScale', QuaternionType, QuaternionType, float),
      QuaternionDivide: ray.define('QuaternionDivide', QuaternionType, QuaternionType, QuaternionType),
      QuaternionLerp: ray.define('QuaternionLerp', QuaternionType, QuaternionType, QuaternionType, float),
      QuaternionNlerp: ray.define('QuaternionNlerp', QuaternionType, QuaternionType, QuaternionType, float),
      QuaternionSlerp: ray.define('QuaternionSlerp', QuaternionType, QuaternionType, QuaternionType, float),
      QuaternionFromVector3ToVector3: ray.define('QuaternionFromVector3ToVector3', QuaternionType, Vector3Type, Vector3Type),
      QuaternionFromMatrix: ray.define('QuaternionFromMatrix', QuaternionType, MatrixType),
      QuaternionToMatrix: ray.define('QuaternionToMatrix', MatrixType, QuaternionType),
      QuaternionFromAxisAngle: ray.define('QuaternionFromAxisAngle', QuaternionType, Vector3Type, float),
      QuaternionToAxisAngle: ray.define('QuaternionToAxisAngle', void, QuaternionType, ptr, ptr),
      QuaternionFromEuler: ray.define('QuaternionFromEuler', QuaternionType, float, float, float),
      QuaternionToEuler: ray.define('QuaternionToEuler', Vector3Type, QuaternionType),
      QuaternionTransform: ray.define('QuaternionTransform', QuaternionType, QuaternionType, MatrixType),
      QuaternionEquals: ray.define('QuaternionEquals', int, QuaternionType, QuaternionType),
    },

    # ----------------------------------------------------------------
    # Camera functions (rcamera.h)
    # ----------------------------------------------------------------
    camera: {
      GetCameraForward: ray.define('GetCameraForward', Vector3Type, ptr),
      GetCameraUp: ray.define('GetCameraUp', Vector3Type, ptr),
      GetCameraRight: ray.define('GetCameraRight', Vector3Type, ptr),

      # Camera movement
      CameraMoveForward: ray.define('CameraMoveForward', void, ptr, float, bool),
      CameraMoveUp: ray.define('CameraMoveUp', void, ptr, float),
      CameraMoveRight: ray.define('CameraMoveRight', void, ptr, float, bool),
      CameraMoveToTarget: ray.define('CameraMoveToTarget', void, ptr, float),

      # Camera rotation
      CameraYaw: ray.define('CameraYaw', void, ptr, float, bool),
      CameraPitch: ray.define('CameraPitch', void, ptr, float, bool, bool, bool),
      CameraRoll: ray.define('CameraRoll', void, ptr, float),
      GetCameraViewMatrix: ray.define('GetCameraViewMatrix', MatrixType, ptr),
      GetCameraProjectionMatrix: ray.define('GetCameraProjectionMatrix', MatrixType, ptr, float),
    },
  }

  return lib
}

