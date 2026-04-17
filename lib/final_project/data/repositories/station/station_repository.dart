import '../../../model/station.dart';

abstract class StationRepository {
  Future<List<Station>> fetchStations();
  Future<Station?> fetchStationById(String id);
}
