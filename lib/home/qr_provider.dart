import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:gio_app/home/Utils/api_support.dart';
import 'package:gio_app/home/details_model.dart';

import 'package:http/http.dart' as http;

class QrProvider extends ChangeNotifier {
  DetailsModel? detailsData;
  bool detailsDataLoading = false;
  String? mobile = "";
  Future<void> getDetails() async {
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
    }
  }


  
}