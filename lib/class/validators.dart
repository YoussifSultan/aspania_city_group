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

  static bool isNumericOrEmptyOnly(String text) {
    if (text.isEmpty) {
      return true;
    }
    if (int.tryParse(text) == null) {
      return false;
    } else {
      return true;
    }
  }

  static bool isListEmpty(List<String> text) {
    for (var element in text) {
      String sampleText = element.trim();
      if (sampleText.characters.isEmpty) {
        return true;
      }
      if (sampleText == '') {
        return true;
      }
    }
    return false;
  }

  static bool isAllElementsInListNotEmpty(List<String> text) {
    for (var element in text) {
      String sampleText = element.trim();
      if (sampleText.characters.isNotEmpty) {
        return true;
      }
      if (sampleText != '') {
        return true;
      }
    }
    return false;
  }
}
