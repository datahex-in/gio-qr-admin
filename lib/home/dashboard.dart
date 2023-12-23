// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gio_app/constants/color_class.dart';
import 'package:gio_app/constants/image_class.dart';
import 'package:gio_app/constants/textstyle_class.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GioHome extends StatefulWidget {
  const GioHome({super.key});

  @override
  State<GioHome> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<GioHome> {
  TextEditingController phoneController = TextEditingController();
  String qrData = "";
  bool isLoading = false;

  void _generateQRCode() {
    setState(() {
      isLoading = true;
    });

    // Simulate some asynchronous operation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        qrData = phoneController.text;
        isLoading = false;
      });
    });
  }

  void _downloadQRCode() async {
    try {
      // Generate the QR code image data
      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        color: const Color.fromARGB(255, 255, 255, 255),
        emptyColor: const Color.fromARGB(255, 0, 0, 0),
      );

      final imgData = await qrPainter.toImageData(500);
      final buffer = imgData!.buffer.asUint8List();

      // Save the image to gallery
      if (kIsWeb) {
        print('downloading image in web');
        await WebImageDownloader.downloadImageFromUInt8List(uInt8List: buffer);
      } else {
        final result = await ImageGallerySaver.saveImage(buffer);
        print("Image saved: $result");
      }

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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: size.width / 1.3,
                height: size.height / 3,
                child: Image.asset(ImageClass.discurso),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Download your E-Pass',
                  style: TextStyleClass.black16_400qua),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                  ),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '+91',
                            style: TextStyleClass.black15_500,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const VerticalDivider(
                          color: ColorClass.litegray,
                          thickness: 1,
                          width: 25,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Expanded(
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: ' Enter your Phone Number',
                              hintStyle: TextStyleClass.greytext16_400,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _generateQRCode();
                  },
                  child: isLoading
                      ? const SizedBox(
                          width: 100,
                          child: SpinKitWave(
                            color: Color.fromARGB(255, 42, 42, 42),
                            size: 20,
                          ),
                        )
                      : Text(
                          "Get Your QR Code",
                          style: TextStyleClass.black16_400qua,
                        ),
                ),
                const SizedBox(height: 30),
                if (qrData.isNotEmpty)
                  Container(
                    width: size.width / 1.5,
                    height: size.height / 3.2,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: ColorClass.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 33,
                          spreadRadius: -4,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: qrData.isNotEmpty,
                  child: ElevatedButton(
                    onPressed: () {
                      _downloadQRCode();
                    },
                    child: const Text("Download QR Code"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
