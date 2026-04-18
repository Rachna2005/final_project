import 'package:flutter/material.dart';
import '../../../../data/repositories/station/station_repository.dart';
import '../../../../model/station.dart';
import '../../../utils/async_value.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class MapViewModel extends ChangeNotifier {
  final StationRepository stationRepo;

  AsyncValue<List<Station>> stationValue = AsyncValue.loading();

  final LatLng currentLocation = LatLng(11.5667, 104.9230);
  LatLng get userLocation => currentLocation;

  List<Station> stations = [];
  Station? nearestSelectedStation;

  bool isNearestActive = false;
  bool isSearching = false;
  String searchStation = '';

  MapViewModel({required this.stationRepo}) {
    fetchStations();
  }
  Future<void> fetchStations() async {
    stationValue = AsyncValue.loading();
    notifyListeners();

    try {
      final fetched = await stationRepo.fetchStations();
      stations = fetched;
      stationValue = AsyncValue.success(stations);
    } catch (e) {
      stationValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  void startSearch() {
    isSearching = true;
    isNearestActive = false;
    notifyListeners();
  }

  void stopSearch() {
    isSearching = false;
    searchStation = '';
    notifyListeners();
  }

  void updateSearch(String query) {
    searchStation = query.trim().toLowerCase();

    isSearching = true;

    notifyListeners();
  }

  List<Station> get displayedStations {
    if (isSearching) {
      if (searchStation.trim().length < 2) {
        return [];
      }

      return stations.where((s) {
        return s.name.toLowerCase().contains(searchStation);
      }).toList();
    }

    if (isNearestActive && nearestSelectedStation != null) {
      return [nearestSelectedStation!];
    }
    return stations;
  }

  Station? findNearestStation() {
    final available = stations.where((s) => s.availableBikes > 0).toList();
    if (available.isEmpty) return null;

    available.sort((a, b) {
      final distA = _distance(userLocation, a);
      final distB = _distance(userLocation, b);
      return distA.compareTo(distB);
    });

    return available.first;
  }

  Station? activateNearest() {
    final nearest = findNearestStation();

    if (nearest != null) {
      nearestSelectedStation = nearest;
      isNearestActive = true;

      isSearching = false;
      searchStation = '';

      notifyListeners();
    }

    return nearest;
  }

  void clearNearest() {
    nearestSelectedStation = null;
    isNearestActive = false;
    notifyListeners();
  }

  double _distance(LatLng user, Station s) {
    const R = 6371;

    final dLat = _deg2rad(s.latitude - user.latitude);
    final dLon = _deg2rad(s.longitude - user.longitude);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(user.latitude)) *
            cos(_deg2rad(s.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    return R * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
