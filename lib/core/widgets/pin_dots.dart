import 'package:flutter/material.dart';
import 'package:vindex/core/constants/pin_constants.dart';

class PinDots extends StatelessWidget {
  final Animation<double> shakeAnimation;
  final int dotCount;
  final int filledCount;

  const PinDots({
    super.key,
    required this.shakeAnimation,
    required this.dotCount,
    required this.filledCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(shakeAnimation.value, 0),
        child: child,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(dotCount, (index) {
          final isFilled = filledCount > index;
          return AnimatedContainer(
            duration: PinConstants.dotAnimationDuration,
            width: PinConstants.dotSize,
            height: PinConstants.dotSize,
            margin: const EdgeInsets.symmetric(horizontal: PinConstants.dotMargin),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? colorScheme.primary : colorScheme.surface,
              border: Border.all(
                color: isFilled ? colorScheme.primary : colorScheme.outlineVariant,
                width: PinConstants.dotBorderWidth,
              ),
            ),
          );
        }),
      ),
    );
  }
}
