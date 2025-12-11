import 'dart:convert';
import 'dart:io';

import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/quality_checklist/qc_fill.dart';
import 'package:doer/selection/activity_selection.dart';
import 'package:doer/selection/app_bar_back.dart';
import 'package:doer/selection/check_list_selection.dart';
import 'package:doer/selection/column_selection.dart';
import 'package:doer/selection/contractor_selection.dart';
import 'package:doer/selection/flat_selection.dart';
import 'package:doer/selection/flat_single_selection.dart';
import 'package:doer/selection/floor_selection.dart';
import 'package:doer/selection/footing_selection.dart';
import 'package:doer/selection/sub_activity_selection.dart';
import 'package:doer/style/text_style.dart';
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

class QCListPage extends KFDrawerContent {

  var userToken,projectData;
  QCListPage(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  @override
  QCListPageState createState() => QCListPageState(userToken,projectData);
}
enum status { before, after }
class QCListPageState extends State<QCListPage> {

  var userToken,projectData;
  QCListPageState(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }


  bool getDataFlag = false;

  var selectedActivity = "Select Activity",selectedActivityID = 0;
  List activityList = [];
  var selectedSubactivity = "Select Subactivity",selectedSubactivityID = 0;
  List subActivityList = [];
  var selectedContractor  = "Select Contractor",selectedContractorID = 0;
  List contractorList = [];
  var selectedCheckLists  = "Select CheckLists",selectedCheckListsID = 0,reportingUnit = "";
  List checkLists = [];
  final drawingRef = TextEditingController();
  final FocusNode drawingRefFocus = FocusNode();

  final other = TextEditingController();
  final FocusNode otherFocus = FocusNode();

  status? statusBefore = status.before;
  var phaseFlag = 1;

  var selectedFloors = "Select Floor",selectedfloorsID = 0;
  var selectedColumns = "Select Columns",selectedColumnsID = 0;
  var selectedFooting = "Select Footing",selectedFootingID = 0;
  var selectedFlat = "Select Flat",selectedFlatID = 0;
  List floorList = [];
  List flatList = [];
  List columnList = [];
  List footingList = [];
  List listMap = [];
 String selectedDate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    getActivityList(context);
    selectedDate = ApiClient.todaysDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        backgroundColor: app_color,
        body: Column(children: <Widget>[

          Expanded( flex: 2,child:
          AppBarBack("Quality Checklist")),

          Expanded( flex: 14,
              child:Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(
                    5 * SizeConfig.widthMultiplier,
                  ),topRight: Radius.circular(
                    5 * SizeConfig.widthMultiplier,
                  )),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 3 * SizeConfig.widthMultiplier,top: 2 * SizeConfig.heightMultiplier),
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(projectData['project_name'],
                            style: DTextStyle.bodyLineBold),
                        SizedBox( height: 0.8 * SizeConfig.heightMultiplier,),
                        Text(projectData['building_name'],
                            style: DTextStyle.bodyLineBold),
                        SizedBox( height: 1.5 * SizeConfig.heightMultiplier,),
                        Text("Select Activity",
                            style: DTextStyle.bodyLine),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                        GestureDetector(
                          onTap: () {
                            if(activityList.length >= 1){
                              showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  ActivitySelection(
                                activityList: activityList,
                                onSelected: (actNam, actID) {
                                  print("selectedActivity : $actNam");
                                  print("selectedActivityID : $actID");
                                  setState(() {
                                    selectedActivity = actNam;
                                    selectedActivityID = actID;
                                    selectedSubactivity= "Select Subactivity";
                                    selectedContractor = "Select Contractor";
                                    selectedCheckLists  = "Select CheckLists";
                                    selectedFloors = "Select Floor";
                                    getSubactivityList(context, selectedActivityID);
                                  });
                                },
                              ));
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog("Activity Not available"));
                            }


                          },
                          child: Container(
                            width:
                            94 * SizeConfig.widthMultiplier,
                            height: 6 * SizeConfig.heightMultiplier,
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
                              padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedActivity,
                                      style: DTextStyle.bodyLine),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: app_color,
                                      size: 3.0 *
                                          SizeConfig
                                              .heightMultiplier,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Select Sub-Activity",
                            style: DTextStyle.bodyLine),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                        GestureDetector(
                          onTap: () {
                            if(subActivityList.length >= 1){
                            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  SubActivitySelection(
                              subActivityList: subActivityList,
                              onSelected: (actNam, actID,reportingUnitID) {
                                print("selectedActivity : $actNam");
                                print("selectedActivityID : $actID");
                                setState(() {
                                  selectedSubactivity= actNam;
                                  selectedSubactivityID = actID;
                                  selectedContractor = "Select Contractor";
                                  selectedCheckLists  = "Select CheckLists";
                                  selectedFloors = "Select Floor";

                                  getContractorList(context,selectedActivityID,selectedSubactivityID);
                                  getCheckList(context,selectedActivityID,selectedSubactivityID);
                                  getReportingUnit(context,selectedSubactivityID);
                                });
                              },
                            ));}else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog("Sub Activity Not available"));
                            }

                          },
                          child: Container(
                            width:
                            94 * SizeConfig.widthMultiplier,
                            height: 6 * SizeConfig.heightMultiplier,
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
                              padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 77* SizeConfig.widthMultiplier,
                                    child: Text(selectedSubactivity,
                                        style: DTextStyle.bodyLine),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: app_color,
                                      size: 3.0 *
                                          SizeConfig
                                              .heightMultiplier,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Select Contractor",
                            style: DTextStyle.bodyLine),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                        GestureDetector(
                          onTap: () {
                            if(contractorList.length >= 1){
                              showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  ContractorSelection(
                                contractorList: contractorList,
                                onSelected: (name, id) {
                                  print("selectedActivity : $name");
                                  print("selectedActivityID : $id");
                                  setState(() {
                                    selectedContractor = name;
                                    selectedContractorID = id;
                                    // getContractorList(context,selectedActivityID,selectedSubactivityID);
                                  });
                                },
                              ));
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog("Contractor Not available"));
                            }


                          },
                          child: Container(
                            width:
                            94 * SizeConfig.widthMultiplier,
                            height: 6 * SizeConfig.heightMultiplier,
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
                              padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedContractor,
                                      style: DTextStyle.bodyLine),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: app_color,
                                      size: 3.0 *
                                          SizeConfig
                                              .heightMultiplier,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Select CheckLists",
                            style: DTextStyle.bodyLine),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
                        GestureDetector(
                          onTap: () {
                            if(checkLists.length >= 1){
                              showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  CheckListSelection(
                                checkLists: checkLists,
                                onSelected: (name, id) {
                                  print("selectedActivity : $name");
                                  print("selectedActivityID : $id");
                                  setState(() {
                                    selectedCheckLists = name;
                                    selectedCheckListsID = id;
                                    getChecklistByPhase(context,phaseFlag);
                                    // getContractorList(context,selectedActivityID,selectedSubactivityID);
                                  });
                                },
                              ));
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => CustomDialog("CheckLists Not available"));
                            }


                          },
                          child: Container(
                            width:
                            94 * SizeConfig.widthMultiplier,
                            height: 6 * SizeConfig.heightMultiplier,
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
                              padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(selectedCheckLists,
                                      style: DTextStyle.bodyLine),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: app_color,
                                      size: 3.0 *
                                          SizeConfig
                                              .heightMultiplier,
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Drawing Reference",
                            style: TextStyle(
                              fontSize: 1.8 *
                                  SizeConfig.textMultiplier,
                              fontFamily: 'Lato',
                              color: Colors.black,
                            )),
                        SizedBox(height: 0.5 * SizeConfig.heightMultiplier,),
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
                                  height: 8 *
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
                                    controller: drawingRef,
                                    cursorColor:
                                    Colors.black,
                                    keyboardType:
                                    TextInputType.text,
                                    textInputAction:
                                    TextInputAction
                                        .done,
                                    focusNode:
                                    drawingRefFocus,
                                    maxLines: 3,
                                    onFieldSubmitted: (value) {
                                      drawingRefFocus
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
                        Row(
                          children: [
                            Text("Phase : ",
                                style: DTextStyle.bodyLine),
                            Radio(
                              //focusColor: Color(0xFF7a8d56),
                              activeColor: app_color,
                              value: status.before,
                              groupValue: statusBefore,
                              onChanged: (status? value) {
                                setState(() {
                                  statusBefore = value;
                                  phaseFlag = 1;
                                 // getChecklistByPhase(context,phaseFlag);
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  statusBefore = status.before;
                                  phaseFlag = 1;
                                 // getChecklistByPhase(context,phaseFlag);
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

                              },
                            ),
                            Text("After",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,fontFamily: 'Lato',
                                  color: CustomColor.lightBlack,
                                )),
                          ],
                        ),
                        reportingUnit == "COLUMN"?
                        Column(children: [
                          Row(
                            children: [
                              Container(
                                  width: 45 *
                                      SizeConfig
                                          .widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                          "Select Floor",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig
                                                    .textMultiplier,
                                            fontFamily:
                                            'Lato',
                                            color:
                                            Colors.black,
                                          )),
                                      SizedBox(height: 0.5 *SizeConfig.heightMultiplier),
                                      GestureDetector(
                                        onTap: () {
                                          if(floorList.length >= 1){
                                            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FloorSelection(
                                              floorList: floorList,
                                              reportingUnit :reportingUnit,
                                              onSelected: (name, id) {
                                                print("name : $name");
                                                print("id : $id");
                                                setState(() {
                                                  selectedFloors = name;
                                                  selectedfloorsID = id;
                                                  selectedColumns = "Select Columns";
                                                  selectedColumnsID = 0;
                                                  selectedFlat = "Select Flat";
                                                  selectedFlatID = 0;
                                                  columnList.clear();
                                                  flatList.clear();
                                                  if(reportingUnit == "COLUMN"){
                                                    getColumnList(context, phaseFlag,selectedfloorsID);

                                                  }else{
                                                    getFlatList(context,phaseFlag, selectedfloorsID);
                                                  }

                                                });
                                              },
                                            ));
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomDialog("Floor List Not avalible"));
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
                                    ],
                                  )),
                              SizedBox(
                                width: 4 *
                                    SizeConfig
                                        .widthMultiplier,
                              ),
                              Container(
                                  width: 45 *
                                      SizeConfig
                                          .widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("Select Columns",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig
                                                    .textMultiplier,
                                            fontFamily:
                                            'Lato',
                                            color:
                                            Colors.black,
                                          )),
                                      SizedBox(
                                        height: 0.5 *
                                            SizeConfig
                                                .heightMultiplier,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if(columnList.length >= 1){
                                            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  ColumnSelection(
                                              columnList: columnList,
                                              onSelected: (columnsMap,selectedName) {
                                                print("selectedName : $selectedName");
                                                print("name : $columnsMap");
                                                setState(() {
                                                  listMap = columnsMap;
                                                  selectedColumns = selectedName;
                                                });
                                              }, selectedName: null,
                                            ));
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomDialog("Column List Not avalible"));
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
                                                  child: Text(selectedColumns,
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
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 1 *SizeConfig.heightMultiplier,),

                        ]):
                        reportingUnit == "FLAT"?
                        Column(children: [
                          Row(
                            children: [
                              Container(
                                  width: 45 *
                                      SizeConfig
                                          .widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                          "Select Floor",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig
                                                    .textMultiplier,
                                            fontFamily:
                                            'Lato',
                                            color:
                                            Colors.black,
                                          )),
                                      SizedBox(height: 0.5 *SizeConfig.heightMultiplier),
                                      GestureDetector(
                                        onTap: () {
                                          if(floorList.length >= 1){
                                            showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FloorSelection(
                                              floorList: floorList,
                                              reportingUnit :reportingUnit,
                                              onSelected: (name, id) {
                                                print("name : $name");
                                                print("id : $id");
                                                setState(() {
                                                  selectedFloors = name;
                                                  selectedfloorsID = id;
                                                  selectedColumns = "Select Columns";
                                                  selectedColumnsID = 0;
                                                  selectedFlat = "Select Flat";
                                                  selectedFlatID = 0;
                                                  columnList.clear();
                                                  flatList.clear();
                                                  if(reportingUnit == "COLUMN"){
                                                    getColumnList(context, phaseFlag,selectedfloorsID);
                                                  }else{
                                                    getFlatList(context,phaseFlag, selectedfloorsID);
                                                  }

                                                });
                                              },
                                            ));
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomDialog("Floor List Not avalible"));
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
                                    ],
                                  )),
                              SizedBox(
                                width: 4 *
                                    SizeConfig
                                        .widthMultiplier,
                              ),
                              Container(
                                  width: 45 *
                                      SizeConfig
                                          .widthMultiplier,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("Select Flat",
                                          style: TextStyle(
                                            fontSize: 1.8 *
                                                SizeConfig
                                                    .textMultiplier,
                                            fontFamily:
                                            'Lato',
                                            color:
                                            Colors.black,
                                          )),
                                      SizedBox(
                                        height: 0.5 *
                                            SizeConfig
                                                .heightMultiplier,
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
                                                });
                                              },
                                            ));
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomDialog("Flat List Not avalible"));
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
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 1 *SizeConfig.heightMultiplier,),

                        ]):
                        reportingUnit == "FLOOR"?
                        Container(
                            width: 94 *
                                SizeConfig
                                    .widthMultiplier,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text(
                                    "Select Floor",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig
                                              .textMultiplier,
                                      fontFamily:
                                      'Lato',
                                      color:
                                      Colors.black,
                                    )),
                                SizedBox(height: 0.5 *SizeConfig.heightMultiplier),
                                GestureDetector(
                                  onTap: () {
                                    if(floorList.length >= 1){
                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FloorSelection(
                                        floorList: floorList,
                                        reportingUnit :reportingUnit,
                                        onSelected: (name, id) {
                                          print("name : $name");
                                          print("id : $id");
                                          setState(() {
                                            selectedFloors = name;
                                            selectedfloorsID = id;
                                            selectedColumns = "Select Columns";
                                            selectedColumnsID = 0;
                                            selectedFlat = "Select Flat";
                                            selectedFlatID = 0;
                                            columnList.clear();
                                            flatList.clear();
                                            if(reportingUnit == "COLUMN"){
                                              getColumnList(context, phaseFlag,selectedfloorsID);
                                            }else{
                                              getFlatList(context,phaseFlag, selectedfloorsID);
                                            }

                                          });
                                        },
                                      ));
                                    }else{
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CustomDialog("Floor List Not avalible"));
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
                              ],
                            )):
                        reportingUnit == "FOOTING"?
                        Container(
                            width: 94 *
                                SizeConfig
                                    .widthMultiplier,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Select Footing",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig
                                              .textMultiplier,
                                      fontFamily:
                                      'Lato',
                                      color:
                                      Colors.black,
                                    )),
                                SizedBox(
                                  height: 0.5 *
                                      SizeConfig
                                          .heightMultiplier,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if(footingList.length >= 1){
                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FootingSelection(
                                        footingList: footingList,
                                        onSelected: (footingMap,selectedName) {
                                          print("selectedName : $selectedName");
                                          print("name : $footingMap");
                                          setState(() {
                                            listMap = footingMap;
                                            selectedFooting = selectedName;
                                          });
                                        }, selectedName: null,
                                      ));
                                    }else{
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CustomDialog("Footing List Not avalible"));
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
                                            child: Text(selectedFooting,
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
                              ],
                            )):
                        reportingUnit == "OTHER"?
                        Container(
                            width: 94 *
                                SizeConfig
                                    .widthMultiplier,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                Text("Other",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig
                                              .textMultiplier,
                                      fontFamily:
                                      'Lato',
                                      color:
                                      Colors.black,
                                    )),
                                SizedBox(
                                  height: 0.5 *
                                      SizeConfig
                                          .heightMultiplier,
                                ),
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

                                          child: TextFormField(
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 2 *
                                                  SizeConfig
                                                      .heightMultiplier,
                                              fontFamily: 'Lato',
                                            ),
                                            controller: other,
                                            cursorColor:
                                            Colors.black,
                                            keyboardType:
                                            TextInputType.text,
                                            textInputAction:
                                            TextInputAction
                                                .done,
                                            focusNode:
                                            otherFocus,
                                            maxLines: 3,
                                            onFieldSubmitted: (value) {
                                              otherFocus
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

                                              hintText: "Enther Other Unit",
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
                              ],
                            )):Container(),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("Date : ${ApiClient.dataFormatYear(selectedDate)}",
                            style: DTextStyle.bodyLine),


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

                                    if(selectedActivity != "Select Activity"){
                                      if(selectedSubactivity != "Select Subactivity"){
                                        if(selectedContractor != "Select Contractor"){
                                          if(selectedCheckLists != "Select CheckLists"){
                                            if(!drawingRef.text.isEmpty){
                                              if(reportingUnit == "COLUMN"){
                                                if(selectedFloors != "Select Floor"){
                                                  if(selectedColumns != "Select Columns"){
                                                    getSave(context);
                                                  }else{
                                                    showDialog(context: context,builder: (BuildContext
                                                    context) =>CustomDialog("Please Select Columns"));
                                                  }
                                                }else{
                                                  showDialog(context: context,builder: (BuildContext
                                                  context) =>CustomDialog("Please Select Floor"));
                                                }

                                              }else if(reportingUnit == "FLAT"){
                                                if(selectedFloors != "Select Floor"){
                                                  if(selectedFlat != "Select Flat"){
                                                    getSave(context);
                                                  }else{
                                                    showDialog(context: context,builder: (BuildContext
                                                    context) =>CustomDialog("Please Select Flat"));
                                                  }
                                                }else{
                                                  showDialog(context: context,builder: (BuildContext
                                                  context) =>CustomDialog("Please Select Floor"));
                                                }
                                              }else if(reportingUnit == "FLOOR"){
                                                if(selectedFloors != "Select Floor"){
                                                  getSave(context);
                                                }else{
                                                  showDialog(context: context,builder: (BuildContext
                                                  context) =>CustomDialog("Please Select Floor"));
                                                }
                                              }else if(reportingUnit == "FOOTING"){
                                                if(selectedFooting != "Select Footing"){
                                                  getSave(context);
                                                }else{
                                                  showDialog(context: context,builder: (BuildContext
                                                  context) =>CustomDialog("Please Select Footing"));
                                                }
                                              }else if(reportingUnit == "OTHER"){
                                                if(!other.text.isEmpty){
                                                  getSave(context);
                                                }else{
                                                  showDialog(context: context,builder: (BuildContext
                                                  context) =>CustomDialog("Please enter Other value"));
                                                }
                                              }
                                            }else{
                                              showDialog(context: context,builder: (BuildContext
                                              context) =>CustomDialog("Please enter drawing reference"));
                                            }
                                          }else{
                                            showDialog(context: context,builder: (BuildContext
                                            context) =>CustomDialog("Please select CheckLists"));
                                          }
                                        }else{
                                          showDialog(context: context,builder: (BuildContext
                                          context) =>CustomDialog("Please select contractor"));
                                        }
                                      }else{
                                        showDialog(context: context,builder: (BuildContext
                                        context) =>CustomDialog("Please select sub activity"));
                                      }
                                    }else{
                                      showDialog(context: context,builder: (BuildContext
                                      context) =>CustomDialog("Please select activity"));
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
                        SizedBox( height: 2 * SizeConfig.widthMultiplier,),

                      ],
                    ),
                  ),
                ),
              ))




        ])
    );

  }

  // Get Activity List
  getActivityList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_activity");
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
          activityList = decoded['data'];
        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // Get Sub Activity List
  getSubactivityList(BuildContext context,activityID) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_sub_activity_quality_checklist");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "activity_id":"$activityID",
    };
    print("url : $url");
    print("map : ${jsonEncode(map)}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          subActivityList = decoded['data'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }

  // Get Sub Activity List
  getContractorList(BuildContext context,activityID,subActivityId) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_contractor_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "activity_id":"$activityID",
      "sub_activity_id":"$subActivityId"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("getContractorList : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          contractorList = decoded['data'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }

  // Get Sub Activity List
  getCheckList(BuildContext context,activityID,subActivityId) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_check_lists");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "activity_id":"$activityID",
      "sub_activity_id":"$subActivityId"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("checkLists : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          checkLists = decoded['data'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }
  // Get Sub Activity List
  getReportingUnit(BuildContext context,subActivityId) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_reporting_unit_chk");
    Map map ={
      "sub_activity_id":"$subActivityId"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("getReportingUnit : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         reportingUnit = decoded['data']['reporting_unit'];

        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }

  // Get Sub Activity List
  getChecklistByPhase(BuildContext context,flag) async{
    setState(() {

      selectedFloors = "Select Floor";
      selectedColumns = "Select Columns";
      selectedFlat = "Select Flat";
      floorList.clear();
      flatList.clear();
      columnList.clear();
    });
    var url = Uri.parse(ApiClient.BASE_URL+"get_checklist_by_phase");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "activity_id":"$selectedActivityID",
      "sub_activity_id":"$selectedSubactivityID",
      "phase":"$flag",
      "contractor_id":"$selectedContractorID",
      "reporting_unit":"$reportingUnit",
      "checklist_id":"$selectedCheckListsID"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("get floor_list Phase : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         // reportingUnit = decoded['data']['reporting_unit'];
           floorList = decoded['data']['floor_list'];
           footingList = decoded['data']['footing_list'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }

  getColumnList(BuildContext context,flag,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_column_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"$id",
      "phase":"$flag",
      "checklist_id":"$selectedCheckListsID"
    };
    print("map get getColumnList Phase : : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("get getColumnList Phase : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          // reportingUnit = decoded['data']['reporting_unit'];
          columnList = decoded['data'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }
  getFlatList(BuildContext context,flag,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_flat_list");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "floor_id":"$id",
      "phase":"$flag",
      "checklist_id":"$selectedCheckListsID"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("getFlatList Phase : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          // reportingUnit = decoded['data']['reporting_unit'];
          flatList = decoded['data'];
        });
      }else{
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }
  }

  getSave(BuildContext context) async {
    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL + "save_checklist");
    Map map = {
      "project_id": "${projectData['project_id']}",
      "building_id": "${projectData['building_id']}",
      "floor_id": "$selectedfloorsID",
      "column_name": listMap,
      "phase": "$phaseFlag",
      "activity_id": "$selectedActivityID",
      "sub_activity_id": "$selectedSubactivityID",
      "contractor_id": "$selectedContractorID",
      "drawing_reference": drawingRef.text,
      "unit": reportingUnit,
      "checklist_id": selectedCheckListsID,
      "date": selectedDate,
      "others_value": other.text,
      "flat_id": selectedFlatID,
      "flat_name": listMap,
      "footing_no": listMap
    };
    print("map : ${jsonEncode(map)}");
    var response = await http.post(url, headers: {
      'Content-type': 'application/json',
      'Authorization': "$userToken"
    }, body: utf8.encode(json.encode(map)));
    Map decoded = jsonDecode(response.body);
    print("getSave Phase : ${decoded}");
    print("getSave response.statusCode : ${response.statusCode}");
    Navigator.pop(context);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        setState(() {
          listMap.clear();
          other.text = "";
          drawingRef.text = "";
          selectedfloorsID = 0;
          selectedActivityID = 0;
          selectedActivity = "Select Activity";
          selectedSubactivity = "Select Subactivity";
          selectedContractor = "Select Contractor";
          selectedCheckLists = "Select CheckLists";
          selectedFloors = "Select Floor";
          selectedColumns = "Select Columns";
          selectedFooting = "Select Footing";
          selectedFlat = "Select Flat";
        });
        final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new FillQCPage(
                userToken, decoded['data'])));
        if (result != null || result == null) {
          // getFavourite(context);
        }
      } else {
        if (decoded['token']) {
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  CustomDialog(decoded['message']));
        } else {
          showDialog(barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => TokenExpired());
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(decoded['message']));
    }
  }

}
