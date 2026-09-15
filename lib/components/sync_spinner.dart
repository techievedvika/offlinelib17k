// lib/components/sync_spinner_icon.dart
import 'package:flutter/material.dart';
import '../configs/color/color.dart';

class SyncSpinnerIcon extends StatefulWidget {
  const SyncSpinnerIcon();

  @override
  State<SyncSpinnerIcon> createState() => _SyncSpinnerIconState();
}

class _SyncSpinnerIconState extends State<SyncSpinnerIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Icon(Icons.sync, size: 48, color: AppColors.primary),
    );
  }
}