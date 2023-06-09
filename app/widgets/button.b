import ..ray
import ..control { Control }

class Button < Control {
  var _show_children = false

  Button(options) {
    parent(options)
    if !options options = {}

    self.font_size = options.get('font_size', self._default_font_size)
    self.font_color = options.get('font_color', ray.WHITE)
    self.color = options.get('color', self._theme_color)
    self.hover_color = options.get('hover_color', ray.BLUE)
    self.active_color = options.get('active_color', ray.BLUE)
    self.padding = options.get('padding', 6)
    self.y_padding = options.get('y_padding', self.padding)
    self.x_padding = options.get('x_padding', self.padding)
    self.cursor = options.get('cursor', ray.MOUSE_CURSOR_POINTING_HAND)
  }

  Paint(ui) {
    parent.Paint(ui)

    var text = self.get_text()
    var text_size = ray.DeVector2(ui.MeasureTextEx(self.font, text, self.font_size, 0))

    # if height is zero and auto_size is true, automatically set height.
    if self.height == 0 and self.auto_size {
      self.height = text_size.y +  (self.y_padding * 2)
      self.update_bounds()
    }

    # if width is zero and auto_size is true, automatically set width.
    if self.width == 0 and self.auto_size {
      self.width = text_size.x + (self.x_padding * 2)
      self.update_bounds()
    }

    ui.DrawRectangleRec(
      self.bounds, 
      self.mouse_is_hover ? self.hover_color : self.color
    )
    ui.DrawTextEx(
      self.font, 
      text, 
      ray.Vector2(
        self.rect.x + ((self.rect.width - (text_size.x + (self.x_padding / 2))) / 2), 
        self.rect.y + self.y_padding
      ), 
      self.font_size, 
      0, 
      self.font_color
    )
  }
}
