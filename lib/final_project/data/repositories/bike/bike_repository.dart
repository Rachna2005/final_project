import '../../../model/bike.dart';

abstract class BikeRepository {
  Future<List<Bike>> fetchBike();
  Future<Bike?> fetchBikeById(String id);
}
