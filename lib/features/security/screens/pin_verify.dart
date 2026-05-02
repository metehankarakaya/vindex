import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vindex/core/constants/app_strings.dart';

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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: 0.0), weight: 1),
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
    // isValid ise router otomatik dashboard'a yönlendirir
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      AppStrings.pinVerifyTitle.tr(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.pinVerifySubtitle.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final isFilled = _enteredPin.length > index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? colorScheme.primary : Colors.transparent,
                              border: Border.all(
                                color: isFilled ? colorScheme.primary : colorScheme.outlineVariant,
                                width: 2,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  childCount: 12,
                    (context, index) {
                    if (index == 9) return const SizedBox.shrink();
                    if (index == 11) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _onDelete,
                          customBorder: const CircleBorder(),
                          child: Center(
                            child: Icon(
                              Icons.backspace_outlined,
                              size: 28,
                              color: colorScheme.onSurface
                            ),
                          ),
                        ),
                      );
                    }
                    final val = index == 10 ? "0" : "${index + 1}";
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onKeyPress(val),
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
