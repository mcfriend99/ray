import ..app { * }
import reflect
import os

var GLSL_VERSION = 330
var SCREEN_WIDTH = 1280
var SCREEN_HEIGHT = 615

var resource_dir = os.join_paths(os.dir_name(__file__), 'resources')

var ui = Init()

ui.SetConfigFlags(FLAG_MSAA_4X_HINT | FLAG_FULLSCREEN_MODE)
ui.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, 'Scarfy')
ui.InitAudioDevice()
ui.DisableCursor()

var jump_sound = ui.LoadSound(os.join_paths(resource_dir, 'jump.wav'))
var font = ui.GetFontDefault()

var background = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_background.png'))
var _background = DeTexture(background)
var midground = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_midground.png'))
var _midground = DeTexture(midground)
var foreground = ui.LoadTexture(os.join_paths(resource_dir, 'cyberpunk_street_foreground.png'))
var _foreground = DeTexture(foreground)

var scarfy = ui.LoadTexture(os.join_paths(resource_dir, 'scarfy.png'))
var coin = ui.LoadTexture(os.join_paths(resource_dir, 'coin-big.png'))
var _scarfy = DeTexture(scarfy)
var _coin = DeTexture(coin)
var coin_width = _coin.width / 6
var scarfy_width = _scarfy.width / 6

var position = Vector2(0, 435)
var frame_rec = Rectangle(0, 0, scarfy_width, _scarfy.height)

var page = 0
var game_time = to_int(rand(90, 300))

var enter_text = 'Press ENTER to start'
var enter2_text = 'Press ENTER to restart'
var game_over_text = 'Game Over'
var game_instruction = 'Win as many coins as you can before your time runs out.'
var scarfy_name_size = DeVector2(ui.MeasureTextEx(font, 'SCARFY', 30, 5))
var enter_ins_size = DeVector2(ui.MeasureTextEx(font, enter_text, 16, 2))
var enter2_size = DeVector2(ui.MeasureTextEx(font, enter2_text, 16, 5))
var instruction_size = DeVector2(ui.MeasureTextEx(font, game_instruction, 12, 2))
var game_over_size = DeVector2(ui.MeasureTextEx(font, game_over_text, 80, 10))
var game_frames = game_time * 60

var game_over_rec = Rectangle(
  (SCREEN_WIDTH - (game_over_size.x + 60)) / 2,
  (SCREEN_HEIGHT - (game_over_size.y + 120)) / 2,
  game_over_size.x + 60,
  game_over_size.y + 120
)
var _game_over_rec = DeRectangle(game_over_rec)

var scrolling_back = 0, scrolling_mid = 0, scrolling_fore = 0
var current_frame = 0, frame_speed = 8, frame_counter = 0
var global_counter = 0
var x_pos = 0, y_pos = 435
var max_x = SCREEN_WIDTH - (scarfy_width)
var min_y = 20
var flipped = false
var score = 0

class Coin {
  Coin(x, y) {
    self.x = x
    self.y = y
    self._x = 0
  }

  update(current_frame) {
    self._x = current_frame * coin_width
  }

  draw(ui) {
    ui.DrawTextureRec(
      coin, 
      Rectangle(self._x, 0, coin_width, _coin.height), 
      Vector2(self.x, self.y), 
      WHITE
    )
  }
}

class CoinBucket {
  var _coins = []
  var _count = 3
  var _duration = 300

  CoinBucket(ui) {
    self.ui = ui
  }

  populate() {
    if self._coins.is_empty() {
      self._count++
      for i in 0..(self._count) {
        self._coins.append(Coin(
          rand(SCREEN_WIDTH - coin_width),
          rand(20, SCREEN_HEIGHT - 60)
        ))
      }
      if self._count == 10 self._count = 2
    }
  }

  update(current_frame, frame_count, scarfy_rec) {
    if frame_count % self._duration == 0 {
      self.clear()
      self._duration -= 20
      if self._duration < 150 self._duration = 300
      return
    }
    
    self._coins.each(@(x, i) {
      if self.ui.CheckCollisionRecs(
        Rectangle(x_pos, y_pos, scarfy_width, _scarfy.height), 
        Rectangle(x.x, x.y, coin_width, _coin.height)
      ) {
        self._coins.remove_at(i)
        score += 5
        ui.PlaySound(jump_sound)
      }

      x.update(current_frame)
    })
  }

  draw() {
    self._coins.each(@(x) {
      x.draw(self.ui)
    })
  }

  count() {
    return self._coins.length()
  }

  clear() {
    self._coins.clear()
  }
}

ui.SetTargetFPS(60)

var bucket = CoinBucket(ui)
while !ui.WindowShouldClose() {
  global_counter++
  frame_counter++

  if page > 0 and global_counter < game_frames {
    if !flipped {
      scrolling_back -= 0.1
      scrolling_mid -= 0.5
      scrolling_fore -= 1
    } else if scrolling_fore < 0 {
      scrolling_back += 0.1
      scrolling_mid += 0.5
      scrolling_fore += 1
    }
  
    if scrolling_back <= (-_background.width * 3) scrolling_back = 0 
    if scrolling_mid <= (-_midground.width * 3) scrolling_mid = 0 
    if scrolling_fore <= (-_foreground.width * 3) scrolling_fore = 0 
  
    bucket.populate()
  
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
        current_frame * scarfy_width,
        _frame_rec.y,
        abs(_frame_rec.width) * (flipped ? -1 : 1),
        _frame_rec.height
      )
      bucket.update(current_frame, global_counter, frame_rec)
    }
  
    if ui.IsKeyDown(KEY_RIGHT) {
      x_pos += 5
      if x_pos > max_x x_pos = max_x 
      flipped = false
      scrolling_back -= 0.1
      scrolling_mid -= 0.5
      scrolling_fore -= 1
    } else if ui.IsKeyDown(KEY_LEFT) and scrolling_fore < 0 {
      x_pos -= 5
      if x_pos < 0 x_pos = 0 
      flipped = true
      scrolling_back += 0.1
      scrolling_mid += 0.5
      scrolling_fore += 1
    }
  }

  ui.BeginDrawing()
  using page {
    when 0 { # splash and home
      ui.ClearBackground(WHITE)
      ui.DrawTextureRec(scarfy, frame_rec, Vector2((SCREEN_WIDTH - scarfy_width) / 2, (SCREEN_HEIGHT - _scarfy.height) / 2), WHITE)
      ui.DrawRectangle(0, (((SCREEN_HEIGHT - _scarfy.height) / 2) + _scarfy.height) - 15, SCREEN_WIDTH, 20, WHITE)

      if frame_counter > 120 {
        ui.DrawTextEx(font, 'SCARFY', Vector2((SCREEN_WIDTH - scarfy_name_size.x) / 2, (((SCREEN_HEIGHT - _scarfy.height) / 2) + _scarfy.height) + 10), 30, 5, DARKBLUE)
        ui.DrawTextEx(font, game_instruction, Vector2((SCREEN_WIDTH - instruction_size.x) / 2, (((SCREEN_HEIGHT - _scarfy.height) / 2) + _scarfy.height) + 50), 12, 2, DARKGRAY)
        ui.DrawTextEx(font, enter_text, Vector2((SCREEN_WIDTH - enter_ins_size.x) / 2, (((SCREEN_HEIGHT - _scarfy.height) / 2) + _scarfy.height) + 100), 16, 2, DARKGRAY)

        if ui.IsKeyPressed(KEY_ENTER) {
          frame_counter = 0
          global_counter = 0
          page++
          ui.PlaySound(jump_sound)
        }
      }

      # Copyrights
      ui.DrawText('(c) Scarfy sprite by Eiden Marsal', SCREEN_WIDTH - 200, SCREEN_HEIGHT - 25, 10, GRAY)
      ui.DrawText('(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)', SCREEN_WIDTH - 330, SCREEN_HEIGHT - 10, 10, GRAY)
    }
    default { # game
      # ui.ClearBackground(ui.GetColor(0x052c46ff))
      ui.ClearBackground(BLACK)
  
      ui.DrawTextureEx(background, Vector2(scrolling_back, 20), 0, 3, WHITE)
      ui.DrawTextureEx(background, Vector2(_background.width * 3 + scrolling_back, 20), 0, 3, WHITE)
  
      ui.DrawTextureEx(midground, Vector2(scrolling_mid, 20), 0, 3, WHITE)
      ui.DrawTextureEx(midground, Vector2(_midground.width * 3 + scrolling_mid, 20), 0, 3, WHITE)
  
      ui.DrawTextureEx(foreground, Vector2(scrolling_fore, 20), 0, 3, WHITE)
      ui.DrawTextureEx(foreground, Vector2(_foreground.width * 3 + scrolling_fore, 20), 0, 3, WHITE)
  
      ui.DrawTextureRec(scarfy, frame_rec, Vector2(x_pos, y_pos), WHITE)
      bucket.draw()

      if global_counter > game_frames {
        ui.DrawRectangleRec(game_over_rec, BLACK)
        ui.DrawRectangleLinesEx(game_over_rec, 10, ORANGE)
        ui.DrawTextEx(font, game_over_text, Vector2(_game_over_rec.x + 30, _game_over_rec.y + 30), 80, 10, WHITE)
        
        var score_size = DeVector2(ui.MeasureTextEx(font, 'Score: ${score}', 30, 5))
        ui.DrawTextEx(font, 'Score: ${score}', Vector2(_game_over_rec.x + 30 + ((_game_over_rec.x + 60 - score_size.x) / 2), _game_over_rec.y + 110), 30, 5, ORANGE)

        ui.DrawTextEx(font, enter2_text, Vector2(_game_over_rec.x + 30 + ((_game_over_rec.x + 60 - enter2_size.x) / 2), _game_over_rec.y + 155), 16, 5, LIGHTGRAY)

        if ui.IsKeyPressed(KEY_ENTER) {
          global_counter = 0
          frame_counter = 0
          score = 0
          x_pos = 0
          y_pos = 435
          ui.PlaySound(jump_sound)
        }
      } else {
        ui.DrawText('Score: ${score}', 10, 0, 20, ORANGE)
      }
    }
  }
  ui.EndDrawing()
}

ui.UnloadSound(jump_sound)
ui.UnloadTexture(coin)
ui.UnloadTexture(scarfy)
ui.UnloadTexture(background)
ui.UnloadTexture(midground)
ui.UnloadTexture(foreground)

ui.CloseWindow()
