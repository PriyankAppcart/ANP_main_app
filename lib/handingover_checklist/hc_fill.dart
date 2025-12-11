
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/selection/handing_over_history.dart';
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

import '../util/colors_file.dart';

class FillHCPage extends KFDrawerContent {

  var userToken,projectData,selectedRoomID,selectedDefectActivityID,flat_id,checklist_id;
  FillHCPage(userToken,projectData,selectedRoomID,selectedDefectActivityID,flat_id,checklist_id){
    this.userToken = userToken;
    this.projectData = projectData;
    this.selectedRoomID = selectedRoomID;
    this.selectedDefectActivityID = selectedDefectActivityID;
    this.flat_id = flat_id;
    this.checklist_id = checklist_id;
  }

  @override
  FillHCPageState createState() => FillHCPageState(userToken,projectData,selectedRoomID,selectedDefectActivityID,flat_id,checklist_id);
}

enum status { before, after }
enum YesNo { Yes, No }
class FillHCPageState extends State<FillHCPage> {

  var userToken,projectData,selectedRoomID,selectedDefectActivityID,flat_id,checklist_id;
  FillHCPageState(userToken,projectData,selectedRoomID,selectedDefectActivityID,flat_id,checklist_id){
    this.userToken = userToken;
    this.projectData = projectData;
    this.selectedRoomID = selectedRoomID;
    this.selectedDefectActivityID = selectedDefectActivityID;
    this.flat_id = flat_id;
    this.checklist_id = checklist_id;
  }

  List<bool> selected = [];

  status? statusBefore = status.before;
  YesNo? yesNo = YesNo.Yes;

  List checklistData = [];
  List checklistItems = [];
  List<int> selectedYesNo = [];
  List<TextEditingController> _doerComment = [];
  List<FocusNode> _focusNodeDoer = [];

  List<TextEditingController> _checkerComment = [];
  List<FocusNode> _focusNodeChecker = [];

  List imageList  = [];

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;
  List<bool> isColumns = [];
  List<bool> photoCompulsory = [];

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
        getDefectItems(context);
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
                          Text("Handing Over Checklist",
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

          Expanded( flex: 14,
              child:internetConnection?apiStustFlag?apiFlag?
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
                      SizedBox( height: 1 * SizeConfig.heightMultiplier,),
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
                            Row(
                              children: [
                                Container(
                                  width: 48 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Project",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: app_color,
                                          )),
                                      SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                      Text(checklistData[0]['project_name'],
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 45 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Building",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: app_color,
                                          )),
                                      SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                      Text(checklistData[0]['building_name'],
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height:  1 * SizeConfig.heightMultiplier,),
                            Row(
                              children: [
                                Container(
                                  width: 48 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Floor and Flat",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: app_color,
                                          )),
                                      SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                      Text("${checklistData[0]['floor_name']}, ${checklistData[0]['flat_name']}",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 45 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Room Type",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: app_color,
                                          )),
                                      SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                      Text(checklistData[0]['room_type'],
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                            Row(
                              children: [
                                Container(
                                  width: 92 * SizeConfig.widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Defect Activity",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: app_color,
                                          )),
                                      SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                                      Text(checklistData[0]['defect_activity_name'],
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                    ],
                                  ),
                                ),

                              ],
                            ),

                            SizedBox(height:  1 * SizeConfig.heightMultiplier,),

                          ],
                        ),
                      ),
                      SizedBox( height: 2 * SizeConfig.heightMultiplier,),

                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: checklistItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Container(
                                  height: 5 * SizeConfig.heightMultiplier,
                                  color: Color(0xFFf5f5f5),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("onTap $index");
                                    setState(() {
                                      for(int i = 0; i<checklistItems.length; i++){
                                        if(i == index){
                                          selected[i] = true;
                                        }else{
                                          selected[i] = false;
                                        }
                                      }
                                    });

                                  },
                                  child: Container(
                                    width: 100 * SizeConfig.widthMultiplier,
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
                                      padding: EdgeInsets.all( 3 * SizeConfig.widthMultiplier),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 80 * SizeConfig.widthMultiplier,
                                                child: Text(checklistData[0]['status'] == 5 && checklistItems[index]['is_reject'] == 1?
                                                "${checklistItems[index]['defect_item']}  | Rejected Item":checklistItems[index]['defect_item'],
                                                    style: TextStyle(
                                                      fontSize:
                                                      1.8 * SizeConfig.textMultiplier,
                                                      fontFamily: 'Lato',
                                                      fontWeight: FontWeight.bold,
                                                      color: (checklistData[0]['status'] == 5 || checklistData[0]['status'] == 6) && checklistItems[index]['is_reject'] == 1?Colors.red:Colors.black,
                                                    )),
                                              ),
                                              Icon(
                                                selected[index]
                                                    ? Icons.keyboard_arrow_up
                                                    : Icons.keyboard_arrow_down,
                                                color: app_color,
                                                size:
                                                3.0 * SizeConfig.heightMultiplier,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: selected[index] == false ? 3 * SizeConfig.heightMultiplier : 0,
                                          ),
                                          selected[index]
                                              ? Column(
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

                                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                                  ApiClient.userType == "2" && (checklistData[0]['status'] == 2 || checklistData[0]['status'] == 6 || checklistData[0]['status'] == 0
                                                  || checklistData[0]['status'] == 1)?
                                                  Row(
                                                    children: [
                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        activeColor: app_color,
                                                        value: isColumns[index],
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isColumns[index] = value!;
                                                          });
                                                        },
                                                      ),
                                                      Text("Reject Item",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),
                                                    ],
                                                  ): Container(),
                                                  ApiClient.userType == "4" && checklistData[0]['status'] == 4?
                                                  Row(
                                                    children: [

                                                      Checkbox(
                                                        checkColor: Colors.white,
                                                        activeColor: app_color,
                                                        value: isColumns[index],
                                                        onChanged: (bool? value) {
                                                          setState(() {
                                                            isColumns[index] = value!;
                                                          });
                                                        },
                                                      ),
                                                      Text("Revoke Item",
                                                          style: TextStyle(
                                                            fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                                            color: CustomColor.lightBlack,
                                                          )),
                                                    ],
                                                  ): Container()

                                                ],
                                              ),

                                             HandingOverHistory(ho_history_data: checklistItems[index]['checklist_history_data']),

                                              ApiClient.userType == "1"?
                                              (checklistData[0]['status'] == 0 || checklistData[0]['status'] == 1 || checklistData[0]['status'] == 5) &&
                                                  (checklistItems[0]['status'] == 0 || checklistItems[0]['status'] == 1 || checklistItems[0]['status'] == 5) ?
                                              Column(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
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
                                                        height: 6 *
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
                                                                  controller: _doerComment[index],
                                                                  cursorColor:
                                                                  Colors.black,
                                                                  keyboardType:
                                                                  TextInputType.text,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  focusNode:_focusNodeDoer[index],
                                                                  maxLines: 3,
                                                                  onFieldSubmitted: (value) {
                                                                    _focusNodeDoer[index].unfocus();
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
                                                      SizedBox(height: 1.5 *SizeConfig.heightMultiplier,),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Upload Photo",
                                                          style: TextStyle(
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontFamily: 'Lato',
                                                            color: Colors.black,
                                                          )),
                                                      checklistItems[index]['photo_compulsory'] == 1?
                                                      Text(" ( At least one Photo compulsory )",
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
                                                  Container(
                                                    height: 10 *SizeConfig.heightMultiplier,
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics: ScrollPhysics(),
                                                        itemCount: imageList[index]['images'].length,
                                                        itemBuilder: (BuildContext context, int subIndex) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(left: 1 * SizeConfig.widthMultiplier),
                                                            child: InkWell(
                                                              onTap: () {
                                                                get_image(ImageSource.camera,index,subIndex);
                                                              },
                                                              child: imageList[index]['images'][subIndex] == ""?Container(
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
                                                                  child: Text(
                                                                      "Click to Upload\n the image ${subIndex + 1}",
                                                                      style: TextStyle(
                                                                        fontSize: 1.8 *
                                                                            SizeConfig
                                                                                .textMultiplier,
                                                                        fontFamily: 'Lato',
                                                                        color: Colors.black,
                                                                      )),
                                                                ),
                                                              ):Container(
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
                                                                    image: new DecorationImage(
                                                                      image: FileImage(imageList[index]['images'][subIndex]),
                                                                      fit: BoxFit.cover,
                                                                    ),

                                                                  )),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                ],
                                              ):Container():Container(),

                                              ApiClient.userType == "2"?
                                              (checklistData[0]['status'] == 0 || checklistData[0]['status'] == 1 || checklistData[0]['status'] == 2 || checklistData[0]['status'] == 6) &&
                                                  (checklistItems[0]['status'] == 0 || checklistItems[0]['status'] == 1 || checklistItems[0]['status'] == 2 || checklistItems[0]['status'] == 6)?
                                              Column(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
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
                                                        height: 6 *
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
                                                                  controller: _doerComment[index],
                                                                  cursorColor:
                                                                  Colors.black,
                                                                  keyboardType:
                                                                  TextInputType.text,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  focusNode:_focusNodeDoer[index],
                                                                  maxLines: 3,
                                                                  onFieldSubmitted: (value) {
                                                                    _focusNodeDoer[index].unfocus();
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
                                                        height: 6 *
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
                                                                  controller: _checkerComment[index],
                                                                  cursorColor:
                                                                  Colors.black,
                                                                  keyboardType:
                                                                  TextInputType.text,
                                                                  textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                                  focusNode:_focusNodeChecker[index],
                                                                  maxLines: 3,
                                                                  onFieldSubmitted: (value) {
                                                                    _focusNodeChecker[index].unfocus();
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
                                                      SizedBox(height: 1.5 *SizeConfig.heightMultiplier,),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Upload Photo",
                                                          style: TextStyle(
                                                            fontSize: 1.8 *
                                                                SizeConfig.textMultiplier,
                                                            fontFamily: 'Lato',
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 0.5 *
                                                        SizeConfig.heightMultiplier,
                                                  ),
                                                  Container(
                                                    height: 10 *SizeConfig.heightMultiplier,
                                                    child: ListView.builder(
                                                        scrollDirection: Axis.horizontal,
                                                        padding: EdgeInsets.zero,
                                                        shrinkWrap: true,
                                                        physics: ScrollPhysics(),
                                                        itemCount: imageList[index]['images'].length,
                                                        itemBuilder: (BuildContext context, int subIndex) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(left: 1 * SizeConfig.widthMultiplier),
                                                            child: InkWell(
                                                              onTap: () {
                                                                get_image(ImageSource.camera,index,subIndex);
                                                              },
                                                              child: imageList[index]['images'][subIndex] == ""?Container(
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
                                                                  child: Text(
                                                                      "Click to Upload\n the image ${subIndex + 1}",
                                                                      style: TextStyle(
                                                                        fontSize: 1.8 *
                                                                            SizeConfig
                                                                                .textMultiplier,
                                                                        fontFamily: 'Lato',
                                                                        color: Colors.black,
                                                                      )),
                                                                ),
                                                              ):Container(
                                                                  width: 30 *
                                                                      SizeConfig.widthMultiplier,
                                                                  height: 10 *
                                                                      SizeConfig.heightMultiplier,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                          2 *  SizeConfig
                                                                                  .imageSizeMultiplier,
                                                                        )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape.rectangle,
                                                                    image: new DecorationImage(
                                                                      image: FileImage(imageList[index]['images'][subIndex]),
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  )),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                  SizedBox(height: 2 *SizeConfig.heightMultiplier,),
                                                ],
                                              ):Container():Container(),


                                            ],
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),

                      ApiClient.userType == "1"?
                      (checklistData[0]['status'] == 0 || checklistData[0]['status'] == 1 || checklistData[0]['status'] == 5) &&
                        (checklistItems[0]['status'] == 0 || checklistItems[0]['status'] == 1 || checklistItems[0]['status'] == 5) ?
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
                                  for(int i= 0; i<checklistItems.length;i++){
                                    if(photoCompulsory[i]){
                                      if(imageList[i]['images'][0] == "" && imageList[i]['images'][1] == "" && imageList[i]['images'][2] == ""){
                                        print(imageList[i]['images'][0]);
                                        print(imageList[i]['images'][1]);
                                        print(imageList[i]['images'][2]);
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
                                //  if(!flag){
                                    submitForApprovalDialog("Are you sure want to Save?",1);
                                 // }else{
                                 //   showDialog(context: context,builder: (BuildContext context) =>CustomDialog("Please upload compulsory photo"));
                                //  }
                                }
                              } on SocketException catch (_) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                              }
                            },
                          ),
                        ],
                      ):Container():Container(),

                      ApiClient.userType == "2"?
                     ( checklistData[0]['status'] == 0 || checklistData[0]['status'] == 1 || checklistData[0]['status'] == 2 || checklistData[0]['status'] == 6) &&
                         (checklistItems[0]['status'] == 0 || checklistItems[0]['status'] == 1 || checklistItems[0]['status'] == 2 || checklistItems[0]['status'] == 6) ?
                      Column(
                        children: [
                         /* Row(
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
                                      submitForApprovalDialog("Are you sure want to Save?",1);
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
                                child: Text('Accept Defect',
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

                                      if(checkRejectFlag()){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>CustomDialog("You are selected reject Item\n You can not Accept Defect"));
                                      }else{
                                        submitForApprovalDialog("Are you sure want to Accept Defect?",3);
                                      }

                                    }
                                  } on SocketException catch (_) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                                  }
                                },
                              ),
                              SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                              MaterialButton(
                                color: Colors.red,
                                splashColor: Colors.redAccent,
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
                                child: Text('Reject Defect',
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
                                      //  for(int)

                                      if(checkRejectFlag()){
                                        submitForApprovalDialog("Are you sure want to Reject Defect?",5);

                                      }else{
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>CustomDialog("Please select Item for reject"));
                                      }

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
                      ):Container():Container(),

                      ApiClient.userType == "4" && checklistData[0]['status'] == 4 ?
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Colors.red,
                            splashColor: Colors.redAccent,
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
                                if (result.isNotEmpty &&result[0].rawAddress.isNotEmpty) {
                                  //  for(int)

                                  if(checkRejectFlag()){
                                    submitForApprovalDialog("Are you sure want to Revoke Defect?",6);

                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>CustomDialog("Please select Item for reject"));
                                  }

                                }
                              } on SocketException catch (_) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>CustomDialog("Check net internet connection"));
                              }
                            },
                          ),
                        ],
                      ):Container(),
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

        ])
    );

  }


  bool checkRejectFlag(){
    var flag = false;
    for(int i = 0; i<isColumns.length;i++){
      if(isColumns[i]){
        flag = true;
        break;
      }else{
        flag = false;
      }
    }
    return flag;
  }
  getDefectItems (BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_handing_over_checklist");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
     // "floor_id":"${projectData['floor_id']}",
    //  "flat_id":"${projectData['flat_id']}",
      "defect_activity_id":selectedDefectActivityID,
      "room_type_id":selectedRoomID,
      "checklist_id":"$checklist_id",
      "flat_id":"$flat_id"
    };
    print("map : ${jsonEncode(map)}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded view_handing_over : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          checklistData = decoded['checklist_data'];
          checklistItems = decoded['checklist_items_arr'];

          for(int i = 0; i<checklistItems.length; i++){

            _doerComment.add(new TextEditingController());
            _checkerComment.add(new TextEditingController());
            _focusNodeDoer.add(new FocusNode());
            _focusNodeChecker.add(new FocusNode());

           _doerComment[i].text = checklistItems[i]['doer_comment'];
            isColumns.add(false);

            if(i == 0){
              selected.add(true);
            }else{
              selected.add(false);
            }
            if(checklistItems[i]['checklist_check_status'] == 0){
              selectedYesNo.add(2);
            }else{
              selectedYesNo.add(1);
            }
            if(checklistItems[i]['doer_comment'] =="" && checklistItems[i]['photo_compulsory'] == 1){
              photoCompulsory.add(true);
            }else{
              photoCompulsory.add(false);
            }

            List<dynamic> _image = ["","",""];
            Map map = {
              "user_type":ApiClient.userType,
              "defect_item_id":"${checklistItems[i]['id']}",
              "images":_image
            };
            imageList.add(map);

          }
          apiFlag = true;
          apiStustFlag = true;
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

  bool _inProcess = false;
  get_image(ImageSource source,index,subIndex) async {
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

      this.setState(()  {
        if(ApiClient.imageSize(bytes)){
          imageList[index]['images'][subIndex] = File(cropped!.path);
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
   //   _image = _image;
      imageList[index]['images'][subIndex] = imageList[index]['images'][subIndex];

      print(" print == ::: $imageList[index]['images'][subIndex]");
      //  print(_image!.lengthSync());
    });
  }

  getSave(BuildContext context,status) async{
   showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"save_handover_list");
    var response;
    try {
      var dio = Dio();

      List itemsArr = [];

      var yesNo,isReject,doer_comments = "",checker_comments = "",comments;


      for(int i = 0; i < checklistItems.length; i++){

        if(selectedYesNo[i] == 1){
          yesNo = "YES";
        }else{
          yesNo = "NO";
        }
        if(isColumns[i]){
          isReject = 1;
          /*if(ApiClient.userType == "2" && checklistData[0]['status'] == 2){
            isReject = 1;
          }else if(ApiClient.userType == "4" && checklistData[0]['status'] == 4){
            isReject = 2;
          }*/
        }else{
          isReject = 0;
        }
     /*   if(ApiClient.userType == "1"){
          doer_comments = _controllers[i].text;
          comments = _controllers[i].text;
          checker_comments = " ";
        }else{
          doer_comments = _controllers[i].text;
          checker_comments = _controllersChecker[i].text;
          comments = _controllersChecker[i].text;
        }
        var  image = _image[i];*/
        List image = [];
        for(int j = 0; j < imageList[i]['images'].length; j++){
          Map map1;
          if(imageList[i]['images'][j] == ""){
            map1 = {"photo":""};
          }else{
            map1 = { "photo": await MultipartFile.fromFile(imageList[i]['images'][j].path, filename: 'img$i.jpg'),};
          }
          image.add(map1);
        }
        Map map = {
          "defect_id":"${checklistData[0]['defect_id']}",
          "item_id":"${checklistItems[i]['id']}",
          "defect_item_id":"${checklistItems[i]['defect_item_id']}",
          "review_checklist_id":"${checklistData[0]['id']}",
          "room_id":"${checklistData[0]['room_id']}",
          "defect_item":checklistItems[i]['defect_item'],
          "checklist_check_status":yesNo,
          "is_reject":"$isReject",
          "user_type":ApiClient.userType,
          "doer_comments":_doerComment[i].text,
          "checker_comments":_checkerComment[i].text,
          "imageList": image,
        };
        /* if(image == ""){
          map = {
            "defect_item_id":checklistItems[i]['id'],
            "checklist_id":"${checklistData[0]['id']}",
            "defect_item":checklistItems[i]['defect_item'],
            "checklist_check_status":yesNo,
            "user_type":ApiClient.userType,
            "doer_comments":doer_comments,
            "checker_comments":checker_comments,
            "photo": imageList,
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
        }*/

        itemsArr.add(map);
      }

      Map maps = {
        "review_checklist_id":"${checklistData[0]['id']}",
        "status":"$status",
        "user_type":ApiClient.userType,
        "checklist_items_arr":itemsArr,
      };

      print("maps >> ====>>  :: $maps");

      FormData formData = FormData.fromMap({

        "review_checklist_id":"${checklistData[0]['id']}",
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
     // Navigator.pop(context,true);
      if(response.data['status']){
        Navigator.pop(context,true);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(response.data['message']));

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

}
