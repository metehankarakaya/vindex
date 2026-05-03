import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vindex/core/constants/app_strings.dart';
import 'package:vindex/core/constants/pin_constants.dart';

import '../providers/security_provider.dart';

enum _Stage { enter, confirm }

class PinSetup extends ConsumerStatefulWidget {
  const PinSetup({super.key});

  @override
  ConsumerState createState() => _PinSetupState();
}

class _PinSetupState extends ConsumerState<PinSetup> with SingleTickerProviderStateMixin {

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  String _enteredPin = "";
  String _firstPin = "";
  _Stage _stage = _Stage.enter;

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

    if (_stage == _Stage.enter) {
      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = "";
        _stage = _Stage.confirm;
      });
    } else {
      if (_enteredPin == _firstPin) {
        await ref.read(securityProvider.notifier).enableLock(_enteredPin);
        if (mounted) context.go("/settings/security");
      } else {
        _shakeController.forward(from: 0);
      }
    }
  }

  void _onDelete() {
    if (_enteredPin.isNotEmpty) {
      setState(
        () => _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1)
      );
      HapticFeedback.mediumImpact();
    }
  }

  String get _title =>
    _stage == _Stage.enter ? AppStrings.pinSetupAppBarTitle.tr() : AppStrings.pinConfirmTitle.tr();

  String get _subtitle =>
    _stage == _Stage.enter ? AppStrings.pinSetupSubtitle.tr() : AppStrings.pinConfirmSubtitle.tr();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.pinSetupAppBarTitle.tr()),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PinConstants.screenPadding),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: PinConstants.topSpacingSetup),
                    Text(
                      _title,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PinConstants.titleSubtitleGap),
                    Text(
                      _subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PinConstants.subtitleDotsGap),
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
                            duration: PinConstants.dotAnimationDuration,
                            width: PinConstants.dotSize,
                            height: PinConstants.dotSize,
                            margin: const EdgeInsets.symmetric(horizontal: PinConstants.dotMargin),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isFilled ? colorScheme.primary : Colors.transparent,
                              border: Border.all(
                                color: isFilled ? colorScheme.primary : colorScheme.outlineVariant,
                                width: PinConstants.dotBorderWidth,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: PinConstants.dotsKeypadGap),
                  ],
                ),
              ),
            ),
            SliverPadding(
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
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _onDelete,
                          customBorder: const CircleBorder(),
                          child: Center(
                            child: Icon(
                              Icons.backspace_outlined,
                              size: PinConstants.backspaceIconSize,
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
