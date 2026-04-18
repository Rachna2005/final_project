import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_common.dart';
import 'data/repositories/station/station_repository.dart';
import 'data/repositories/station/station_repository_firebase.dart';

List<InheritedProvider> get devProviders {
  return [
    // 1 - Inject repositories
    Provider<StationRepository>(create: (_) => StationRepositoryFirebase()),
  ];
}

void main() {
  mainCommon(devProviders);
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final repo = BikeRepositoryFirebase();
//   final bikes = await repo.fetchBike();
//   print(bikes);
//   // mainCommon();
// }
