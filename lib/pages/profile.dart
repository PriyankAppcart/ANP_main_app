import 'dart:convert';
import 'dart:io';

import 'package:doer/pages/kf_drawer_page.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/class_builder.dart';
import 'package:doer/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors_file.dart';

class ProfilePage extends KFDrawerContent {

  var userToken,backFlag;
  ProfilePage(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  @override
  ProfilePageState createState() => ProfilePageState(userToken,backFlag);
}

class ProfilePageState extends State<ProfilePage> {

  var userToken,backFlag;
  ProfilePageState(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  var firstName,lastName,email,mobileNumber;

  bool aPIFlag = false;
  bool aPIStustFlag = false;
  bool internetConnection = true;
  List roleList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    apiCall(context);
  }

  apiCall(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
        getProfile(context);
        getRole(context);
      }
      else{
        setState(() {
          internetConnection = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        internetConnection = false;
      });
    }
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
                      backFlag ==1?IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 3.0 * SizeConfig.heightMultiplier,
                        ),
                        onPressed: () => Navigator.pop(context,""),
                      ):
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.bars,color: Colors.white,
                          size: 6.0 * SizeConfig.imageSizeMultiplier,),
                        onPressed: widget.onMenuPressed,
                      ),
                      Text("My Profile",
                          style: TextStyle(
                            fontSize: 2.2 *
                                SizeConfig.textMultiplier,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ],

              ),
            ),
          )),

          Expanded( flex: 14,
          child: internetConnection?aPIStustFlag?aPIFlag?
          Column(
            children: [
              Center(
                child: Column(children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/icons/app_icon.png"),
                    radius: 10 * SizeConfig.widthMultiplier,backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Text("$firstName $lastName",
                      style: TextStyle(
                        fontSize: 2.2 *
                            SizeConfig.textMultiplier,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ],),
              ),
              SizedBox(height: 4 * SizeConfig.heightMultiplier,),
              Expanded(
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier,
                  // height: 40 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          5 * SizeConfig.imageSizeMultiplier,
                        ),
                        topRight: Radius.circular(
                          5 * SizeConfig.imageSizeMultiplier,
                        )),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, -2))
                    ],
                    color: Color(0xFFf5f5f5),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.all(4 * SizeConfig.widthMultiplier),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Email ID",
                            style: TextStyle(
                              fontSize: 2.2 *
                                  SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: CustomColor.lightBlack,
                            )),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      Text(email,
                          style: TextStyle(
                            fontSize: 2.2 *
                                SizeConfig.textMultiplier,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: app_color,
                          )),

                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        Text("Mobile No.",
                            style: TextStyle(
                              fontSize: 2.2 *
                                  SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: CustomColor.lightBlack,
                            )),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text(mobileNumber,
                            style: TextStyle(
                              fontSize: 2.2 *
                                  SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              color: app_color,
                            )),
                        SizedBox(height: 2 * SizeConfig.heightMultiplier,),

                        Container(
                          height: 42 * SizeConfig.heightMultiplier,
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
                                          "userType",roleList[index]['user_type'].toString());
                                      await sharedPreferences.setString(
                                          "roleName",roleList[index]['role_name']['role_name']);

                                      setState(() {
                                        ApiClient.roleName = roleList[index]['role_name']['role_name'];
                                        ApiClient.roleID =roleList[index]['role_id'].toString();
                                        ApiClient.userType =roleList[index]['role_name']['user_type'].toString();
                                      });
                                      print("ApiClient.userType :: "+roleList[index]['role_name']['user_type'].toString());
                                      print("ApiClient.userType :: "+ApiClient.userType);

                                      ClassBuilder.registerClasses(userToken);
                                      Navigator.pushAndRemoveUntil( //160879
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => new KFDrawerPage(userToken)
                                          ),
                                          ModalRoute.withName("/HomePage")
                                      );

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
                     /*   Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: Color(0xFFf07e01),
                              splashColor: app_color,
                              minWidth: 28 *
                                  SizeConfig
                                      .widthMultiplier,
                              height: 4.7 *
                                  SizeConfig
                                      .heightMultiplier,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .circular(1.8 *
                                      SizeConfig
                                          .widthMultiplier)),
                              child: Text('Request to change password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 2 *
                                          SizeConfig
                                              .textMultiplier)),
                              onPressed: () async {
                                try {
                                  final result =
                                  await InternetAddress.lookup('google.com');
                                  if (result.isNotEmpty &&result[0].rawAddress.isNotEmpty) {
                                    print('connected : ' +
                                        result[0]
                                            .rawAddress
                                            .toString());
                                  }
                                } on SocketException catch (_) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                                }
                              },
                            ),
                          ],
                        ),*/
                    ],),
                  ),
                ),

              )

            ],
          )
          :Container(
              height: 75 * SizeConfig.heightMultiplier,
              width: 95 * SizeConfig.widthMultiplier,
              decoration: BoxDecoration(
                color: Colors.white,//Color(0xFFf8f8f6),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    25 * SizeConfig.imageSizeMultiplier,
                  ),
                  topLeft: Radius.circular(
                    25 * SizeConfig.imageSizeMultiplier,
                  ),
                  bottomLeft: Radius.circular(
                    25 * SizeConfig.imageSizeMultiplier,
                  ),
                ),
              ),
              child: Column(children: [
                SizedBox(height: 20 * SizeConfig.heightMultiplier),
                Image.asset('assets/icons/no_data_found.png',
                  height: 20 * SizeConfig.widthMultiplier,
                  width: 20 * SizeConfig.widthMultiplier,),
                SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                Text("Doer Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 2.2 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',)),
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                Text("There is no doer profile data found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

              ])
          )
          :Center(child: Container(color:Colors.white,child: CustomDialogLoading1(),))
          :Center(child: Column(children: [
            SizedBox(height: 20 * SizeConfig.heightMultiplier),
            Image.asset('assets/icons/connection_off.png',
              height: 30 * SizeConfig.widthMultiplier,
              width: 30 * SizeConfig.widthMultiplier,),
            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
            Text("Opps, your Connection seems off...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',)),
            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
            Text("Keep calm  and press the refresh button to try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 2.2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
            SizedBox(height: 2.5 * SizeConfig.heightMultiplier),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                MaterialButton(
                  color: app_color,
                  splashColor:  Colors.grey,
                  minWidth: 31 * SizeConfig.widthMultiplier,
                  height: 4.7 * SizeConfig.heightMultiplier,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.8 * SizeConfig.widthMultiplier)),
                  child: Text('Refresh',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                          fontSize:
                          2 * SizeConfig.textMultiplier)),
                  onPressed: ()  {
                    apiCall(context);
                  },
                ),
              ],
            ),

          ],))),




        ])
    );
  }

  getProfile(BuildContext context) async{

    // showDialog(context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"get_user_profile");
    var response = await http.post(url, headers: {'Authorization': "$userToken"});

    print("URL :  ${url}");
    print("Authorization : ${userToken}");

    Map decoded = jsonDecode(response.body);
    // Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      setState(() {
        firstName = decoded['data']['first_name'];
        lastName = decoded['data']['last_name'];
        email = decoded['data']['email'];
        mobileNumber = decoded['data']['mobile_number'];

        aPIFlag = true;
        aPIStustFlag = true;
      });
    }else{
      setState(() {
        aPIFlag = true;
        aPIStustFlag = true;
      });
    }
  }

  getRole(BuildContext context,) async {
    var url = Uri.parse(ApiClient.BASE_URL + "get_assign_roles");

    print("decoded url ::: ${url}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"});
    Map decoded = jsonDecode(response.body);
    print("decoded getRole : ${decoded}");
    print("decoded getRole :::: ${jsonEncode(decoded['data'][2])}");
    print("response.statusCode : ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        if (decoded['data'].length >= 1) {
          setState(() {
            roleList = decoded['data'];
          });

        }
      } else {
        if (decoded['token']) {
          showDialog(context: context,builder: (BuildContext context) =>CustomDialog(decoded['message']));
        }
      }
    } else {}
  }

}
