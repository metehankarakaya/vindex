import 'package:flutter/material.dart';
import 'package:vindex/core/constants/pin_constants.dart';

class PinKeypad extends StatelessWidget {
  final void Function(String) onKeyPress;
  final VoidCallback onDelete;

  const PinKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: PinConstants.screenPadding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: PinConstants.gridColumns,
          childAspectRatio: PinConstants.gridAspectRatio,
          mainAxisSpacing: PinConstants.gridSpacing,
          crossAxisSpacing: PinConstants.gridSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          childCount: 12,
          (context, index) {
            if (index == 9) return const SizedBox.shrink();
            if (index == 11) {
              return InkWell(
                onTap: onDelete,
                customBorder: const CircleBorder(),
                child: Center(
                  child: Icon(
                    Icons.backspace_outlined,
                    size: PinConstants.backspaceIconSize,
                    color: colorScheme.onSurface,
                  ),
                ),
              );
            }
            final val = index == 10 ? "0" : "${index + 1}";
            return InkWell(
              onTap: () => onKeyPress(val),
              customBorder: const CircleBorder(),
              child: Center(
                child: Text(
                  val,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
