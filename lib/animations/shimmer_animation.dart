import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ShimmerAnimation extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerAnimation({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  State<ShimmerAnimation> createState() => _ShimmerAnimationState();
}

class _ShimmerAnimationState extends State<ShimmerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppTheme.shimmerBaseColor,
                AppTheme.shimmerHighlightColor,
                AppTheme.shimmerBaseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_animation.value, 0.0),
              end: Alignment(_animation.value + 1.0, 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
} 