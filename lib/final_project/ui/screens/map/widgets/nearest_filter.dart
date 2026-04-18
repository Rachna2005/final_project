import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class NearestFilter extends StatelessWidget {
  final VoidCallback onClear;

  const NearestFilter({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: 50,
        padding:  EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            GestureDetector(onTap: onClear, child:  Icon(Icons.close)),
             SizedBox(width: 8),
             Icon(Icons.directions_bike, color: AppColors.primary),
             SizedBox(width: 8),
            Expanded(child: Text("Nearest Station", style: AppTextStyles.body)),
          ],
        ),
      ),
    );
  }
}
