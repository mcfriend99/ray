import reflect
import os
import ..ray
import ..control { Control }

var _default_font_file = os.join_paths(os.dir_name(os.current_file()), '../../fonts/Segoe UI.ttf')

class Form < Control {
  var is_running = false
  var _el_id = 0
  var _active_id = -1
  var _child_list = []
  var _locked_to = nil

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

  _handle_mouse_events(ui, el, mousepos, mousepos_coords) {
    if el.id > self._active_id {
      ui.SetMouseCursor(el.cursor)
      self._active_id = el.id
    }
    
    mousepos_coords.x -= el.rect.x
    mousepos_coords.y -= el.rect.y
    
    el.mouse_is_hover = true
    if ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_LEFT) {
      el.clicked(self.ui, mousepos_coords)
      el.has_mouse_down = false
      el.was_activated = true
      el.was_context_clicked = false
    } else if(ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_RIGHT)) {
      el.context_clicked(self.ui, mousepos_coords)
      el.has_mouse_down = false
      el.was_context_clicked = true
    } else if(ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT)) {
      el.mouse_down(self.ui, mousepos_coords)
      el.has_mouse_down = true
      el.was_activated = true
    } else if(ui.IsMouseButtonUp(ray.MOUSE_BUTTON_LEFT)) {
      el.mouse_up(self.ui, mousepos_coords)
      el.has_mouse_down = false
    } else {
      el.has_mouse_down = false
      el.was_context_clicked = false
      el.was_activated = false
    }
  }

  _Paint(ui, el, mousepos) {
    if el != self {
      self._child_list.append(el)
      el.id = self._el_id++
      el.form = self
    }

    var active_found = false
    ui.BeginScissorMode(el.rect.x, el.rect.y, el.rect.width, el.rect.height)
    if !el.can_have_child() {
      return active_found
    }

    for child in el.children {
      if is_function(child) {
        child = child()
      }

      if child != nil {
        if !instance_of(child, Control) {
          die Exception('invalid control in UI')
        } else if !reflect.has_prop(child, 'font') {
          child.font = self.font
        }

        child.form = self
        if child.is_visible() {
          child.ancestor = el
          self._child_list.append(child)
          child.id = self._el_id++

          if self._locked_to == child {
            # paint the background blur
            ui.DrawRectangleRec(self.bounds, ui.Fade(ray.BLACK, 0.3))
          }

          child.update_bounds()
          child.Paint(ui)

          if child.children {
            self._Paint(ui, child, mousepos)
          }
        }
      }
    }

    ui.EndScissorMode()
    return active_found
  }

  lock(el) {
    self._locked_to = el
  }

  locked_to(el) {
    return !self._locked_to or self._locked_to == el
  }

  unlock() {
    self._locked_to = false
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

    while !self.ui.WindowShouldClose() {
      self._el_id = -1
      self._child_list.clear()

      self.width = self.ui.GetRenderWidth()
      self.height = self.ui.GetRenderHeight()
      self.update_bounds()

      self.ui.BeginDrawing()
      {
        self.ui.ClearBackground(self.color)
        var mousepos = self.ui.GetMousePosition()
        var mousepos_coords = ray.DeVector2(mousepos)
        self._Paint(self.ui, self, mousepos)

        var form_active_found = false

        iter var i = self._child_list.length() - 1; i >= 0; i-- {
          var child = self._child_list[i]

          if !form_active_found and self.ui.CheckCollisionPointRec(mousepos, child.bounds) and
            self.ui.CheckCollisionPointRec(mousepos, child.ancestor.bounds) {
            if self._locked_to {
              if child != self._locked_to and !child.is_child_of(self._locked_to) {
                continue
              }
            }

            form_active_found = true
            self._handle_mouse_events(self.ui, child, mousepos, mousepos_coords)
            self.ui.SetMouseCursor(child.cursor)
          } else {
            child.mouse_is_hover = false
            child.was_context_clicked = false
            if self.ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_LEFT) or self.ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_RIGHT) {
              child.blured(self.ui)
              child.was_activated = false
              child.has_mouse_down = false
              child.was_context_clicked = false
            }
          }
        }

        if !form_active_found {
          self.ui.SetMouseCursor(self._default_cursor)
          if(self.ui.IsMouseButtonReleased(ray.MOUSE_BUTTON_RIGHT)) {
            self.context_clicked(self.ui, mousepos_coords)
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

