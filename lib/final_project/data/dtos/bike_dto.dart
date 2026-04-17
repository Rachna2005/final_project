import '../../model/bike.dart';

class BikeDto {
  static const String stationIdKey = 'stationId';
  static const String statusKey = 'status';
  static Bike fromJson(String id, Map<String, dynamic> json) {
    assert(json[stationIdKey] is String);
    assert(json[statusKey] is String);
    return Bike(id: id, stationId: json[stationIdKey], status: json[statusKey]);
  }

  static Map<String, dynamic> toJson(Bike bike) {
    return {stationIdKey: bike.stationId, statusKey: bike.status};
  }
}
