import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  QRCodeScannerPageState createState() => QRCodeScannerPageState();
}

class QRCodeScannerPageState extends State<QRCodeScannerPage>
    with SingleTickerProviderStateMixin {
  MobileScannerController cameraController = MobileScannerController();
  String result = "";
  bool isScanning = true;
  bool isFlashOn = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Définition des couleurs professionnelles
  static const Color primaryBlue = Color(0xFF2962FF);
  static const Color secondaryBlue = Color(0xFF2d71b5);
  static const Color lightBlue = Color(0xFFe8f1f8);
  static const Color accentBlue = Color(0xFF0a2d5c);

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 10).animate(_animationController);
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        _showCustomSnackBar(
          'La permission de la caméra est nécessaire pour scanner',
          isError: true,
        );
      }
    }
  }

  void _showCustomSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error : Icons.info,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: isError ? Colors.red : primaryBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scanner le QR Code',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isFlashOn ? secondaryBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                  cameraController.toggleTorch();
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryBlue, primaryBlue, Colors.white],
            stops: [0, 0.2, 0.2],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        setState(() {
                          result = barcode.rawValue ?? "Unknown";
                          isScanning = false;
                        });
                        cameraController.stop();
                        _processTransaction(result);
                      }
                    },
                  ),
                  CustomPaint(
                    painter: ScannerOverlay(
                      borderColor: secondaryBlue,
                      borderRadius: 20,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                  if (isScanning)
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Container(
                          width: 310,
                          height: 310,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: secondaryBlue.withOpacity(0.5),
                              width: _animation.value,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentBlue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  isScanning
                      ? const Column(
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              size: 50,
                              color: primaryBlue,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Scannez un QR code',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentBlue,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Placez le code QR dans le cadre pour scanner',
                              style: TextStyle(
                                color: Color(0xFF0a2d5c),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 50,
                              color: secondaryBlue,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Code scanné : $result',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: accentBlue,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  isScanning = true;
                                  result = "";
                                });
                                cameraController.start();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text(
                                'Scanner à nouveau',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processTransaction(String qrData) {
    final logger = Logger();
    logger.i('Traitement de la transaction avec les données: $qrData');
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay({
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderLength,
    required this.cutOutSize,
  });

  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()
          ..addRRect(
            RRect.fromRectAndRadius(
              rect,
              Radius.circular(borderRadius),
            ),
          ),
      ),
      Paint()..color = Colors.black54,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + borderLength)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + borderLength, rect.top)
        ..moveTo(rect.right - borderLength, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + borderLength)
        ..moveTo(rect.right, rect.bottom - borderLength)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right - borderLength, rect.bottom)
        ..moveTo(rect.left + borderLength, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.bottom - borderLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
