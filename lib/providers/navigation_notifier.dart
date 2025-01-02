import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_notifier.g.dart';

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  int build() {
    return 0;
  }

  // Method to update the current navigation index
  void navigateTo(int index) {
    state = index;
  }
}
