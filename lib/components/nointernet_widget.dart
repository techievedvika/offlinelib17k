
import 'package:flutter/material.dart';

import '../../configs/color/color.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.signal_wifi_off,
            size: 100,
            color: AppColors.error,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            style:ElevatedButton.styleFrom(
              backgroundColor:AppColors.primary 
              
            ),
            child: const Text('Retry',style: TextStyle(color: AppColors.onPrimary),),
          ),
        ],
      ),
    );
  }
}
