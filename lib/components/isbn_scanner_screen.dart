import 'package:flutter/material.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

/// Full-screen barcode scanner. Pops with the scanned value, or null if cancelled.
class IsbnScannerScreen extends StatefulWidget {
  const IsbnScannerScreen({super.key});

  static Future<String?> scan(BuildContext context) =>
      Navigator.of(context).push<String>(
        MaterialPageRoute(builder: (_) => const IsbnScannerScreen()),
      );

  @override
  State<IsbnScannerScreen> createState() => _IsbnScannerScreenState();
}

class _IsbnScannerScreenState extends State<IsbnScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    formats: const [
      BarcodeFormat.ean13, // ISBN-13 (978/979)
      BarcodeFormat.ean8,
      BarcodeFormat.upcA,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
    ],
  );

  bool _done = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_done) return;
    final value = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (value == null || value.isEmpty) return;
    _done = true;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Scan ISBN Barcode'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.flash_on),
      //       onPressed: () => _controller.toggleTorch(),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.cameraswitch),
      //       onPressed: () => _controller.switchCamera(),
      //     ),
      //   ],
      // ),
      appBar: CustomAppbar(
        title: 'Scan ISBN Barcode',
        backbutton: true,
        scanSection: true,
        scannerController: _controller,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              final denied = error.errorCode == MobileScannerErrorCode.permissionDenied;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 56),
                      const SizedBox(height: 12),
                      Text(
                        denied
                            ? 'Camera permission is needed to scan the barcode.'
                            : 'Camera error: ${error.errorCode.name}',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => denied ? openAppSettings() : _controller.start(),
                        child: Text(denied ? 'Open Settings' : 'Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: Container(
              width: 280,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Text(
              'Align the book barcode inside the frame',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}