import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'account.g.dart';

@Riverpod(keepAlive: true)
class Account extends _$Account {
  int heightFt = 6;
  int heightIn = 0;
  String? primaryHand;
  String? skillLevel;
  late String? token;



  @override
  Account build() {
    _initialize();
    return this;
  }

  // Methods
  void _initialize() async {

  }

  // Method to set height in feet and inches
  void setHeight(int feet, int inches) {
    heightFt = feet;
    heightIn = inches;
    // Notify listeners that the state has been updated
    state = this;
  }

  // Method to set height in feet and inches
  void setPrimaryHand(String hand) {
    primaryHand = hand;
    state = this;
  }
}
