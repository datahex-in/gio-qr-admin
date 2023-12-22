// ignore_for_file: avoid_web_libraries_in_flutter, library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously, avoid_print

import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ImageSaverWeb extends StatefulWidget {
  const ImageSaverWeb({super.key});

  @override
  _ImageSaverWebState createState() => _ImageSaverWebState();
}

class _ImageSaverWebState extends State<ImageSaverWeb> {
  TextEditingController textEditingController = TextEditingController();
  String qrData = "";

  void _generateQRCode() {
    setState(() {
      qrData = textEditingController.text;
    });
  }

  Future<Uint8List> _captureImage(QrPainter painter) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(const Offset(0.0, 0.0), const Offset(200.0, 200.0)));
    painter.paint(canvas, const Size(200.0, 200.0));

    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 200);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  Future<void> _downloadQRCode() async {
    try {
      // Generate the QR code image data
      final img = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        color: const Color.fromARGB(255, 255, 255, 255),
        emptyColor: const Color.fromARGB(255, 0, 0, 0),
      );

      final buffer = await _captureImage(img);

      // Create a blob from the Uint8List
      final blob = html.Blob([buffer]);

      // Create an object URL from the blob
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element with download attribute
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'qr_code.png';

      // Programmatically click the anchor element to trigger the download
      html.document.body?.children.add(anchor);
      anchor.click();

      // Clean up by revoking the object URL
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code saved to gallery')),
      );
    } catch (e) {
      print("Error saving image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save QR code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter text for QR code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateQRCode,
              child: const Text('Generate QR Code'),
            ),
            const SizedBox(height: 16),
            if (qrData.isNotEmpty)
              Image.memory(
                Uint8List.fromList([]), // Placeholder for the image
                width: 200,
                height: 200,
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _downloadQRCode,
              child: const Text('Download QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ImageSaverWeb(),
  ));
}
