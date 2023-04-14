import ..ray
import ..control { Control }
import .box
import .label
import .line
import .button

class Message < Control {

  Message(options) {
    parent(options)
    if !options options = {}

    self.title = options.get('title', 'Untitled')
    self.width = options.get('width', 0)
    self.height = options.get('height', 0)
    self.color = options.get('color', ray.WHITE)
    self.title_color = options.get('title_color', self._theme_color)
    self.title_font_color = options.get('title_font_color', ray.WHITE)

    if self.padding < 20 self.padding = 20

    self.children = [
      box.Box({
        children: [
          label.Label({
            text: self.title,
            padding: 5,
            color: self.title_font_color
          })
        ],
        color: self.title_color,
        cursor: ray.MOUSE_CURSOR_POINTING_HAND,
      }),
      label.Label({
        text: self.text,
        padding: self.padding,
      }),
      box.Box({
        children: [
          button.Button({
            x: 5,
            y: 5,
            text: 'OK',
            padding: 5,
          }),
        ],
        color: self.color,
      }),
      line.Line({

      }),
    ]
  }

  Paint(ui) {
    parent.Paint(ui)

    var title_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, self.title, 20, 0))
    var text_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, self.text, 20, 0))
    if self.width == 0 {
      self.width = text_bounds.x + (self.padding * 2)
      self.update_bounds()
    }
    if self.height == 0 {
      self.height = (title_bounds.y * 2) + text_bounds.y + (self.padding * 2) + 25
      self.update_bounds()
    }

    self.children[0].width = self.width
    self.children[1].width = self.width
    self.children[2].width = self.width
    self.children[3].width = self.width

    self.children[0].height = title_bounds.y + 10
    self.children[2].height = title_bounds.y + 20
    self.children[1].y = title_bounds.y + 10
    self.children[3].y = text_bounds.y + title_bounds.y + (self.padding * 2) + 11
    self.children[2].y = self.children[3].y + 2

    for child in self.children {
      child.update_bounds()
    }

    if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) {
      if ui.CheckCollisionPointRec(ui.GetMousePosition(), self.children[0].bounds) {
        var xy = ray.DeVector2(ui.math.Vector2Add(ray.Vector2(self.x, self.y), ui.GetMouseDelta()))
        self.x = xy.x
        self.y = xy.y
        self.update_bounds()
      }
    }

    ui.DrawRectangleRec(self.bounds, self.color)
  }
}
