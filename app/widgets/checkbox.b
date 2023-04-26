import ..ray
import ..control { Control }

class Checkbox < Control {
  var _show_children = false
  var checked = false

  Checkbox(options) {
    parent(options)
    if !options options = {}

    self.font_size = options.get('font_size', self._default_font_size)
    self.font_color = options.get('font_color', self._default_font_color)
    self.color = options.get('color', ray.RAYWHITE)
    self.check_color = options.get('check_color', ray.BLUE)
    self.checked = options.get('checked', self.checked)

    if self.width == 0 self.width = 16
    if self.height != self.width self.height = self.width # height and width must always be the same

    if self.width < 16 {
      self.width = self.height = 8
    }

    self.update_bounds()
  }

  is_checked() {
    if is_function(self.checked) return self.checked()
    return self.checked
  }

  Paint(ui) {
    parent.Paint(ui)

    var text = self.get_text()
    var text_size = ray.DeVector2(ui.MeasureTextEx(self.font, text, self.font_size, 0))

    ui.DrawRectangleRec(self.bounds, self.color)

    if self.mouse_is_hover {
      if ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_LEFT) {
        self.checked = !self.checked
      }
    }

    if self.is_checked() {
      ui.DrawRectangleRec(ray.Rectangle(
        self.rect.x + 4, self.rect.y + 4, self.rect.width - 8, self.rect.height - 8
      ), self.check_color)
    }

    ui.DrawTextEx(
      self.font, 
      text, 
      ray.Vector2(
        self.rect.x + self.width + 5, 
        self.rect.y + ((self.height - text_size.y) / 2)
      ), 
      self.font_size, 
      0, 
      self.font_color
    )

    ui.DrawRectangleLinesEx(self.bounds, 1, self.check_color)
  }
}
