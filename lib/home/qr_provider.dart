import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:gio_app/home/Utils/api_support.dart';
import 'package:gio_app/home/dashboard.dart';
import 'package:gio_app/home/details_model.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class QrProvider extends ChangeNotifier {
  DetailsModel? detailsData;
  bool detailsDataLoading = false;
  String? mobile = "";
  Future<void> getDetails({
    required BuildContext context,
  }) async {
    
    detailsDataLoading = true;
    notifyListeners();
    Uri url = Uri.parse(Apis.getDetails(mobile));
    var response = await http.get(url);
    log(url.toString());
    log(response.body);

    if (response.statusCode == 200) {
      detailsData = detailsModelFromJson(response.body);

      detailsDataLoading = false;
      notifyListeners();
    } else {
      
      log('error');
      detailsDataLoading = false;
      notifyListeners();
       // ignore: use_build_context_synchronously
       showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          title: const Center(child: Text('Registration Required',
          textAlign: TextAlign.center,)),
          content: SizedBox(
            height: 120, // Adjust the height as needed
            child: Column(
              children: [
                const Text(
                  'Your registration to Discurso Muslimah is not yet received. Register Now',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigate to the provided link
                    // You may need to use a package like 'url_launcher' for this
                    // Example using 'url_launcher':
                   _launchUrl();
                  },
                  child: const Text(
                    'https://discurso.giokerala.org/register/',
                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const GioHome()));
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
    }
  }
  final Uri _url = Uri.parse('https://discurso.giokerala.org/register/');
  Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}

  
}