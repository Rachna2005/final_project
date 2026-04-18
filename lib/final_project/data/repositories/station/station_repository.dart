import '../../../model/station.dart';

abstract class StationRepository {
  Future<List<Station>> fetchStations();
  Future<Station?> fetchStationById(String id);
  Future<void> updateAvailableBikes(String stationId, int value);
}
