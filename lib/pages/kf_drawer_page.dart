import 'dart:convert';
import 'dart:io';

import 'package:doer/pages/notification.dart';
import 'package:doer/pages/profile.dart';
import 'package:doer/pages/projects_list.dart';
import 'package:doer/help/help_page.dart';
import 'package:doer/rera/rera_fill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/pages/dashboard_page.dart';
import 'package:doer/pages/logout.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:doer/widgets/class_builder.dart';
import 'package:doer/widgets/exitApp.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors_file.dart';

class KFDrawerPage extends StatefulWidget {

  var userToken;
  KFDrawerPage(userToken){
    this.userToken = userToken;
  }
  @override
  _KFDrawerPageState createState() => new _KFDrawerPageState(userToken);
}

class _KFDrawerPageState extends State<KFDrawerPage> with TickerProviderStateMixin {

  late KFDrawerController _drawerController;

  var userToken;
  _KFDrawerPageState(userToken){
    this.userToken = userToken;
  }

  var version;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('DashboardPage'),
      items: [
        KFDrawerItem.initWithPage(

          text: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Text('Dashboard',   style: TextStyle(
              fontSize: 2.2 *
                  SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.white,
            )),
          ),
          icon: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Image.asset('assets/icons/home.png',color: Colors.white,
                height: 6 * SizeConfig.widthMultiplier,
                width: 6 * SizeConfig.widthMultiplier,
                fit: BoxFit.fill),
          ),
          page: DashboardPage(userToken),

        ),
        KFDrawerItem.initWithPage(

          text: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Text('My Profile',   style: TextStyle(
              fontSize: 2.2 *
                  SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.white,
            )),
          ),
          icon: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Image.asset('assets/icons/user.png',color: Colors.white,
                height: 6 * SizeConfig.widthMultiplier,
                width: 6 * SizeConfig.widthMultiplier,
                fit: BoxFit.fill),
          ),
          page: ProfilePage(userToken,2),

        ),

        KFDrawerItem.initWithPage(
          text: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Text('Help',   style: TextStyle(
              fontSize: 2.2 *
                  SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.white,
            )),
          ),
          icon: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Image.asset('assets/icons/dpr.png',color: Colors.white,
                height: 6 * SizeConfig.widthMultiplier,
                width: 6 * SizeConfig.widthMultiplier,
                fit: BoxFit.fill),
          ),
          page: HelpPage(userToken,2),
        ),
/*

        KFDrawerItem.initWithPage(
          text: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Text('Notification',   style: TextStyle(
              fontSize: 2.2 *
                  SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.white,
            )),
          ),
          icon: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Image.asset('assets/icons/notifications.png',color: Colors.white,
                height: 6 * SizeConfig.widthMultiplier,
                width: 6 * SizeConfig.widthMultiplier,
                fit: BoxFit.fill),
          ),
          page: NotificationPage(userToken,2),
        ),
*/

        KFDrawerItem.initWithPage(
          text: Padding(
            padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Text('Logout',   style: TextStyle(
              fontSize: 2.2 *
                  SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.white,
            )),
          ),
          icon: Padding(
            padding:  EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier,
                top:3.6 * SizeConfig.widthMultiplier),
            child: Image.asset('assets/icons/logout.png',color: Colors.white,
                height: 6 * SizeConfig.widthMultiplier,
                width: 6 * SizeConfig.widthMultiplier,
                fit: BoxFit.fill),
          ),
          page: LogoutPage(),
        ),

      ],
    );

    get();
  }

  get() async {

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
/*
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;*/
    setState(() {
      version = packageInfo.version;
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     body: checkLoginStatus() ,

      body: KFDrawer(

      //  borderRadius: 10.0,
      // shadowBorderRadius: 10.0,
      /*  menuPadding: EdgeInsets.only(top: 2 *
            SizeConfig
                .heightMultiplier,),*/
     scrollable: true,

        controller: _drawerController,
        header: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: (){
              setState(() {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new ProfilePage(userToken,1));
                Navigator.of(context).push(route);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 20 * SizeConfig.widthMultiplier),
              child:  CircleAvatar(
                backgroundImage: AssetImage("assets/icons/app_icon.png"),
                radius: 10 * SizeConfig.widthMultiplier,backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
        footer: KFDrawerItem(
        text: Padding(
          padding:  EdgeInsets.only(left: 2.6 * SizeConfig.widthMultiplier,
              top: 5 * SizeConfig.widthMultiplier),
          child: Text(
            'App Version $version',
              style: TextStyle(
                fontSize: 2.2 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                color: Colors.white,
              )
          ),
        ),
      ),
        decoration: BoxDecoration(
         // color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [site_color,site_color],
            tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }


  Future<bool> _onWillPop() async {

    if(ApiClient.drawerFlag == "1"){
    return (await
    showDialog(context: context, builder: (BuildContext context) => exitApp())
    ) ?? false;
    }else{
      ClassBuilder.registerClasses(userToken);
      Navigator.pushAndRemoveUntil( //160879
          context,
          MaterialPageRoute(
              builder: (context) => new KFDrawerPage(userToken)
          ),
          ModalRoute.withName("/HomePage")
      );
    }
    return true;
  }

}