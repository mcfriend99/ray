import ..ray
import .progress { Progress }

class Slider < Progress {

  Slider(options) {
    parent(options)
    self.cursor = options.get('cursor', ray.MOUSE_CURSOR_POINTING_HAND)
    self.as_int = options.get('as_int', false)
    self.on_change = options.get('on_change', @(s, t){})
  }

  Paint(ui) {
    if !self.visible return

    var bound = ray.DeRectangle(self.bounds)

    var mousepos = ui.GetMousePosition()
    if ui.CheckCollisionPointRec(mousepos, self.bounds) {
      self._was_activated = true
    }

    if self._was_activated {
      if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) {
        var mouse_coords = ray.DeVector2(mousepos)
        var x = mouse_coords.x - (self.x + self.padding)
        self.value = self.min + ((x /  (self.width - (self.padding * 2))) * (self.max - self.min))
        if self.value < self.min self.value = self.min
        else if self.value > self.max self.value = self.max

        if self.as_int self.value = to_int(self.value)
        if self.on_change self.on_change(self, self.value)
      } else {
        self._was_activated = false
      }
    }

    parent.Paint(ui)
    var inner_bound = ray.DeRectangle(self._inner_bounds)

    ui.DrawRectangleRec(ray.Rectangle(
      inner_bound.x + inner_bound.width + self.padding - 5,
      bound.y - 2,
      10,
      bound.height + 4
    ), self.color)
  }
}
