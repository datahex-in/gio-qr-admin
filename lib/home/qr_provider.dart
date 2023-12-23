// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gio_app/home/Utils/api_support.dart';
import 'package:gio_app/home/details_model.dart';

import 'package:http/http.dart' as http;

class QrProvider extends ChangeNotifier {
  DetailsModel? detailsData;
  bool detailsDataLoading = false;
  String? mobile = "";

  bool isMobileValid = false;
  Future<void> getDetails() async {
    detailsDataLoading = true;
    notifyListeners();
    Uri url = Uri.parse(Apis.getDetails(mobile));
    var response = await http.get(url);
    print(url.toString());
    print(response.body);

    if (response.statusCode == 200) {
      detailsData = detailsModelFromJson(response.body);
      if (detailsData != null) {
        if (detailsData!.response.isNotEmpty) {
          isMobileValid = true;
          notifyListeners();
        }
        detailsDataLoading = false;
        notifyListeners();
      } else {
        log('error');
        detailsDataLoading = false;
        notifyListeners();
      }
    }
  }
}
