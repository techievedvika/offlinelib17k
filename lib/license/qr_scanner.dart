import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class LicenseQrScannerPage extends StatefulWidget {
  const LicenseQrScannerPage({super.key});

  @override
  State<LicenseQrScannerPage> createState() => _LicenseQrScannerPageState();
}

class _LicenseQrScannerPageState extends State<LicenseQrScannerPage> {
  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool scanned = false;
  bool _hasPermission = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (mounted) {
        setState(() {
          _hasPermission = true;
          _isCheckingPermission = false;
        });
      }
    } else {
      final result = await Permission.camera.request();
      if (mounted) {
        setState(() {
          _hasPermission = result.isGranted;
          _isCheckingPermission = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String _extractLicenseKey(String rawValue) {
    final trimmed = rawValue.trim();

    // 1. Try parsing JSON
    if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
        (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map<String, dynamic>) {
          for (final key in [
            'license_key',
            'licenseKey',
            'license',
            'key',
            'code',
            'qr_code'
          ]) {
            if (decoded.containsKey(key) &&
                decoded[key] != null &&
                decoded[key].toString().trim().isNotEmpty) {
              return decoded[key].toString().trim();
            }
          }
        }
      } catch (_) {}
    }

    // 2. Try parsing URL query parameters
    try {
      final uri = Uri.parse(trimmed);
      if (uri.hasQuery) {
        for (final key in [
          'license_key',
          'licenseKey',
          'license',
          'key',
          'code'
        ]) {
          final val = uri.queryParameters[key];
          if (val != null && val.trim().isNotEmpty) {
            return val.trim();
          }
        }
      }
    } catch (_) {}

    // 3. Fallback to raw trimmed string
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan License QR'),
        actions: [
          if (_hasPermission) ...[
            IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: () => controller.toggleTorch(),
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              onPressed: () => controller.switchCamera(),
            ),
          ],
        ],
      ),
      body: _isCheckingPermission
          ? const Center(child: CircularProgressIndicator())
          : !_hasPermission
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Camera permission is required to scan the License QR code.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            final status = await Permission.camera.request();
                            if (status.isPermanentlyDenied) {
                              openAppSettings();
                            } else {
                              _checkAndRequestPermission();
                            }
                          },
                          child: const Text('Grant Camera Permission'),
                        ),
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    MobileScanner(
                      controller: controller,
                      errorBuilder: (context, error) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Camera Error: ${error.errorCode.name}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => controller.start(),
                                  child: const Text('Retry Camera'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onDetect: (capture) {
                        if (scanned) return;

                        final barcode = capture.barcodes.firstOrNull;
                        final value = barcode?.rawValue;

                        if (value != null && value.trim().isNotEmpty) {
                          scanned = true;
                          final cleanKey = _extractLicenseKey(value);

                          Navigator.pop(
                            context,
                            cleanKey,
                          );
                        }
                      },
                    ),
                    Center(
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Align the License QR code within the frame',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
