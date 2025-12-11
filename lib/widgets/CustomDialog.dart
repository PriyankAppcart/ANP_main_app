import 'package:flutter/material.dart';
import 'package:doer/util/SizeConfig.dart';

import '../util/colors_file.dart';

class CustomDialog extends StatelessWidget {
  var msg;
  CustomDialog(msg){
    this.msg = msg;
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Container(
        padding: EdgeInsets.only(
          top: 18.0,
        ),
        margin: EdgeInsets.only(top: 3.5 * SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(4 * SizeConfig.widthMultiplier),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 0.0,
                offset: Offset(0.0, 0.0),
              ),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 3 * SizeConfig.heightMultiplier,
            ),
            Center(
                child: Padding(
                  padding:  EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                  child: new Text(msg, style:TextStyle(fontSize: 2 * SizeConfig.textMultiplier,color: Colors.black)),
                )//
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  color: app_color,
                  splashColor:  app_color,
                  minWidth: 22 * SizeConfig.widthMultiplier,
                  height: 5.2 * SizeConfig.heightMultiplier,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.8 * SizeConfig.widthMultiplier)),
                  child: Text('Ok',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                          1.8 * SizeConfig.textMultiplier)),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 3 * SizeConfig.heightMultiplier),
          ],
        ),
      ),
    );
  }
}