import reflect
import os
import ..ray
import ..control { Control }

var _default_font_file = os.join_paths(os.dir_name(os.current_file()), '../../fonts/Segoe UI.ttf')

class Form < Control {
  var is_running = false

  Form(ui, options) {
    parent(options)
    if !options options = {}
    self.ui = ui
    if self.width < 50 self.width = 50
    if self.height < 10 self.height = 50

    self.font = options.get('font', _default_font_file)
    self.resizable = options.get('resizable', true)
    self.title = options.get('title', self.text)
  }

  _Paint(ui, el, mousepos) {
    var active_found = false
    ui.BeginScissorMode(el.rect.x, el.rect.y, el.rect.width, el.rect.height)
    if !el.can_have_child() return active_found

    for child in el.children {
      if is_function(child) child = child()
      if child != nil {
        if !instance_of(child, Control)
          die Exception('invalid control in UI')
        if !reflect.has_prop(child, 'font') {
          child.font = self.font
        }
        if child.is_visible() {
          child._parent = el

          # update cursor
          if self.ui.CheckCollisionPointRec(mousepos, child.bounds) {
            child._is_form_active = true
            active_found = true
          } else {
            # child._is_form_active = false
          }

          child.update_bounds()
          child.Paint(self.ui)

          if child.children {
            var has_active_child = self._Paint(ui, child, mousepos)

            # TODO: Review this. This might be a bad idea
            if has_active_child {
              child._is_form_active = false
            }
          }
        }
      }
    }

    ui.EndScissorMode()
    return active_found
  }

  Paint() {
    var flags = ray.FLAG_MSAA_4X_HINT | ray.FLAG_WINDOW_HIGHDPI | ray.FLAG_VSYNC_HINT
    if self.resizable {
      flags |= ray.FLAG_WINDOW_RESIZABLE
    }

    self.ui.SetConfigFlags(flags)
    self.ui.InitWindow(self.width, self.height, self.title)
    self.ui.SetExitKey(ray.KEY_NULL)  # disable the default raylib esc to exit behavior
    self.ui.SetTargetFPS(50) # try at 60
    self.is_running = true

    # properly load the font from the name.
    if is_string(self.font) {
      self.font = self.load_font(self.ui, self.font)
    }

    # reset x and y so that generations can get correct 
    # coordinates within the form.
    self.x = 0
    self.y = 0
    self.update_bounds()

    while !self.ui.WindowShouldClose() {
      self.ui.BeginDrawing()
      {
        self.ui.ClearBackground(self.color)
        var mousepos = self.ui.GetMousePosition()
        var form_active_found = self._Paint(self.ui, self, mousepos)

        if !form_active_found {
          self.ui.SetMouseCursor(self._default_cursor)
          if(self.ui.IsMouseButtonDown(ray.MOUSE_BUTTON_RIGHT)) {
            var mousepos_coords = ray.DeVector2(mousepos)
            if self.context_listener self.context_listener(self, mousepos_coords)
          }
        }
      }
      self.ui.EndDrawing()
    }
  }

  Dispose() {
    for child in self.children {
      if is_function(child) child = child()
      if child != nil {
        if(!instance_of(child, Control))
          die Exception('invalid control in UI')
        child.Dispose(self.ui)
      }
    }
    if !is_string(self.font) self.ui.UnloadFont(self.font)
    if self.is_running self.ui.CloseWindow()
  }
}

