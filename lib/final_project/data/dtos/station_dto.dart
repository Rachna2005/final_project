import '../../model/station.dart';

class StationDto {
  static const String nameKey = 'name';
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String totalSlotsKey = 'totalSlots';
  static const String availableBikesKey = 'availableBikes';

  static Station fromJson(String id, Map<String, dynamic> json) {
    assert(json[nameKey] is String);
    assert(json[latitudeKey] is num);
    assert(json[longitudeKey] is num);
    assert(json[totalSlotsKey] is int);
    assert(json[availableBikesKey] is int);

    return Station(
      id: id,
      name: json[nameKey],
      latitude: (json[latitudeKey] as num).toDouble(),
      longitude: (json[longitudeKey] as num).toDouble(),
      totalSlots: json[totalSlotsKey],
      availableBikes: json[availableBikesKey],
    );
  }

  static Map<String, dynamic> toJson(Station station) {
    return {
      nameKey: station.name,
      latitudeKey: station.latitude,
      longitudeKey: station.longitude,
      totalSlotsKey: station.totalSlots,
      availableBikesKey: station.availableBikes,
    };
  }
}
