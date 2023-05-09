# Dialogx

Dialogx is a Flutter package that provides simple and customizable modal dialogs, toast messages, and loading indicators. This package is useful for displaying information to users in a clean and concise way.

## Installation

To use Dialogx, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  dialogx: ^1.0.0
```

Then, run `flutter pub get` to install the package.

## Usage

### Modal Dialog

To show a modal dialog, use the `showModalDialog` method:

```dart
final data = await context.showModalDialog<String>(
  builder: (BuildContext context) {
    return AlertDialog(
      title: Text('Dialog Title'),
      content: Text('Dialog Content'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: Text('OK'),
        ),
      ],
    );
  },
);
```

This method takes a `builder` function that returns a `Widget`. The `builder` function is called when the dialog is shown. You can customize the appearance and behavior of the dialog by passing additional arguments to `showModalDialog`, such as the `barrierColor`, `barrierDismissible`, and `transitionDuration`.

### Toast

To show a toast message, use the `showToast` method:

```dart
context.showToast(
  'This is a toast message',
  toastDuration: Duration(seconds: 3),
  backgroundColor: Colors.black.withOpacity(0.8),
  textColor: Colors.white,
);
```

This method takes a `String` message to display. You can customize the appearance and behavior of the toast by passing additional arguments to `showToast`, such as the `toastDuration`, `backgroundColor`, and `textColor`.

### Loading Indicator

To show a loading indicator, use the `showLoadingIndicator` method:

```dart
context.showLoading(loader: CircularProgressIndicator());
await Future.delayed(Duration(seconds: 5));
loading.dismiss();
```

This method takes a `BuildContext` and returns a `LoadingOverlay` object that can be used to show and dismiss the loading indicator. You can customize the appearance and behavior of the loading indicator by passing additional arguments to `showLoadingIndicator`, such as the `loadingIndicator` and `loadingMessage`.

## Contribution

If you find any bugs or have suggestions for improvements, feel free to open an issue or pull request on GitHub at https://github.com/hasanmhallak/dialogx.

## License

Dialogx is released under the MIT License. See the [LICENSE](https://github.com/hasanmhallak/dialogx/blob/master/LICENSE) file for details.
