import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class NearestButton extends StatelessWidget {
  final VoidCallback onTap;

  const NearestButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape:  CircleBorder(),
      elevation: 6,
      color: AppColors.primary,
      child: InkWell(
        onTap: onTap,
        customBorder:  CircleBorder(),
        child: SizedBox(
          width: 90,
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.directions_bike, color: Colors.white, size: 28),
               SizedBox(height: 4),
              Text(
                "Nearest",
                style: AppTextStyles.body.copyWith(color: Colors.white),
              ),
               Text(
                "Bike",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
