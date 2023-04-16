import ..ray
import ..control { Control }
import .box
import .label
import .line
import .button
import .form { Form }

class Message < Control {

  Message(options) {
    parent(options)
    if !options options = {}

    self.title = options.get('title', 'Untitled')
    self.width = options.get('width', 0)
    self.height = options.get('height', 0)
    self.movable = options.get('movable', true)
    self.color = options.get('color', ray.WHITE)
    self.title_color = options.get('title_color', self._theme_color)
    self.title_font_color = options.get('title_font_color', ray.WHITE)
    self.on_close = options.get('on_close', @(){})

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
            x_padding: 15,
            on_click: @(s, e) {
              if self.on_close {
                self.on_close()
              }
              if !self.is_visible() {
                self.form.unlock()
              }
            },
          }),
        ],
        color: self.color,
      }),
      line.Line(),
    ]
  }

  get_title() {
    if is_function(self.title)
      return to_string(self.title())
    return self.title ? self.title : ''
  }

  Paint(ui) {
    if !instance_of(self.ancestor, Form) {
      die Exception('Message can only have a Form ancestor')
    }

    self.form.lock(self)

    parent.Paint(ui)

    var text = self.get_text()
    var title = self.get_title()

    var title_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, title, 20, 0))
    var text_bounds = ray.DeVector2(ui.MeasureTextEx(self.font, text, 20, 0))
    
    var w_text = text_bounds.x + (self.padding * 2)
    var w_title = title_bounds.x + (self.padding * 2)

    self.width = (w_text > w_title ? w_text : w_title)
    self.height = (title_bounds.y * 2) + text_bounds.y + (self.padding * 2) + 25

    self.children[0].width = self.width
    self.children[1].width = self.width
    self.children[2].width = self.width
    self.children[3].width = self.width

    self.children[0].height = title_bounds.y + 10
    self.children[2].height = title_bounds.y + 20
    self.children[1].y = title_bounds.y + 10
    self.children[3].y = text_bounds.y + title_bounds.y + (self.padding * 2) + 11
    self.children[2].y = self.children[3].y + 2

    self.children[3].color = ui.Fade(ray.DARKGRAY, 0.1)
    
    self.update_bounds()

    if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) and self.movable {
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
