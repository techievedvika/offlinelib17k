import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class IsbnCameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const IsbnCameraScreen({super.key, required this.cameras});

  @override
  State<IsbnCameraScreen> createState() => _IsbnCameraScreenState();
}

class _IsbnCameraScreenState extends State<IsbnCameraScreen> {
  late CameraController _controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _controller = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
    );
    await _controller.initialize();
    if (mounted) setState(() => isReady = true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> capture() async {
    final file = await _controller.takePicture();
    Navigator.pop(context, file.path);
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(_controller),

          /// Overlay
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: ScannerOverlay(),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: capture,
                child: const Icon(Icons.camera),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.6);

    final rect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.8,
      height: 120,
    );

    final bg = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cut = Path()..addRect(rect);

    canvas.drawPath(Path.combine(PathOperation.difference, bg, cut), paint);

    final border = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(rect, border);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}