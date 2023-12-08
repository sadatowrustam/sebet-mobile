import 'package:flutter/material.dart';
class Counter with ChangeNotifier{

  int _count;
  Counter(this._count);


  int get count => _count;

  set count(int value) {
    _count = value;
  }
   addpro() {
    _count++;
    notifyListeners();
  }
  remove() {
    _count--;
    notifyListeners();
  }
  nully() {
    _count=0;
    notifyListeners();
  }

}