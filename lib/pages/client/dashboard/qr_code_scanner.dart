import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  QRCodeScannerPageState createState() => QRCodeScannerPageState();
}

class QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = "";
  bool isScanning = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'La permission de la caméra est nécessaire pour scanner')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le QR Code'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.deepPurple,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isScanning
                  ? const Text(
                      'Scannez un QR code pour effectuer une transaction')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Résultat: $result'),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isScanning = true;
                              result = "";
                            });
                            controller?.resumeCamera();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                          child: Text('Scanner à nouveau'),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
        isScanning = false;
      });
      controller.pauseCamera();
      _processTransaction(result);
    });
  }

  void _processTransaction(String qrData) {
    final logger = Logger();

    // Ici, vous pouvez ajouter la logique pour traiter la transaction
    // Par exemple, analyser les données du QR code et effectuer une action
    logger.i('Traitement de la transaction avec les données: $qrData');
    // Vous pouvez naviguer vers une nouvelle page ou afficher un dialogue de confirmation ici
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
