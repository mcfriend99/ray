import ..ray
import ..control { Control }

class Label < Control {
  var _show_children = false

  Label(options) {
    parent(options)
    if !options options = {}

    self.font_size = options.get('font_size', self._default_font_size)
    self.color = options.get('color', self._default_font_color)
    self.background_color = options.get('background_color', ray.TRANSPARENT)
  }

  Paint(ui) {
    parent.Paint(ui)

    var text = self.get_text()

    # if width is zero and auto_size is true, automatically set width.
    if self.width == 0 and self.auto_size {
      self.width = ray.DeVector2(
        ui.MeasureTextEx(self.font, text, self.font_size, 0)).x + 
        (self.padding * 2)
      self.update_bounds()
    }

    ui.DrawRectangleRec(self.bounds, self.background_color)
    ui.DrawTextEx(
      self.font, 
      text, 
      ray.Vector2(
        self.rect.x + self.padding, 
        self.rect.y + self.padding
      ), 
      self.font_size, 
      0, 
      self.color
    )
  }
}
