import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/widgets/bike/bike_slot_tile.dart';
import '../../theme/theme.dart';
import '../booking/booking_screen.dart';
import 'view_model/station_detail_view_model.dart';

class StationDetailContent extends StatelessWidget {
  const StationDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationDetailViewModel>();

    final stationState = vm.stationState;
    final bikesState = vm.bikesState;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: stationState?.data == null
            ? const Text("Station Detail")
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    stationState!.data!.name,
                    style: AppTextStyles.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stationState.data!.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
      
      body: (stationState == null || bikesState == null)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (stationState.data != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            style: AppTextStyles.body,
                            children: [
                              TextSpan(
                                text: "ALL Slots ${stationState.data!.totalSlots} ",
                              ),
                              const TextSpan(
                                text: "| ",
                                style: TextStyle(color: AppColors.primaryDark),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ), 
                                  ),
                                  child: const Icon(
                                    Icons.directions_bike,
                                    size: 16,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Bikes ${stationState.data!.availableBikes} ",
                              ),
                              const TextSpan(
                                text: "| ",
                                style: TextStyle(color: AppColors.primaryDark),
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.local_parking,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Parking Slot  ${stationState.data!.totalSlots - stationState.data!.availableBikes}",
                              ),
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),

                const Divider(color: AppColors.primaryLight),

                Expanded(
                  child: bikesState.data == null
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: bikesState.data!.length,
                          itemBuilder: (context, index) {
                            final bike = bikesState.data![index];

                            return BikeSlotTile(
                              bike: bike,
                              isSelected: vm.selectedBikeId == bike.id,
                              onTap: () {
                                vm.selectBike(bike.id);
                              },
                            );
                          },
                        ),
                ),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.canBook ? () async {
                              final station = vm.stationState!.data!;
                              final bikeId = vm.selectedBikeId!;

                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                    bikeId: bikeId,
                                    stationName: station.name,
                                  ),
                                ),
                              );

                              if (result == true) {
                                vm.bookBike();
                              }
                            } : null,
                      child: const Text("Book Bike"
                      ,
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
