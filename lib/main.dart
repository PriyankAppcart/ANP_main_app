import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:doer/pages/role.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doer/pages/kf_drawer_page.dart';
import 'package:doer/pages/login_page.dart';
import 'package:doer/util/AppTheme.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:doer/widgets/class_builder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
/*Flutter: prevent device orientation changes and force portrait*/

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp]); // To turn of
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ANP',
              theme: AppTheme.lightTheme,
              home: MyHomePage(),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //     body: checkLoginStatus() ,

        );
  }

  checkLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    bool? login = preferences.getBool("login");
    var userToken = preferences.getString("userToken");
    var userName = preferences.getString("userName");
    var roleId = preferences.getString("roleId");
    var roleName = preferences.getString("roleName");
    var userType = preferences.getString("userType");
    setState(() {
      ApiClient.roleName = roleName.toString();
      ApiClient.roleID = roleId.toString();
      ApiClient.userType = userType.toString();
      ApiClient.userName = userName.toString();
    });
    print("login :: $login");
    print("userToken :: $userToken");

    if (login != null) {
      if (login) {
        /*  ClassBuilder.registerClasses(userToken);
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new KFDrawerPage(userToken));
        Navigator.of(context).pushReplacement(route);*/

        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            getRole(context, userToken);
          } else {
            noInternet(context, userToken);
          }
        } on SocketException catch (_) {
          noInternet(context, userToken);
        }
      } else {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new LoginPage()));
      }
    } else {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new LoginPage()));
      //  print("login Null : $login");
      /*   Timer(
        Duration(seconds: 3),
            () => Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (BuildContext context) => new LoginPage())),// LoginPage
        // return LoginPage();
      );*/
    }
  }

  getRole(BuildContext context, userToken) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialogLoading());

    var url = Uri.parse(ApiClient.BASE_URL + "get_assign_roles");

    print(ApiClient.BASE_URL + "get_assign_roles");
    print('Authorization' + "$userToken");

    var response =
        await http.post(url, headers: {'Authorization': "$userToken"});
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    Navigator.pop(context);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        if (decoded['data'].length == 1) {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setBool("login", true);
          await sharedPreferences.setString(
              "roleId", decoded['data'][0]['role_id'].toString());
          await sharedPreferences.setString("userType",
              decoded['data'][0]['role_name']['user_type'].toString());
          await sharedPreferences.setString(
              "roleName", decoded['data'][0]['role_name']['role_name']);

          setState(() {
            ApiClient.roleName = decoded['data'][0]['role_name']['role_name'];
            ApiClient.roleID = decoded['data'][0]['role_id'].toString();
            ApiClient.userType =
                decoded['data'][0]['role_name']['user_type'].toString();
          });

          ClassBuilder.registerClasses(userToken);
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new KFDrawerPage(userToken));
          Navigator.of(context).pushReplacement(route);
        } else {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new RolePage(userToken, decoded['data']));
          Navigator.of(context).pushReplacement(route);
        }
      } else {
        if (!decoded['token']) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => TokenExpired());
        }
      }
    } else {}
  }

  noInternet(context, userToken) {
    ClassBuilder.registerClasses(userToken);

    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new KFDrawerPage(userToken));
    Navigator.of(context).pushReplacement(route);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
