
import 'dart:convert';
import 'dart:io';

import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/selection/checklist_history.dart';
import 'package:doer/style/text_style.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../util/colors_file.dart';

class FillQCPage extends KFDrawerContent {

  var userToken,data;
  FillQCPage(userToken,data){
    this.userToken = userToken;
    this.data = data;
  }

  @override
  FillQCPageState createState() => FillQCPageState(userToken,data);
}

enum status { before, after }
class FillQCPageState extends State<FillQCPage> {

  var userToken,data;
  FillQCPageState(userToken,data){
    this.userToken = userToken;
    this.data = data;
  }

  List<bool> selected = [];
  List<int> selectedYesNo = [];
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNode = [];

  List<TextEditingController> _controllersChecker = [];
  List<FocusNode> _focusNodeChecker = [];

  List<dynamic> _image = [];

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;


  final approvedWithComments = TextEditingController();
  final FocusNode approvedWithCommentsFocus = FocusNode();

  final revokeWithComments = TextEditingController();
  final FocusNode revokeWithCommentsFocus = FocusNode();

  List checklist = [];
  List afterChecklist = [];
  List beforeChecklist = [];
  List checklistData = [];
  status? statusBefore = status.before;
  var phaseFlag = 1;
  List listMap = [];
  List<bool> photoCompulsory = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    print("data $data");

    apiCall(context);


  }
  apiCall(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
        viewCheckList(context);
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
        body: Stack(
          children: [
            Container(
              height: 40 * SizeConfig.heightMultiplier,
              color: app_color,
            ),
            Column(children: <Widget>[

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
                              Text("Quality Checklist",
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
              )),

              Flexible( flex: 14,
                  child: internetConnection?apiStustFlag?apiFlag?
                  SingleChildScrollView(
                    child: Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(
                          5 * SizeConfig.widthMultiplier,
                        ),topRight: Radius.circular(
                          5 * SizeConfig.widthMultiplier,
                        )),
                      ),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.start,
                        children: [
                          SizedBox( height: 3 * SizeConfig.heightMultiplier,),
                          Padding(
                            padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Checklist Code",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                                SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                Text(checklistData[0]['checklist_code'],
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.lightBlack,
                                    )),
                                SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                                Text("Checklist Name",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                                SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                Text(checklistData[0]['checklist_name'],
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.lightBlack,
                                    )),
                                SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                                Text("Project & Building",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                                SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                Text("${checklistData[0]['project_name']}, ${checklistData[0]['building_name']}",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.lightBlack,
                                    )),
                                SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                                Row(
                                  children: [
                                    Text("Phase",
                                        style: TextStyle(
                                          fontSize: 1.8 *
                                              SizeConfig.textMultiplier,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          color: app_color,
                                        )),
                                    SizedBox(width:  3 * SizeConfig.widthMultiplier,),
                                    Radio(
                                      //focusColor: Color(0xFF7a8d56),
                                      activeColor: app_color,
                                      value: status.before,
                                      groupValue: statusBefore,
                                      onChanged: (status? value) {
                                        setState(() {
                                          statusBefore = value;
                                          phaseFlag = 1;
                                          beforeCheckList();
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          statusBefore = status.before;
                                            phaseFlag = 1;
                                           beforeCheckList();
                                        });
                                      },
                                      child: Text("Before",
                                          style: TextStyle(
                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                            color: CustomColor.lightBlack,
                                          )),
                                    ),

                                    Radio(
                                      focusColor: app_color,
                                      activeColor: app_color,
                                      value: status.after,
                                      groupValue: statusBefore,
                                      onChanged: (status? value) {
                                        setState(() {
                                          if(checklistData[0]['after_phase'] == 2 || (checklistData[0]['status'] == 3 || checklistData[0]['status'] == 4)){
                                            statusBefore = status.after;
                                            phaseFlag = 2;
                                            afterCheckList();
                                          }
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          if(checklistData[0]['after_phase'] == 2 || (checklistData[0]['status'] == 3 || checklistData[0]['status'] == 4)){
                                            statusBefore = status.after;
                                            phaseFlag = 2;
                                            afterCheckList();
                                          }

                                        });
                                      },
                                      child: Text("After",
                                          style: TextStyle(
                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                            color: CustomColor.lightBlack,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),

                                Text("Contractor",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                                SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                Text(checklistData[0]['contractor_name'],
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.lightBlack,
                                    )),
                                SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                Text("Location",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                                SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                                Text(getUnit(checklistData[0]),
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                    )),
                                SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                              ],
                            ),
                          ),
                          SizedBox( height: 2 * SizeConfig.heightMultiplier,),
                          (ApiClient.userType == "1" || ApiClient.userType == "2") && phaseFlag == 2 && checklistData[0]['after_phase'] == 0 && (checklistData[0]['status'] == 3 || checklistData[0]['status'] == 4)?
                         /* Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                color: app_color,
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
                                child: Text('Create After Phase',
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
                                    afterSave(context,1,"");
                                  } on SocketException catch (_) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                                  }
                                },
                              ),
                            ],
                          )*/
                          Center(
                            child: Padding(
                              padding:  EdgeInsets.only(top: 5 * SizeConfig.heightMultiplier),
                              child: Text("After checklist Item not found\n Please contact to admin ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.5 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                            ),
                          )
                         :ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: checklist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return  Stack(
                                  children: [
                                    Container(
                                      height: 5 * SizeConfig.heightMultiplier,
                                      color: Color(0xFFf5f5f5),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("index :: $index  :: ${selected.length}");
                                        print("index :: ${selected[index]}");
                                        for(int i = 0; i< selected.length; i++){

                                          setState(() {
                                            if(index == i){
                                              setState(() {
                                                selected[index] = true;
                                                print("index if $index :: i $i  :: ${selected[index]}");
                                              });

                                            }else{
                                              setState(() {
                                                selected[i] = false;
                                              });
                                            }
                                          });


                                        }
                                        print("selected ::  $selected");
                                      },
                                      child: Container(
                                        width: 100 * SizeConfig.widthMultiplier,
                                        //  height: selected[1]?70 * SizeConfig.heightMultiplier:10 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                4 * SizeConfig.imageSizeMultiplier,
                                              ),
                                              topRight: Radius.circular(
                                                4 * SizeConfig.imageSizeMultiplier,
                                              )),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 4,
                                                offset: Offset(0, -2))
                                          ],
                                          color: Color(0xFFf5f5f5),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 4 * SizeConfig.widthMultiplier),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 80 * SizeConfig.widthMultiplier,
                                                    child: Text(checklist[index]['checklist_item'],
                                                        style: TextStyle(
                                                          fontSize:
                                                          1.8 * SizeConfig.textMultiplier,
                                                          fontFamily: 'Lato',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                                    child: Icon(
                                                      selected[index]
                                                          ? Icons.keyboard_arrow_up
                                                          : Icons.keyboard_arrow_down,
                                                      color: app_color,
                                                      size:
                                                      3.0 * SizeConfig.heightMultiplier,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: selected[index] == false ? 3 * SizeConfig.heightMultiplier : 0,
                                              ),
                                              selected[index]?
                                    phaseFlag == 1?
                                              ApiClient.userType =="1"?
                                                  "${checklistData[0]['status']}" == "0" || "${checklistData[0]['status']}" == "1" || "${checklistData[0]['status']}" == "5"?
                                                  Column(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            //focusColor: Color(0xFF7a8d56),
                                                            activeColor: app_color,
                                                            value: 1,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYesNo[index] = 1;
                                                              });
                                                            },
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedYesNo[index] = 1;
                                                              });
                                                            },
                                                            child: Text("Yes",
                                                                style: TextStyle(
                                                                  fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                  color: CustomColor.lightBlack,
                                                                )),
                                                          ),

                                                          Radio(
                                                            focusColor: app_color,
                                                            activeColor: app_color,
                                                            value: 2,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedYesNo[index] = 2;
                                                              });
                                                            },
                                                          ),
                                                          GestureDetector(
                                                            onTap: (){
                                                              setState(() {
                                                                selectedYesNo[index] = 2;
                                                              });
                                                            },
                                                            child: Text("No",
                                                                style: TextStyle(
                                                                  fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                  color: CustomColor.lightBlack,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),

                                                      Text("Doer Comment:",
                                                          style: TextStyle(
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontFamily: 'Lato',
                                                            color: Colors.black,
                                                          )),
                                                      SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                      Container(
                                                        width: 94 *
                                                            SizeConfig.widthMultiplier,
                                                        height: 8 *
                                                            SizeConfig.heightMultiplier,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(
                                                                2 *
                                                                    SizeConfig
                                                                        .imageSizeMultiplier,
                                                              )),
                                                          // color: Color(0xFFba3d41),
                                                          shape: BoxShape.rectangle,
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  right: 2 *
                                                                      SizeConfig
                                                                          .widthMultiplier),
                                                              child: Container(
                                                                width: 90 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                height: 10 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                child: TextFormField(
                                                                  style: new TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 2 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    fontFamily: 'Lato',
                                                                  ),
                                                                  controller: _controllers[index],
                                                                  cursorColor:
                                                                  Colors.black,
                                                                  keyboardType:
                                                                  TextInputType.text,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  focusNode:
                                                                  _focusNode[index],
                                                                  maxLines: 2,
                                                                  onFieldSubmitted:
                                                                      (value) {
                                                                    _focusNode[index]
                                                                        .unfocus();
                                                                    //  _calculator();
                                                                  },
                                                                  decoration:
                                                                  InputDecoration(
                                                                    // labelText: "Enter Email",
                                                                    // isDense: true,
                                                                    border:
                                                                    InputBorder.none,
                                                                    focusedBorder:
                                                                    InputBorder.none,
                                                                    enabledBorder:
                                                                    InputBorder.none,
                                                                    errorBorder:
                                                                    InputBorder.none,
                                                                    disabledBorder:
                                                                    InputBorder.none,
                                                                    contentPadding: new EdgeInsets
                                                                        .symmetric(
                                                                        vertical: 1 *
                                                                            SizeConfig
                                                                                .widthMultiplier,
                                                                        horizontal: 1 *
                                                                            SizeConfig
                                                                                .widthMultiplier),

                                                                    hintText: "",
                                                                    hintStyle: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 2 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontFamily: 'Lato',
                                                                    ),
                                                                  ),
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                      SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                                                      Row(
                                                        children: [
                                                          Text("Upload Photo",
                                                              style: TextStyle(
                                                                fontSize: 1.8 *
                                                                    SizeConfig.textMultiplier,
                                                                fontFamily: 'Lato',
                                                                color: Colors.black,
                                                              )),
                                                          checklist[index]['photo_compulsory'] == 1?
                                                          Text(" ( Photo compulsory )",
                                                              style: TextStyle(
                                                                fontSize: 1.8 *
                                                                    SizeConfig.textMultiplier,
                                                                fontFamily: 'Lato',
                                                                color: Colors.red,
                                                              )):Container(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 0.5 *
                                                            SizeConfig.heightMultiplier,
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                get_image(ImageSource.camera,index);
                                                              },
                                                              child: Container(
                                                                width: 30 *
                                                                    SizeConfig.widthMultiplier,
                                                                height: 10 *
                                                                    SizeConfig.heightMultiplier,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                        2 *
                                                                            SizeConfig
                                                                                .imageSizeMultiplier,
                                                                      )),
                                                                  // color: Color(0xFFba3d41),
                                                                  shape: BoxShape.rectangle,
                                                                  border: Border.all(
                                                                    color: Colors.grey,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: _image[index] == ""?Text(
                                                                      "Click to Upload\n the image",
                                                                      style: TextStyle(
                                                                        fontSize: 1.8 *
                                                                            SizeConfig
                                                                                .textMultiplier,
                                                                        fontFamily: 'Lato',
                                                                        color: Colors.black,
                                                                      )):Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(
                                                                              2 *
                                                                                  SizeConfig
                                                                                      .imageSizeMultiplier,
                                                                            )),
                                                                        // color: Color(0xFFba3d41),
                                                                        shape: BoxShape.rectangle,
                                                                        image: new DecorationImage(
                                                                          image: FileImage(_image[index]),
                                                                          fit: BoxFit.cover,
                                                                        ),

                                                                      )),
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                    ],
                                                  )
                                                  :Column(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            //focusColor: Color(0xFF7a8d56),
                                                            activeColor: app_color,
                                                            value: 1,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                            },
                                                          ),
                                                          Text("Yes",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),

                                                          Radio(
                                                            focusColor: app_color,
                                                            activeColor: app_color,
                                                            value: 2,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                            },
                                                          ),
                                                          Text("No",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),
                                                        ],
                                                      ),
                                                      ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                    ],
                                                  )
                                              :ApiClient.userType == "2"?
                                                "${checklistData[0]['status']}" == "0" || "${checklistData[0]['status']}" == "1" || "${checklistData[0]['status']}" == "2" || "${checklistData[0]['status']}" == "5" || "${checklistData[0]['status']}" == "5"?
                                                 Column(
                                                  mainAxisAlignment:MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Radio(
                                                          //focusColor: Color(0xFF7a8d56),
                                                          activeColor: app_color,
                                                          value: 1,
                                                          groupValue: selectedYesNo[index],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedYesNo[index] = 1;
                                                            });
                                                          },
                                                        ),
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              selectedYesNo[index] = 1;
                                                            });
                                                          },
                                                          child: Text("Yes",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),
                                                        ),

                                                        Radio(
                                                          focusColor: app_color,
                                                          activeColor: app_color,
                                                          value: 2,
                                                          groupValue: selectedYesNo[index],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              selectedYesNo[index] = 2;
                                                            });
                                                          },
                                                        ),
                                                        GestureDetector(
                                                          onTap: (){
                                                            setState(() {
                                                              selectedYesNo[index] = 2;
                                                            });
                                                          },
                                                          child: Text("No",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                    ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),

                                                    Text("Doer Comment:",
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig.textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.black,
                                                        )),
                                                    SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                    Container(
                                                      width: 94 *
                                                          SizeConfig.widthMultiplier,
                                                      height: 8 *
                                                          SizeConfig.heightMultiplier,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                              2 *
                                                                  SizeConfig
                                                                      .imageSizeMultiplier,
                                                            )),
                                                        // color: Color(0xFFba3d41),
                                                        shape: BoxShape.rectangle,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                right: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier),
                                                            child: Container(
                                                              width: 90 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              child: TextFormField(
                                                                style: new TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 2 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  fontFamily: 'Lato',
                                                                ),
                                                                controller: _controllers[index],
                                                                cursorColor:
                                                                Colors.black,
                                                                keyboardType:
                                                                TextInputType.text,
                                                                textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                                focusNode:
                                                                _focusNode[index],
                                                                maxLines: 2,
                                                                onFieldSubmitted:
                                                                    (value) {
                                                                  _focusNode[index]
                                                                      .unfocus();
                                                                  //  _calculator();
                                                                },
                                                                decoration:
                                                                InputDecoration(
                                                                  // labelText: "Enter Email",
                                                                  // isDense: true,
                                                                  border:
                                                                  InputBorder.none,
                                                                  focusedBorder:
                                                                  InputBorder.none,
                                                                  enabledBorder:
                                                                  InputBorder.none,
                                                                  errorBorder:
                                                                  InputBorder.none,
                                                                  disabledBorder:
                                                                  InputBorder.none,
                                                                  contentPadding: new EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 1 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      horizontal: 1 *
                                                                          SizeConfig
                                                                              .widthMultiplier),

                                                                  hintText: "",
                                                                  hintStyle: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 2 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontFamily: 'Lato',
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                                                    Text("Checker Comment:",
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig.textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.black,
                                                        )),
                                                    SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                    Container(
                                                      width: 94 *
                                                          SizeConfig.widthMultiplier,
                                                      height: 8 *
                                                          SizeConfig.heightMultiplier,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(
                                                              2 *
                                                                  SizeConfig
                                                                      .imageSizeMultiplier,
                                                            )),
                                                        // color: Color(0xFFba3d41),
                                                        shape: BoxShape.rectangle,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                            padding: EdgeInsets.only(
                                                                left: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                                right: 2 *
                                                                    SizeConfig
                                                                        .widthMultiplier),
                                                            child: Container(
                                                              width: 90 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              child: TextFormField(
                                                                style: new TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 2 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  fontFamily: 'Lato',
                                                                ),
                                                                controller: _controllersChecker[index],
                                                                cursorColor:
                                                                Colors.black,
                                                                keyboardType:
                                                                TextInputType.text,
                                                                textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                                focusNode:
                                                                _focusNodeChecker[index],
                                                                maxLines: 2,
                                                                onFieldSubmitted:
                                                                    (value) {
                                                                      _focusNodeChecker[index]
                                                                      .unfocus();
                                                                  //  _calculator();
                                                                },
                                                                decoration:
                                                                InputDecoration(
                                                                  // labelText: "Enter Email",
                                                                  // isDense: true,
                                                                  border:
                                                                  InputBorder.none,
                                                                  focusedBorder:
                                                                  InputBorder.none,
                                                                  enabledBorder:
                                                                  InputBorder.none,
                                                                  errorBorder:
                                                                  InputBorder.none,
                                                                  disabledBorder:
                                                                  InputBorder.none,
                                                                  contentPadding: new EdgeInsets
                                                                      .symmetric(
                                                                      vertical: 1 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                      horizontal: 1 *
                                                                          SizeConfig
                                                                              .widthMultiplier),

                                                                  hintText: "",
                                                                  hintStyle: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 2 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontFamily: 'Lato',
                                                                  ),
                                                                ),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                    SizedBox(height: 1 *SizeConfig.heightMultiplier,),

                                                    Text("Upload Photo", //
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig.textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.black,
                                                        )),
                                                    SizedBox(
                                                      height: 0.5 *
                                                          SizeConfig.heightMultiplier,
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              get_image(ImageSource.camera,index);
                                                            },
                                                            child: Container(
                                                              width: 30 *
                                                                  SizeConfig.widthMultiplier,
                                                              height: 10 *
                                                                  SizeConfig.heightMultiplier,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(
                                                                      2 *
                                                                          SizeConfig
                                                                              .imageSizeMultiplier,
                                                                    )),
                                                                // color: Color(0xFFba3d41),
                                                                shape: BoxShape.rectangle,
                                                                border: Border.all(
                                                                  color: Colors.grey,
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: _image[index] == ""?Text(
                                                                    "Click to Upload\n the image",
                                                                    style: TextStyle(
                                                                      fontSize: 1.8 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontFamily: 'Lato',
                                                                      color: Colors.black,
                                                                    )):Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                            2 *
                                                                                SizeConfig
                                                                                    .imageSizeMultiplier,
                                                                          )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape.rectangle,
                                                                      image: new DecorationImage(
                                                                        image: FileImage(_image[index]),
                                                                        fit: BoxFit.cover,
                                                                      ),

                                                                    )),
                                                              ),
                                                            )
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                  ],
                                                )
                                                 :Column(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            //focusColor: Color(0xFF7a8d56),
                                                            activeColor: app_color,
                                                            value: 1,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                            },
                                                          ),
                                                          Text("Yes",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),

                                                          Radio(
                                                            focusColor: app_color,
                                                            activeColor: app_color,
                                                            value: 2,
                                                            groupValue: selectedYesNo[index],
                                                            onChanged: (value) {
                                                            },
                                                          ),
                                                          Text("No",
                                                              style: TextStyle(
                                                                fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                color: CustomColor.lightBlack,
                                                              )),
                                                        ],
                                                      ),
                                                      ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                    ],
                                                )
                                                  :ApiClient.userType == "3" || ApiClient.userType == "4"?
                                                 Column(
                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Radio(
                                                              //focusColor: Color(0xFF7a8d56),
                                                              activeColor: app_color,
                                                              value: 1,
                                                              groupValue: selectedYesNo[index],
                                                              onChanged: (value) {
                                                              },
                                                            ),
                                                            Text("Yes",
                                                                style: TextStyle(
                                                                  fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                  color: CustomColor.lightBlack,
                                                                )),

                                                            Radio(
                                                              focusColor: app_color,
                                                              activeColor: app_color,
                                                              value: 2,
                                                              groupValue: selectedYesNo[index],
                                                              onChanged: (value) {
                                                              },
                                                            ),
                                                            Text("No",
                                                                style: TextStyle(
                                                                  fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                                  color: CustomColor.lightBlack,
                                                                )),
                                                          ],
                                                        ),
                                                        ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                      ],
                                              )

                                             : Container()

                                        :ApiClient.userType =="1"?
                                              (("${checklistData[0]['after_status']}" == "1" || "${checklistData[0]['after_status']}" == "5" ) ||
                                                  ("${checklistData[0]['after_status']}" == "0" && "${checklistData[0]['after_phase']}" == "2"))?
                                              Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        //focusColor: Color(0xFF7a8d56),
                                                        activeColor: app_color,
                                                        value: 1,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedYesNo[index] = 1;
                                                          });
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            selectedYesNo[index] = 1;
                                                          });
                                                        },
                                                        child: Text("Yes",
                                                            style: TextStyle(
                                                              fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                              color: CustomColor.lightBlack,
                                                            )),
                                                      ),

                                                      Radio(
                                                        focusColor: app_color,
                                                        activeColor: app_color,
                                                        value: 2,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedYesNo[index] = 2;
                                                          });
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            selectedYesNo[index] = 2;
                                                          });
                                                        },
                                                        child: Text("No",
                                                            style: TextStyle(
                                                              fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                              color: CustomColor.lightBlack,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),

                                                  Text("Doer Comment:",
                                                      style: TextStyle(
                                                        fontSize: 1.8 *
                                                            SizeConfig.textMultiplier,
                                                        fontFamily: 'Lato',
                                                        color: Colors.black,
                                                      )),
                                                  SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                  Container(
                                                    width: 94 *
                                                        SizeConfig.widthMultiplier,
                                                    height: 8 *
                                                        SizeConfig.heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                            2 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          )),
                                                      // color: Color(0xFFba3d41),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              right: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          child: Container(
                                                            width: 90 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            height: 10 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            child: TextFormField(
                                                              style: new TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 2 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                fontFamily: 'Lato',
                                                              ),
                                                              controller: _controllers[index],
                                                              cursorColor:
                                                              Colors.black,
                                                              keyboardType:
                                                              TextInputType.text,
                                                              textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                              focusNode:
                                                              _focusNode[index],
                                                              maxLines: 2,
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                _focusNode[index]
                                                                    .unfocus();
                                                                //  _calculator();
                                                              },
                                                              decoration:
                                                              InputDecoration(
                                                                // labelText: "Enter Email",
                                                                // isDense: true,
                                                                border:
                                                                InputBorder.none,
                                                                focusedBorder:
                                                                InputBorder.none,
                                                                enabledBorder:
                                                                InputBorder.none,
                                                                errorBorder:
                                                                InputBorder.none,
                                                                disabledBorder:
                                                                InputBorder.none,
                                                                contentPadding: new EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    horizontal: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier),

                                                                hintText: "",
                                                                hintStyle: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 2 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily: 'Lato',
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                                                  Row(
                                                    children: [
                                                      Text("Upload Photo",
                                                          style: TextStyle(
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontFamily: 'Lato',
                                                            color: Colors.black,
                                                          )),
                                                      checklist[index]['photo_compulsory'] == 1?
                                                      Text(" ( Photo compulsory )",
                                                          style: TextStyle(
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontFamily: 'Lato',
                                                            color: Colors.red,
                                                          )):Container(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig.heightMultiplier,
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            get_image(ImageSource.camera,index);
                                                          },
                                                          child: Container(
                                                            width: 30 *
                                                                SizeConfig.widthMultiplier,
                                                            height: 10 *
                                                                SizeConfig.heightMultiplier,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                    2 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                  )),
                                                              // color: Color(0xFFba3d41),
                                                              shape: BoxShape.rectangle,
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: _image[index] == ""?Text(
                                                                  "Click to Upload\n the image",
                                                                  style: TextStyle(
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontFamily: 'Lato',
                                                                    color: Colors.black,
                                                                  )):Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                          2 *
                                                                              SizeConfig
                                                                                  .imageSizeMultiplier,
                                                                        )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape.rectangle,
                                                                    image: new DecorationImage(
                                                                      image: FileImage(_image[index]),
                                                                      fit: BoxFit.cover,
                                                                    ),

                                                                  )),
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                ],
                                              )
                                                  :Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        //focusColor: Color(0xFF7a8d56),
                                                        activeColor: app_color,
                                                        value: 1,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("Yes",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),

                                                      Radio(
                                                        focusColor: app_color,
                                                        activeColor: app_color,
                                                        value: 2,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("No",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),
                                                    ],
                                                  ),
                                                  ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                ],
                                              )
                                         :ApiClient.userType == "2"?
                                    (("${checklistData[0]['after_status']}" == "1" || "${checklistData[0]['after_status']}" == "5" || "${checklistData[0]['after_status']}" == "2" || "${checklistData[0]['after_status']}" == "6" )  ||
                                        ("${checklistData[0]['after_status']}" == "0" && "${checklistData[0]['after_phase']}" == "2"))?
                                              Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        //focusColor: Color(0xFF7a8d56),
                                                        activeColor: app_color,
                                                        value: 1,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedYesNo[index] = 1;
                                                          });
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            selectedYesNo[index] = 1;
                                                          });
                                                        },
                                                        child: Text("Yes",
                                                            style: TextStyle(
                                                              fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                              color: CustomColor.lightBlack,
                                                            )),
                                                      ),

                                                      Radio(
                                                        focusColor: app_color,
                                                        activeColor: app_color,
                                                        value: 2,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedYesNo[index] = 2;
                                                          });
                                                        },
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            selectedYesNo[index] = 2;
                                                          });
                                                        },
                                                        child: Text("No",
                                                            style: TextStyle(
                                                              fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                              color: CustomColor.lightBlack,
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                  ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),

                                                  Text("Doer Comment:",
                                                      style: TextStyle(
                                                        fontSize: 1.8 *
                                                            SizeConfig.textMultiplier,
                                                        fontFamily: 'Lato',
                                                        color: Colors.black,
                                                      )),
                                                  SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                  Container(
                                                    width: 94 *
                                                        SizeConfig.widthMultiplier,
                                                    height: 8 *
                                                        SizeConfig.heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                            2 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          )),
                                                      // color: Color(0xFFba3d41),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              right: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          child: Container(
                                                            width: 90 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            height: 10 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            child: TextFormField(
                                                              style: new TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 2 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                fontFamily: 'Lato',
                                                              ),
                                                              controller: _controllers[index],
                                                              cursorColor:
                                                              Colors.black,
                                                              keyboardType:
                                                              TextInputType.text,
                                                              textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                              focusNode:
                                                              _focusNode[index],
                                                              maxLines: 2,
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                _focusNode[index]
                                                                    .unfocus();
                                                                //  _calculator();
                                                              },
                                                              decoration:
                                                              InputDecoration(
                                                                // labelText: "Enter Email",
                                                                // isDense: true,
                                                                border:
                                                                InputBorder.none,
                                                                focusedBorder:
                                                                InputBorder.none,
                                                                enabledBorder:
                                                                InputBorder.none,
                                                                errorBorder:
                                                                InputBorder.none,
                                                                disabledBorder:
                                                                InputBorder.none,
                                                                contentPadding: new EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    horizontal: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier),

                                                                hintText: "",
                                                                hintStyle: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 2 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily: 'Lato',
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                                                  Text("Checker Comment:",
                                                      style: TextStyle(
                                                        fontSize: 1.8 *
                                                            SizeConfig.textMultiplier,
                                                        fontFamily: 'Lato',
                                                        color: Colors.black,
                                                      )),
                                                  SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
                                                  Container(
                                                    width: 94 *
                                                        SizeConfig.widthMultiplier,
                                                    height: 8 *
                                                        SizeConfig.heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(
                                                            2 *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                          )),
                                                      // color: Color(0xFFba3d41),
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(
                                                              left: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              right: 2 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          child: Container(
                                                            width: 90 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            height: 10 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            child: TextFormField(
                                                              style: new TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 2 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                fontFamily: 'Lato',
                                                              ),
                                                              controller: _controllersChecker[index],
                                                              cursorColor:
                                                              Colors.black,
                                                              keyboardType:
                                                              TextInputType.text,
                                                              textInputAction:
                                                              TextInputAction
                                                                  .done,
                                                              focusNode:
                                                              _focusNodeChecker[index],
                                                              maxLines: 2,
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                _focusNodeChecker[index]
                                                                    .unfocus();
                                                                //  _calculator();
                                                              },
                                                              decoration:
                                                              InputDecoration(
                                                                // labelText: "Enter Email",
                                                                // isDense: true,
                                                                border:
                                                                InputBorder.none,
                                                                focusedBorder:
                                                                InputBorder.none,
                                                                enabledBorder:
                                                                InputBorder.none,
                                                                errorBorder:
                                                                InputBorder.none,
                                                                disabledBorder:
                                                                InputBorder.none,
                                                                contentPadding: new EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    horizontal: 1 *
                                                                        SizeConfig
                                                                            .widthMultiplier),

                                                                hintText: "",
                                                                hintStyle: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 2 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily: 'Lato',
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(height: 1 *SizeConfig.heightMultiplier,),

                                                  Text("Upload Photo", //
                                                      style: TextStyle(
                                                        fontSize: 1.8 *
                                                            SizeConfig.textMultiplier,
                                                        fontFamily: 'Lato',
                                                        color: Colors.black,
                                                      )),
                                                  SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig.heightMultiplier,
                                                  ),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            get_image(ImageSource.camera,index);
                                                          },
                                                          child: Container(
                                                            width: 30 *
                                                                SizeConfig.widthMultiplier,
                                                            height: 10 *
                                                                SizeConfig.heightMultiplier,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                    2 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                  )),
                                                              // color: Color(0xFFba3d41),
                                                              shape: BoxShape.rectangle,
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: _image[index] == ""?Text(
                                                                  "Click to Upload\n the image",
                                                                  style: TextStyle(
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontFamily: 'Lato',
                                                                    color: Colors.black,
                                                                  )):Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                          2 *
                                                                              SizeConfig
                                                                                  .imageSizeMultiplier,
                                                                        )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape.rectangle,
                                                                    image: new DecorationImage(
                                                                      image: FileImage(_image[index]),
                                                                      fit: BoxFit.cover,
                                                                    ),

                                                                  )),
                                                            ),
                                                          )
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                ],
                                              )
                                                  :Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        //focusColor: Color(0xFF7a8d56),
                                                        activeColor: app_color,
                                                        value: 1,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("Yes",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),

                                                      Radio(
                                                        focusColor: app_color,
                                                        activeColor: app_color,
                                                        value: 2,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("No",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),
                                                    ],
                                                  ),
                                                  ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                ],
                                              )
                                                  :ApiClient.userType == "3" || ApiClient.userType == "4"?
                                              Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                        //focusColor: Color(0xFF7a8d56),
                                                        activeColor: app_color,
                                                        value: 1,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("Yes",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),

                                                      Radio(
                                                        focusColor: app_color,
                                                        activeColor: app_color,
                                                        value: 2,
                                                        groupValue: selectedYesNo[index],
                                                        onChanged: (value) {
                                                        },
                                                      ),
                                                      Text("No",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),
                                                    ],
                                                  ),
                                                  ChecklistHistory(checklist_history_data: checklist[index]['checklist_history_data']),
                                                ],
                                              )
                                            : Container()

                                            : Container()
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),

                          phaseFlag == 1?
                            checklistData[0]['add_approve_comments'] !=""?
                              Padding(
                                padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                child: Text("Approve with Comment\n\n${checklistData[0]['add_approve_comments']}",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: Colors.black,
                                    )),
                              ):Container()
                          :checklistData[0]['after_approve_with_comments'] !=""?
                            Padding(
                            padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                            child: Text("Approve with Comment\n\n${checklistData[0]['after_approve_with_comments']}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                          ):Container(),

                          phaseFlag == 1?
                          checklistData[0]['before_revoke_comments'] !=""?
                          Padding(
                            padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                            child: Text("Revoke with Comment\n\n${checklistData[0]['before_revoke_comments']}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                          ):Container()
                              :checklistData[0]['after_revoke_comments'] !=""?
                          Padding(
                            padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                            child: Text("Revoke with Comment\n\n${checklistData[0]['after_revoke_comments']}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                          ):Container(),


                          (ApiClient.userType == "1" && phaseFlag == 1) && ("${checklistData[0]['status']}" == "1" || "${checklistData[0]['status']}" == "5" || "${checklistData[0]['status']}" == "0")?
                          DoerSaveSubmit()
                              : (ApiClient.userType == "1" && phaseFlag == 2) && (("${checklistData[0]['after_status']}" == "1" || "${checklistData[0]['after_status']}" == "5" ) ||
                                ("${checklistData[0]['after_status']}" == "0" && "${checklistData[0]['after_phase']}" == "2"))?
                          DoerSaveSubmit()
                              :Container(),

                          SizedBox(height: 1.5 *SizeConfig.heightMultiplier,),
                         (ApiClient.userType == "2" && phaseFlag == 1) && ("${checklistData[0]['status']}" == "2" || "${checklistData[0]['status']}" == "6" ||
                              "${checklistData[0]['status']}" == "1" || "${checklistData[0]['status']}" == "5" || "${checklistData[0]['status']}" == "0")
                         ?checkerApprove()
                             :  ((ApiClient.userType == "2" && phaseFlag == 2) &&
                             (("${checklistData[0]['after_status']}" == "2" || "${checklistData[0]['after_status']}" == "1" || "${checklistData[0]['after_status']}" == "5") || "${checklistData[0]['after_status']}" == "6" ||
                                 ("${checklistData[0]['after_status']}" == "0" && "${checklistData[0]['after_phase']}" == "2")))
                             ?checkerApprove()
                         :Container(),

                          (ApiClient.userType == "4") && (("${checklistData[0]['status']}" == "3" || "${checklistData[0]['status']}" == "4") && ("${checklistData[0]['after_status']}" == "3" || "${checklistData[0]['after_status']}" == "4"))
                            ?revokerRevoke():Container(),

                        ],
                      ),
                    ),
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
                        Text("Checklist data",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',)),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("There is no any project checklist data",
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
                          color: Color(0xFFe4a205),
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

                  ],)))

            ]),
          ],
        )
    );

  }

  // Get Activity List
  viewCheckList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_checklist");
    Map map ={
      "check_list_id":"$data",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
           beforeChecklist = decoded['checklist_items_arr'];
           checklistData = decoded['checklist_data'];
           afterChecklist = decoded['checklist_after_items_arr'];
           if(checklistData[0]['after_phase'] == 0 ){
             getAfterChecklistData();
           }
           if(checklistData[0]['after_phase'] == 2){
             statusBefore = status.after;
             afterCheckList();
           }else{
             beforeCheckList();
           }

           apiFlag = true;
           apiStustFlag = true;
           print("_image $_image");
        });
      }else{
        setState(() {
          apiStustFlag = true;
        });
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  beforeCheckList() {
    print("phaseFlag :: $phaseFlag");
      setState(() {
        checklist = beforeChecklist;
        phaseFlag = 1;
        photoCompulsory.clear();
        _controllers.clear();
        _focusNode.clear();
        _image.clear();
        for(int i = 0; i< checklist.length; i++){

          _controllers.add(new TextEditingController());
          _focusNode.add(new FocusNode());
          _controllers[i].text = checklist[i]['doer_comments'];
          if(ApiClient.userType == "2" && checklist[i]['doer_comments'] !=""){
            _controllers[i].text = checklist[i]['doer_comments'];
          }

          if(checklist[i]['status'] == 1){

          }

          if(checklist[i]['doer_comments'] =="" && checklist[i]['photo_compulsory'] == 1){
            photoCompulsory.add(true);
          }else{
            photoCompulsory.add(false);
          }

          _controllersChecker.add(new TextEditingController());
          _focusNodeChecker.add(new FocusNode());
          _image.add("");

          if(checklist[i]['checklist_check_status'] == "NO"){
            selectedYesNo.add(2);
          }else{
            selectedYesNo.add(1);
          }

          if(i == 0){
            selected.add(true);
          }else{
            selected.add(false);
          }
        }
      });
  }

  afterCheckList() {
    print("phaseFlag ::>> $phaseFlag");

    print("afterChecklist ${afterChecklist.length}");
    setState(() {
      checklist =  afterChecklist;
      phaseFlag = 2;
      photoCompulsory.clear();
      _controllers.clear();
      _focusNode.clear();
      _image.clear();
      for(int i = 0; i< checklist.length; i++){

        _controllers.add(new TextEditingController());
        _focusNode.add(new FocusNode());
        _controllers[i].text = checklist[i]['doer_comments'];
        if(ApiClient.userType == "2" && checklist[i]['doer_comments'] !=""){
          _controllers[i].text = checklist[i]['doer_comments'];
        }

        if(checklist[i]['doer_comments'] =="" && checklist[i]['photo_compulsory'] == 1){
          photoCompulsory.add(true);
        }else{
          photoCompulsory.add(false);
        }

        print(" after_phase :: ${checklistData[0]['after_phase']}");
        _controllersChecker.add(new TextEditingController());
        _focusNodeChecker.add(new FocusNode());
        _image.add("");

        if(checklist[i]['checklist_check_status'] == "NO"){
          selectedYesNo.add(2);
        }else{
          selectedYesNo.add(1);
        }
        if(i == 0){
          selected.add(true);
        }else{
          selected.add(false);
        }
      }
    });
  }

  //  confirmation  Dialog
  submitForApprovalDialog(message,flag) async{
    showDialog(
        context: context,
        builder: (dialogContex) {
          return AlertDialog(
            content: Container(
              height: 25 * SizeConfig.heightMultiplier,

              child: Column(children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text('$message',
                    style: TextStyle(
                      fontSize: 2 *
                          SizeConfig.textMultiplier,
                      color: Colors.black,
                    )),

                SizedBox(height: 5 * SizeConfig.heightMultiplier,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          right: 2.0 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
                        color: Colors.white,
                        splashColor: Colors.white,
                        minWidth: 31 * SizeConfig.widthMultiplier,
                        height: 4.7 * SizeConfig.heightMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.8 * SizeConfig.widthMultiplier),
                            side: BorderSide(color: app_color)),
                        child: Text('No',
                            style: TextStyle(
                              fontSize: 2 * SizeConfig.textMultiplier,
                              color: Colors.black,
                            )),
                        onPressed: () {
                          Navigator.pop(dialogContex);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 2.0 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
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
                        child: Text('Yes',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                2 * SizeConfig.textMultiplier)),
                        onPressed: () {
                          //  Navigator.pop(context);
                          Navigator.of(context).pop();
                          getSave(context,flag);
                        },
                      ),
                    )
                  ],
                ),
              ],),
            ),

          );
        });
  }
  bool _inProcess = false;
  get_image(ImageSource source,index) async {
    print("fgdhg");

    this.setState(() {
      _inProcess = true;
    });
    var image = await ImagePicker().pickImage(source: source,maxHeight: 592, maxWidth: 360); // moto x4
    if (image != null) {
      var cropped = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressQuality: 50,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.square,
          //   //  CropAspectRatioPreset.ratio3x2,
          //   // CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.ratio4x3,
          //   /*   CropAspectRatioPreset.ratio5x3,
          //   CropAspectRatioPreset.ratio5x4,
          //   CropAspectRatioPreset.ratio7x5,*/
          //   CropAspectRatioPreset.ratio16x9
          // ],
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: app_color,
              toolbarTitle: "ANP Application",
              statusBarColor: app_color,
              backgroundColor: Colors.white,)]);

      final bytes = (await image.readAsBytes()).lengthInBytes;

      print(" print bytes == ::: $bytes");
      this.setState(() {
        if(ApiClient.imageSize(bytes)){
          _image[index] = File(cropped!.path);
        }else{
          showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog("Failed to upload an image. The image maximum size is 2MB."));
      }



        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }

    setState(() {
      _image = _image;

      print(" print == ::: $_image");
      //  print(_image!.lengthSync());
    });
  }

getSave(BuildContext context,status) async{
  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
  var url = Uri.parse(ApiClient.BASE_URL+"save_checklist_items_new");
  var response;

  print("url  :: $url");
  try {
    var dio = Dio();

    List itemsArr = [];

    var yesNo,doer_comments = "",checker_comments = "",comments;

    for(int i = 0; i < checklist.length; i++){

      if(selectedYesNo[i] == 1){
        yesNo = "YES";
      }else{
        yesNo = "NO";
      }
      if(ApiClient.userType == "1"){
        doer_comments = _controllers[i].text;
        comments = _controllers[i].text;
        checker_comments = " ";
      }else{
        doer_comments = _controllers[i].text;
        checker_comments = _controllersChecker[i].text;
        comments = _controllersChecker[i].text;
      }
     var  image = _image[i];
      Map map;
      if(image == ""){
        map = {
          "id":checklist[i]['id'],
          "review_checklist_id":"${checklistData[0]['id']}",
          "checklist_id":"${checklistData[0]['checklist_id']}",
          "checklist_item":checklist[i]['checklist_item'],
          "checklist_check_status":yesNo,
          "user_type":ApiClient.userType,
          "checklist_phase":"${checklistData[0]['phase']}",
          "doer_comments":doer_comments,
          "checker_comments":checker_comments,
          "comments":comments,
          "photo": "",
        };
      }else{
        map = {
          "id":checklist[i]['id'],
          "review_checklist_id":"${checklistData[0]['id']}",
          "checklist_id":"${checklistData[0]['checklist_id']}",
          "checklist_item":checklist[i]['checklist_item'],
          "checklist_check_status":yesNo,
          "user_type":ApiClient.userType,
          "checklist_phase":"${checklistData[0]['phase']}",
          "doer_comments":doer_comments,
          "checker_comments":checker_comments,
          "comments":comments,
          "photo": await MultipartFile.fromFile(image.path, filename: 'img$i.jpg'),
        };
      }

      itemsArr.add(map);
    }
    print("map : >>>1 $itemsArr");
    Map maps = {
      "review_checklist_id":"${checklistData[0]['id']}",
      "checklist_id":"${checklistData[0]['checklist_id']}",
      "add_approve_comments":approvedWithComments.text,
      "revoker_comments":revokeWithComments.text,
      "phase":"$phaseFlag",
      "status":"$status",
      "user_type":ApiClient.userType,
      "checklist_items_arr":itemsArr,
    };
    print("map : >>>2 $maps");

    FormData formData = FormData.fromMap({
      "review_checklist_id":"${checklistData[0]['id']}",
      "checklist_id":"${checklistData[0]['checklist_id']}",
      "add_approve_comments":approvedWithComments.text,
      "revoker_comments":revokeWithComments.text,
      "phase":"$phaseFlag",
      "status":"$status",
      "user_type":ApiClient.userType,
      "checklist_items_arr":itemsArr,
    });
    // checklist_items_arr.photo
    dio.options.headers['Authorization'] = '$userToken';
    dio.options.headers['Content-Type'] = 'application/json';
    response = await dio.post("$url",data: formData);
    print("getSave Phase : ${response}");
    print("getSave response.statusCode : ${response.statusCode}");
    print("getSave Phase : ${response.data}");
  }on DioError catch (e) {

    print("Error 1 : ${e.message}");
    print("Error 2 : ${e.error}");
    print("Error 3 : ${e.toString()}");
    print("Error 3 : ${e}");
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog("Remarks and Photos Not Added"));
    FocusScope.of(context).unfocus();
  }
  Navigator.pop(context);

   if(response.statusCode == 200 || response.statusCode == 201){
   //  Navigator.pop(context,true);
     if(response.data['status']){
      //  Navigator.pop(context,true);

       if(status == 1){
         _image.clear();
         viewCheckList(context);

       }else{
         Navigator.pop(context,true);
       }

       showDialog(
           context: context,
           builder: (BuildContext context) => CustomDialog(response.data['message']));
  /*     if(checklistData[0]['after_phase'] == 0 && checklistData[0]['status'] == 2 && (status == 3 || status == 4)){
         afterSave(context,0,response.data['message']);
       }else{
         if(status == 1){
           _image.clear();
           viewCheckList(context);

         }else{
           Navigator.pop(context,true);
         }

         showDialog(
             context: context,
             builder: (BuildContext context) => CustomDialog(response.data['message']));

       }*/

      }else{
        if(response.data['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(response.data['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(response.data['message']));
    }

}

  getAfterChecklistData() {

    print("review_footings >> ");


    if(checklistData[0]['reporting_unit'] == "COLUMN"){
      for(int i = 0; i<checklistData[0]['review_column'].length; i++){
        Map map = {
          "column_name": checklistData[0]['review_column'][i]['column_name'],
          "column_id": checklistData[0]['review_column'][i]['column_id']
        };
        listMap.add(map);
      }
    }else if(checklistData[0]['reporting_unit'] == "FOOTING"){
      for(int i = 0; i<checklistData[0]['review_footings'].length; i++){
        Map map = {
          "footing_name": checklistData[0]['review_footings'][i]['footing_name'],
          "footing_id": checklistData[0]['review_footings'][i]['footing_id']
        };
        listMap.add(map);
      }
    }

    print("listMap $listMap");
  }
  afterSave(BuildContext context,n,message) async{
 // showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"save_checklist");
    Map map ={
      "review_checklist_id":"${checklistData[0]['id']}",
      "project_id":"${checklistData[0]['project_id']}",
      "building_id":"${checklistData[0]['building_id']}",
      "floor_id":"${checklistData[0]['floor_id']}",
      "column_name":listMap,
      "phase":"2",
      "activity_id":"${checklistData[0]['activity_id']}",
      "sub_activity_id":"${checklistData[0]['sub_activity_id']}",
      "contractor_id":"${checklistData[0]['contractor_id']}",
      "drawing_reference":checklistData[0]['drawning_reference'],
      "unit":"${checklistData[0]['reporting_unit']}",
      "checklist_id":"${checklistData[0]['checklist_id']}",
      "date":ApiClient.todaysDate(DateTime.now()),
      "others_value":checklistData[0]['other_unit'],
      "flat_id":"${checklistData[0]['flat_id']}",
      "flat_name":"${checklistData[0]['flat_name']}",
      "footing_no":listMap
    };
    print("map : >>> ${jsonEncode(map)}");
    var response = await http.post(url, headers: {'Content-type':'application/json','Authorization': "$userToken"}, body: utf8.encode(json.encode(map)));
    Map decoded = jsonDecode(response.body);
    print("getSave Phase : ${decoded}");
    print("getSave response.statusCode : ${response.statusCode}");
  //  Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(n == 1){
        if(decoded['status']){

          viewCheckList(context);
        }else{
          if(decoded['token']){
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(decoded['message']));
          }else{
            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
          }
        }
      }else{
        Navigator.pop(context,true);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(message));
      }

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(decoded['message']));
    }
  }



  String getUnit(checklistCollection) {
    if(checklistCollection['reporting_unit'] == "COLUMN"){
      var COLUMN  = "";
      for(int i = 0; i < checklistCollection['review_column'].length; i++){
        COLUMN = COLUMN + ", "+ checklistCollection['review_column'][i]['column_name'];
      }
      return "Floor : ${checklistCollection['floor_name']}, Column : $COLUMN";

    }else if(checklistCollection['reporting_unit'] == "FLAT"){
      return "Floor : ${checklistCollection['floor_name']}, Flat : ${checklistCollection['flat_name']}";
    }else if(checklistCollection['reporting_unit'] == "FLOOR"){
      return "Floor : ${checklistCollection['floor_name']}";
    }  else if(checklistCollection['reporting_unit'] == "FOOTING"){
      var FOOTING  = "";
      for(int i = 0; i < checklistCollection['review_footings'].length; i++){
        FOOTING = FOOTING + ", "+ checklistCollection['review_footings'][i]['footing_name'];
      }
      return "Footing : $FOOTING";
    }
    else if(checklistCollection['reporting_unit'] == "OTHER"){
      return "Other";
    }
    return "Test";
  }



  Widget DoerSaveSubmit() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            MaterialButton(
              color: app_color,
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
              child: Text('Save',
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
                    var flag = false;
                    for(int i= 0; i<checklist.length;i++){
                      if(photoCompulsory[i]){
                        if(_image[i] == "" ){

                          setState(() {
                            flag = true;
                            selected[i] = true;
                          });
                          break;
                        }else{
                          setState(() {
                            flag = false;
                          });
                        }
                      }
                      // imageList
                    }
                   // if(!flag){
                      submitForApprovalDialog("Are you sure want to Save?",1);
                   // }else{
                   //   showDialog(context: context,builder: (BuildContext context) =>CustomDialog("Please upload compulsory photo"));
                   // }

                  }
                } on SocketException catch (_) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                }
              },
            ),
          ],
        ),
        SizedBox( height: 1.5 * SizeConfig.heightMultiplier,),
        Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            MaterialButton(
              color: app_color,
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
              child: Text('Submit For Approval',
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
                    var checkComment = true;

                    var flag = false;
                    for(int i= 0; i<checklist.length;i++){

                      if(photoCompulsory[i]){


                       var f = await checkFlag(checklist[i]['checklist_history_data']);

                      //  print("checklist_history_data ::: ${checklist[i]['checklist_history_data'][1]['check_list_photo'].length}");
                      //  checklist_history_data[subIndex]['check_list_photo'].length >= 1?

                       if(f){
                        if(_image[i] == "" ){

                          setState(() {
                            flag = true;
                            selected[i] = true;
                          });
                          break;
                        }else{
                          setState(() {
                            flag = false;
                          });
                        }}else{
                         setState(() {
                           flag = false;
                         });
                       }

                      }
                      // imageList
                    }

                     if(!flag){
                      submitForApprovalDialog("Are you sure want to submit for approve?",2);
                     }else{
                    showDialog(context: context,builder: (BuildContext context) =>CustomDialog("Please upload compulsory photo"));
                    }

                 //   submitForApprovalDialog("Are you sure want to submit for approve?",2);
                    /*      for(int i = 0; i< _controllers.length;i++) {
                                            if(_controllers[i].text.isEmpty){
                                             // checkComment = false;
                                              break;
                                            }
                                          }*/
                    print("checkComment :: $checkComment");
                    /*   if(checkComment){
                                            submitForApprovalDialog("Are you sure want to submit for approve?",2);
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>CustomDialog("Please fill all comment"));
                                          }*/
                  }
                } on SocketException catch (_) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                }
              },
            ),
          ],
        ),
      ],
    );
  }
  Widget checkerApprove() {
    return Padding(
      padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier,right: 3 * SizeConfig.widthMultiplier),
      child: Column( mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text("Approve with Comment:",
              style: TextStyle(
                fontSize: 1.8 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                color: Colors.black,
              )),
          SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
          Container(
            width: 94 *
                SizeConfig.widthMultiplier,
            height: 10 *
                SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(
                    2 *
                        SizeConfig
                            .imageSizeMultiplier,
                  )),
              // color: Color(0xFFba3d41),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 2 *
                          SizeConfig
                              .widthMultiplier,
                      right: 2 *
                          SizeConfig
                              .widthMultiplier),
                  child: Container(
                    width: 90 *
                        SizeConfig
                            .widthMultiplier,
                    height: 10 *
                        SizeConfig
                            .heightMultiplier,
                    child: TextFormField(
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 2 *
                            SizeConfig
                                .heightMultiplier,
                        fontFamily: 'Lato',
                      ),
                      controller: approvedWithComments,
                      cursorColor:
                      Colors.black,
                      keyboardType:
                      TextInputType.text,
                      textInputAction:
                      TextInputAction
                          .done,
                      focusNode:approvedWithCommentsFocus,
                      maxLines: 3,
                      onFieldSubmitted:
                          (value) {
                        approvedWithCommentsFocus.unfocus();
                        //  _calculator();
                      },
                      decoration:
                      InputDecoration(
                        // labelText: "Enter Email",
                        // isDense: true,
                        border:
                        InputBorder.none,
                        focusedBorder:
                        InputBorder.none,
                        enabledBorder:
                        InputBorder.none,
                        errorBorder:
                        InputBorder.none,
                        disabledBorder:
                        InputBorder.none,
                        contentPadding: new EdgeInsets
                            .symmetric(
                            vertical: 1 *
                                SizeConfig
                                    .widthMultiplier,
                            horizontal: 1 *
                                SizeConfig
                                    .widthMultiplier),

                        hintText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 2 *
                              SizeConfig
                                  .textMultiplier,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              MaterialButton(
                color: app_color,
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
                child: Text('Approve',
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
                      var checkComment = true;
                      submitForApprovalDialog("Are you sure want to approve?", 3);
                      /*  for(int i = 0; i< _controllersChecker.length;i++) {
                                              if(_controllersChecker[i].text.isEmpty){
                                                checkComment = false;
                                                break;
                                              }
                                            }
                                            if(checkComment){
                                              submitForApprovalDialog("Are you sure want to approve?", 3);
                                            }else{
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>CustomDialog("Please fill all comment"));
                                            }*/

                    }
                  } on SocketException catch (_) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                  }
                },
              ),
              SizedBox(width: 3.5 *SizeConfig.widthMultiplier,),
              MaterialButton(
                color: app_color,
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
                child: Text('Reject',
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
                    var checkComment = true;
                    for(int i = 0; i< _controllersChecker.length;i++) {
                      if(_image[i] == ""){
                        checkComment = false;
                      }else{
                        checkComment = true;
                        break;
                      }
                    }
                    if(checkComment){
                     submitForApprovalDialog("Are you sure want to Reject?", 5);
                    }else{
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>CustomDialog("Please upload reject items images"));
                    }
                  } on SocketException catch (_) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [

              MaterialButton(
                color: app_color,
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
                child: Text('Approve with Comment',
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
                      submitForApprovalDialog("Are you sure want to approve with comment?", 4);
                    }
                  } on SocketException catch (_) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget revokerRevoke() {
    return Padding(
      padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier,right: 3 * SizeConfig.widthMultiplier),
      child: Column( mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text("Revoke with comment:",
              style: TextStyle(
                fontSize: 1.8 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                color: Colors.black,
              )),
          SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
          Container(
            width: 94 *
                SizeConfig.widthMultiplier,
            height: 10 *
                SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(
                    2 *
                        SizeConfig
                            .imageSizeMultiplier,
                  )),
              // color: Color(0xFFba3d41),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 2 *
                          SizeConfig
                              .widthMultiplier,
                      right: 2 *
                          SizeConfig
                              .widthMultiplier),
                  child: Container(
                    width: 90 *
                        SizeConfig
                            .widthMultiplier,
                    height: 10 *
                        SizeConfig
                            .heightMultiplier,
                    child: TextFormField(
                      style: new TextStyle(
                        color: Colors.black,
                        fontSize: 2 *
                            SizeConfig
                                .heightMultiplier,
                        fontFamily: 'Lato',
                      ),
                      controller: revokeWithComments,
                      cursorColor:
                      Colors.black,
                      keyboardType:
                      TextInputType.text,
                      textInputAction:
                      TextInputAction
                          .done,
                      focusNode:revokeWithCommentsFocus,
                      maxLines: 3,
                      onFieldSubmitted:
                          (value) {
                            revokeWithCommentsFocus.unfocus();
                        //  _calculator();
                      },
                      decoration:
                      InputDecoration(
                        // labelText: "Enter Email",
                        // isDense: true,
                        border:
                        InputBorder.none,
                        focusedBorder:
                        InputBorder.none,
                        enabledBorder:
                        InputBorder.none,
                        errorBorder:
                        InputBorder.none,
                        disabledBorder:
                        InputBorder.none,
                        contentPadding: new EdgeInsets
                            .symmetric(
                            vertical: 1 *
                                SizeConfig
                                    .widthMultiplier,
                            horizontal: 1 *
                                SizeConfig
                                    .widthMultiplier),

                        hintText: "",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 2 *
                              SizeConfig
                                  .textMultiplier,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          SizedBox(height: 0.5 *SizeConfig.heightMultiplier,),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              MaterialButton(
                color: app_color,
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
                child: Text('Revoke',
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
                    submitForApprovalDialog("Are you sure want to Revoke?", 6);
                  } on SocketException catch (_) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

   checkFlag(checklistD) {
    var flag = true;
    print("checklistD.length ===== ${checklistD.length}");

    for(int i= 0; i<checklistD.length;i++){
      if(checklistD[i]['check_list_photo'].length >= 1){
        setState(() {
          flag = false;
        });
        print("flag ===== ${checklistD[i]['check_list_photo'].length}");
        break;

      }
   //   break;
    }


    print("flag ===== $flag");

    return flag;
  }

}