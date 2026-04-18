import 'package:flutter/material.dart';
import 'map_content.dart';
import 'package:provider/provider.dart';
import 'view_model/map_view_model.dart';
import '../../../data/repositories/station/station_repository.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          MapViewModel(stationRepo: context.read<StationRepository>()),
      child: MapContent(),
    );
  }
}
