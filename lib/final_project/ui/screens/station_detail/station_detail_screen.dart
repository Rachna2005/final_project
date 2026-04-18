import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'station_detail_content.dart';
import '../../../data/repositories/bike/bike_repository.dart';
import '../../../data/repositories/station/station_repository.dart';
import 'view_model/station_detail_view_model.dart';

class StationDetailScreen extends StatelessWidget {
  final String stationId;

  const StationDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StationDetailViewModel(
        bikeRepo: context.read<BikeRepository>(),
        stationRepo: context.read<StationRepository>(),
      )..load(stationId),
      child: const StationDetailContent(),
    );
  }
}
