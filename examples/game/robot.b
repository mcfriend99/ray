import ..app { * }
import reflect
import os
import clib
import struct

var GLSL_VERSION = 330
var SCREEN_WIDTH = 800
var SCREEN_HEIGHT = 450

var animation_file = os.join_paths(os.dir_name(os.current_file()), 'resources', 'models', 'gltf', 'robot.glb')

var ui = Init()

ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Animation Example')

# Create fine tuned font...
var font = ui.LoadFont(os.join_paths(os.dir_name(os.dir_name(os.dir_name(os.current_file()))), 'fonts', 'Segoe UI.ttf'))
var t1 = DeFont(font).texture
var texture = Texture2D(t1.id, t1.width, t1.height, t1.mipmaps, t1.format)
ui.SetTextureFilter(texture, TEXTURE_FILTER_TRILINEAR)

# Define the camera to look into our 3d world
var camera = Camera(
  Vector3(5, 5, 5),   # position
  Vector3(0, 2, 0),   # target
  Vector3(0, 1, 0),   # up
  45,                     # fovy
  CAMERA_PERSPECTIVE # projection
)

var position = Vector3(0, 0, 0)
var model = ui.LoadModel(animation_file)

var anims_count = 0
var anim_index = 0
var anim_current_frame = 0

var counts = struct.pack('i', 0)
var model_animation = ui.LoadModelAnimations(animation_file, reflect.get_ptr(counts))
anims_count = struct.unpack('i', counts)[1]
echo 'Animations in file: ${anims_count}...'

# ui.DisableCursor()
ui.SetTargetFPS(60)

while !ui.WindowShouldClose() {
  ui.UpdateCamera(reflect.get_ptr(camera), CAMERA_THIRD_PERSON)

  if ui.IsKeyPressed(KEY_UP) anim_index = (anim_index + 1) % anims_count
  else if ui.IsKeyPressed(KEY_DOWN) anim_index = (anim_index + anims_count - 1) % anims_count

  var anim = clib.get_ptr_index(model_animation, ModelAnimationType, anim_index)
  var _anim = DeModelAnimation(anim)
  anim_current_frame = (anim_current_frame + 1) % _anim.frameCount

  ui.UpdateModelAnimation(model, anim, anim_current_frame)

  ui.BeginDrawing()
    ui.ClearBackground(RAYWHITE)
    ui.BeginMode3D(camera)
      ui.DrawModel(model, position, 1, WHITE)
      ui.DrawGrid(10, 1)
    ui.EndMode3D()
    ui.DrawTextEx(font, 'Use the UP/DOWN arrow keys to switch animation', Vector2(10, 10), 20, 0, GRAY)
  ui.EndDrawing()
}

ui.UnloadModel(model)
ui.CloseWindow()
