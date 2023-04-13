import ..ray
import ..control { Control }

class Label < Control {

  Label(options) {
    parent(options)
    if !options options = {}

    self.font_size = options.get('font_size', self._default_font_size)
    self.font_color = options.get('font_color', self._default_font_color)
  }

  Paint(ui) {
    if !self.visible return
    parent.Paint(ui)

    var text = self.get_text()

    # if width is zero and auto_size is true, automatically set width.
    if self.width == 0 and self.auto_size {
      self.width = ray.DeVector2(
        ui.MeasureTextEx(self.font, text, self.font_size, 0)).x + 
        (self.padding * 2)
      self.bounds = ray.Rectangle(self.x, self.y, self.width, self.height)
    }

    ui.DrawTextEx(
      self.font, 
      text, 
      ray.Vector2(
        self.x + self.padding, 
        self.y + self.padding
      ), 
      self.font_size, 
      0, 
      self.font_color
    )
  }
}
