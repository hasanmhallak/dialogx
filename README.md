# Dialogx

Dialogs is a Flutter package that provides an easy way to display dialogs and toasts in your Flutter app. With Dialogs, you can save time and effort by avoiding boilerplate code.

If you encounter any issues or have any suggestions, please don't hesitate to open an issue or pull request on the GitHub repository.

## Installation

To use Dialogs in your Flutter project, follow these steps:

1. Add the package to your pubspec.yaml file:

```yaml
dependencies:
  dialogs: ^0.0.1
```

2. Install the package by running flutter pub get in your terminal.

## Usage

Dialogs provides the following methods:

### showToast

```Dart
void showToast(
  String message, {
  Duration toastDuration = const Duration(seconds: 3),
  Duration transitionDuration = const Duration(milliseconds: 200),
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
})
```

Displays a Material toast with the specified message. Optional parameters include the duration of the toast, the duration of the transition animation, and the background and text colors.

However, if this function is called multiple times, the previous toast will disappear.

### dismiss

```Dart
void dismiss<T>([T? result])
```

Dismisses the current dialog if any, with an optional result. If there is no dialog currently displayed, calling this method will have no effect.

### showModalDialog

```Dart
Future<T?> showModalDialog<T>({
  required WidgetBuilder builder,
  Color barrierColor = const Color(0x80000000),
  bool barrierDismissible = true,
  Duration transitionDuration = const Duration(milliseconds: 200),
})
```

Displays a modal dialog that will block user interaction until dismissed. The dialog is built using the specified WidgetBuilder. Optional parameters include the barrier color, whether the dialog can be dismissed by tapping outside of it, and the duration of the transition animation.
