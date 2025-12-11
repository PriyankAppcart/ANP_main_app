
import 'dart:convert';
import 'dart:io';

import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/handingover_checklist/hc_fill.dart';
import 'package:doer/quality_checklist/qc_fill.dart';
import 'package:doer/selection/defect_activity_selection.dart';
import 'package:doer/selection/flat_single_selection.dart';
import 'package:doer/selection/floor_selection.dart';
import 'package:doer/selection/room_selection.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import '../util/colors_file.dart';

class HCSelectPage extends KFDrawerContent {

  var userToken,projectData;
  HCSelectPage(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  @override
  HCSelectPageState createState() => HCSelectPageState(userToken,projectData);
}

class HCSelectPageState extends State<HCSelectPage> {

  var userToken,projectData;
  HCSelectPageState(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  List checkData =[];
  bool checkDataFlag = false;
  bool checkFlag = false;
  var selectedFloors = "Select Floor",selectedfloorsID = 0;
  var selectedFlat = "Select Flat",selectedFlatID = 0;
  var selectedRoom = "Select Room",selectedRoomID = 0;
  var selectedDefectActivity = "Select Defect Activity",selectedDefectActivityID = 0;
  List defectActivityList = [];
  List roomList = [];
  List floorList = [];
  List flatList = [];
  var submitForApprovalFlag = false;
  var approvalFlat = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("projectData ::::  $projectData");
    getRoomList(context);

  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(

        body: Stack(
          children: [
            Container(
              height: 25 * SizeConfig.heightMultiplier,
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
                  child:SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft:Radius.circular(
                          5 * SizeConfig.widthMultiplier,
                        ),topRight: Radius.circular(
                          5 * SizeConfig.widthMultiplier,
                        )),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            SizedBox( height: 3 * SizeConfig.heightMultiplier,),
                            Text("Project & Building",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                            Text("${projectData['project_name']} \n${projectData['building_name']}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                            Text("Checklist Code",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                            Text(projectData['checklist_code'],
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox(height:  1 * SizeConfig.heightMultiplier,),
                            Text("Floor & Flat",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                            Text("${projectData['floor_name']}, ${projectData['flat_name']}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox(height:  1 * SizeConfig.heightMultiplier,),
                            Text("Created Date",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                            Text("${ApiClient.dataFormatDayTime(projectData['created_by'])}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox( height: 2 * SizeConfig.heightMultiplier,),
                            Text("Select Room",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                            SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                            GestureDetector(
                              onTap: () {
                                if(roomList.length >= 1){
                                  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  RoomSelection(
                                    roomList: roomList,
                                    onSelected: (name, id) {
                                      print("name : $name");
                                      print("id : $id");
                                      setState(() {
                                        selectedRoom = name;
                                        selectedRoomID = id;
                                        selectedDefectActivity = "Select Defect Activity";
                                        selectedDefectActivityID = 0;
                                        defectActivityList.clear();
                                        getDefectActivity(context);
                                      });
                                    },
                                  ));
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomDialog("Room Not available"));
                                }
                              },
                              child: Container(
                                width: 94 *
                                    SizeConfig.widthMultiplier,
                                // height: 7 * SizeConfig.heightMultiplier,
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
                                child: Padding(
                                  padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        width: 80 *
                                            SizeConfig.widthMultiplier,
                                        child: Text(selectedRoom,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 1.8 *
                                                  SizeConfig
                                                      .textMultiplier,
                                              fontFamily: 'Lato',
                                              color: Colors.black,
                                            )),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: app_color,
                                        size: 3.0 *
                                            SizeConfig
                                                .heightMultiplier,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox( height: 1 * SizeConfig.heightMultiplier,),
                            Text("Select Defect Activity",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                            SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                            GestureDetector(
                              onTap: () {
                                if(defectActivityList.length >= 1){
                                  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  DefectActivitySelection(
                                    defectActivityList: defectActivityList,
                                    onSelected: (name, id) {
                                      print("name : $name");
                                      print("id : $id");
                                      setState(() {
                                        selectedDefectActivity = name;
                                        selectedDefectActivityID = id;

                                      });
                                    },
                                  ));
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomDialog("Defect Activity Not available"));
                                }
                              },
                              child: Container(
                                width: 94 *
                                    SizeConfig.widthMultiplier,
                                // height: 7 * SizeConfig.heightMultiplier,
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
                                child: Padding(
                                  padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Container(
                                        width: 80 *
                                            SizeConfig.widthMultiplier,
                                        child: Text(selectedDefectActivity,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 1.8 *
                                                  SizeConfig
                                                      .textMultiplier,
                                              fontFamily: 'Lato',
                                              color: Colors.black,
                                            )),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: app_color,
                                        size: 3.0 *
                                            SizeConfig
                                                .heightMultiplier,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox( height: 2 * SizeConfig.widthMultiplier,),
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
                                  child: Text('Continue',
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
                                        if(selectedRoom != "Select Room"){
                                          if(selectedDefectActivity != "Select Defect Activity"){
                                            final result = await Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => FillHCPage(userToken,projectData,"$selectedRoomID","$selectedDefectActivityID",projectData['flat_id'],projectData['id'])));
                                            if(result != null){
                                              getRoomList(context);
                                              defectActivityList.clear();
                                              getDefectActivity(context);
                                            }
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>CustomDialog("Please select defect activity"));
                                          }
                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>CustomDialog("Please select room"));
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
                            SizedBox( height: 1 * SizeConfig.widthMultiplier,),
                            ApiClient.userType == "1" && (projectData['status'] == 0 || projectData['status'] == 1 || projectData['status'] == 5) &&
                            submitForApprovalFlag?Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
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
                                        var flag = false;
                                /*        for(int i= 0; i<checklistItems.length;i++){
                                          if(photoCompulsory[i]){
                                            if(imageList[i]['images'][0] == "" && imageList[i]['images'][1] == "" && imageList[i]['images'][2] == ""){

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
                                        }*/
                                        //  if(!flag){
                                       // submitForApprovalDialog("Are you sure want to Save?",1);
                                        // }else{
                                        //   showDialog(context: context,builder: (BuildContext context) =>CustomDialog("Please upload compulsory photo"));
                                        //  }
                                        submitForApprovalDialog("Are you sure want to submit for approve?",2);

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
                            approvalFlat?Row(
                              mainAxisAlignment:MainAxisAlignment.center,
                              crossAxisAlignment:CrossAxisAlignment.center,
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
                                  child: Text('Accept Flat',
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
                                        submitForApprovalDialog("Are you sure want to Accept Flat?",4);

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

                            SizedBox( height: 1 * SizeConfig.widthMultiplier,),

                          ],
                        ),
                      ),
                    ),
                  ))

            ]),
          ],
        )
    );

  }

  getRoomList (BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_room_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"${projectData['floor_id']}",
      "flat_id":"${projectData['flat_id']}",
      "checklist_id":"${projectData['id']}"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded roomList : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {

          print("ApiClient.userType :: ${ApiClient.userType}");
          roomList = decoded['data'];

          if(ApiClient.userType == "1") {
            for (int i = 0; i < roomList.length; i++) {
              print("room_status :: ${roomList[i]['room_status']}");
              if (roomList[i]['room_status'] == "S" || roomList[i]['room_status'] == "AR") {
                setState(() {
                  submitForApprovalFlag = true;
                });
              } else {
                setState(() {
                  submitForApprovalFlag = false;
                });
                break;
              }
            }
          }
          if(ApiClient.userType == "2" && (projectData['status'] == 2 || projectData['status'] == 3 || projectData['status'] == 6)){
            for(int i = 0; i<roomList.length; i++){
              if(roomList[i]['room_status'] == "AR"){
                approvalFlat = true;
              }else{
                approvalFlat = false;
                break;
              }
            }
          }

        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  getDefectActivity (BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_defects_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"${projectData['floor_id']}",
      "flat_id":"${projectData['flat_id']}",
      "room_type_id":"$selectedRoomID",
      "checklist_id":"${projectData['id']}"

    };
    print("map ::::: ${jsonEncode(map)}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          defectActivityList = decoded['data'];

        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }
    }else{

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
                            side: BorderSide(color: Color(0xFFF38D31))),
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
  getSave(BuildContext context,status) async{
    var url = Uri.parse(ApiClient.BASE_URL+"update_handingover_checklist_items");
    Map map ={
      "review_checklist_id":"${projectData['id']}",
      "status":"$status"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id ::::>>>  ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        Navigator.pop(context,true);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
      }else{

        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }

      }

    }else{

    }
  }
  List checklistData = [];
  List checklistItems = [];
  List<bool> photoCompulsory = [];
  getDefectItems (BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_handing_over_checklist");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      // "floor_id":"${projectData['floor_id']}",
      //  "flat_id":"${projectData['flat_id']}",
      "defect_activity_id":selectedDefectActivityID,
      "room_type_id":selectedRoomID,
     "flat_id":"${projectData['flat_id']}",
     "checklist_id":"${projectData['id']}"
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
            if(checklistItems[i]['doer_comment'] =="" && checklistItems[i]['photo_compulsory'] == 1){
              photoCompulsory.add(true);
            }else{
              photoCompulsory.add(false);
            }

          }

        });
      }
    }else{

    }
  }

}
