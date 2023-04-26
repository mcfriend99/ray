import ..app { * }

var ui = Init()

var username = Textbox({
  x: 40, 
  y: 55,
  border_width: 1,
  max_length: 100,
})
var password = Textbox({
  x: 40, 
  y: 120,
  border_width: 1,
  max_length: 100,
  obscure_char: '*',
})

var slide_value = 0
var show_message = false

Form(ui, {
  width: 280,
  height: 270,
  title: 'Login',
  color: RAYWHITE,
  resizable: false,
  show_controls: false,
  children: [
    Label({
      x: 40,
      y: 30,
      font_size: 20,
      text: 'Username:',
      padding: 0,
    }),
    username,
    Label({
      x: 40,
      y: 95,
      font_size: 20,
      text: 'Password:',
      padding: 0,
    }),
    password,
    Checkbox({
      x: 40,
      y: 160,
      font_size: 20,
      text: 'Keep me logged in'
    }),
    Button({
      x: 40,
      y: 190,
      x_padding: 20,
      font_size: 20,
      width: 200,
      text: 'Login',
      on_click: @(s, e) { show_message = true }
    }),
    Label({
      x: 115,
      y: 235,
      text: 'Cancel',
      cursor: MOUSE_CURSOR_POINTING_HAND,
      on_click: @(s,e) {
        s.form.close()
      }
    }),
    Message({
      text: 'Login failed!',
      visible: @(){ return show_message },
      on_close: @(){ show_message = false },
    }),
  ]
})
