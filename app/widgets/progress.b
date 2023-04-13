import ..ray
import ..control { Control }

class Progress < Control {

  Progress(options) {
    parent(options)
    if !options options = {}
    self.padding = options.get('padding', 2)
    self.width = options.get('width', 200)
    self.height = options.get('height', 6)
    self.min = options.get('min', 0)
    self.max = options.get('max', 100)
    self.value = options.get('value', 0)
    self.indeterminate = options.get('indeterminate', false)
    self.color = options.get('color', ray.BLUE)
    self.background_color = options.get('background_color', ray.SKYBLUE)

    # update progress bounds since default bound may have width set to zero.
    self.bounds = ray.Rectangle(self.x, self.y, self.width, self.height)
  }

  Paint(ui) {
    if !self.visible return
    parent.Paint(ui)
    var bounds = ray.DeRectangle(self.bounds)
    var inner_width = bounds.width - (self.padding * 2)
    var inner_height = bounds.height - (self.padding * 2)

    var inner_bounds
    if !self.indeterminate {
      inner_bounds = ray.Rectangle(
        bounds.x + self.padding,
        bounds.y + self.padding,
        (self.value / (self.max - self.min)) * inner_width,
        inner_height
      )
    } else {
      inner_bounds = ray.Rectangle(
        bounds.x + self.padding + ((microtime() / 5000) % (inner_width - (inner_width * 0.3))),
        bounds.y + self.padding,
        inner_width * 0.3,
        inner_height
      )
    }

    # draw outer
    ui.DrawRectangleRec(self.bounds, self.background_color)
    # draw inner
    ui.DrawRectangleRec(inner_bounds, self.color)
  }
}
