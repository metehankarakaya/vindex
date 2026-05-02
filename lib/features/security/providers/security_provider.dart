import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityState {
  final bool hasPinSetup;
  final bool isUnlocked;

  const SecurityState({
    required this.hasPinSetup,
    required this.isUnlocked,
  });

  SecurityState copyWith({bool? hasPinSetup, bool? isUnlocked}) {
    return SecurityState(
      hasPinSetup: hasPinSetup ?? this.hasPinSetup,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class SecurityNotifier extends AsyncNotifier<SecurityState> {
  final _storage = const FlutterSecureStorage();

  @override
  Future<SecurityState> build() async {
    final pin = await _storage.read(key: "user_pin");
    return SecurityState(
      hasPinSetup: pin != null,
      isUnlocked: false,
    );
  }

  Future<void> enableLock(String pin) async {
    await _storage.write(key: "user_pin", value: pin);
    state = AsyncData(state.value!.copyWith(hasPinSetup: true));
  }

  Future<void> disableLock() async {
    await _storage.delete(key: "user_pin");
    state = AsyncData(state.value!.copyWith(
      hasPinSetup: false,
      isUnlocked: false,
    ));
  }

  Future<bool> verifyPin(String pin) async {
    final savedPin = await _storage.read(key: "user_pin");
    final isValid = pin == savedPin;
    if (isValid) {
      state = AsyncData(state.value!.copyWith(isUnlocked: true));
    }
    return isValid;
  }
}

final securityProvider =
AsyncNotifierProvider<SecurityNotifier, SecurityState>(
  SecurityNotifier.new,
);