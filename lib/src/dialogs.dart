// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dialogx/src/toast.dart';
import 'package:flutter/material.dart';

import 'loading_barrier.dart';
import 'modal_dialog.dart';

class Dialogx {
  static OverlayEntry? _toastEntry;
  static OverlayEntry? _loadingEntry;
  static GlobalKey<LoadingOverlayState>? _loadingKey;
  static Timer? _timer;

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
  static Future<T?> showModalDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    final navigator = Navigator.of(context, rootNavigator: true);
    final dialog = ModalDialog<T>(
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
      builder: (context) {
        return Center(
          child: UnconstrainedBox(
            child: builder(context),
          ),
        );
      },
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
    );

    return navigator.push<T>(
      dialog,
    );
  }

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
  static void showToast(
    BuildContext context,
    String message, {
    Duration toastDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color backgroundColor = const Color(0xCC000000), // black with 80% opacity.
    Color textColor = Colors.white,
    @visibleForTesting Key? containerKey,
  }) async {
    //! overlays can't be remove if we don't have a reference to
    //! to entry. so each time we call this method. we should make sure
    //! we clear all previous overlays and dispose recourses.
    _clearToast();
    // If the context is not mounted, do nothing.
    if (!context.mounted) return;
    final overlay = Overlay.of(context);
    // this will allow us to reverse the animation.
    final stateKey = GlobalKey<ToastState>();
    // Create a new overlay entry for the toast.
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return Toast(
          key: stateKey,
          message: message,
          backgroundColor: backgroundColor,
          transitionDuration: transitionDuration,
          textColor: textColor,
          containerKey: containerKey,
          onDispose: () async {
            // if this is not true, this means that we show another entry and remove this one.
            // so we should not cancel the timer as it will cause the currently showing entry
            // to NOT be removed.
            if (_toastEntry == entry) {
              //! Cancel the timer to avoid failing the test if the widget is disposed and there is still an active timer.
              _timer?.cancel();
              _timer == null;
            }
          },
        );
      },
    );

    _toastEntry = entry;

    // add toast to screen.
    overlay.insert(entry);
    // Set a timer to remove the toast after the specified duration.
    _timer = Timer(toastDuration, () async {
      await stateKey.currentState!.reveredTransition();
      _clearToast();
    });
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
  static void showLoading(
    BuildContext context, {
    required Widget loader,
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color barrierColor = const Color(0x64000000),
  }) async {
    //! overlays can't be remove if we don't have a reference to
    //! to entry. so each time we call this method. we should make sure
    //! we clear all previous overlays and dispose recourses.
    await _clearLoading();
    if (!context.mounted) return;
    final overlay = Overlay.of(context);
    // this will allow us to reverse the animation.
    _loadingKey = GlobalKey<LoadingOverlayState>();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) {
        return LoadingOverlay(
          key: _loadingKey,
          backgroundColor: barrierColor,
          transitionDuration: transitionDuration,
          loader: loader,
        );
      },
    );

    // save toast to the map.
    _loadingEntry = entry;
    // add toast to screen.
    overlay.insert(entry);
  }

  /// Clears all toasts and disposes resources used by them.
  ///
  /// This method should be called each time before showing a new overlay to avoid conflicts.
  ///
  /// It clears and disposes resources used by Toast and
  /// cancels any existing timer used by Toast to remove it
  /// even if the duration is not over.
  static void _clearToast() async {
    _toastEntry
      ?..remove()
      ..dispose();
    _toastEntry = null;
    //
    _timer?.cancel();
    _timer = null;
  }

  /// Clears all loading overlays and disposes resources used by them.
  ///
  /// This method should be called each time before showing a new overlay to avoid conflicts.
  ///
  /// It clears and disposes resources used by both LoadingOverlay.
  /// Reverses the transition of the LoadingOverlay if it's currently showing before removing it.
  static Future<void> _clearLoading() async {
    await _loadingKey?.currentState?.reveredTransition();
    _loadingEntry
      ?..remove()
      ..dispose();
    _loadingEntry = null;
    _loadingKey = null;
  }

  /// Clears all loading overlays and disposes resources used by them after Reversing it's transition.
  static Future<void> dismissLoading() => _clearLoading();
}
