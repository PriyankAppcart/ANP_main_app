import 'package:doer/pages/login_page.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenExpired extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      await sharedPreferences.setBool("login", false);
      await sharedPreferences.setString("userToken", "");

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          LoginPage()), (Route<dynamic> route) => false);
    });
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 4 * SizeConfig.heightMultiplier,bottom: 4 * SizeConfig.heightMultiplier
              ,left: 2  *SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
          child: Text('Your current token has been expired can you please login again? ',
              style: TextStyle( fontSize: 2 *
              SizeConfig.textMultiplier, color: Colors.black,
                  fontFamily: 'Lato')),
        ),
      ),
    );
  }
}

