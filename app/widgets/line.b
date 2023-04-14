import ..ray
import ..control { Control }

class Line < Control {
  var _show_children = false

  Line(options) {
    parent(options)
    if !options options = {}
    self.thickness = options.get('thickness', 1)
  }

  Paint(ui) {
    if !self.visible return
    parent.Paint(ui)
    var bounds = ray.DeRectangle(self.bounds)

    ui.DrawLineEx(
      ray.Vector2(bounds.x, bounds.y),
      ray.Vector2(bounds.x + bounds.width, bounds.y),
      self.thickness,
      self.color
    )
  }
}
