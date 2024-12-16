import 'package:flutter_riverpod/flutter_riverpod.dart';

// This is so I can keep track of things my providers are doing
// for example if the provider gets created, destroyed, update, fail, etc.
// I can print out when these things happen. This observes all providers btw
// This is useful debugging information.
class MyObserver extends ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase<Object?> provider,
      Object? value,
      ProviderContainer container,
      ) {
    print('Provider $provider was initialized with $value');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider,
      ProviderContainer container,
      ) {
    print('Provider $provider was disposed');
  }

  @override
  void didUpdateProvider(
      ProviderBase<Object?> provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    //print('Provider $provider updated from $previousValue to $newValue');
  }

  @override
  void providerDidFail(
      ProviderBase<Object?> provider,
      Object error,
      StackTrace stackTrace,
      ProviderContainer container,
      ) {
    print('Provider $provider threw $error at $stackTrace');
  }
}