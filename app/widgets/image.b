import reflect
import ..ray
import ..control { Control }

class Image < Control {
  var _image

  Image(options) {
    parent(options)
    self.color = options.get('color', ray.WHITE)
    self.opacity = options.get('opacity', 1)
    self.src = options.get('src', '')
  }

  Paint(ui) {
    parent.Paint(ui)
    
    if is_string(self.src) {
      self._image = ui.LoadImage(self.src)

      var image = ray.DeImage(self._image)

      var should_resize = !(self.width == 0 and self.height == 0)

      if self.width == 0 {
        self.width = image.width 
        self.update_bounds()
      }
      if self.height == 0 {
        self.height = image.height
        self.update_bounds()
      }

      if should_resize {
        ui.ImageResize(reflect.get_ptr(self._image), self.rect.width, self.rect.height)
      }

      self.src = ui.LoadTextureFromImage(self._image)
      ui.SetTextureFilter(self.src, ray.TEXTURE_FILTER_TRILINEAR)
    }

    ui.DrawTexture(self.src, self.rect.x, self.rect.y, ui.Fade(self.color, self.opacity))
  }

  Dispose(ui) {
    if self.src and !is_string(self.src) {
      ui.UnloadImage(self._image)
      ui.UnloadTexture(self.src)
    }
  }
}
