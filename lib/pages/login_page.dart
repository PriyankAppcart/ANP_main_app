import 'dart:convert';
import 'dart:io';

import 'package:doer/pages/role.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doer/pages/kf_drawer_page.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/class_builder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors_file.dart';
//import 'package:upgrader/upgrader.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool checkLatestversion = false;

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscureText = true;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    Future.delayed(const Duration(), () => SystemChannels.textInput.invokeMethod('TextInput.hide'));



    return Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: Stack(
          children: [
            Container(
              height: 100 * SizeConfig.heightMultiplier,
              width: 100 * SizeConfig.widthMultiplier,
              child: Image.asset('assets/icons/image.png', fit: BoxFit.fill),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10 * SizeConfig.heightMultiplier,
                  left: 12 * SizeConfig.widthMultiplier,
                  right: 12 * SizeConfig.widthMultiplier),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
               //  UpgradeAlert(upgrader: Upgrader(shouldPopScope: () => true)),
                  Container(
                    height: 12 * SizeConfig.heightMultiplier,
                    width: 55 * SizeConfig.widthMultiplier,
                    child: Image.asset('assets/icons/kp_logo.png',
                        fit: BoxFit.fill),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 80 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(
                        2 * SizeConfig.imageSizeMultiplier,
                      )),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: TextFormField(
                          style: new TextStyle(
                            color: app_color,
                            fontSize: 2 * SizeConfig.heightMultiplier,
                            fontFamily: 'Lato-Regular',
                          ),
                          controller: _email,
                          cursorColor: app_color,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                          onFieldSubmitted: (term) {
                            _fieldFocusChange(
                                context, _emailFocus, _passwordFocus);
                          },
                          decoration: InputDecoration(
                            // labelText: "Enter Email",
                            // isDense: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1 * SizeConfig.widthMultiplier,
                                horizontal: 1 * SizeConfig.widthMultiplier),

                            hintText: "Email ID",
                            hintStyle: TextStyle(
                              color: app_color,
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                            ),

                            suffixIcon: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.envelope,
                                color: app_color,
                                size: 4.5 * SizeConfig.imageSizeMultiplier,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80 * SizeConfig.widthMultiplier,
                    child: Divider(
                      thickness: 1.2,
                      color: app_color,
                    ),
                  ),
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  Container(
                    height: 5 * SizeConfig.heightMultiplier,
                    width: 80 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(
                        2 * SizeConfig.imageSizeMultiplier,
                      )),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                        child: TextFormField(
                          style: new TextStyle(
                            color: app_color,
                            fontSize: 2 * SizeConfig.heightMultiplier,
                            fontFamily: 'Lato',
                          ),
                          controller: _password,
                          obscureText: _obscureText,
                          cursorColor: app_color,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus,
                          onFieldSubmitted: (value) {
                            _passwordFocus.unfocus();
                            //  _calculator();
                          },
                          decoration: InputDecoration(
                            // labelText: "Enter Email",
                            // isDense: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: new EdgeInsets.symmetric(
                                vertical: 1 * SizeConfig.widthMultiplier,
                                horizontal: 1 * SizeConfig.widthMultiplier),

                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: app_color,
                              fontSize: 2 * SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                            ),

                            suffixIcon: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.lockOpen,
                                color: app_color,
                                size: 4.5 * SizeConfig.imageSizeMultiplier,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80 * SizeConfig.widthMultiplier,
                    child: Divider(
                      thickness: 1.2,
                      color: app_color,
                    ),
                  ),
                  SizedBox(
                    height: 5 * SizeConfig.heightMultiplier,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: app_color,
                        splashColor: app_color,
                        minWidth: 31 * SizeConfig.widthMultiplier,
                        height: 4.7 * SizeConfig.heightMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                1.8 * SizeConfig.widthMultiplier)),
                        child: Text('LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * SizeConfig.textMultiplier)),
                        onPressed: () async {
                          //   var a = bloc.loginEmaill.toString();

                          try {
                            final result = await InternetAddress.lookup('google.com');
                            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                              print('connected : ' +
                                  result[0].rawAddress.toString());

                              FocusScope.of(context).unfocus();


                              // NotificationPlugin;
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (!_email.text.isEmpty) {
                                if (regExp.hasMatch(_email.text)) {
                                  if (!_password.text.isEmpty) {
                                    getLogin(context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialog(
                                                "Password is required"));
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialog(
                                              "Invalid email address"));
                                }
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialog(
                                            "Email address is required"));
                              }
                            }
                          } on SocketException catch (_) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialog("Check net connection"));
                          }
                        },
                      )
                    ],
                  ),
                ],
              )),
            ),
          ],
        ));
  }

  getLogin(BuildContext context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialogLoading());

    var url = Uri.parse(ApiClient.BASE_URL + 'login');
    Map map = {
      "email": _email.text,
      "password": _password.text,
      "FCM_token": "fgdgggfdd",
    };

    print("jsonMap " + json.encode(map));

    final response = await http.post(url, body: map);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    print("response.statusCode ${response.statusCode}");
    Map decoded = jsonDecode(response.body);
    Navigator.pop(context);
    if (decoded['status']) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setBool("login", true);
      await sharedPreferences.setString(
          "userToken", decoded['data']['access_token'].toString());
      await sharedPreferences.setString(
          "userName", decoded['data']['user_name'].toString());
      setState(() {
        ApiClient.userName =  decoded['data']['user_name'].toString();
      });

      getRole(context, decoded['data']['access_token'],decoded['data']['user_name']);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(decoded['message']));
    }
  }

  getRole(BuildContext context, userToken,userName) async {
    var url = Uri.parse(ApiClient.BASE_URL + "get_assign_roles");



    var response =
        await http.post(url, headers: {'Authorization': "$userToken",'Accept': "*/*",});
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {

            if (decoded['data'].length == 1) {

              SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
              await sharedPreferences.setBool("login", true);
              await sharedPreferences.setString(
                  "roleId",decoded['data'][0]['role_id'].toString());
              await sharedPreferences.setString(
                  "userType",decoded['data'][0]['role_name']['user_type'].toString());
              await sharedPreferences.setString(
                  "roleName",decoded['data'][0]['role_name']['role_name']);
              setState(() {
                ApiClient.roleName = decoded['data'][0]['role_name']['role_name'];
                ApiClient.roleID =decoded['data'][0]['role_id'].toString();
                ApiClient.userType =decoded['data'][0]['role_name']['user_type'].toString();
              });


                ClassBuilder.registerClasses(userToken);
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new KFDrawerPage(userToken));
                Navigator.of(context).pushReplacement(route);
            } else {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) => new RolePage(userToken,decoded['data']));
                Navigator.of(context).pushReplacement(route);
            }
      } else {
        if (decoded['token']) {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  CustomDialog(decoded['message']));
        }
      }
    } else {}
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
