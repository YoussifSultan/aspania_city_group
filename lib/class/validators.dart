import 'package:flutter/material.dart';

class Validators {
  static bool isArabicOnly(String text) {
    for (var character in text.toString().characters) {
      //NOTE - This Are The caracters that can't be written
      if (RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(character)) {
        return false;
      }
    }
    return true;
  }

  static bool isNumericOnly(String text) {
    if (int.tryParse(text) == null) {
      return false;
    } else {
      return true;
    }
  }
}
