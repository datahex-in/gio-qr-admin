// ignore_for_file: deprecated_member_use, avoid_print, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gio_app/home/qr_provider.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gio_app/constants/color_class.dart';
import 'package:gio_app/constants/image_class.dart';
import 'package:gio_app/constants/textstyle_class.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class GioHome extends StatefulWidget {
  const GioHome({super.key});

  @override
  State<GioHome> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<GioHome> {
  TextEditingController phoneController = TextEditingController();
  String qrData = "";
  bool isLoading = false;
  final Uri _url = Uri.parse('https://discurso.giokerala.org/register/');
  Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

   

  Future<void> _generateQRCode() async {
  String phoneNumber = phoneController.text.trim();
  String formatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check if the cleaned number starts with "91"
    if (cleanedNumber.startsWith("91")) {
      // Remove "91" from the beginning
      cleanedNumber = cleanedNumber.substring(2);
    }

    // Add the country code and format the number
    return "+91 ${cleanedNumber.substring(0, 5)} ${cleanedNumber.substring(5)}";
  }

  // Basic validation: Check if the phone number is not empty and has 10 digits
  if (phoneNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid 10-digit phone number')),
    );
    return;
  }

  // Fetch details for the entered phone number
  QrProvider qrProvider = Provider.of<QrProvider>(context, listen: false);
  qrProvider.mobile = formatPhoneNumber(phoneNumber);
  await qrProvider.getDetails(context: context);

  if (qrProvider.detailsData!.success == true) {
   
  
    setState(() {
      qrData = formatPhoneNumber(phoneNumber);
      isLoading = false;
    });
    // Show a message that the user needs to register
   

    setState(() {
      isLoading = false;
    });
  }
}




// ...

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
        child: Consumer<QrProvider>(
builder: (context,snapshot,child)=>
           Column(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Download Your E-Pass",
                  style: TextStyleClass.black16_400qua,),
                  const SizedBox(height: 20,),
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
    //              Text(snapshot.detailsData!.response.first.name == null
    // ? " "
    // : snapshot.detailsData!.response.first.name.toString()),

                  if (qrData.isNotEmpty)
                    Column(
                      children: [
                          Text("Show this QR code at the registration counter",
                        style: TextStyleClass.black14_400sec,),
                        const SizedBox(height: 10,),

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
                      ],
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
                      child:   Text("Download QR Code",
                      style: TextStyleClass.black16_400qua,),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
