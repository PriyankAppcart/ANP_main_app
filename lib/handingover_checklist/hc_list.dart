
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

class HCListPage extends KFDrawerContent {

  var userToken,projectData;
  HCListPage(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  @override
  HCListPageState createState() => HCListPageState(userToken,projectData);
}

class HCListPageState extends State<HCListPage> {

  var userToken,projectData;
  HCListPageState(userToken,projectData){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    getFloorList(context);

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
                            SizedBox(height:  0.5 * SizeConfig.heightMultiplier,),
                            checkData.length >= 1?Text(checkData[0]['checklist_code']+"\n ${ApiClient.dataFormatDayTime( checkData[0]['created_by'])}",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )):Container(),
                            SizedBox( height: 2 * SizeConfig.heightMultiplier,),
                            Text("Select Floor",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                            SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                            GestureDetector(
                              onTap: () {
                                if(floorList.length >= 1){
                                  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FloorSelection(
                                    floorList: floorList,
                                    reportingUnit :"FLAT",
                                    onSelected: (name, id) {
                                      print("name : $name");
                                      print("id : $id");
                                      setState(() {
                                        selectedFloors = name;
                                        selectedfloorsID = id;
                                        selectedFlat = "Select Flat";
                                        selectedFlatID = 0;
                                        flatList.clear();
                                        getFlatList(context);
                                      });
                                    },
                                  ));
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomDialog("Floor List Not available"));
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
                                        width: 32 *
                                            SizeConfig.widthMultiplier,
                                        child: Text(selectedFloors,
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
                            Text("Select Flat",
                                style: TextStyle(
                                  fontSize: 1.8 *
                                      SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                            SizedBox(
                              height:
                              0.5 * SizeConfig.heightMultiplier,
                            ),
                            GestureDetector(
                              onTap: () {
                                if(flatList.length >= 1){
                                  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FlatSingleSelection(
                                    flatList: flatList,
                                    onSelected: (name, id) {
                                      print("selectedName : $name");
                                      print("id : $id");
                                      setState(() {
                                        selectedFlat = name;
                                        selectedFlatID = id;
                                        selectedRoomID = 0;
                                        selectedRoom = "Select Room";
                                      });
                                      getCheckListCode(context,2);
                                    },
                                  ));
                                }else{
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => CustomDialog("Flat List Not available"));
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
                                        child: Text(selectedFlat,
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

                            checkFlag && checkData.length == 0?
                            Padding(
                              padding: EdgeInsets.only(top: 1 * SizeConfig.heightMultiplier),
                              child: Row(
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
                                    child: Text('Create Checklist',
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
                                          getCheckListCode(context,2);
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
                            ):Container(),
                            checkDataFlag?
                            Column(
                              mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1 * SizeConfig.heightMultiplier),
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
                                            if(selectedFloors != "Select Floor"){
                                              if(selectedFlat != "Select Flat"){
                                                if(selectedRoom != "Select Room"){
                                                  if(selectedDefectActivity != "Select Defect Activity"){
                                                    final result = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => FillHCPage(userToken,projectData,"$selectedRoomID","$selectedDefectActivityID","$selectedFlatID",checkData[0]['id'])));
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
                                              }else{
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) =>CustomDialog("Please select flat"));
                                              }
                                            }else{
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>CustomDialog("Please select floor"));
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
                            ):Container(),


                            SizedBox( height: 2 * SizeConfig.widthMultiplier,),

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

  getFloorList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_floor_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          floorList = decoded['data'];
        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  getFlatList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_flat_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"$selectedfloorsID"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          flatList = decoded['data'];
        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  getCheckListCode (BuildContext context,flag) async{
    showDialog( barrierDismissible: false,context: context,builder: (BuildContext context) => CustomDialogLoading());

    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_data");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"$selectedfloorsID",
      "flat_id":"$selectedFlatID",
      "flag":"$flag"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         checkData = decoded['data'];

         checkDataFlag = true;
         checkFlag = false;

         getRoomList(context);
        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
        setState(() {
          checkData = decoded['data'];
          checkDataFlag = false;
          if(flag == 1){
            checkFlag = true;
            checkDataFlag = false;
          }
        });
      }

    }else{

    }
  }

  getRoomList (BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_handover_room_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"$selectedfloorsID",
      "flat_id":"$selectedFlatID",
      "checklist_id":"${checkData[0]['id']}"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          roomList = decoded['data'];
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
      "floor_id":"$selectedfloorsID",
      "flat_id":"$selectedFlatID",
      "room_type_id":"$selectedRoomID",
      "checklist_id":"${checkData[0]['id']}"
    };
    print("map : ${map}");
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
}
