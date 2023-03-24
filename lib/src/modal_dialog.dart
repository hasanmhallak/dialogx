import 'package:flutter/material.dart';

class ModalDialog<T> extends RawDialogRoute<T> {
  ModalDialog({
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
