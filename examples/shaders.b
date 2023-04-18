import ..app { * }
import reflect
import os

var GLSL_VERSION = 330
var SCREEN_WIDTH = 800
var SCREEN_HEIGHT = 650

var resource_dir = os.join_paths(os.dir_name(os.current_file()), 'resources', 'shaders', 'glsl${GLSL_VERSION}')

var ui = Init()

ui.SetConfigFlags(FLAG_MSAA_4X_HINT)
ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, '3D Example')

# Create fine tuned font...
var font = ui.LoadFont(os.join_paths(os.dir_name(os.dir_name(os.current_file())), 'fonts', 'Segoe UI.ttf'))
var t1 = ray.DeFont(font).texture
var texture = ray.Texture2D(t1.id, t1.width, t1.height, t1.mipmaps, t1.format)
ui.SetTextureFilter(texture, ray.TEXTURE_FILTER_TRILINEAR)

# Define the camera to look into our 3d world
var camera = Camera(
  Vector3(2, 3, 2),   # position
  Vector3(0, 1, 0),   # target
  Vector3(0, 1, 0),   # up
  45,                     # fovy
  CAMERA_PERSPECTIVE # projection
)

var position = Vector3(0, 0, 0)
var model = ui.LoadModel(os.join_paths(os.dir_name(os.current_file()), 'resources', 'models', 'church.obj'))
var texture = ui.LoadTexture(os.join_paths(os.dir_name(os.current_file()), 'resources', 'models', 'church_diffuse.png'))
ui.SetMaterialTexture(
  DeModel(model).materials, 
  MATERIAL_MAP_DIFFUSE, 
  texture
)

var shaders = [
  ui.LoadShader(nil, os.join_paths(resource_dir, '')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'grayscale.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'posterization.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'dream_vision.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'pixelizer.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'cross_hatching.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'cross_stitching.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'predator.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'scanlines.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'fisheye.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'sobel.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'bloom.fs')),
  ui.LoadShader(nil, os.join_paths(resource_dir, 'blur.fs')),
]

var postpro_shader_text = [
  'NORMAL',
  'GRAYSCALE',
  'POSTERIZATION',
  'DREAM_VISION',
  'PIXELIZER',
  'CROSS_HATCHING',
  'CROSS_STITCHING',
  'PREDATOR_VIEW',
  'SCANLINES',
  'FISHEYE',
  'SOBEL',
  'BLOOM',
  'BLUR',
]

var current_shader = 0

var target = ui.LoadRenderTexture(SCREEN_WIDTH, SCREEN_HEIGHT)

var _target_texture = DeRenderTexture2D(target).texture
var target_texture = Texture2D(
  _target_texture.id, 
  _target_texture.width, 
  _target_texture.height, 
  _target_texture.mipmaps, 
  _target_texture.format
)

ui.SetTargetFPS(60)

while !ui.WindowShouldClose() {
  ui.UpdateCamera(reflect.get_ptr(camera), CAMERA_ORBITAL)

  if ui.IsKeyPressed(KEY_RIGHT) current_shader++
  else if ui.IsKeyPressed(KEY_LEFT) current_shader--

  if current_shader >= shaders.length() current_shader = 0
  else if current_shader < 0 current_shader = shaders.length() - 1

  ui.BeginTextureMode(target)
    ui.ClearBackground(RAYWHITE)
    ui.BeginMode3D(camera)
      ui.DrawModel(model, position, 0.1, WHITE)
      ui.DrawGrid(10, 1)
    ui.EndMode3D()
  ui.EndTextureMode()

  ui.BeginDrawing()
    ui.ClearBackground(RAYWHITE)

    ui.BeginShaderMode(shaders[current_shader])
      ui.DrawTextureRec(
        target_texture, 
        Rectangle(0, 0, _target_texture.width, -_target_texture.height), 
        Vector2(0, 0), 
        WHITE
      )
    ui.EndShaderMode()

    ui.DrawRectangle(0, 9, 580, 30, ui.Fade(LIGHTGRAY, 0.7))

    ui.DrawTextEx(font, '(c) Church 3D model by Alberto Cano', Vector2(SCREEN_WIDTH - 200, SCREEN_HEIGHT - 20), 10, 0, GRAY)
    ui.DrawTextEx(font, 'CURRENT POSTPRO SHADER:', Vector2(10, 15), 20, 0, BLACK)
    ui.DrawTextEx(font, postpro_shader_text[current_shader], Vector2(330, 15), 20, 0, RED)
    ui.DrawText("< >", 540, 10, 30, DARKBLUE)
    ui.DrawFPS(700, 15)

  ui.EndDrawing()
}

for shader in shaders ui.UnloadShader(shader)

ui.UnloadTexture(texture)
ui.UnloadModel(model)
ui.UnloadRenderTexture(target)

ui.CloseWindow()

