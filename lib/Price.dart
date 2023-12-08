import 'package:flutter/material.dart';
class Price with ChangeNotifier{

  double _sana;
  Price(this._sana);
  double get sana => _sana;
  set sana(double value) {
    _sana = value;
  }

  addpro(double price) {
    _sana=_sana+price;
    notifyListeners();
  }
  removePro(double price) {
    _sana=_sana-price;
    notifyListeners();
  }
  nola() {
    _sana=0;
    notifyListeners();
  }

}