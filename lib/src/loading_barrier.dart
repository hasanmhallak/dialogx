import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  final Duration transitionDuration;
  final Color backgroundColor;
  final Widget loader;
  const LoadingOverlay(
      {super.key,
      required this.transitionDuration,
      required this.backgroundColor,
      required this.loader});

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay>
    with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animation,
          child: child,
        );
      },
      child: Material(
        color: widget.backgroundColor,
        child: UnconstrainedBox(
          child: widget.loader,
        ),
      ),
    );
  }
}
