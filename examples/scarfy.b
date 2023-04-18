import ..app { * }
import reflect
import os

var GLSL_VERSION = 330
var SCREEN_WIDTH = 1280
var SCREEN_HEIGHT = 615

var resource_dir = os.join_paths(os.dir_name(os.current_file()), 'resources')

var ui = Init()

ui.SetConfigFlags(FLAG_MSAA_4X_HINT | FLAG_FULLSCREEN_MODE)
ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Scarfy')

var background = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_background.png'))
var _background = DeTexture(background)
var midground = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_midground.png'))
var _midground = DeTexture(midground)
var foreground = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_foreground.png'))
var _foreground = DeTexture(foreground)

var scarfy = ui.LoadTexture(os.join_paths(resource_dir, 'scarfy.png'))
var _scarfy = DeTexture(scarfy)

var position = Vector2(0, 435)
var frame_rec = Rectangle(0, 0, _scarfy.width / 6, _scarfy.height)

var scrolling_back = 0, scrolling_mid = 0, scrolling_fore = 0
var current_frame = 0, frame_speed = 8, frame_counter = 0
var x_pos = 0, y_pos = 435
var max_x = SCREEN_WIDTH - (_scarfy.width / 6)
var min_y = (SCREEN_HEIGHT - _background.height) / 2
var flipped = false

ui.SetTargetFPS(60)

while !ui.WindowShouldClose() {
  frame_counter++
  if !flipped {
    scrolling_back -= 0.1
    scrolling_mid -= 0.5
    scrolling_fore -= 1
  } else if scrolling_fore != 0  and x_pos <= (_scarfy.width / 2) {
    scrolling_back += 0.1
    scrolling_mid += 0.5
    scrolling_fore += 1
  }

  if scrolling_back <= (-_background.width * 3) scrolling_back = 0 
  if scrolling_mid <= (-_midground.width * 3) scrolling_mid = 0 
  if scrolling_fore <= (-_foreground.width * 3) scrolling_fore = 0 

  if ui.IsKeyDown(KEY_SPACE) {
    y_pos -= 10
    if y_pos < min_y y_pos = min_y
  } else if y_pos < 435 {
    y_pos += 10
  }

  var _frame_rec = DeRectangle(frame_rec)
  if frame_counter >= (60 / frame_speed) {
    frame_counter = 0
    current_frame++

    if current_frame > 5 {
      current_frame = 0
    }

    frame_rec = Rectangle(
      current_frame * _scarfy.width / 6,
      _frame_rec.y,
      abs(_frame_rec.width) * (flipped ? -1 : 1),
      _frame_rec.height
    )
  }

  if ui.IsKeyDown(KEY_RIGHT) {
    x_pos += 5
    if x_pos > max_x x_pos = max_x 
    flipped = false
    scrolling_back -= 0.1
    scrolling_mid -= 0.5
    scrolling_fore -= 1
  } else if ui.IsKeyDown(KEY_LEFT) and scrolling_fore != 0 {
    x_pos -= 5
    if x_pos < 0 x_pos = 0 
    flipped = true
    if x_pos <= (_scarfy.width / 2) {
      scrolling_back += 0.1
      scrolling_mid += 0.5
      scrolling_fore += 1
    }
  }

  ui.BeginDrawing()
    # ui.ClearBackground(ui.GetColor(0x052c46ff))

    ui.DrawTextureEx(background, Vector2(scrolling_back, 20), 0, 3, WHITE)
    ui.DrawTextureEx(background, Vector2(_background.width * 3 + scrolling_back, 20), 0, 3, WHITE)

    ui.DrawTextureEx(midground, Vector2(scrolling_mid, 20), 0, 3, WHITE)
    ui.DrawTextureEx(midground, Vector2(_midground.width * 3 + scrolling_mid, 20), 0, 3, WHITE)

    ui.DrawTextureEx(foreground, Vector2(scrolling_fore, 20), 0, 3, WHITE)
    ui.DrawTextureEx(foreground, Vector2(_foreground.width * 3 + scrolling_fore, 20), 0, 3, WHITE)

    ui.DrawTextureRec(scarfy, frame_rec, Vector2(x_pos, y_pos), WHITE)
  ui.EndDrawing()
}

ui.UnloadTexture(background)
ui.UnloadTexture(midground)
ui.UnloadTexture(foreground)

ui.CloseWindow()
