import 'package:flutter/material.dart';

class Toast extends StatefulWidget {
  final String message;
  final Duration transitionDuration;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDispose;
  @visibleForTesting
  final Key? containerKey;
  const Toast({
    super.key,
    required this.message,
    required this.transitionDuration,
    required this.backgroundColor,
    required this.textColor,
    required this.onDispose,
    this.containerKey,
  });

  @override
  State<Toast> createState() => ToastState();
}

class ToastState extends State<Toast> with SingleTickerProviderStateMixin {
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
    widget.onDispose();
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
                  key: widget.containerKey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
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
