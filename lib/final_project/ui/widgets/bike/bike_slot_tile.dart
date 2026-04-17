import 'package:flutter/material.dart';
import '../../../model/bike.dart';
import '../../theme/theme.dart';
import '../../utils/formatId_utils.dart';

class BikeSlotTile extends StatelessWidget {
  final Bike bike;
  final VoidCallback onTap;
  final bool isSelected;

  const BikeSlotTile({
    super.key,
    required this.bike,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = bike.status == "available";

    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),

          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1)
              : null,

          boxShadow: [BoxShadow(color: AppColors.textLight, blurRadius: 1)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                formatBikeId(bike.id),
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 24),
            const Icon(Icons.directions_bike, color: Colors.black87),
            const Spacer(),

            Text(
              bike.status.toUpperCase(),
              style: TextStyle(
                color: isAvailable ? AppColors.primaryDark : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
