import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DTextStyle{
  static TextStyle mainHeadline = TextStyle(
    fontSize: 2 * SizeConfig.textMultiplier,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle  bodyLine = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontFamily: 'Lato',
    color: Colors.black,
  );
  static TextStyle  bodyLineBold = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  

}