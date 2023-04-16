import .ray

class Control {
  # private props
  var _show_children = true
  var _default_font_size = 16
  var _default_font_color = ray.Color(90, 90, 90, 255)
  var _theme_color = ray.Color(0, 100, 200, 255)
  var _default_cursor = ray.MOUSE_CURSOR_DEFAULT

  # states
  var mouse_is_hover = false
  var was_activated = false
  var was_clicked = false
  var was_right_clicked = false
  var _is_form_active = false

  # relation
  var ancestor

  # public props
  var rect = {}

  Control(options) {
    if !options options = {}

    # properties
    self.x = options.get('x', 0)
    self.y = options.get('y', 0)
    self.height = options.get('height', 0)
    self.width = options.get('width', 0)
    self.text = options.get('text', '')
    self.padding = options.get('padding', 5)
    self.children = options.get('children', [])
    self.color = options.get('color', ray.GRAY)
    self.cursor = options.get('cursor', self._default_cursor)
    self.enabled = options.get('enabled', true)
    self.visible = options.get('visible', true)
    self.auto_size = options.get('auto_size', true)

    # event listeners
    self.click_listener = options.get('on_click', @(sender, data){})
    self.context_listener = options.get('on_context', @(sender, data){})
    self.mouse_over_listener = options.get('on_mouse_over', @(sender, data){})
    self.mouse_down_listener = options.get('on_mouse_down', @(sender, data){})
    self.blur_listener = options.get('on_blur', @(sender, data){})

    # auto sets
    self.update_bounds()
  }

  can_have_child() {
    return self._show_children
  }

  get_text() {
    if is_function(self.text)
      return to_string(self.text())
    return self.text ? self.text : ''
  }

  is_visible() {
    if is_function(self.visible)
      return self.visible()
    return self.visible
  }

  load_font(ui, path) {
    var font = ui.LoadFontEx(path, 56, nil, 0)
    var t1 = ray.DeFont(font).texture
    var texture = ray.Texture2D(
      t1.id,
      t1.width,
      t1.height,
      t1.mipmaps,
      t1.format
    )
    ui.SetTextureFilter(texture, ray.TEXTURE_FILTER_TRILINEAR)
    return font
  }

  update_bounds(width, height) {
    if !width width = self.width
    if !height height = self.height

    if self.ancestor != nil {
      self.bounds = ray.Rectangle(
        self.ancestor.rect.x + self.x, 
        self.ancestor.rect.y + self.y, 
        width, 
        height
      )

      self.rect = {
        x: self.ancestor.rect.x + self.x,
        y: self.ancestor.rect.y + self.y,
        width,
        height,
      }
    } else {
      self.bounds = ray.Rectangle(
        self.x, 
        self.y, 
        width, 
        height
      )

      self.rect = {
        x: self.x,
        y: self.y,
        width,
        height,
      }
    }

    if self.can_have_child() and self.children {
      for child in self.children {
        if !is_function(child) {
          child.update_bounds()
        }
      }
    }
  }

  is_child_of(el) {
    if self.ancestor {
      return self.ancestor == el or self.ancestor.is_child_of(el)
    }
  }

  Paint(ui) {
   /*  # detect mouse events
    var mousepos = ui.GetMousePosition()
    if ui.CheckCollisionPointRec(mousepos, self.bounds) {
      if self._is_form_active ui.SetMouseCursor(self.cursor)
      var mousepos_coords = ray.DeVector2(mousepos)
      mousepos_coords.x -= self.rect.x
      mousepos_coords.y -= self.rect.y

      if !self.mouse_is_hover and self.mouse_over_listener 
        self.mouse_over_listener(self, mousepos_coords)
      self.mouse_is_hover = true
      if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) {
        if !self.was_clicked and self.click_listener 
          self.click_listener(self, mousepos_coords)
        self.was_clicked = true
        self.was_activated = true
        self.was_right_clicked = false
      } else if(ui.IsMouseButtonDown(ray.MOUSE_BUTTON_RIGHT)) {
        if !self.was_right_clicked and self.context_listener 
          self.context_listener(self, mousepos_coords)
        self.was_right_clicked = true
      } else if(ui.IsMouseButtonUp(ray.MOUSE_BUTTON_LEFT)) {
        self.was_clicked = false
      } else if(ui.IsMouseButtonUp(ray.MOUSE_BUTTON_RIGHT)) {
        self.was_clicked = false
        self.was_right_clicked = false
      } else {
        self.was_right_clicked = false
      }
    } else {
      self.mouse_is_hover = false
      self.was_right_clicked = false
      if ui.IsMouseButtonDown(ray.MOUSE_BUTTON_LEFT) or ui.IsMouseButtonDown(ray.MOUSE_BUTTON_RIGHT) {
        if self.blur_listener self.blur_listener()
        self.was_activated = false
      }
    } */
  }

  Dispose(ui) {}
}

