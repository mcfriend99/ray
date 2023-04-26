import ..ray
import ..control { Control }
import .box
import .label
import .line
import .button
import .form { Form }

class Message < Control {
  var _original_bounds

  Message(options) {
    parent(options)
    if !options options = {}

    self.title = options.get('title', nil)
    self.width = options.get('width', 0)
    self.height = options.get('height', 0)
    self.movable = options.get('movable', true)
    self.color = options.get('color', ray.WHITE)
    self.title_color = options.get('title_color', self._theme_color)
    self.title_font_color = options.get('title_font_color', ray.WHITE)
    self.on_close = options.get('on_close', @(){})

    if self.padding < 20 self.padding = 20

    self.children = [
      label.Label({
        text: self.get_title,
        padding: 5,
        color: self.title_font_color,
        background_color: self.title_color,
        cursor: ray.MOUSE_CURSOR_POINTING_HAND,
        font_size: 16,
      }),
      label.Label({
        text: self.get_text,
        padding: self.padding,
        background_color: self.color,
        font_size: 16,
      }),
      line.Line(),
      button.Button({
        text: 'OK',
        padding: 5,
        x_padding: 15,
        font_size: 16,
        on_click: @(s, e) {
          if self.on_close {
            self.on_close()
          }
          if !self.is_visible() {
            self.form.unlock()
            self.reset()
          }
        },
      }),
    ]
  }

  reset() {
    self._original_bounds = nil
  }

  get_title() {
    if is_function(self.title)
      return to_string(self.title())
    return self.title ? self.title : self.form.title
  }

  Paint(ui) {
    if !instance_of(self.ancestor, Form) {
      die Exception('Message can only have a Form ancestor')
    }

    self.form.lock(self)

    parent.Paint(ui)

    if !self._original_bounds and self.form {
      var title_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, self.get_title(), 16, 0))
      var text_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, self.get_text(), 16, 0))
      var ok_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, 'OK', 16, 0))
      ok_bounds.x += 30
      ok_bounds.y += 10
      
      var w_text = text_bounds.x + (self.padding * 2)
      var w_title = title_bounds.x + (self.padding * 2)

      self.width = (w_text > w_title ? w_text : w_title)
      self.height = (title_bounds.y + 10) + (text_bounds.y + (self.padding * 2)) + (ok_bounds.y + 14)

      self.children[0].width = self.width
      self.children[1].width = self.width
      self.children[2].width = self.width

      self.children[0].height = title_bounds.y + 10
      self.children[1].x = (self.width - w_text) / 2
      self.children[1].y = title_bounds.y + 10
      self.children[2].y = text_bounds.y + title_bounds.y + (self.padding * 2) + 11
      self.children[3].y = self.children[2].y + 6
      self.children[3].x = self.width - ok_bounds.x - 7

      self.children[2].color = ui.Fade(ray.DARKGRAY, 0.1)

      self.x = (self.form.width - self.width) / 2
      self.y = (self.form.height - self.height) / 2
      
      self._original_bounds = {x: self.x, y: self.y}
      self.update_bounds()
    }

    if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) and self.movable {
      if ui.CheckCollisionPointRec(ui.GetMousePosition(), self.children[0].bounds) {
        var xy = ray.DeVector2(ui.math.Vector2Add(ray.Vector2(self.x, self.y), ui.GetMouseDelta()))
        self.x = xy.x
        self.y = xy.y
        self.update_bounds()
      }
    }

    ui.DrawRectangleRec(self.bounds, self.color)
    ui.DrawRectangleLinesEx(self.bounds, 1, self.title_color)
  }
}
