# Development instructions

If you are working with `Flutter` but you have no compatible device paired with
your system, Flutter will suggest you to use the `Chrome` browser.

By default, Chrome has strict CORS policies when in Debug Mode with Flutter, so
it is necessary to disable the additional security in the corresponding settings,

A useful tool to make rid of it is [flutter_cors](https://pub.dev/packages/flutter_cors)