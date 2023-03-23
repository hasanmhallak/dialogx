import 'dart:async';

import 'package:flutter/material.dart';

extension Dialog on BuildContext {
  /// Shows a Material Toast.
  ///
  /// Calling This multiple times, because the previous
  /// Toast to disappears.
  void showToast(
    String message, {
    Duration toastDuration = const Duration(seconds: 3),
    Duration transitionDuration = const Duration(milliseconds: 200),
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    return _Dialogs.showToast(
      this,
      message,
      toastDuration: toastDuration,
      transitionDuration: transitionDuration,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  /// Dismisses The current Dialog if any, with [result].
  ///
  /// Calling this when no dialog on the screen, will have
  /// no effect.
  void dismiss<T>([T? result]) => _Dialogs.dismiss(result);

  /// Show a modal dialog that will block the user interaction.
  Future<T?> showModalDialog<T>({
    required WidgetBuilder builder,
    Color barrierColor = const Color(0x80000000),
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) async =>
      _Dialogs.showModalDialog(
        this,
        builder: builder,
        barrierDismissible: barrierDismissible,
        transitionDuration: transitionDuration,
        barrierColor: barrierColor,
      );
}

class _Dialogs {
  static Completer _completer = Completer();
  static final _overlayEntries = <OverlayEntry, GlobalKey<_ToastState>>{};

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
    final dialog = _ModalDialog<T>(
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
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    final overlay = Overlay.of(context);
    // this will allow us to reverse the animation.
    final stateKey = GlobalKey<_ToastState>();
    final entry = OverlayEntry(
      builder: (context) {
        return _Toast(
          key: stateKey,
          message: message,
          backgroundColor: backgroundColor,
          transitionDuration: transitionDuration,
          textColor: textColor,
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
    Future.delayed(toastDuration, () async {
      // here we are accessing the toast from the map and
      // not the entry itself because we might dispose the toast
      // before the 3 secods end, so if we try to show an other toast
      // we will dispose the old one, and when the 3 seconds finish,
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

class _ModalDialog<T> extends RawDialogRoute<T> {
  _ModalDialog({
    super.barrierColor,
    super.barrierDismissible,
    super.transitionDuration,
    required WidgetBuilder builder,
    required CapturedThemes capturedThemes,
  }) : super(
          pageBuilder: (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            final Widget pageChild = builder(buildContext);
            return capturedThemes.wrap(pageChild);
          },
        );
}

class _Toast extends StatefulWidget {
  final String message;
  final Duration transitionDuration;
  final Color backgroundColor;
  final Color textColor;
  const _Toast({
    super.key,
    required this.message,
    required this.transitionDuration,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.transitionDuration,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> reveredTransition() async {
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height -
              MediaQuery.of(context).size.height / 5,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 40,
            ),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SlideTransition(
                  position: Tween(
                    begin: Offset.zero,
                    end: const Offset(0, -1),
                  ).animate(_animation),
                  child: FadeTransition(
                    opacity: _animation,
                    child: child,
                  ),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
