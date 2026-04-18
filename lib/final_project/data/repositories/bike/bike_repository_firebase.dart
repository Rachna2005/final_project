import 'dart:convert';
import 'package:http/http.dart' as http;
import 'bike_repository.dart';
import '../../dtos/bike_dto.dart';
import '../../../model/bike.dart';

class BikeRepositoryFirebase extends BikeRepository {
  final String baseUrl =
      'final-project-6e87c-default-rtdb.asia-southeast1.firebasedatabase.app';

  @override
  Future<List<Bike>> fetchBike() async {
    final Uri bikeUri = Uri.https(baseUrl, '/bikes.json');
    final http.Response response = await http.get(bikeUri);
    if (response.statusCode == 200) {
      Map<String, dynamic> bikeJson = json.decode(response.body);
      List<Bike> result = [];
      for (final entry in bikeJson.entries) {
        result.add(BikeDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      throw Exception('Failed to load bikes');
    }
  }

  @override
  Future<Bike?> fetchBikeById(String id) async {
    final Uri bikeUri = Uri.https(baseUrl, '/bikes/$id.json');
    final http.Response response = await http.get(bikeUri);
    if (response.statusCode == 200) {
      if (response.body == 'null') {
        return null;
      }
      Map<String, dynamic> bikeJson = json.decode(response.body);
      return BikeDto.fromJson(id, bikeJson);
    } else {
      throw Exception('Failed to load bikes');
    }
  }
  @override
  Future<void> updateBikeStatus(String bikeId, String status) async {
    final uri = Uri.https(baseUrl, '/bikes/$bikeId.json');

    final res = await http.patch(uri, body: json.encode({"status": status}));

    if (res.statusCode != 200) {
      throw Exception("Failed to update bike");
    }
  }
}


