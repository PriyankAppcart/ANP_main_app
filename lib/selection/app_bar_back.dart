import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import '../util/colors_file.dart';

class AppBarBack extends StatelessWidget {

  var title;
  AppBarBack(String title){
    this.title = title;
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(
          5 * SizeConfig.widthMultiplier,
        ),bottomRight: Radius.circular(
          5 * SizeConfig.widthMultiplier,
        )),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [app_color,app_color],
          tileMode: TileMode.repeated,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top:3 * SizeConfig.heightMultiplier),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 3.0 * SizeConfig.heightMultiplier,
                  ),
                  onPressed: () => Navigator.pop(context,""),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 2 *
                              SizeConfig.textMultiplier,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    Text(ApiClient.userName + " "+ ApiClient.roleName,
                        style: TextStyle(
                          fontSize: 1.6 *
                              SizeConfig.textMultiplier,
                          fontFamily: 'Lato',
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ],

        ),
      ),
    );
  }
}
