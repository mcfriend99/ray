# ray

Simple game and forms widget library for Blade based on raylib.

### Package Information

- **Name:** ray
- **Version:** 1.0.0
- **Homepage:** _Homepage goes here._
- **Tags:** game, gui, desktop, engine, widgets, controls
- **Author:** Richard Ore <eqliqandfriends@gmail.com>
- **License:** ISC
- **Requires:** Blade v0.0.84 and later.

### Important Notice

- Most raylib file management functions such as `GetFileLength` with the excpetion of dropped file management functions such as `IsFileDropped` are not implemented because they have better interoping alternatives in Blade.
- Callbacks are not yet supported by Blade clib so all callbackbased functions such as `SetTraceLogCallback` are not implemented.
- All Compression/Encoding functionality such as `EncodeDataBase64` are not implemented because they have better interoping alternatives in Blade.