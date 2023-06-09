import os
import ..ray
import ..control { Control }

var _is_osx = os.platform == 'osx'

class Textbox <  Control {
  var _show_children = false
  var mouse_is_hover = false
  var was_activated = false
  var _frame_counter = 0

  # real text data
  var text = ''

  Textbox(options) {
    parent(options)

    if !options options = {}
    self.font_size = options.get('font_size', self._default_font_size)
    self.font_color = options.get('font_color', self._default_font_color)
    self.width = options.get('width', 200)
    self.cursor = options.get('cursor', ray.MOUSE_CURSOR_IBEAM)
    self.color = options.get('color', ray.RAYWHITE)
    self.border_color = options.get('border_color', ray.LIGHTGRAY)
    self.border_width = options.get('border_width', 1)
    self.hover_border_color = options.get('hover_border_color', ray.DARKGRAY)
    self.active_border_color = options.get('active_border_color', ray.BLUE)
    self.caret_color = options.get('caret_color', ray.DARKGRAY)
    self.max_length = options.get('max_length', -1)
    self.obscure_char = options.get('obscure_char', nil)
    if options.contains('font') {
      self.font = options.font
    }
    self.on_change = options.get('on_change', @(s,t){})

    if self.obscure_char and (!is_string(self.obscure_char) or self.obscure_char.length() > 1) {
      die Exception('invalid obscure character in ${typeof(self)}')
    }

    # update textbox bounds since default bound may have width set to zero.
    self.update_bounds()
  }

  Paint(ui) {
    parent.Paint(ui)

    # if height is zero and auto_size is true, automatically set height.
    if self.height == 0 and self.auto_size {
      self.height = ray.DeVector2(
        ui.MeasureTextEx(self.font, self.text ? self.text : 'y', self.font_size, 0)).y + 
        (self.padding * 2) + 
        (self.border_width * 2)
      self.update_bounds()
    }
  
    if self.was_activated self._frame_counter++
    else self._frame_counter = 0
  
    var can_blink = ((self._frame_counter / 20) % 2) <= 1
    var can_delete = ((self._frame_counter / 2) % 2) == 0
  
    if self.was_activated and self.enabled {
      # add new typed text
      var key = ui.GetCharPressed()
      while key > 0 {
        if key >= 32 and key <= 125 {
          if self.max_length == -1 or self.text.length() < self.max_length {
            self.text += chr(key)
          }
        }
  
        key = ui.GetCharPressed()

        if self.on_change self.on_change(self, self.text)
      }
  
      # delete on backspace
      if (ui.IsKeyPressed(ray.KEY_BACKSPACE) and !ui.IsKeyDown(ray.KEY_BACKSPACE)) or
        (ui.IsKeyDown(ray.KEY_BACKSPACE) and !ui.IsKeyPressed(ray.KEY_BACKSPACE) and can_delete) {
          self.text = self.text[,-1]
          if self.on_change self.on_change(self, self.text)
      }

      var ctrl_down = _is_osx ? (
        ui.IsKeyDown(ray.KEY_RIGHT_SUPER) or ui.IsKeyDown(ray.KEY_LEFT_SUPER)
      ) : (
        ui.IsKeyDown(ray.KEY_LEFT_CONTROL) or ui.IsKeyDown(ray.KEY_RIGHT_CONTROL)
      )

      # handle paste
      if ctrl_down and ui.IsKeyDown(ray.KEY_V) {
        self.text += ui.GetClipboardText()
        if self.on_change self.on_change(self, self.text)
      }
    }

    self.text = self.text.ascii()

    ui.DrawRectangleRec(self.bounds, self.color)
    var line_color = self.mouse_is_hover and !self.was_activated ? 
      self.hover_border_color : 
        (self.was_activated ? 
          self.active_border_color : 
          self.border_color
        )
    ui.DrawRectangleLinesEx(self.bounds, self.border_width, line_color)

    var chars_shown
    var text_width = ray.DeVector2(ui.MeasureTextEx(self.font, self.text, self.font_size, 0)).x
    var max_width = self.width - (self.padding * 2) - (self.border_width * 2) - 1
    if text_width < max_width {
      chars_shown = self.text
    } else {
      var ratio = self.width/(text_width + (self.padding * 2) + (self.border_width * 2) + 1)
      if self.was_activated {
        var start = (self.text.length() - (ratio * self.text.length()) + 1) // 1
        chars_shown = self.text[start+1,]
        while ray.DeVector2(ui.MeasureTextEx(self.font, chars_shown, self.font_size, 0)).x >= max_width
          chars_shown = chars_shown[1,]
      } else {
        var end = (ratio * self.text.length()) // 1
        chars_shown = self.text[,end]
        while ray.DeVector2(ui.MeasureTextEx(self.font, chars_shown, self.font_size, 0)).x >= max_width
          chars_shown = chars_shown[,-1]
      }
    }

    if self.obscure_char {
      chars_shown = self.obscure_char * chars_shown.length()
    }

    ui.DrawTextEx(
      self.font, 
      chars_shown, 
      ray.Vector2(
        self.rect.x + self.padding + self.border_width, 
        self.rect.y + self.padding + self.border_width
      ), 
      self.font_size, 
      0, 
      self.font_color
    )

    if self.was_activated and can_blink {
      # Draw the caret
      var current_text_size = ray.DeVector2(
        ui.MeasureTextEx(self.font, chars_shown, self.font_size, 0)
      )
      var caret_x = self.rect.x + self.padding + current_text_size.x + self.border_width + 1
      var caret_ys = self.rect.y + self.padding + self.border_width - 1
      var caret_ye = self.rect.y + current_text_size.y + self.padding + self.border_width + 1
      ui.DrawLineBezier(
        ray.Vector2(caret_x, caret_ys), 
        ray.Vector2(caret_x, caret_ye), 
        1, 
        self.caret_color
      )
    }
  }
}

