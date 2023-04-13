import ..app { * }

var ui = Init()

var name = Textbox({
  x: 265, 
  y: 180,
  border_width: 1,
  max_length: 100,
  on_context: @() {
    echo 'Context called.'
  }
})

var f = Form(ui, {
  width: 800,
  height: 450,
  title: 'Ray Test Application',
  color: ray.RAYWHITE,
  children: [
    Label({
      x: 260,
      y: 145,
      font_size: 20,
      text: 'CLICK ON THE INPUT BOX TO BEGIN!',
    }),
    name,
    @() {
      return name.text.length() > 0 ?
        Label({
          x: 260,
          y: 206,
          font_size: 14,
          text: 'Maximum of 100 characters.',
        }) : nil
    },
    /* @() {
      return name.text.length() > 0 ?
        Label({
          x: 325,
          y: 250,
          font_size: 20,
          text: @() {
            return 'INPUT CHARS: ${name.text.length()}'
          },
        }) : nil
    }, */
    Button({
      x: 470,
      y: 180,
      x_padding: 12,
      text: 'Search',
      on_click: @(s, e) { echo e }
    }),
    @() {
      return name.text.length() > 0 ? Progress({
        x: 265,
        y: 250,
        height: 8,
        width: 265,
        value: name.text.length() < 100 ? name.text.length() : 100,
        # indeterminate: true,
      }) : nil
    }
  ]
})
f.Paint()
f.Dispose()

# ui.OpenURL('https://wazobia.com')
