import 'package:flutter/material.dart';

import 'dialogs.dart';

extension Dialog on BuildContext {
  /// Shows a Material Toast.
  ///
  /// Calling This multiple times, cause the previous
  /// Toast to disappears.
  void showToast(
    String message, {
    Duration toastDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    @visibleForTesting Key? containerKey,
  }) {
    return Dialogs.showToast(
      this,
      message,
      toastDuration: toastDuration,
      transitionDuration: transitionDuration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      containerKey: containerKey,
    );
  }

  /// Dismisses The current Dialog if any, with [result].
  ///
  /// Calling this when no dialog on the screen, will have
  /// no effect.
  void dismiss<T>([T? result]) => Dialogs.dismiss(result);

  /// Show a modal dialog that will block the user interaction.
  Future<T?> showModalDialog<T>({
    required WidgetBuilder builder,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) async =>
      Dialogs.showModalDialog(
        this,
        builder: builder,
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
      );
}
