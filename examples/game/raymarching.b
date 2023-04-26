import ..app { * }
import reflect
import os
import struct

var GLSL_VERSION = 330
var SCREEN_WIDTH = 800
var SCREEN_HEIGHT = 450

var resource_dir = os.join_paths(os.dir_name(os.current_file()), 'resources', 'shaders', 'glsl${GLSL_VERSION}')

var ui = Init()

ui.SetConfigFlags(FLAG_WINDOW_RESIZABLE)
ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Raymarching shapes generation')

# Create fine tuned font...
var font = ui.LoadFont(os.join_paths(os.dir_name(os.dir_name(os.current_file())), 'fonts', 'Segoe UI.ttf'))
var t1 = DeFont(font).texture
var texture = Texture2D(t1.id, t1.width, t1.height, t1.mipmaps, t1.format)
ui.SetTextureFilter(texture, TEXTURE_FILTER_TRILINEAR)

# Define the camera to look into our 3d world
var camera = Camera(
  Vector3(2.5, 2.5, 3),   # position
  Vector3(0, 0, 0.7),   # target
  Vector3(0, 1, 0),   # up
  65,                     # fovy
  CAMERA_PERSPECTIVE # projection
)
var _camera = DeCamera(camera)

var shader = ui.LoadShader(nil, os.join_paths(resource_dir, 'raymarching.fs'))

var view_eye_loc = ui.GetShaderLocation(shader, 'viewEye')
var view_center_loc = ui.GetShaderLocation(shader, 'viewCenter')
var run_time_loc = ui.GetShaderLocation(shader, 'runTime')
var resolution_loc = ui.GetShaderLocation(shader, 'resolution')

ui.SetShaderValue(shader, resolution_loc, float2([SCREEN_WIDTH, SCREEN_HEIGHT]), SHADER_UNIFORM_VEC2)

var runtime = 0
ui.DisableCursor()
ui.SetTargetFPS(60)

while !ui.WindowShouldClose() {
  ui.UpdateCamera(reflect.get_ptr(camera), CAMERA_FIRST_PERSON)

  var camera_pos = float3(_camera.position.to_list()[1])
  var camera_target = float3(_camera.target.to_list()[1])

  var delta_time = ui.GetFrameTime()
  runtime += delta_time

  ui.SetShaderValue(shader, view_eye_loc, camera_pos, SHADER_UNIFORM_VEC3)
  ui.SetShaderValue(shader, view_center_loc, camera_target, SHADER_UNIFORM_VEC3)
  var f = struct.pack('f', runtime)
  ui.SetShaderValue(shader, run_time_loc, f, SHADER_UNIFORM_FLOAT)
  runtime = struct.unpack('f', f)[1]

  var width = ui.GetScreenWidth(), height = ui.GetScreenHeight()

  if ui.IsWindowResized() {
    ui.SetShaderValue(shader, resolution_loc, float2([width, height]), SHADER_UNIFORM_VEC2)
  }
  
  ui.BeginDrawing()
    ui.ClearBackground(RAYWHITE)

    ui.BeginShaderMode(shader)
      ui.DrawRectangle(0, 0, width, height, WHITE)
    ui.EndShaderMode()

    ui.DrawTextEx(font, '(c) Raymarching shader by Iñigo Quilez. MIT License.', Vector2(width - 280, height - 20), 10, 0, BLACK)
  ui.EndDrawing()
}

ui.UnloadShader(shader)
ui.CloseWindow()

