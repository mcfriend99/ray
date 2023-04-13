import ..ray
import ..control { Control }

class Box < Control {

  Box(options) {
    parent(options)
  }

  Paint(ui) {
    if !self.visible return
    parent.Paint(ui)
    ui.DrawRectangleRec(self.bounds, self.color)
  }
}
