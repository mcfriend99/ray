import ..ray
import ..control { Control }

class Box < Control {

  Box(options) {
    parent(options)
  }

  Paint(ui) {
    parent.Paint(ui)
    ui.DrawRectangleRec(self.bounds, self.color)
  }
}
