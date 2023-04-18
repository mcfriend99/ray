import ..app { * }
import reflect
import os

var GLSL_VERSION = 330
var SCREEN_WIDTH = 800
var SCREEN_HEIGHT = 450

var ui = Init()

ui.SetConfigFlags(FLAG_MSAA_4X_HINT)
ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Plane Example')

# Create fine tuned font...
var font = ui.LoadFont(os.join_paths(os.dir_name(os.dir_name(os.current_file())), 'fonts', 'abeezee.ttf'))
var t1 = ray.DeFont(font).texture
var texture = ray.Texture2D(t1.id, t1.width, t1.height, t1.mipmaps, t1.format)
ui.SetTextureFilter(texture, ray.TEXTURE_FILTER_TRILINEAR)

# Define the camera to look into our 3d world
var camera = Camera(
  Vector3(0, 50, -120),   # position
  Vector3(0, 0, 0),   # target
  Vector3(0, 1, 0),   # up
  30,                     # fovy
  CAMERA_PERSPECTIVE # projection
)

var model = ui.LoadModel(os.join_paths(os.dir_name(os.current_file()), 'resources', 'models', 'obj', 'plane.obj'))
var texture = ui.LoadTexture(os.join_paths(os.dir_name(os.current_file()), 'resources', 'models', 'obj', 'plane_diffuse.png'))
ui.SetMaterialTexture(
  DeModel(model).materials, 
  MATERIAL_MAP_DIFFUSE, 
  texture
)

var pitch = 0, roll = 0, yaw = 0, base = -10
var has_moved = false
var frame_count = 0, multiplier = 1

ui.SetTargetFPS(60)

while !ui.WindowShouldClose() {
  # plane pitch (x-axis) control
  if ui.IsKeyDown(KEY_W) pitch += 0.6
  else if ui.IsKeyDown(KEY_Z) pitch -= 0.6
  else {
    if pitch > 0.3 pitch -= 0.3
    else if pitch < -0.3 pitch += 0.3
  }

  # plane yaw (y-axis) control
  if ui.IsKeyDown(KEY_A) yaw -= 1
  else if ui.IsKeyDown(KEY_S) yaw += 1
  else {
    if yaw > 0 yaw -= 0.5
    else if yaw < 0 yaw += 0.5
  }

  # plane roll (z-axis) control
  if ui.IsKeyDown(KEY_LEFT) roll -= 1
  else if ui.IsKeyDown(KEY_RIGHT) roll += 1
  else {
    if roll > 0 roll -= 0.5
    else if roll < 0 roll += 0.5
  }

  # plane base (distance) control
  if ui.IsKeyDown(KEY_UP) {
    if ((frame_count / 20) % 2) == 0 and multiplier < 3 {
      multiplier += 0.001
    }

    base += multiplier
    if(base > 100) base = -20
    has_moved = true
  }
  else if ui.IsKeyDown(KEY_DOWN) {
    base -= multiplier
    if base < -20 base = 100
  }
  else if has_moved {
    multiplier = 1
    if base < -20 base += 1
  }

  # transformation matrix for rotations
  var transform = ui.math.MatrixRotateXYZ(Vector3(DEG2RAD * pitch, DEG2RAD * yaw, DEG2RAD * roll))
  iter var i = 0; i < transform.length(); i++ {
    model[i] = transform[i]
  }

  ui.BeginDrawing()
    ui.ClearBackground(SKYBLUE)
    ui.BeginMode3D(camera)
      ui.DrawModel(model, Vector3(0, -8, base), 1, WHITE)
      # ui.DrawGrid(10, 10)
    ui.EndMode3D()

    ui.DrawRectangle(10, 370, 160, 70, ui.Fade(GREEN, 0.5))
    ui.DrawRectangleLines(10, 370, 160, 70, ui.Fade(DARKGREEN, 0.5))
    ui.DrawTextEx(font, 'Move: Arrow Up', Vector2(20, 376), 12, 0, DARKGRAY)
    ui.DrawTextEx(font, 'Pitch: W (Left) / Z (Right)', Vector2(20, 392), 12, 0, DARKGRAY)
    ui.DrawTextEx(font, 'Roll: A (Left) / S (Right)', Vector2(20, 408), 12, 0, DARKGRAY)
    ui.DrawTextEx(font, 'Yaw: Arrow Left / Arrow Right', Vector2(20, 424), 12, 0, DARKGRAY)
    ui.DrawTextEx(font, '(c) WWI Plane Model created by GiaHanLam', Vector2(SCREEN_WIDTH - 220, SCREEN_HEIGHT - 20), 12, 0, DARKGRAY)
  ui.EndDrawing()
}

ui.UnloadModel(model)
ui.CloseWindow()

