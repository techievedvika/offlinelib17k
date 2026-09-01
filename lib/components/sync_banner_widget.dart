import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../configs/color/color.dart';
import '../core/sync/sync_status_cubit.dart';

class SyncBannerWidget extends StatelessWidget {
  const SyncBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncStatusCubit, SyncStatusState>(
      builder: (context, state) {
        if (state is SyncOffline) {
          return _banner(
            icon: Icons.cloud_off,
            text: 'Working offline — changes will sync automatically when online',
            color: Colors.orange.shade100,
            iconColor: Colors.orange.shade800,
          );
        }
        if (state is SyncInProgress) {
          return _banner(
            icon: Icons.sync,
            text: 'Syncing pending changes...',
            color: Colors.blue.shade50,
            iconColor: AppColors.primary,
          );
        }
        // SyncCompleted / SyncFailed / SyncInitial → show nothing, don't block UI
        return const SizedBox.shrink();
      },
    );
  }

  Widget _banner({required IconData icon, required String text, required Color color, required Color iconColor}) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: iconColor))),
        ],
      ),
    );
  }
}