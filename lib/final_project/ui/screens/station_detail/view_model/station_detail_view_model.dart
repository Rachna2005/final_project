import 'package:flutter/material.dart';
import '../../../../model/station.dart';
import '../../../utils/async_value.dart';
import '../../../../model/bike.dart';
import '../../../../data/repositories/bike/bike_repository.dart';
import '../../../../data/repositories/station/station_repository.dart';

class StationDetailViewModel extends ChangeNotifier {
  final BikeRepository bikeRepo;
  final StationRepository stationRepo;

  StationDetailViewModel({required this.bikeRepo, required this.stationRepo});

  AsyncValue<Station>? stationState;
  AsyncValue<List<Bike>>? bikesState;

  String? selectedBikeId;

  
  Future<void> load(String stationId) async {
    stationState = AsyncValue.loading();
    bikesState = AsyncValue.loading();
    notifyListeners();

    try {
      final station = await stationRepo.fetchStationById(stationId);
      final bikes = await bikeRepo.fetchBike();

      final List<Bike> filtered = [];

      for (var b in bikes) {
        if (b.stationId == stationId && b.status == "available") {
          filtered.add(b);
        }
      }

      stationState = AsyncValue.success(station!);
      bikesState = AsyncValue.success(filtered);
    } catch (e) {
      stationState = AsyncValue.error(e);
      bikesState = AsyncValue.error(e);
    }

    notifyListeners();
  }
  Future<void> bookBike() async {
    if (selectedBikeId == null || stationState?.data == null) return;

    final station = stationState!.data!;

    try {

      await bikeRepo.updateBikeStatus(selectedBikeId!, "reserved");

      await stationRepo.updateAvailableBikes(
        station.id,
        station.availableBikes - 1,
      );
      await load(station.id);
      selectedBikeId = null;
      notifyListeners();
    } catch (e) {
      print("Booking error: $e");
    }
  }
  void selectBike(String bikeId) {
    if (selectedBikeId == bikeId) {
      selectedBikeId = null;
    } else {
      selectedBikeId = bikeId;
    }
    notifyListeners();
  }

  bool get canBook => selectedBikeId != null;
}
