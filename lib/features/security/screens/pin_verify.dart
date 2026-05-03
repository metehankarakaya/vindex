import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/constants/pin_constants.dart';
import 'package:vindex/core/widgets/pin_dots.dart';
import 'package:vindex/core/widgets/pin_keypad.dart';

import '../providers/security_provider.dart';

class PinVerify extends ConsumerStatefulWidget {
  const PinVerify({super.key});

  @override
  ConsumerState createState() => _PinSetupState();
}

class _PinSetupState extends ConsumerState<PinVerify> with SingleTickerProviderStateMixin {

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String _enteredPin = "";

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: PinConstants.shakeAnimationDuration,
      vsync: this,
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -PinConstants.shakeOffset), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -PinConstants.shakeOffset, end: PinConstants.shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: PinConstants.shakeOffset, end: -PinConstants.shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -PinConstants.shakeOffset, end: PinConstants.shakeOffset), weight: 2),
      TweenSequenceItem(tween: Tween(begin: PinConstants.shakeOffset, end: 0.0), weight: 1),
    ]).animate(_shakeController);
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _enteredPin = "");
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _onKeyPress(String value) async {
    if (_enteredPin.length >= 4) return;
    setState(() => _enteredPin += value);
    HapticFeedback.lightImpact();
    if (_enteredPin.length < 4) return;

    final isValid =
    await ref.read(securityProvider.notifier).verifyPin(_enteredPin);

    if (!mounted) return;

    if (!isValid) {
      _shakeController.forward(from: 0);
    }
    // If valid, the router guard automatically redirects to the dashboard
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(
        () => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1),
      );
      HapticFeedback.mediumImpact();
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PinConstants.screenPadding),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: PinConstants.topSpacing),
                    Text(
                      AppStrings.pinVerifyTitle.tr(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PinConstants.titleSubtitleGap),
                    Text(
                      AppStrings.pinVerifySubtitle.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PinConstants.subtitleDotsGap),
                    PinDots(
                      shakeAnimation: _shakeAnimation,
                      dotCount: 4,
                      filledCount: _enteredPin.length,
                    ),
                    const SizedBox(height: PinConstants.dotsKeypadGap),
                  ],
                ),
              ),
            ),
            PinKeypad(
              onKeyPress: _onKeyPress,
              onDelete: _onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
