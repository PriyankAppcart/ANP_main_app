import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/pages/login_page.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors_file.dart';

class LogoutPage extends KFDrawerContent {

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {


  @override
  void initState() {
    // TODO: implement initState
    ApiClient.drawerFlag = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: Column(children: <Widget>[
          Expanded( flex: 2,child:
          Container(
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
                        icon: FaIcon(FontAwesomeIcons.bars,color: Colors.white,
                          size: 6.0 * SizeConfig.imageSizeMultiplier,),
                        onPressed: widget.onMenuPressed,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Logout",
                              style: TextStyle(
                                fontSize: 2 *
                                    SizeConfig.textMultiplier,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],

              ),
            ),
          )),

          Expanded( flex: 14,
              child: Center(
                child:   Container(
                  height: 75 * SizeConfig.heightMultiplier,
                  width: 95 * SizeConfig.widthMultiplier,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8 * SizeConfig.widthMultiplier, right: 8 * SizeConfig.widthMultiplier),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[

                          ],),
                        Text('Are you sure you want to logout now?',

                            style: TextStyle(
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                color: Colors.black,
                              fontFamily: 'Lato',
                            )),
                        SizedBox(height: 5 * SizeConfig.heightMultiplier),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: app_color,
                              splashColor: app_color,
                              minWidth: 28 *
                                  SizeConfig.widthMultiplier,
                              height: 4.7 *
                                  SizeConfig.heightMultiplier,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .circular(1.8 *
                                      SizeConfig
                                          .widthMultiplier)),
                              child: Text('Logout',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                      2 * SizeConfig.textMultiplier,
                                    fontFamily: 'Lato',)),
                              onPressed: () async {



                                SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                                await sharedPreferences.setBool("login", false);
                                await sharedPreferences.setString("userToken", "");

                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    LoginPage()), (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        )

                      ],),
                  ),
                ),
              )),

        ])
    );


  }

}
