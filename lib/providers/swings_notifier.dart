import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'swings_notifier.g.dart';

@Riverpod(keepAlive: true)
class SwingsNotifier extends _$SwingsNotifier {
  @override
  List<SwingData> build() {
    return [];
  }

  // Add Swing
  void addSwing(SwingData swing) {
    // This checks to see if the swing is already in our notifier. If so then we will just skip adding it
    if (state.any((existingSwing) => existingSwing.swingId == swing.swingId)) return;
    // Concatenate the new event to the current state
    state = [...state, swing];

    // Sort the swings by `createdAt` in descending order (most recent first)
    state.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) return 0; // Handle null timestamps
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }

  // Update Swing
  void updateSwing(SwingData updatedSwing) {
    print("updated swing");

    // Replace the swing with the updated one
    state = state.map((swing) {
      return swing.swingId == updatedSwing.swingId ? updatedSwing : swing;
    }).toList();

    // Sort the swings by `createdAt` in descending order (most recent first)
    state.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) return 0; // Handle null timestamps
      return b.createdAt!.compareTo(a.createdAt!);
    });
  }

  void removeSwing(String swingId) {
    print("removed swing");

    // Remove the swing by its ID
    state = state.where((swing) => swing.swingId != swingId).toList();
  }
}
