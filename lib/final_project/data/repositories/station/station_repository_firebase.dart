import 'dart:convert';
import 'package:http/http.dart' as http;
import 'station_repository.dart';
import '../../dtos/station_dto.dart';
import '../../../model/station.dart';

class StationRepositoryFirebase extends StationRepository {
  final String baseUrl =
      'final-project-6e87c-default-rtdb.asia-southeast1.firebasedatabase.app';

  @override
  Future<List<Station>> fetchStations() async {
    final Uri stationUri = Uri.https(baseUrl, '/stations.json');

    final http.Response response = await http.get(stationUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> stationJson = json.decode(response.body);

      List<Station> result = [];

      for (final entry in stationJson.entries) {
        result.add(StationDto.fromJson(entry.key, entry.value));
      }

      return result;
    } else {
      throw Exception('Failed to load stations');
    }
  }

  @override
  Future<Station?> fetchStationById(String id) async {
    final Uri stationUri = Uri.https(baseUrl, '/stations/$id.json');

    final http.Response response = await http.get(stationUri);

    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return null;
      }

      final Map<String, dynamic> stationJson = json.decode(response.body);

      return StationDto.fromJson(id, stationJson);
    } else {
      throw Exception('Failed to load station');
    }
  }
}
