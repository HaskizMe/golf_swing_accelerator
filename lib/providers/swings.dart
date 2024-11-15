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
  void setSwings(List<dynamic> swings) {
    // Convert each swing from Map to SwingData
    List<SwingData> swingList = swings.map((swing) => SwingData.fromJson(swing)).toList();

    // Sort the list by createdAt, most recent first
    swingList.sort((a, b) {
      if (a.createdAt == null || b.createdAt == null) return 0; // Handle null timestamps
      return b.createdAt!.compareTo(a.createdAt!); // Most recent first
    });

    // Update the state
    state = swingList;
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
