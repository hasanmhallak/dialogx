import 'package:flutter/material.dart';

import 'dialogs.dart';

extension Dialog on BuildContext {
  /// Shows a toast message on top of the current screen.
  ///
  /// This method clears all previously shown overlays and disposes their resources.
  ///
  /// If the provided [BuildContext] is not mounted, this method does nothing.
  ///
  ///  [message] is the string message to be displayed in the toast.
  ///
  ///  [toastDuration] is the duration for which the toast message should be visible.
  ///
  ///  [transitionDuration]  for the fade-in and fade-out animation of the loading indicator.
  /// By default, it is set to 200 milliseconds.
  ///
  ///  [backgroundColor] is the color of the background of the toast message. The default value is black with 80% opacity.
  ///
  ///  [textColor] is the color of the text message in the toast. The default value is white.
  ///
  ///  [containerKey] is a key that can be used to identify the toast container. This is useful when testing.
  void showToast(
    String message, {
    Duration toastDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    @visibleForTesting Key? containerKey,
  }) {
    return Dialogx.showToast(
      this,
      message,
      toastDuration: toastDuration,
      transitionDuration: transitionDuration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      // ignore: invalid_use_of_visible_for_testing_member
      containerKey: containerKey,
    );
  }

  /// Displays a loading indicator on top of the current screen.
  /// This method is useful when you want to inform the user that
  /// an operation is taking place and that the user should wait
  /// for it to complete.
  ///
  /// [context]: The `BuildContext` that the overlay will be inserted into.
  ///
  /// [loader]: The `Widget` to be displayed as the loading indicator.
  ///
  /// [transitionDuration]: The `Duration` for the fade-in and fade-out
  /// animation of the loading indicator. By default, it is set to 200 milliseconds.
  ///
  /// [barrierColor]: The `Color` of the overlay barrier.
  /// By default, it is set to a semi-transparent black.
  void showLoading({
    required Widget loader,
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color barrierColor = const Color(0x64000000),
  }) =>
      Dialogx.showLoading(
        this,
        loader: loader,
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
      );

  /// Shows a modal dialog.
  ///
  /// Displays a modal dialog above the current context's widget tree.
  ///
  /// The `builder` argument must not be null. It is called when the dialog is shown.
  ///
  /// The dialog is built in a center-aligned UnconstrainedBox to ensure its content is
  /// unconstrained.
  ///
  /// The dialog's background is a modal barrier that obscures everything below it.
  /// The opacity and color of the barrier can be customized using the `barrierColor` argument.
  ///
  /// By default, the dialog can be dismissed by tapping outside of its bounds or by
  /// pressing the back button on Android. To disable this behavior, set the
  /// `barrierDismissible` argument to false.
  ///
  /// The dialog can also be dismissed by calling `Navigator.pop` with a value returned
  /// from the dialog's `builder`. If the dialog is dismissed by tapping outside of
  /// its bounds or by pressing the back button, the value returned from the `builder`
  /// will be null.
  ///
  /// The `transitionDuration` argument controls how long it takes for the dialog to
  /// transition into and out of view.
  ///
  /// Returns a Future that resolves to the value returned by the dialog's `builder`
  /// when the dialog is dismissed.
  Future<T?> showModalDialog<T>({
    required WidgetBuilder builder,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) async =>
      Dialogx.showModalDialog(
        this,
        builder: builder,
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
      );

  /// Clears all loading overlays and disposes resources used by them after Reversing it's transition.
  Future<void> dismissLoading() => Dialogx.dismissLoading();
}
