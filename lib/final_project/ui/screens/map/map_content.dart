import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/async_value.dart';
import 'view_model/map_view_model.dart';
import '../../../model/station.dart';
import '../../theme/theme.dart';
import 'widgets/nearest_button.dart';
import 'widgets/nearest_filter.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  GoogleMapController? _mapController;
  BitmapDescriptor? _userIcon;

  @override
  void initState() {
    super.initState();
    _loadUserIcon();
  }

  Future<void> _loadUserIcon() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/icons/user_dot.png',
    );
    setState(() => _userIcon = icon);
  }

  Set<Marker> _buildMarkers(MapViewModel vm, List<Station> stations) {
    return stations.map((station) {
      return Marker(
        markerId: MarkerId(station.id),
        position: LatLng(station.latitude, station.longitude),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: 'Bikes: ${station.availableBikes}',
        ),
      );
    }).toSet();
  }

  Set<Marker> _buildUserMarker(MapViewModel vm) {
    if (_userIcon == null) return {};

    return {
      Marker(
        markerId: MarkerId("user_location"),
        position: vm.userLocation,
        icon: _userIcon!,
      ),
    };
  }

  void _zoomToStation(Station station) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(station.latitude, station.longitude),
        16,
      ),
    );
  }

  void _resetCamera(MapViewModel vm) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(vm.userLocation, 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    final asyncValue = vm.stationValue;

    switch (asyncValue.state) {
      case AsyncValueState.loading:
        return  Center(child: CircularProgressIndicator());

      case AsyncValueState.error:
        return Center(
          child: Text(
            'Error: ${asyncValue.error}',
            style:  TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        final stations = vm.isNearestActive
            ? vm.displayedStations
            : vm.stations;

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: vm.userLocation,
                zoom: 13,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                ..._buildMarkers(vm, stations),
                ..._buildUserMarker(vm),
              },
            ),

            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: vm.isNearestActive
                    ? NearestFilter(
                        key: const ValueKey("nearest"),
                        onClear: () {
                          vm.clearNearest();
                          _resetCamera(vm);
                        },
                      )
                    : _SearchBar(key: ValueKey("search")),
              ),
            ),

            if (vm.isSearching && vm.displayedStations.isNotEmpty)
              Positioned.fill(
                child: _SearchResultList(
                  onSelect: (station) {
                    vm.nearestSelectedStation = station;
                    vm.stopSearch();
                    _zoomToStation(station);
                  },
                ),
              ),

            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Center(
                child: NearestButton(
                  onTap: () {
                    final nearest = vm.activateNearest();
                    if (nearest != null) {
                      _zoomToStation(nearest);
                    }
                  },
                ),
              ),
            ),
          ],
        );
    }
  }
}

class _SearchResultList extends StatelessWidget {
  final void Function(Station) onSelect;

  const _SearchResultList({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    final results = vm.displayedStations;

    return Stack(
      children: [
        GestureDetector(
          onTap: vm.stopSearch,
          child: Container(color: AppColors.textDark.withOpacity(0.2)),
        ),

        Positioned(
          top: 110,
          left: 16,
          right: 16,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints:  BoxConstraints(maxHeight: 350),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: results.length,
                separatorBuilder: (_, __) =>  Divider(height: 1),
                itemBuilder: (_, index) {
                  final s = results[index];

                  return ListTile(
                    contentPadding:  EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading:  Icon(
                      Icons.location_on,
                      color: AppColors.primaryDark,
                    ),
                    title: Text(
                      s.name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "Bikes: ${s.availableBikes}",
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    onTap: () => onSelect(s),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MapViewModel>();

    return Material(
      elevation: 4,
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: TextField(
        style: AppTextStyles.body,
        onTap: vm.startSearch,
        onChanged: vm.updateSearch,
        decoration: InputDecoration(
          hintText: "Search station...",
          prefixIcon:  Icon(Icons.search, color: AppColors.textLight),
          border: InputBorder.none,
          contentPadding:  EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

