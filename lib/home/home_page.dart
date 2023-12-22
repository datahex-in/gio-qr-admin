import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ImageSaverWeb extends StatefulWidget {
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
    final canvas = Canvas(recorder, Rect.fromPoints(Offset(0.0, 0.0), Offset(200.0, 200.0)));
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
        color: Color.fromARGB(255, 255, 255, 255),
        emptyColor: Color.fromARGB(255, 0, 0, 0),
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
        SnackBar(content: Text('QR code saved to gallery')),
      );
    } catch (e) {
      print("Error saving image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save QR code')),
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
              decoration: InputDecoration(
                hintText: 'Enter text for QR code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateQRCode,
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 16),
            if (qrData.isNotEmpty)
              Image.memory(
                Uint8List.fromList([]), // Placeholder for the image
                width: 200,
                height: 200,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _downloadQRCode,
              child: Text('Download QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageSaverWeb(),
  ));
}
