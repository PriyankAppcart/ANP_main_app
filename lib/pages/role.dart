import 'dart:convert';
import 'dart:io';

import 'package:doer/util/ApiClient.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doer/pages/kf_drawer_page.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/class_builder.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RolePage extends StatefulWidget {
  var userToken,roleList;
  RolePage(userToken, roleList) {
    this.userToken = userToken;
    this.roleList = roleList;
  }

  @override
  _RolePageState createState() => _RolePageState(userToken,roleList);
}

class _RolePageState extends State<RolePage> {
  var userToken, roleList;
  _RolePageState(userToken, roleList) {
    this.userToken = userToken;
    this.roleList = roleList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: roleList.length >= 1?SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(height: 10 * SizeConfig.heightMultiplier,),
            Container(
              width: 100 * SizeConfig.widthMultiplier,
              child: Center(child: Text("choose your role",
                  style: TextStyle(
                    fontSize: 2.2 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )))
            ),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Container(
                width: 80 * SizeConfig.widthMultiplier,
                child: Center(child: Text("Once you choose your role you can access all application by using the selected role ",
                    style: TextStyle(
                      fontSize: 2 *
                          SizeConfig.textMultiplier,
                      fontFamily: 'Lato',
                      color: Colors.black,
                    )))
            ),
            SizedBox(height: 2 * SizeConfig.heightMultiplier,),
            Container(
              height: 76 * SizeConfig.heightMultiplier,
              child:  ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: roleList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  Padding(
                      padding:  EdgeInsets.all( 2 * SizeConfig.widthMultiplier),
                      child:  InkWell(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          await sharedPreferences.setString(
                              "roleId",roleList[index]['role_id'].toString());
                          await sharedPreferences.setString(
                              "userType",roleList[index]['role_name']['user_type'].toString());
                          await sharedPreferences.setString(
                              "roleName",roleList[index]['role_name']['role_name']);
                            setState(() {
                              ApiClient.roleName = roleList[index]['role_name']['role_name'];
                              ApiClient.roleID =roleList[index]['role_id'].toString();
                              ApiClient.userType =roleList[index]['role_name']['user_type'].toString();
                            });



                          ClassBuilder.registerClasses(userToken);
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) => new KFDrawerPage(userToken));
                          Navigator.of(context).pushReplacement(route);

                        },
                        child: Container(
                            height: 10 * SizeConfig.heightMultiplier,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                2 * SizeConfig.imageSizeMultiplier,
                              )),
                              color:Colors.white,
                              shape: BoxShape.rectangle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0.0, 0.75))
                              ],
                            ),
                            child:Center(
                              child: Row(
                                children: [
                                  SizedBox(width: 4 * SizeConfig.heightMultiplier,),
                                  Container(
                                    child: Image.asset('assets/icons/user.png',color: Colors.black,
                                        height: 6 * SizeConfig.widthMultiplier,
                                        width: 6 * SizeConfig.widthMultiplier,
                                        fit: BoxFit.fill),
                                  ),
                                  SizedBox(width: 2 * SizeConfig.heightMultiplier,),
                                  Text(roleList[index]['role_name']['role_name'],
                                      style: TextStyle(
                                        fontSize: 2 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),),
                      ),
                    );
                  }),
            )
          ]),
        )
            :Container(
            height: 75 * SizeConfig.heightMultiplier,
            width: 95 * SizeConfig.widthMultiplier,
            child: Column(children: [
              SizedBox(height: 20 * SizeConfig.heightMultiplier),
              Image.asset('assets/icons/no_data_found.png',
                height: 20 * SizeConfig.widthMultiplier,
                width: 20 * SizeConfig.widthMultiplier,),
              SizedBox(height: 3 * SizeConfig.heightMultiplier,),
              Text("User Role",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 2.2 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lato',)),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Text("There is no role found",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
              SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

            ])
        ));
  }

  getRole(BuildContext context, userToken) async {
    var url = Uri.parse(ApiClient.BASE_URL + "get_assign_roles");

    var response =
    await http.post(url, headers: {'Authorization': "$userToken"});
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
          showDialog(context: context,builder: (BuildContext context) =>CustomDialog(decoded['message']));
        }
      }
    } else {}
  }
}
