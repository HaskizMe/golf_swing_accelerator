import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'swings.g.dart';

@Riverpod(keepAlive: true)
class SwingsNotifier extends _$SwingsNotifier {
  @override
  List<SwingData> build() {
    return [];
  }
  // Add multiple events on top of the existing list
  void setSwings(List<SwingData> swings) {
    // Concatenate the new events on top of the current state
    state = [...state, ...swings];
  }

  // Add Swing
  void addSwing(SwingData swing) {
    // Concatenate the new events on top of the current state
    state = [...state, swing];
  }

  // Remove an announcement by its announcementId
  void removeSwing(int swingId) {
    // Filter out the announcement with the matching ID
    //state = state.where((announcement) => announcement.id != announcementId).toList();
  }
}
