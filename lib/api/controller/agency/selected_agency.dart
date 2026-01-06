import 'package:flutter/material.dart';

class SelectedAgencyProvider with ChangeNotifier {
  String? agencyId;
  String? agencyName;

  void setSelectedAgency(String id, String name) {
    agencyId = id;
    agencyName = name;
    notifyListeners();
  }

  void clear() {
    agencyId = null;
    agencyName = null;
    notifyListeners();
  }
}
