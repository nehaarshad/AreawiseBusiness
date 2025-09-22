import 'package:flutter/material.dart';
Color StatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'approved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'dispatched':
      return Colors.blue;
    case 'delivered':
      return Colors.purple;
    case 'completed':
      return Colors.amber;
    default:
      return Colors.grey;
  }
}