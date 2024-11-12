class SwingData {
  final int speed;
  final String timeStamp;
  final List<double> swingPoints;
  SwingData({
    required this.speed,
    required this.swingPoints,
    required this.timeStamp,
  });

  int getCarryDistance() {
    return (speed * 2.45).toInt();
  }

  int getTotalDistance() {
    return (speed * 2.7).toInt();
  }
  int getSpeed() {
    return speed;
  }
  List<double> getSwingPoints() {
    return swingPoints;
  }
}