import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../components/app_feedback.dart';

/// Shows [child] only when the device has a network connection.
/// Otherwise shows an error dialog and goes back to the previous screen.
class OnlineGate extends StatefulWidget {
  final Widget child;
  final String featureName;
  const OnlineGate({super.key, required this.child, required this.featureName});

  @override
  State<OnlineGate> createState() => _OnlineGateState();
}

class _OnlineGateState extends State<OnlineGate> {
  late final Future<bool> _check = _isOnline();

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    // connectivity_plus v6 returns a List, older versions return a single value
    final list = result is List ? result : [result];
    return !list.contains(ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _check,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.data == true) return widget.child;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          await AppFeedback.showError(
            context,
            title: 'No Internet Connection',
            message: '${widget.featureName} needs an internet connection. '
                'Please connect and try again.',
          );
          if (mounted && Navigator.of(context).canPop()) Navigator.of(context).pop();
        });
        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}