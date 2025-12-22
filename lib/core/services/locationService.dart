import 'package:flutter/material.dart';
import '../../Views/shared/widgets/locationDropDown.dart';

class LocationService {

  /// Show location selection dialog
  static Future<bool?> showLocationSelector(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => const locationDropDown(),
    );
  }

}