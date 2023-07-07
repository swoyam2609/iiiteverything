import 'package:flutter/cupertino.dart';

class FindValue extends ChangeNotifier {
  String _subject = "";
  String get subject => _subject;
  String _docType = "";
  String get docType => _docType;

  void updateSubject(String value) {
    _subject = value;
    notifyListeners();
  }

  void updateDoc(String value) {
    _docType = value;
    notifyListeners();
  }
}
