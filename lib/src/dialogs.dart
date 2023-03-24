import 'dart:async';

import 'package:dialogs/src/toast.dart';
import 'package:flutter/material.dart';

import 'modal_dialog.dart';

class Dialogs {
  static Completer _completer = Completer();
  static final _overlayEntries = <OverlayEntry, GlobalKey<ToastState>>{};
  static Timer? _timer;

  static void dismiss<T>([T? result]) {
    if (!_completer.isCompleted) {
      _completer.complete(result);
      _completer = Completer();
    }
  }

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
    _completer.future.then((result) {
      if (dialog.canPop && dialog.isCurrent) {
        navigator.pop(result);
      }
    });

    return navigator.push<T>(
      dialog,
    );
  }

  static void showToast(
    BuildContext context,
    String message, {
    Duration toastDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
    // black with 80% opacity.
    Color backgroundColor = const Color(0xCC000000),
    Color textColor = Colors.white,
    Key? containerKey,
  }) {
    final overlay = Overlay.of(context);
    // this will allow us to reverse the animation.
    final stateKey = GlobalKey<ToastState>();
    final entry = OverlayEntry(
      builder: (context) {
        return Toast(
          key: stateKey,
          message: message,
          backgroundColor: backgroundColor,
          transitionDuration: transitionDuration,
          textColor: textColor,
          containerKey: containerKey,
          onDispose: () {
            // cancel timer if the widget was dispose for some reason.
            // e.g. in tests.
            _timer!.cancel();
            _overlayEntries
              ..forEach(
                (key, value) {
                  key
                    ..remove()
                    ..dispose();
                },
              )
              ..clear();
          },
        );
      },
    );
    // clear any toast that is showing on the screen.
    _overlayEntries
      ..forEach(
        (key, value) {
          key
            ..remove()
            ..dispose();
        },
      )
      ..clear();
    // add toast to screen.
    overlay.insert(entry);
    // save toast to the map.
    _overlayEntries[entry] = stateKey;
    _timer = Timer(toastDuration, () async {
      // here we are accessing the toast from the map and
      // not the entry itself because we might dispose the toast
      // before toastDuration end, so if we try to show an other toast
      // we will dispose the old one, and when toastDuration finish,
      // this will throw, so we are checking if overly is still showing
      // first, and if it is, then we remove it.
      if (_overlayEntries.containsKey(entry)) {
        await _overlayEntries[entry]!.currentState!.reveredTransition();
        entry
          ..remove()
          ..dispose();
        _overlayEntries.remove(entry);
      }
    });
  }
}
