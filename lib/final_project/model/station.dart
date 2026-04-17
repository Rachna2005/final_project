class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final int totalSlots;
  final int availableBikes;

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.totalSlots,
    required this.availableBikes,
  });
}
