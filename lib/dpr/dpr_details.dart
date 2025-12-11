import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:doer/dpr/dpr_apis.dart';
import 'package:doer/dpr/flat_selection.dart';
import 'package:doer/dpr/manpower_screen.dart';
import 'package:doer/pages/view_photos.dart';
import 'package:doer/selection/activity_selection.dart';
import 'package:doer/selection/sub_activity_selection.dart';
import 'package:doer/style/text_style.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';
import 'package:dio/dio.dart';

import '../util/colors_file.dart';
import '../widgets/colors.dart';

class DprDetailsPage extends KFDrawerContent {
  var userToken,projectData,dates;
  DprDetailsPage(userToken,projectData,dates) {
    this.userToken = userToken;
    this.projectData = projectData;
    this.dates = dates;
  }

  @override
  _DprDetailsPageState createState() => _DprDetailsPageState(userToken,projectData,dates);
}

class _DprDetailsPageState extends State<DprDetailsPage>  with SingleTickerProviderStateMixin {
  var userToken,projectData,dates;
  _DprDetailsPageState(userToken,projectData,dates) {
    this.userToken = userToken;
    this.projectData = projectData;
    this.dates = dates;
  }  // 40474544908 SBIN0009281 Nangrool



  List<File> _image = [];
  List<bool> isImage = [true];

  List<bool> selected = [false, false, false, true];
  var isProject = false;
  var isViewDPR = false;
  var dprId; // 27
  var selectedManpower = "Select Manpower",selectedManpowerID,editManpowerId,isEditManpower = false,approved = 0,revoked = 0;
  List manPowerList = [];
  List manPowerTodayList = [];

  var selectedContractor = "Select Contractor",selectedContractorID;
  List contractorList = [];

  var selectedMaterial  = "Select Material",selectedMaterialID,mUnit = "",openingBalance = "",ClosingBalanc = 0,isEditMaterial = false,editMaterialId;
  List materialList = [];
  List MaterialTodayList = [];
  List<int> sNum = [7,10,13];

  var selectedactivity = "Select Activity",selectedActivityID;
  List activityList = [];

  var actID = "0",otheActID = "0";
  var selectedSubactivity = "Select Subactivity",selectedSubactivityID,reportingUnit = "",otherUnit = "",otherQty = "",Progress = "";
  List subActivityList = [];
  List ActivityTodayList = [];
  bool isEditActivity = false;

  List columnsList = [];
  List footingsList = [];
  List floorsList = [];
  var floor_category;
  var selectedFloors = "Select Floor",selectedfloorsID = 0,floorPreProg ="";
  var selectedColumns = "Select Columns",selectedColumnsID;
  var selectedFooting = "Select Footing",selectedFootingID;
  List<bool> isFootingsList= [];

  bool isChecked = true;
  List<bool> isColumnsList= [];
  List<bool> todayProgressValidation = [];
  List<TextEditingController> _controllers = [];
  List<FocusNode> _focusNode = [];
  List columnsMap = [];
  var columnsMap1 = [];

  List flatList = [];
  var selectedFlat = "Select Flat",selectedFlatID;
  List<bool> isFlatList= [];

  List DatewiseDPR = [];


  var selectedDate = "";
  final createdBy = TextEditingController();
  final FocusNode createdByFocus = FocusNode();

  final skilledWorkers = TextEditingController();
  final FocusNode skilledWorkersFocus = FocusNode();
  final unSkilledWorkers = TextEditingController();
  final FocusNode unSkilledWorkersFocus = FocusNode();
  final comments = TextEditingController();
  final FocusNode commentsFocus = FocusNode();

  final receivedToday = TextEditingController();
  final FocusNode receivedTodayFocus = FocusNode();
  final issueToday = TextEditingController();
  final FocusNode issueTodayFocus = FocusNode();
  final mComments = TextEditingController();
  final FocusNode mCommentsFocus = FocusNode();

  bool isProgress = true;
  final aProgress = TextEditingController();
  final FocusNode aProgressFocus = FocusNode();
  final aComments = TextEditingController();
  final FocusNode aCommentsFocus = FocusNode();

  final description = TextEditingController();
  final FocusNode descriptionFocus = FocusNode();
  List remarkPhotoList = [];
  bool apiFlag = false;
  var isDescription = "";

  final revokeWithComments = TextEditingController();
  final FocusNode revokeWithCommentsFocus = FocusNode();
  var revokeComments = "";



  late ManpowerPageState _manpower = new ManpowerPageState(projectData,userToken,selectedDate,dprId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    if(dates == "1"){
      selectedDate = ApiClient.todaysDate(DateTime.now());
    }else{
      print("dates ::::  $dates");
      selectedDate = dates;
    }

    print("userToken $userToken");
    createdBy.text = ApiClient.userName ;
    viewDPR(context,1);
    getDatewiseDPR(context);
    getManpowerList(context);


    getActivityList(context);


    print("print ${APIS.viewDPR(10)}");

    print("_image.length  :: ${_image.length}");

  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: Column(children: <Widget>[
          Container(
            width: 100 * SizeConfig.widthMultiplier,
            height: 12.5 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [app_color, app_color],
                tileMode: TileMode.repeated,
              ),
            ),
            child: Padding(
              padding:
              EdgeInsets.only(top: 3 * SizeConfig.heightMultiplier),
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
                        onPressed: () => Navigator.pop(context, ""),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("DPR-Project",
                              style: DTextStyle.mainHeadline),
                          Text(ApiClient.userName + " "+ ApiClient.roleName,
                              style: TextStyle(
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                                fontFamily: 'Lato',
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.calendarAlt,
                      color: Colors.white,
                      size: 6.0 *
                          SizeConfig.imageSizeMultiplier,
                    ),
                    onPressed: () async {

                      DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23,59,59) ;
                      print("dateToday : $dateToday");

                      DateTime? newDateTime =
                      await showRoundedDatePicker(
                        context: context,
                          builderDay:
                              (DateTime dateTime, bool isCurrentDay, bool isSelected, TextStyle defaultTextStyle) {
                            if (isSelected) {
                              return Container(
                                decoration: BoxDecoration(color: app_color, shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    dateTime.day.toString(),
                                    style: TextStyle(
                                      fontSize:
                                      1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }

                            for(int i = 0; i<DatewiseDPR.length; i++){
                              var dd = "${DatewiseDPR[i]['dpr_date']} 00:00:00";
                              int y = int.parse(dd.substring(0,4));
                              int m = int.parse(dd.substring(5,7));
                              int d = int.parse(dd.substring(8,10));
                              print('DatewiseDPR :: ${dd.substring(0,4)}');
                              print('DatewiseDPR :: ${dd.substring(5,7)}');
                              print('DatewiseDPR :: ${dd.substring(8,10)}');

                              print('dateTime :: ${dateTime}');
                              if (dateTime.day == d && dateTime.month == m && dateTime.year == y ) {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: app_color, width: 0.2* SizeConfig.widthMultiplier), shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      dateTime.day.toString(),
                                      style: defaultTextStyle,
                                    ),
                                  ),
                                );
                              }
                            }
                            return Container(
                              child: Center(
                                child: Text(
                                  dateTime.day.toString(),
                                  style: defaultTextStyle,
                                ),
                              ),
                            );
                          },
                         // listDateDisabled: [ DateTime(2021,10,10),],
                        theme: ThemeData(
                            primarySwatch: Colors.orange),
                        height: 50 *
                            SizeConfig.heightMultiplier,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            DateTime.now().year, DateTime.now().month - 2),
                        lastDate: dateToday,
                        // borderRadius: 2,
                      );
                      if (newDateTime != null) {
                        setState(() {
                          print("newDateTime : $newDateTime");

                          selectedDate =  ApiClient.todaysDate(newDateTime);
                          viewDPR(context,2);

                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Flexible( fit: FlexFit.tight,
              flex: 14,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    isViewDPR?
                    Container(
                      width: 100 * SizeConfig.widthMultiplier,
                    //  height: 30 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, -2))
                        ],
                        color: app_color,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(projectData['project_name'],
                                style: TextStyle(
                                  fontSize: 2 * SizeConfig.textMultiplier,
                                  color: Colors.white,
                                )),
                            Text(projectData['building_name'],
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Text("Date : DPR $selectedDate",
                                style: TextStyle(
                                  fontSize:
                                  1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Text("Report Created By : ${createdBy.text}",
                                style: TextStyle(
                                  fontSize:
                                  1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: ()async {
                                    setState(() {

                                      DPRConfirmationDialog(context,2);
                                    });
                                  },
                                  child: Container(
                                   // width: 20 * SizeConfig.widthMultiplier,
                                    height: 5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(
                                        2 * SizeConfig.imageSizeMultiplier,
                                      )),
                                      // color: Color(0xFFba3d41),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("  Create New  ",
                                          style: TextStyle(
                                            fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3 * SizeConfig.widthMultiplier,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                          ],
                        ),
                      ),
                    )
                    : Container(
                      width: 100 * SizeConfig.widthMultiplier,
                      //  height: 30 * SizeConfig.heightMultiplier,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, -2))
                        ],
                        color: app_color,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 3 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(projectData['project_name'],
                                    style: TextStyle(
                                      fontSize: 2 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                                IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                    size: 3.0 * SizeConfig.heightMultiplier,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text(projectData['building_name'],
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            isProject?Text("Date : DPR ${ApiClient.dataFormatYear(selectedDate)}",
                                style: TextStyle(
                                  fontSize:
                                  1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                ))
                                :Container(
                              width: 94 * SizeConfig.widthMultiplier,
                              // height: 7 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  2 * SizeConfig.imageSizeMultiplier,
                                )),
                                // color: Color(0xFFba3d41),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text("Date : ",
                                              style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color: Colors.white,
                                              )),
                                          Text(ApiClient.dataFormatYear(selectedDate),
                                              style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color: Colors.white,
                                              )),
                                        ],
                                      ),
                                      IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.calendarAlt,
                                          color: Colors.white,
                                          size: 6.0 *
                                              SizeConfig.imageSizeMultiplier,
                                        ),
                                        onPressed: () async {

                                          DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23,59,59) ;

                                          print("dateToday : $dateToday");

                                          DateTime? newDateTime =
                                          await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                DateTime.now().year, DateTime.now().month, DateTime.now().day - 2),
                                            lastDate: dateToday,
                                            builder: (context, child) {
                                              return Theme(
                                                data: Theme.of(context).copyWith(
                                                  colorScheme: ColorScheme.light(
                                                    background: Colors.white,
                                                    primary: app_color, // header background color
                                                    onPrimary: Colors.white, // header text color
                                                    onSurface: Colors.black, // body text color
                                                  ),
                                                  textButtonTheme: TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: app_color, // button text color
                                                    ),
                                                  ),
                                                    datePickerTheme: DatePickerThemeData(
                                                      backgroundColor: Colors.white,
                                                      surfaceTintColor: Colors.transparent,
                                                      headerForegroundColor: Colors.black,

                                                      //u need to match the text color also
                                                      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                                                        if (states.contains(MaterialState.selected)) {
                                                          return app_color;
                                                        }
                                                        return Colors.white;
                                                      }),)
                                                ),
                                                child: child!,
                                              );
                                            },
                                          );
                                          if (newDateTime != null) {
                                            setState(() {
                                              print("newDateTime : $newDateTime");
                                              selectedDate =  ApiClient.todaysDate(newDateTime);
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            isProject?Text("Report Created By : ${createdBy.text}",
                                style: TextStyle(
                                  fontSize:
                                  1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                )):
                            Container(
                              width: 94 * SizeConfig.widthMultiplier,
                              height: 6 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  2 * SizeConfig.imageSizeMultiplier,
                                )),
                                // color: Color(0xFFba3d41),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 2 * SizeConfig.widthMultiplier,
                                      right: 2 * SizeConfig.widthMultiplier),
                                  child: Row(
                                    children: [
                                      Text("Report Created By: ",
                                          style: TextStyle(
                                            fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.white,
                                          )),
                                      Container(
                                        width: 50 * SizeConfig.widthMultiplier,
                                        child: TextFormField(
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                            2 * SizeConfig.heightMultiplier,
                                            fontFamily: 'Lato',
                                          ),
                                          controller: createdBy,
                                          cursorColor: Colors.white,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          focusNode: createdByFocus,
                                          onFieldSubmitted: (value) {
                                            createdByFocus.unfocus();
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
                                            contentPadding:
                                            new EdgeInsets.symmetric(
                                                vertical: 1 *
                                                    SizeConfig
                                                        .widthMultiplier,
                                                horizontal: 1 *
                                                    SizeConfig
                                                        .widthMultiplier),
                                            hintText: "",
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              2 * SizeConfig.textMultiplier,
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            isProject && (ApiClient.userType =="1" || ApiClient.userType == "2")?Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Create previous DPR ",
                                    style: TextStyle(
                                      fontSize:
                                      1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: Colors.white,
                                    )),
                                IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.calendarAlt,
                                    color: Colors.white,
                                    size: 6.0 *
                                        SizeConfig.imageSizeMultiplier,
                                  ),
                                  onPressed: () async {

                                    DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23,59,59) ;



                                    DateTime? newDateTime =
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(
                                          DateTime.now().year, DateTime.now().month, DateTime.now().day - 2),
                                      lastDate: dateToday,
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              background: Colors.white,
                                              primary: app_color, // header background color
                                              onPrimary: Colors.white, // header text color
                                              onSurface: Colors.black, // body text color
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: app_color, // button text color
                                              ),
                                            ),
                                           datePickerTheme: DatePickerThemeData(
                                             backgroundColor: Colors.white,
                                             surfaceTintColor: Colors.transparent,
                                             headerForegroundColor: Colors.black,

                                             //u need to match the text color also
                                             dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                                               if (states.contains(MaterialState.selected)) {
                                                 return app_color;
                                               }
                                               return Colors.white;
                                             }),)
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                   //  fdg

                                    if (newDateTime != null) {
                                      print("dateToday 1 ---- : $dateToday");
                                      print("dateToday 2 ---- : $newDateTime");
                                      print("dateToday 3 ---- : ${ApiClient.todaysDate(newDateTime)}");

                                      createNewDPR(context,ApiClient.todaysDate(newDateTime));
                                    }
                                  },
                                ),
                              ],
                            ):Container(),
                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                isProject?Container(): InkWell(
                                  onTap: ()async {
                                    try {
                                      final result = await InternetAddress.lookup('google.com');
                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                        print('connected  ::::::: ' + result[0].rawAddress.toString());
                                        FocusScope.of(context).unfocus();

                                        if (!createdBy.text.isEmpty) {
                                          if (createdBy.text.length >= 3) {
                                            createNewDPR(context,selectedDate);
                                          }else{
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) => CustomDialog("At least 3 character is required"));
                                          }
                                        }else{
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) => CustomDialog("Report created by is required"));
                                        }
                                      }
                                    } on SocketException catch (_) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => CustomDialog("Check Internet connection"));
                                    }
                                  },
                                  child: Container(
                                    width: 20 * SizeConfig.widthMultiplier,
                                    height: 5 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(
                                        2 * SizeConfig.imageSizeMultiplier,
                                      )),
                                      // color: Color(0xFFba3d41),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("Save ",
                                          style: TextStyle(
                                            fontSize:
                                            1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 3 * SizeConfig.widthMultiplier,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                          ],
                        ),
                      ),
                    ),

                    apiFlag?isProject?
                    Column(
                      children: [

                        Stack(
                          children: [
                            Container(
                              height: 5 * SizeConfig.heightMultiplier,
                              color: app_color,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected[0] = true;
                                  selected[1] = false;
                                  selected[2] = false;
                                  selected[3] = false;
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
                                  padding: EdgeInsets.only(
                                      left: 4 * SizeConfig.widthMultiplier),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier,right: 3 * SizeConfig.widthMultiplier,bottom: 2 * SizeConfig.heightMultiplier ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("RECORD MANPOWER",
                                                style: TextStyle(
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Colors.black,
                                                )),
                                            Icon(
                                              selected[0]
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: app_color,
                                              size: 3.0 * SizeConfig.heightMultiplier,
                                            ),
                                          ],
                                        ),
                                      ),
                                      selected[0]
                                          ?   Column(
                                        mainAxisAlignment:MainAxisAlignment.start,
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          approved == 0?Column(
                                            mainAxisAlignment:MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Text("Select Manpower",
                                                  style: TextStyle(
                                                    fontSize: 1.8 * SizeConfig.textMultiplier,
                                                    fontFamily: 'Lato',
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(
                                                height:
                                                0.5 * SizeConfig.heightMultiplier,
                                              ),
                                              GestureDetector(
                                                onTap: () {

                                                  if(!isEditManpower){
                                                    selectManpower(context);
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => CustomDialog("You can edit only"));
                                                  }
                                                },
                                                child: Container(
                                                  width:
                                                  94 * SizeConfig.widthMultiplier,
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
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(selectedManpower,
                                                            style: TextStyle(
                                                              fontSize: 1.8 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontFamily: 'Lato',
                                                              color: Colors.black,
                                                            )),
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
                                              SizedBox(
                                                height:
                                                1.5 * SizeConfig.heightMultiplier,
                                              ),

                                              Text("Select Contractor",
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
                                                  if(!isEditManpower){
                                                    if(contractorList.length >= 1) {
                                                      selectContractor(context);
                                                    }else{
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) =>
                                                              CustomDialog(
                                                                  "There is no any contractor found.\nPlease select manpower first.OR \nYou can contact to KP admin"));
                                                    }
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => CustomDialog("You can edit only"));
                                                  }

                                                },
                                                child: Container(
                                                  width:
                                                  94 * SizeConfig.widthMultiplier,
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
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(selectedContractor,
                                                            style: TextStyle(
                                                              fontSize: 1.8 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontFamily: 'Lato',
                                                              color: Colors.black,
                                                            )),
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
                                              SizedBox(
                                                height:
                                                1.5 * SizeConfig.heightMultiplier,
                                              ),
                                              Text("No. Of Skilled Workers",
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
                                              Container(
                                                width:
                                                94 * SizeConfig.widthMultiplier,
                                                //height: 4 * SizeConfig.heightMultiplier,
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                                          style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            fontFamily: 'Lato',
                                                          ),
                                                          controller: skilledWorkers,
                                                          cursorColor: Colors.black,
                                                          keyboardType:
                                                          TextInputType.number,
                                                          textInputAction:
                                                          TextInputAction.next,
                                                          focusNode:
                                                          skilledWorkersFocus,
                                                          onFieldSubmitted: (term) {
                                                            _fieldFocusChange(
                                                                context,
                                                                skilledWorkersFocus,
                                                                unSkilledWorkersFocus);
                                                          },
                                                          maxLength: 3,
                                                          decoration: InputDecoration(
                                                            // labelText: "Enter Email",
                                                            // isDense: true,
                                                            counterText: "",
                                                            border: InputBorder.none,
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
                                              SizedBox(
                                                height:
                                                1.5 * SizeConfig.heightMultiplier,
                                              ),
                                              Text("No. Of UnSkilled Workers",
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
                                              Container(
                                                width:
                                                94 * SizeConfig.widthMultiplier, 
                                                //height: 6* SizeConfig.heightMultiplier,
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),],
                                                          style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            fontFamily: 'Lato',
                                                          ),
                                                          controller:
                                                          unSkilledWorkers,
                                                          cursorColor: Colors.black,
                                                          keyboardType:
                                                          TextInputType.number,
                                                          textInputAction:
                                                          TextInputAction.next,
                                                          focusNode:
                                                          unSkilledWorkersFocus,
                                                          onFieldSubmitted: (term) {
                                                            _fieldFocusChange(
                                                                context,
                                                                unSkilledWorkersFocus,
                                                                commentsFocus);
                                                          },
                                                          maxLength: 3,
                                                          decoration: InputDecoration(
                                                            // labelText: "Enter Email",
                                                            // isDense: true,
                                                            counterText: "",
                                                            border: InputBorder.none,
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
                                              SizedBox(
                                                height:
                                                1.5 * SizeConfig.heightMultiplier,
                                              ),
                                              Text(" Comments",
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
                                              Container(
                                                width:
                                                94 * SizeConfig.widthMultiplier,
                                                height:
                                                10 * SizeConfig.heightMultiplier,
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9/_().,]")),],
                                                          style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            fontFamily: 'Lato',
                                                          ),
                                                          controller: comments,
                                                          cursorColor: Colors.black,
                                                          keyboardType:
                                                          TextInputType.text,
                                                          textInputAction:
                                                          TextInputAction.done,
                                                          focusNode: commentsFocus,
                                                          maxLines: 3,
                                                          onFieldSubmitted: (value) {
                                                            commentsFocus.unfocus();
                                                            //  _calculator();
                                                          },
                                                          decoration: InputDecoration(
                                                            // labelText: "Enter Email",
                                                            // isDense: true,
                                                            border: InputBorder.none,
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

                                                            hintText: "Enter Comments",
                                                            hintStyle: TextStyle(
                                                              color: Colors.grey,
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
                                              SizedBox(
                                                height:
                                                1.5 * SizeConfig.heightMultiplier,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  MaterialButton(
                                                    color: app_color,
                                                    splashColor: Colors.yellow[800],
                                                    minWidth: 28 *
                                                        SizeConfig.widthMultiplier,
                                                    height: 4.7 *
                                                        SizeConfig.heightMultiplier,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(1.8 *
                                                            SizeConfig
                                                                .widthMultiplier)),
                                                    child: Text(isEditManpower?'Update And Continue':'Save And Continue',
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
                                                        final result =await InternetAddress.lookup('google.com');
                                                        if (result.isNotEmpty &&result[0].rawAddress.isNotEmpty) {
                                                          if(selectedManpower != 'Select Manpower'){
                                                            if(selectedContractor != "Select Contractor"){
                                                              if(!skilledWorkers.text.isEmpty){
                                                                if(!unSkilledWorkers.text.isEmpty){
                                                                  addManpower(context);
                                                                }else{
                                                                  showDialog(context: context,builder: (BuildContext
                                                                  context) =>
                                                                      CustomDialog(
                                                                          "NO.of unskilled workers is required"));
                                                                }
                                                              }else{
                                                                showDialog(context: context,builder: (BuildContext
                                                                context) =>
                                                                    CustomDialog(
                                                                        "NO.of skilled workers is required"));
                                                              }}else{
                                                              showDialog(context: context,builder: (BuildContext
                                                              context) =>
                                                                  CustomDialog(
                                                                      "Select Contractor is required"));
                                                            }
                                                          }else{
                                                            showDialog(context: context,builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Select manpower is required"));
                                                          }
                                                        }
                                                      } on SocketException catch (_) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Check Internet connection"));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ):Container(),


                                          Container(
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: manPowerTodayList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return  InkWell(
                                                    onTap: ()async {

                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                            Container(
                                                              width: 65 * SizeConfig.widthMultiplier,
                                                              child: Text(manPowerTodayList[index]['man_power_name'],
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                            approved == 0?Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.delete,
                                                                    color: app_color,
                                                                    size:
                                                                    3.0 * SizeConfig.heightMultiplier,
                                                                  ),
                                                                  onPressed: () {
                                                                    confirmationDialog(context,manPowerTodayList[index]['id'],"",1);
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                    color: app_color,
                                                                    size:
                                                                    3.0 * SizeConfig.heightMultiplier,
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      isEditManpower = true;
                                                                      editManpowerId = "${manPowerTodayList[index]['id']}";
                                                                      selectedManpowerID = manPowerTodayList[index]['manpower_id'];
                                                                      selectedContractorID = manPowerTodayList[index]['contractor_id'];
                                                                      skilledWorkers.text = "${manPowerTodayList[index]['no_of_skilled_workers']}";
                                                                      unSkilledWorkers.text = "${manPowerTodayList[index]['no_of_unskilled_workers']}";
                                                                      comments.text = manPowerTodayList[index]['comments'];
                                                                      selectedManpower = manPowerTodayList[index]['man_power_name'];
                                                                      selectedContractor = manPowerTodayList[index]['contractor_name'];
                                                                      getContractorList(selectedManpowerID);
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ):Container(),
                                                          ],
                                                        ),
                                                        Text(manPowerTodayList[index]['contractor_name'],
                                                            style: DTextStyle.bodyLine),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [

                                                            Expanded(
                                                              child: Text("skilledWorkers",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("UnskilledWorkers",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text("${manPowerTodayList[index]['no_of_skilled_workers']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("${manPowerTodayList[index]['no_of_unskilled_workers']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Text(manPowerTodayList[index]['comments'],
                                                            style: DTextStyle.bodyLine),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [

                                                            Flexible(
                                                              child: Divider(height: 2 * SizeConfig.widthMultiplier,color: Colors.grey),
                                                            ),
                                                            SizedBox(width: 2 * SizeConfig.widthMultiplier,)
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          SizedBox(
                                            height:
                                            1.5 * SizeConfig.heightMultiplier,
                                          ),
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 5 * SizeConfig.heightMultiplier,
                              color: Color(0xFFf5f5f5),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected[0] = false;
                                  selected[1] = true;
                                  selected[2] = false;
                                  selected[3] = false;
                                });

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
                                      Padding(
                                        padding:  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier,right: 3 * SizeConfig.widthMultiplier,),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("RECORD MATERIAL",
                                                style: TextStyle(
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Colors.black,
                                                )),
                                            Icon(
                                              selected[1]
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: app_color,
                                              size: 3.0 * SizeConfig.heightMultiplier,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: selected[1] == false
                                            ? 3 * SizeConfig.heightMultiplier
                                            : 1 * SizeConfig.heightMultiplier,
                                      ),
                                      selected[1]
                                          ? Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          approved == 0?Column(
                                            mainAxisAlignment:MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Text("Select Material",
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
                                              GestureDetector(
                                                onTap: () {
                                                  if(!isEditMaterial){
                                                    selectMaterial(context);
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                    padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(selectedMaterial,
                                                            style: TextStyle(
                                                              fontSize: 1.8 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontFamily: 'Lato',
                                                              color: Colors.black,
                                                            )),
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Unit",
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
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Text(mUnit,
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Opening Balance",
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
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Text(openingBalance,
                                                        style: DTextStyle.bodyLine),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Received Today",
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
                                              Container(
                                                width: 94 *
                                                    SizeConfig.widthMultiplier,
                                               // height: 6 * SizeConfig.heightMultiplier,
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")),],

                                                          onChanged: (value){
                                                            int IT, RT;
                                                            if(!value.isEmpty){
                                                              RT = int.parse(value);
                                                              if(issueToday.text.isEmpty){
                                                                calculateClosingBalance(RT,0,);
                                                                print("receivedToday if :: "+ receivedToday.text);
                                                              }else{
                                                                IT = int.parse(issueToday.text);
                                                                calculateClosingBalance(RT,IT,);
                                                              }
                                                            }else{
                                                              if(issueToday.text.isEmpty){
                                                                calculateClosingBalance(0,0);
                                                                print("receivedToday if :: "+ receivedToday.text);
                                                              }else{
                                                                IT = int.parse(issueToday.text);
                                                                calculateClosingBalance(0,IT,);
                                                              }
                                                            }
                                                          },
                                                          style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            fontFamily: 'Lato',
                                                          ),
                                                          controller:
                                                          receivedToday,
                                                          cursorColor:
                                                          Colors.black,
                                                          keyboardType:
                                                          TextInputType.number,
                                                          textInputAction:
                                                          TextInputAction
                                                              .next,
                                                          focusNode:
                                                          receivedTodayFocus,
                                                          onFieldSubmitted:
                                                              (term) {
                                                            _fieldFocusChange(
                                                                context,
                                                                receivedTodayFocus,
                                                                issueTodayFocus);
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Issue Today",
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
                                              Container(
                                                width: 94 *
                                                    SizeConfig.widthMultiplier,
                                                //height: 6 *  SizeConfig.heightMultiplier,
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
                                                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]")),],
                                                          onChanged: (value){
                                                            int IT, RT;
                                                            if(!value.isEmpty){
                                                              IT = int.parse(value);
                                                              if(receivedToday.text.isEmpty){
                                                                calculateClosingBalance(0,IT);
                                                                print("receivedToday if :: "+ receivedToday.text);
                                                              }else{
                                                                RT = int.parse(receivedToday.text);
                                                                calculateClosingBalance(RT,IT);
                                                              }
                                                            }else{
                                                              if(receivedToday.text.isEmpty){
                                                                calculateClosingBalance(0,0);
                                                              }else{
                                                                RT = int.parse(receivedToday.text);
                                                                calculateClosingBalance(RT,0);
                                                              }
                                                            }

                                                          },
                                                          style: new TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 2 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                            fontFamily: 'Lato',
                                                          ),
                                                          controller: issueToday,
                                                          cursorColor:
                                                          Colors.black,
                                                          keyboardType:
                                                          TextInputType.number,
                                                          textInputAction:
                                                          TextInputAction
                                                              .next,
                                                          focusNode:
                                                          issueTodayFocus,
                                                          onFieldSubmitted:
                                                              (term) {
                                                            _fieldFocusChange(
                                                                context,
                                                                issueTodayFocus,
                                                                mCommentsFocus);
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Closing Today",
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
                                              Container(
                                                width: 94 *
                                                    SizeConfig.widthMultiplier,
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
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Text("$ClosingBalanc",
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.grey,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Comments",
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
                                                          controller: mComments,
                                                          cursorColor:
                                                          Colors.black,
                                                          keyboardType:
                                                          TextInputType.text,
                                                          textInputAction:
                                                          TextInputAction
                                                              .done,
                                                          focusNode:
                                                          mCommentsFocus,
                                                          maxLines: 3,
                                                          onFieldSubmitted:
                                                              (value) {
                                                            mCommentsFocus
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  MaterialButton(
                                                    color: app_color,
                                                    splashColor: Colors.yellow[800],
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
                                                    child: Text(isEditMaterial?'Update And Continue':'Save And Continue',
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
                                                        if (result.isNotEmpty &&
                                                            result[0].rawAddress.isNotEmpty) {
                                                          if(selectedMaterial != "Select Material"){
                                                            if(!receivedToday.text.isEmpty){
                                                              if(!issueToday.text.isEmpty){
                                                                addMaterial(context);
                                                              }else{
                                                                showDialog(context: context,builder: (BuildContext
                                                                context) =>
                                                                    CustomDialog(
                                                                        "Issue today is required"));
                                                              }
                                                            }else{
                                                              showDialog(context: context,builder: (BuildContext
                                                              context) =>
                                                                  CustomDialog(
                                                                      "Received today is required"));
                                                            }}else{
                                                            showDialog(context: context,builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Select Material is required"));
                                                          }
                                                        }
                                                      } on SocketException catch (_) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Check net connection"));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ):Container(),

                                          Container(
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: MaterialTodayList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return  InkWell(
                                                    onTap: ()async {

                                                    },
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [

                                                            Container(
                                                              width: 65 * SizeConfig.widthMultiplier,
                                                              child: Text(MaterialTodayList[index]['material_name'],
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                             approved == 0?
                                                             Row(
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.delete,
                                                                    color: app_color,
                                                                    size:
                                                                    3.0 * SizeConfig.heightMultiplier,
                                                                  ),
                                                                  onPressed: () {
                                                                    confirmationDialog(context,MaterialTodayList[index]['id'],"",2);
                                                                  },
                                                                ),
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                    color: app_color,
                                                                    size:
                                                                    3.0 * SizeConfig.heightMultiplier,
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      isEditMaterial = true;
                                                                      editMaterialId = "${MaterialTodayList[index]['id']}";
                                                                      selectedMaterial = MaterialTodayList[index]['material_name'];
                                                                      selectedMaterialID = MaterialTodayList[index]['material_id'];
                                                                      mUnit = MaterialTodayList[index]['unit'];
                                                                      openingBalance = "${MaterialTodayList[index]['opening_balance']}";
                                                                      ClosingBalanc = MaterialTodayList[index]['closing_today'];
                                                                      receivedToday.text = "${MaterialTodayList[index]['receive_today']}";
                                                                      issueToday.text = "${MaterialTodayList[index]['issue_today']}";
                                                                      mComments.text = MaterialTodayList[index]['comments'];
                                                                      receivedTodayFocus.requestFocus();
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ):Container(),
                                                          ],
                                                        ),
                                                        Text("Unit : "+MaterialTodayList[index]['unit'],
                                                            style: DTextStyle.bodyLine),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [

                                                            Expanded(
                                                              child: Text("Receive Today",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("Issue Today",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text("${MaterialTodayList[index]['receive_today']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("${MaterialTodayList[index]['issue_today']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [

                                                            Expanded(
                                                              child: Text("Opening Balance",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("Closing Today",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text("${MaterialTodayList[index]['opening_balance']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                            Expanded(
                                                              child: Text("${MaterialTodayList[index]['closing_today']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Text(MaterialTodayList[index]['comments'],
                                                            style: DTextStyle.bodyLine),
                                                        Row(
                                                          children: [

                                                            Flexible(
                                                              child: Divider(height: 2 * SizeConfig.widthMultiplier,color: Colors.grey),
                                                            ),
                                                            SizedBox(width: 2 * SizeConfig.widthMultiplier,)
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          SizedBox(
                                            height:
                                            0.8 * SizeConfig.heightMultiplier,
                                          ),
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 5 * SizeConfig.heightMultiplier,
                              color: Color(0xFFf5f5f5),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected[0] = false;
                                  selected[1] = false;
                                  selected[2] = true;
                                  selected[3] = false;
                                });
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
                                      Padding(
                                        padding:  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier,right: 3 * SizeConfig.widthMultiplier,),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("RECORD ACTIVITY",
                                                style: TextStyle(
                                                  fontSize: 2 * SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Colors.black,
                                                )),
                                            Icon(
                                              selected[2]
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: app_color,
                                              size: 3.0 * SizeConfig.heightMultiplier,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: selected[2] == false
                                            ? 3 * SizeConfig.heightMultiplier
                                            : 1 * SizeConfig.heightMultiplier,
                                      ),
                                      selected[2]
                                          ? Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          approved == 0?Column(
                                            mainAxisAlignment:MainAxisAlignment.start,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: [
                                              Text("Select Activity",
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
                                              GestureDetector(
                                                onTap: () {

                                                  if(!isEditActivity){
                                                    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  ActivitySelection(
                                                      activityList: activityList,
                                                      onSelected: (actNam, actID) {
                                                        print("selectedActivity : $actNam");
                                                        print("selectedActivityID : $actID");
                                                        setState(() {
                                                          selectedactivity = actNam;
                                                          selectedActivityID = actID;
                                                          selectedSubactivity= "Select Subactivity";
                                                          getSubactivityList(context, selectedActivityID);
                                                        });
                                                      },
                                                    ));
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => CustomDialog("You can edit only"));
                                                  }
                                                },
                                                child: Container(
                                                  width: 94 *
                                                      SizeConfig.widthMultiplier,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(selectedactivity,
                                                            style: TextStyle(
                                                              fontSize: 1.8 *
                                                                  SizeConfig
                                                                      .textMultiplier,
                                                              fontFamily: 'Lato',
                                                              color: Colors.black,
                                                            )),
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Select Sub activity",
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
                                              GestureDetector(
                                                onTap: () {
                                                  if(!isEditActivity){
                                                    if(subActivityList.length >=1){
                                                      showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  SubActivitySelection(
                                                        subActivityList: subActivityList,
                                                        onSelected: (actNam, actID,reportingUnitID) {
                                                          print("selectedActivity : $actNam");
                                                          print("selectedActivityID : $actID");
                                                          setState(() {
                                                            selectedSubactivity= actNam;
                                                            selectedSubactivityID = actID;
                                                            selectedFloors = "Select Floor";
                                                            selectedFlat = "Select Flat";
                                                          });
                                                          getReportingUnit(context,reportingUnitID);
                                                        },
                                                      ));
                                                    }else{
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) =>
                                                              CustomDialog(
                                                                  "There is no any Sub Activity found.\nPlease select Activity first.OR \nYou can contact to KP admin"));
                                                    }
                                                  }else{
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) => CustomDialog("You can edit only"));
                                                  }

                                                },
                                                child: Container(
                                                  width: 94 *
                                                      SizeConfig.widthMultiplier,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Container(

                                                          width: 77 * SizeConfig.widthMultiplier,
                                                          child: Text(selectedSubactivity,
                                                              style: TextStyle(
                                                                fontSize: 1.8 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontFamily: 'Lato',
                                                                color: Colors.black,
                                                              )),
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
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Reporting Unit",
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
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 2 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Text(reportingUnit,
                                                        style: TextStyle(
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontFamily: 'Lato',
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              reportingUnit == "COLUMN"?Column(children: [
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
                                                            SizedBox(
                                                              height: 0.5 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if(!isEditActivity){
                                                                  selectFloor(context,1);
                                                                }else{
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                                if(!isEditActivity){
                                                                  if(columnsList.length >= 1){
                                                                    selectColumns(context);
                                                                  }else{
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) => CustomDialog("Column List Not avalible"));
                                                                  }

                                                                }else{
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemCount: columnsMap.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      _controllers.add(new TextEditingController());
                                                      _focusNode.add(new FocusNode());
                                                      return Row(
                                                        children: [
                                                          Container(
                                                            width: 15 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            child: Text(columnsMap[index]['column_name'],
                                                                style: TextStyle(
                                                                  fontSize: 1.8 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily:
                                                                  'Lato',
                                                                  color:
                                                                  Colors.black,
                                                                )),
                                                          ),
                                                          Container(
                                                              width: 30 *
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
                                                                      "Previous Progress",
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
                                                                    // width: 45 * SizeConfig.widthMultiplier,
                                                                    height: 6 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                        2 *
                                                                            SizeConfig
                                                                                .imageSizeMultiplier,
                                                                      )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                        color:
                                                                        Colors.grey,
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
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Text("${columnsMap[index]['existing_total']}",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                              Text("%",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                            ],
                                                                          )),
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
                                                              width: 40 *
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
                                                                  Text("Today's Progress",
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
                                                                    // width: 45 * SizeConfig.widthMultiplier,
                                                                   // height: 6 * SizeConfig.heightMultiplier,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                        2 *
                                                                            SizeConfig
                                                                                .imageSizeMultiplier,
                                                                      )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                        color:todayProgressValidation[index] ?Colors.red:Colors.grey,
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
                                                                          child: Row(
                                                                            children: [
                                                                              Container(
                                                                                width: 30 *
                                                                                    SizeConfig
                                                                                        .widthMultiplier,
                                                                                child:
                                                                                TextFormField(
                                                                                  style:
                                                                                  new TextStyle(
                                                                                    color:todayProgressValidation[index] ?Colors.red:Colors.black,
                                                                                    fontSize:
                                                                                    2 * SizeConfig.heightMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                  ),
                                                                                  onChanged: (value){
                                                                                    if(value.isEmpty && _controllers[index].text.isEmpty){
                                                                                      setState(() {
                                                                                        todayProgressValidation[index] = true;
                                                                                      });
                                                                                    }else{
                                                                                      print(" existing_total : ${columnsMap[index]['existing_total']}");
                                                                                      int existing_total = columnsMap[index]['existing_total'];
                                                                                      int todayProgress = int.parse(value);
                                                                                      setState(() {
                                                                                        if((existing_total + todayProgress) >100){
                                                                                          todayProgressValidation[index] = true;
                                                                                        }else{
                                                                                          todayProgressValidation[index] = false;
                                                                                        }
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  maxLength: 3,
                                                                                  controller:_controllers[index],
                                                                                  cursorColor:
                                                                                  Colors.black,
                                                                                  keyboardType:
                                                                                  TextInputType.number,
                                                                                  textInputAction:TextInputAction.next,
                                                                                  focusNode:_focusNode[index],

                                                                                  onFieldSubmitted:
                                                                                      (term) {
                                                                                    _fieldFocusChange(
                                                                                        context,
                                                                                        _focusNode[index],
                                                                                        _focusNode[index+1]);
                                                                                  },
                                                                                  decoration:
                                                                                  InputDecoration(
                                                                                    // labelText: "Enter Email",
                                                                                    // isDense: true,
                                                                                    counterText: "",
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
                                                                                    contentPadding: new EdgeInsets.symmetric(
                                                                                        vertical: 1 * SizeConfig.widthMultiplier,
                                                                                        horizontal: 1 * SizeConfig.widthMultiplier),

                                                                                    hintText:
                                                                                    "",
                                                                                    hintStyle:
                                                                                    TextStyle(
                                                                                      color:
                                                                                      Colors.white,
                                                                                      fontSize:
                                                                                      2 * SizeConfig.textMultiplier,
                                                                                      fontFamily:
                                                                                      'Lato',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text("%",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                            ],
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      );
                                                    }),
                                              ])
                                              :reportingUnit == "FLOOR"?Column(
                                                children: [
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
                                                          SizedBox(
                                                            height: 0.5 *
                                                                SizeConfig
                                                                    .heightMultiplier,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {

                                                              if(!isEditActivity){
                                                                selectFloor(context,2);
                                                              }else{
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                  SizedBox(height: 1 *SizeConfig.heightMultiplier,),
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
                                                                  "Previous Progress",
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
                                                                // width: 45 * SizeConfig.widthMultiplier,
                                                                height: 6 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                    2 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                  )),
                                                                  // color: Color(0xFFba3d41),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                    color:
                                                                    Colors.grey,
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
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                        children: [
                                                                          Text("$floorPreProg",
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                1.8 * SizeConfig.textMultiplier,
                                                                                fontFamily:
                                                                                'Lato',
                                                                                color:
                                                                                Colors.black,
                                                                              )),
                                                                          Text("%",
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                1.8 * SizeConfig.textMultiplier,
                                                                                fontFamily:
                                                                                'Lato',
                                                                                color:
                                                                                Colors.black,
                                                                              )),
                                                                        ],
                                                                      )),
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
                                                              Text(
                                                                  "Today's Progress",
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
                                                                // width: 45 * SizeConfig.widthMultiplier,
                                                              //  height: 6 *SizeConfig.heightMultiplier,
                                                                decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                      .circular(
                                                                    2 *
                                                                        SizeConfig
                                                                            .imageSizeMultiplier,
                                                                  )),
                                                                  // color: Color(0xFFba3d41),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                    color:isProgress?Colors.red:Colors.grey,
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
                                                                      child: Row(
                                                                        children: [
                                                                          Container(
                                                                            width: 30 *
                                                                                SizeConfig
                                                                                    .widthMultiplier,
                                                                            child:
                                                                            TextFormField(
                                                                              style:
                                                                              new TextStyle(
                                                                                color:Colors.black,
                                                                                fontSize:
                                                                                2 * SizeConfig.heightMultiplier,
                                                                                fontFamily:
                                                                                'Lato',
                                                                              ),
                                                                              onChanged: (value){
                                                                                if(value.isEmpty){
                                                                                  isProgress = false;
                                                                                }else{
                                                                                  int existing_total = int.parse(floorPreProg);
                                                                                  int todayProgress = int.parse(value);
                                                                                  setState(() {
                                                                                    if((existing_total + todayProgress) >100){
                                                                                      isProgress = true;
                                                                                    }else{
                                                                                      isProgress = false;
                                                                                    }
                                                                                  });
                                                                                }
                                                                              },
                                                                              maxLength: 3,
                                                                              controller:aProgress,
                                                                              cursorColor:isProgress?Colors.red:Colors.black,
                                                                              keyboardType:
                                                                              TextInputType.number,
                                                                              textInputAction:
                                                                              TextInputAction.next,
                                                                              focusNode:aProgressFocus,

                                                                              onFieldSubmitted:
                                                                                  (term) {
                                                                                _fieldFocusChange(
                                                                                    context,
                                                                                    aProgressFocus,
                                                                                    aCommentsFocus);
                                                                              },
                                                                              decoration:
                                                                              InputDecoration(
                                                                                // labelText: "Enter Email",
                                                                                // isDense: true,
                                                                                counterText: "",
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
                                                                                contentPadding: new EdgeInsets.symmetric(
                                                                                    vertical: 1 * SizeConfig.widthMultiplier,
                                                                                    horizontal: 1 * SizeConfig.widthMultiplier),

                                                                                hintText:
                                                                                "",
                                                                                hintStyle:
                                                                                TextStyle(
                                                                                  color:
                                                                                  Colors.white,
                                                                                  fontSize:
                                                                                  2 * SizeConfig.textMultiplier,
                                                                                  fontFamily:
                                                                                  'Lato',
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text("%",
                                                                              style:
                                                                              TextStyle(
                                                                                fontSize:
                                                                                1.8 * SizeConfig.textMultiplier,
                                                                                fontFamily:
                                                                                'Lato',
                                                                                color:
                                                                                Colors.black,
                                                                              )),
                                                                        ],
                                                                      )),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              )
                                              : reportingUnit == "FLAT"?Column(children: [
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
                                                            SizedBox(
                                                              height: 0.5 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                if(!isEditActivity){
                                                                  selectFloor(context,1);
                                                                }else{
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                                if(!isEditActivity){
                                                                  if(selectedfloorsID != 0){
                                                                  selectFlat(context);
                                                          /*          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) =>  FlatSelection(
                                                                      flatList: flatList,
                                                                      isFlatList: isFlatList,
                                                                      selectedfloorsID:selectedfloorsID,
                                                                      onCountSelected: () {
                                                                        print("Count was selected.");
                                                                      },
                                                                      onCountChanged: (List val,List<bool> Validation ) {
                                                                        print("val : $val");
                                                                         setState(() {
                                                                           selectedFlat = "";
                                                                           // _controllers.clear();
                                                                           todayProgressValidation.clear();
                                                                           _focusNode.clear();
                                                                            _controllers.clear();
                                                                             columnsMap.clear();
                                                                           columnsMap = val;
                                                                           todayProgressValidation = Validation;
                                                                         });
                                                                      },
                                                                    ));*/

                                                                  }else{
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) => CustomDialog("Please select Floor first"));
                                                                  }
                                                                }else{
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                ListView.builder(
                                                    scrollDirection: Axis.vertical,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemCount: columnsMap.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Row(
                                                        children: [
                                                          Container(
                                                            width: 15 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            child: Text(columnsMap[index]['flat_name'],
                                                                style: TextStyle(
                                                                  fontSize: 1.8 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  fontFamily:
                                                                  'Lato',
                                                                  color:
                                                                  Colors.black,
                                                                )),
                                                          ),
                                                          Container(
                                                              width: 30 *
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
                                                                      "Previous Progress",
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
                                                                    // width: 45 * SizeConfig.widthMultiplier,
                                                                    height: 6 *
                                                                        SizeConfig
                                                                            .heightMultiplier,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                        2 *
                                                                            SizeConfig
                                                                                .imageSizeMultiplier,
                                                                      )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                        color:
                                                                        Colors.grey,
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
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Text("${columnsMap[index]['existing_total']}",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                              Text("%",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                            ],
                                                                          )),
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
                                                              width: 40 *
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
                                                                  Text("Today's Progress",
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
                                                                    // width: 45 * SizeConfig.widthMultiplier,
                                                                  //  height: 6 * SizeConfig .heightMultiplier,
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .all(Radius
                                                                          .circular(
                                                                        2 *
                                                                            SizeConfig
                                                                                .imageSizeMultiplier,
                                                                      )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                        color:todayProgressValidation[index] ?Colors.red:Colors.grey,
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
                                                                          child: Row(
                                                                            children: [
                                                                              Container(
                                                                                width: 30 *
                                                                                    SizeConfig
                                                                                        .widthMultiplier,
                                                                                child:
                                                                                TextFormField(
                                                                                  style:
                                                                                  new TextStyle(
                                                                                    color:todayProgressValidation[index] ?Colors.red:Colors.black,
                                                                                    fontSize:
                                                                                    2 * SizeConfig.heightMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                  ),
                                                                                  onChanged: (value){
                                                                                    print(" _controllers length : ${_controllers.length}");
                                                                                    if(value.isEmpty && _controllers[index].text.isEmpty){
                                                                                      print(" existing_total : IF");
                                                                                      setState(() {
                                                                                        todayProgressValidation[index] = true;
                                                                                      });
                                                                                    }else{
                                                                                    //  print(" existing_total : Else");
                                                                                  //    print(" todayProgressValidation : ${todayProgressValidation[index]}");
                                                                                  //    print(" existing_total : ${columnsMap[index]['existing_total']}");
                                                                                      int existing_total = columnsMap[index]['existing_total'];
                                                                                      // int existing_total = 10;
                                                                                      int todayProgress = int.parse(value);
                                                                                      setState(() {
                                                                                        if((existing_total + todayProgress) > 100){
                                                                                          print(" total if : ${existing_total + todayProgress}  $index");
                                                                                          todayProgressValidation[index] = true;
                                                                                        }else{
                                                                                          print(" total else : ${existing_total + todayProgress}");
                                                                                          todayProgressValidation[index] = false;
                                                                                        }
                                                                                      });

                                                                                    }
                                                                                  },
                                                                                  maxLength: 3,
                                                                                  controller:_controllers[index],
                                                                                  cursorColor:
                                                                                  Colors.black,
                                                                                  keyboardType:
                                                                                  TextInputType.number,
                                                                                  textInputAction:
                                                                                  TextInputAction.next,
                                                                                  focusNode:_focusNode[index],

                                                                                  onFieldSubmitted:
                                                                                      (term) {
                                                                                    _fieldFocusChange(
                                                                                        context,
                                                                                        _focusNode[index],
                                                                                        _focusNode[index+1]);
                                                                                  },
                                                                                  decoration:
                                                                                  InputDecoration(
                                                                                    // labelText: "Enter Email",
                                                                                    // isDense: true,
                                                                                    counterText: "",
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
                                                                                    contentPadding: new EdgeInsets.symmetric(
                                                                                        vertical: 1 * SizeConfig.widthMultiplier,
                                                                                        horizontal: 1 * SizeConfig.widthMultiplier),

                                                                                    hintText:
                                                                                    "",
                                                                                    hintStyle:
                                                                                    TextStyle(
                                                                                      color:
                                                                                      Colors.white,
                                                                                      fontSize:
                                                                                      2 * SizeConfig.textMultiplier,
                                                                                      fontFamily:
                                                                                      'Lato',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text("%",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontSize:
                                                                                    1.8 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                    color:
                                                                                    Colors.black,
                                                                                  )),
                                                                            ],
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      );
                                                    }),
                                              ])
                                              :reportingUnit == "FOOTING"?Column(
                                                children: [
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
                                                              "Select Footing",
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
                                                              var sta = false;
                                                              if(!isEditActivity){
                                                                for(int i = 0; i<footingsList.length; i++){
                                                                  if(footingsList[i]['progress'] == 0){
                                                                    setState(() {
                                                                      sta = true;
                                                                    });
                                                                    break;
                                                                  }
                                                                }

                                                                if(sta){
                                                                  selectFooting(context);
                                                                }else{
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context) => CustomDialog("$selectedSubactivity All footing completed 100%"));
                                                                }

                                                              }else{
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) => CustomDialog("You can edit only"));
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
                                                          SizedBox(
                                                            height: 1 * SizeConfig.heightMultiplier,),
                                                          Text(
                                                              "Today's Progress",
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
                                                              padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 80 *
                                                                        SizeConfig.widthMultiplier,
                                                                    child: Text("100  %",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                          fontSize: 1.8 *
                                                                              SizeConfig
                                                                                  .textMultiplier,
                                                                          fontFamily: 'Lato',
                                                                          color: Colors.black,
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                                ],
                                              )
                                              :reportingUnit == "OTHER"?Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
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
                                                                Text("Other Unit",
                                                                    style: TextStyle(
                                                                      fontSize: 1.8 *
                                                                          SizeConfig
                                                                              .textMultiplier,
                                                                      fontFamily:
                                                                      'Lato',
                                                                      color:
                                                                      Colors.black,
                                                                    )),
                                                                SizedBox(height: 0.5 *SizeConfig.heightMultiplier,
                                                                ),
                                                                Container(
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
                                                                    padding: EdgeInsets.all(3.5 * SizeConfig.widthMultiplier),
                                                                    child: Container(
                                                                      width: 32 *
                                                                          SizeConfig.widthMultiplier,
                                                                      child: Text(otherUnit,
                                                                          maxLines: 2,
                                                                          style: TextStyle(
                                                                            fontSize: 1.8 *
                                                                                SizeConfig
                                                                                    .textMultiplier,
                                                                            fontFamily: 'Lato',
                                                                            color: Colors.black,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(height: 1 *SizeConfig.heightMultiplier,),
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
                                                                    "Out Of/Progress",
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
                                                                  // width: 45 * SizeConfig.widthMultiplier,
                                                                  height: 6 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .all(Radius
                                                                        .circular(
                                                                      2 *
                                                                          SizeConfig
                                                                              .imageSizeMultiplier,
                                                                    )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    border: Border.all(
                                                                      color:
                                                                      Colors.grey,
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
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                          children: [
                                                                            Text("$otherQty",
                                                                                style:
                                                                                TextStyle(
                                                                                  fontSize:
                                                                                  1.8 * SizeConfig.textMultiplier,
                                                                                  fontFamily:
                                                                                  'Lato',
                                                                                  color:
                                                                                  Colors.black,
                                                                                )),
                                                                            Text("$Progress %",
                                                                                style:
                                                                                TextStyle(
                                                                                  fontSize:
                                                                                  1.8 * SizeConfig.textMultiplier,
                                                                                  fontFamily:
                                                                                  'Lato',
                                                                                  color:
                                                                                  Colors.black,
                                                                                )),
                                                                          ],
                                                                        )),
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
                                                                Text("Today's Progress",
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
                                                                  // width: 45 * SizeConfig.widthMultiplier,
                                                                //    height: 6 * SizeConfig.heightMultiplier,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .all(Radius
                                                                        .circular(
                                                                      2 *
                                                                          SizeConfig
                                                                              .imageSizeMultiplier,
                                                                    )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    border: Border.all(
                                                                      color:Colors.grey,
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
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 30 *
                                                                                  SizeConfig
                                                                                      .widthMultiplier,
                                                                              child:
                                                                              TextFormField(
                                                                                style:
                                                                                new TextStyle(
                                                                                  color:Colors.black,
                                                                                  fontSize:
                                                                                  2 * SizeConfig.heightMultiplier,
                                                                                  fontFamily:
                                                                                  'Lato',
                                                                                ),
                                                                                onChanged: (value){

                                                                                },
                                                                                maxLength: 3,
                                                                                controller:aProgress,
                                                                                cursorColor:
                                                                                Colors.black,
                                                                                keyboardType:
                                                                                TextInputType.number,
                                                                                textInputAction:
                                                                                TextInputAction.next,
                                                                                focusNode:aProgressFocus,

                                                                                onFieldSubmitted:
                                                                                    (term) {
                                                                                  _fieldFocusChange(
                                                                                      context,
                                                                                      aProgressFocus,
                                                                                      aCommentsFocus);
                                                                                },
                                                                                decoration:
                                                                                InputDecoration(
                                                                                  // labelText: "Enter Email",
                                                                                  // isDense: true,
                                                                                  counterText: "",
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
                                                                                  contentPadding: new EdgeInsets.symmetric(
                                                                                      vertical: 1 * SizeConfig.widthMultiplier,
                                                                                      horizontal: 1 * SizeConfig.widthMultiplier),

                                                                                  hintText:
                                                                                  "",
                                                                                  hintStyle:
                                                                                  TextStyle(
                                                                                    color:
                                                                                    Colors.white,
                                                                                    fontSize:
                                                                                    2 * SizeConfig.textMultiplier,
                                                                                    fontFamily:
                                                                                    'Lato',
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Text("%",
                                                                                style:
                                                                                TextStyle(
                                                                                  fontSize:
                                                                                  1.8 * SizeConfig.textMultiplier,
                                                                                  fontFamily:
                                                                                  'Lato',
                                                                                  color:
                                                                                  Colors.black,
                                                                                )),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  ])
                                              :Container(),
                                              SizedBox(
                                                height: 1.5 *
                                                    SizeConfig.heightMultiplier,
                                              ),
                                              Text("Comments",
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
                                                          controller: aComments,
                                                          cursorColor:
                                                          Colors.black,
                                                          keyboardType:
                                                          TextInputType.text,
                                                          textInputAction:
                                                          TextInputAction
                                                              .done,
                                                          focusNode:
                                                          aCommentsFocus,
                                                          maxLines: 3,
                                                          onFieldSubmitted:
                                                              (value) {
                                                            aCommentsFocus
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
                                              SizedBox(height: 1 *SizeConfig.heightMultiplier),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  MaterialButton(
                                                    color: app_color,
                                                    splashColor: Colors.yellow[800],
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
                                                    child: Text(isEditActivity?'Update And Continue':'Save And Continue',
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
                                                        await InternetAddress
                                                            .lookup(
                                                            'google.com');
                                                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                          if(selectedactivity != "Select Activity"){
                                                            if(selectedSubactivity != "Select Subactivity"){
                                                              if(!aComments.text.isEmpty){
                                                                if(reportingUnit == "COLUMN"){
                                                                  if(selectedFloors != "Select Floor"){
                                                                    if(selectedColumns != "Select Columns"){
                                                                      bool isTrue = false;
                                                                      print("todayProgressValidation : $todayProgressValidation");
                                                                      for (int i = 0; i<todayProgressValidation.length; i++) {
                                                                        if(todayProgressValidation[i]){
                                                                          isTrue = true;

                                                                          break;
                                                                        }else{
                                                                          isTrue = false;
                                                                        }
                                                                      }

                                                                      print("isTrue : $isTrue");
                                                                      if(!isTrue){
                                                                        columnsMap1.clear();

                                                                        for(int i = 0; i<columnsMap.length; i++){
                                                                          Map map = {
                                                                            "column_name": columnsMap[i]['column_name'],
                                                                            "column_id": "${columnsMap[i]['column_id']}",
                                                                            "existing_total": "${columnsMap[i]['existing_total']}",
                                                                            "new_progress":"${ _controllers[i].text}",
                                                                            "floor_id":"$selectedfloorsID",
                                                                          };
                                                                          columnsMap1.add(map);
                                                                        }
                                                                        addActivity(context);
                                                                      }else{
                                                                        showDialog(context: context,builder: (BuildContext
                                                                        context) =>
                                                                            CustomDialog("Today progress is required"));
                                                                      }
                                                                    }else{
                                                                      showDialog(context: context,builder: (BuildContext
                                                                      context) =>
                                                                          CustomDialog("Select Columns is required"));
                                                                    }
                                                                  }else{
                                                                    showDialog(context: context,builder: (BuildContext
                                                                    context) =>
                                                                        CustomDialog("Select Floor is required"));
                                                                  }
                                                                }else if(reportingUnit == "FLOOR"){
                                                                  if(selectedFloors != "Select Floor"){
                                                                    if(!isProgress){
                                                                      addActivity(context);
                                                                    }else{
                                                                      showDialog(context: context,builder: (BuildContext
                                                                      context) =>
                                                                          CustomDialog("Today progress is required"));
                                                                    }
                                                                  }else{
                                                                    showDialog(context: context,builder: (BuildContext
                                                                    context) =>
                                                                        CustomDialog("Select Floor is required"));
                                                                  }
                                                                }else if(reportingUnit == "FLAT"){
                                                                  if(selectedFloors != "Select Floor"){
                                                                    if(selectedFlat != "Select Flat"){
                                                                      bool isTrue = false;
                                                                      print("todayProgressValidation : $todayProgressValidation");
                                                                      for (int i = 0; i<todayProgressValidation.length; i++) {
                                                                        if(todayProgressValidation[i]){
                                                                          isTrue = true;

                                                                          break;
                                                                        }else{
                                                                          isTrue = false;
                                                                        }
                                                                      }

                                                                      print("isTrue : $isTrue");
                                                                      if(!isTrue){
                                                                        columnsMap1.clear();

                                                                        for(int i = 0; i<columnsMap.length; i++){
                                                                          print("flat_id  === : ${columnsMap[i]['flat_id']}");
                                                                          Map map = {
                                                                            "flat_name": columnsMap[i]['flat_name'],
                                                                            "flat_id": "${columnsMap[i]['flat_id']}",
                                                                            "new_progress":"${ _controllers[i].text}",
                                                                            "floor_id":"$selectedfloorsID",
                                                                          };
                                                                          columnsMap1.add(map);
                                                                        }
                                                                        addActivity(context);
                                                                      }else{
                                                                        showDialog(context: context,builder: (BuildContext
                                                                        context) =>
                                                                            CustomDialog("Today progress is required"));
                                                                      }
                                                                    }else{
                                                                      showDialog(context: context,builder: (BuildContext
                                                                      context) =>
                                                                          CustomDialog("Select Columns is required"));
                                                                    }
                                                                  }else{
                                                                    showDialog(context: context,builder: (BuildContext
                                                                    context) =>
                                                                        CustomDialog("Select Floor is required"));
                                                                  }
                                                                }else if(reportingUnit == "FOOTING"){
                                                                  if(selectedFooting != "Select Footing"){
                                                                    aProgress.text = "100";
                                                                    addActivity(context);
                                                                    getFootings(context,selectedSubactivityID);
                                                                  }else{
                                                                    showDialog(context: context,builder: (BuildContext
                                                                    context) =>
                                                                        CustomDialog("Select Footing is required"));
                                                                  }
                                                                }else if(reportingUnit == "OTHER"){
                                                                  if(!aProgress.text.isEmpty){
                                                                    addActivity(context);
                                                                  }else{
                                                                    showDialog(context: context,builder: (BuildContext
                                                                    context) =>
                                                                        CustomDialog("Today progress is required"));
                                                                  }
                                                                }
                                                              }else{
                                                                showDialog(context: context,builder: (BuildContext
                                                                context) =>
                                                                    CustomDialog(
                                                                        "Comments is required"));
                                                              }
                                                            }else{
                                                              showDialog(context: context,builder: (BuildContext
                                                              context) =>
                                                                  CustomDialog(
                                                                      "Select sub activity is required"));
                                                            }}else{
                                                            showDialog(context: context,builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Select activity is required"));
                                                          }
                                                        }
                                                      } on SocketException catch (_) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                            context) =>
                                                                CustomDialog(
                                                                    "Check Internet connection"));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 1 *SizeConfig.heightMultiplier),
                                            ],
                                          ):Container(),

                                          Container(
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: ActivityTodayList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [

                                                          Container(
                                                            width: 65 * SizeConfig.widthMultiplier,
                                                            child: Text(ActivityTodayList[index]['activity_name'],
                                                                style: DTextStyle.bodyLineBold),
                                                          ),
                                                          approved == 0?Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: app_color,
                                                                  size:
                                                                  3.0 * SizeConfig.heightMultiplier,
                                                                ),
                                                                onPressed: () {
                                                               // getDelet(context,ActivityTodayList[index]['id'],ActivityTodayList[index]['reporting_unit']);
                                                               confirmationDialog(context,ActivityTodayList[index]['id'],ActivityTodayList[index]['reporting_unit'],3);
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  color: app_color,
                                                                  size:
                                                                  3.0 * SizeConfig.heightMultiplier,
                                                                ),
                                                                onPressed: () {
                                                                  aCommentsFocus.requestFocus();
                                                                  setState(() {
                                                                    isEditActivity = true;
                                                                    actID = "${ActivityTodayList[index]['id']}";
                                                                    //  aCommentsFocus =
                                                                    selectedactivity = ActivityTodayList[index]['activity_name'];
                                                                    selectedActivityID = "${ ActivityTodayList[index]['activity_id']}";
                                                                    selectedSubactivity = ActivityTodayList[index]['sub_activity_name'];
                                                                    selectedSubactivityID = "${ActivityTodayList[index]['sub_activity_id']}";
                                                                    getSubactivityList(context, selectedActivityID);
                                                                    aComments.text = ActivityTodayList [index]['comments'];

                                                                    if(ActivityTodayList[index]['reporting_unit'] == "COLUMN"){
                                                                      reportingUnit = "COLUMN";
                                                                      selectedFloors = ActivityTodayList[index]['get_app_activity_columns'][0]['floor_name'];
                                                                      selectedfloorsID =ActivityTodayList[index]['get_app_activity_columns'][0]['floor_id'];

                                                                      selectedColumns = "";
                                                                      // _controllers.clear();
                                                                      todayProgressValidation.clear();
                                                                      _controllers.clear();
                                                                      columnsMap.clear();
                                                                      _controllers = List.generate(ActivityTodayList[index]['get_app_activity_columns'].length, (i) => TextEditingController());
                                                                      for(int i = 0; i<ActivityTodayList[index]['get_app_activity_columns'].length; i++){
                                                                        /*   if(isColumnsList[i]){
                                                                                setState(() {
                                                                                  todayProgressValidation.add(true);
                                                                                  selectedColumns = selectedColumns + columnsList[i]['column_name'];

                                                                                });*/
                                                                        _focusNode.add(new FocusNode());
                                                                        todayProgressValidation.add(false);
                                                                        _controllers[i].text = "${ActivityTodayList[index]['get_app_activity_columns'][i]['column_progress']}";
                                                                        selectedColumns =  selectedColumns  + ActivityTodayList[index]['get_app_activity_columns'][i]['column_name'];

                                                                        print("progress ===== > ${ActivityTodayList[index]['get_app_activity_columns'][i]['progress']}");
                                                                        print("column_progress ===== > ${ ActivityTodayList[index]['get_app_activity_columns'][i]['column_progress']}");

                                                                        Map map = {
                                                                          "column_name": ActivityTodayList[index]['get_app_activity_columns'][i]['column_name'],
                                                                          "column_id": ActivityTodayList[index]['get_app_activity_columns'][i]['id'],
                                                                          "existing_total": (ActivityTodayList[index]['get_app_activity_columns'][i]['progress'] - ActivityTodayList[index]['get_app_activity_columns'][i]['column_progress']),
                                                                          "new_progress":ActivityTodayList[index]['get_app_activity_columns'][i]['column_progress']
                                                                        };
                                                                        columnsMap.add(map);

                                                                        print("columnsMap ===== > ${columnsMap.length}");
                                                                      }
                                                                    }else  if(ActivityTodayList[index]['reporting_unit'] == "FLOOR"){
                                                                      reportingUnit = "FLOOR";
                                                                      isProgress = false;
                                                                      selectedFloors = ActivityTodayList[index]['get_app_activity_floors'][0]['floor_name'];
                                                                      selectedfloorsID =ActivityTodayList[index]['get_app_activity_floors'][0]['id'];
                                                                      floorPreProg = "${ActivityTodayList[index]['get_app_activity_floors'][0]['progress'] - ActivityTodayList[index]['get_app_activity_floors'][0]['floor_progress']}";
                                                                      aProgress.text = "${ActivityTodayList[index]['get_app_activity_floors'][0]['floor_progress']}";
                                                                      // getFloorProgress(context,selectedfloorsID);
                                                                    } else if(ActivityTodayList[index]['reporting_unit'] == "FLAT"){
                                                                      reportingUnit = "FLAT";
                                                                      selectedFloors = ActivityTodayList[index]['get_app_activity_flats'][0]['floor_name'];
                                                                      selectedfloorsID =ActivityTodayList[index]['get_app_activity_flats'][0]['floor_id'];

                                                                      selectedFlat = "";
                                                                      // _controllers.clear();
                                                                      todayProgressValidation.clear();
                                                                      _controllers.clear();
                                                                      columnsMap.clear();
                                                                      _controllers = List.generate(ActivityTodayList[index]['get_app_activity_flats'].length, (i) => TextEditingController());
                                                                      for(int i = 0; i<ActivityTodayList[index]['get_app_activity_flats'].length; i++){

                                                                        print("ActivityTodayList  :  $i");
                                                                        print("${ActivityTodayList[index]['get_app_activity_flats'].length}  :  $i");
                                                                        todayProgressValidation.add(false);
                                                                        selectedFlat = selectedFlat + flatList[i]['flat_name'];
                                                                        _focusNode.add(new FocusNode());

                                                                        _controllers[i].text = "${ActivityTodayList[index]['get_app_activity_flats'][i]['flat_progress']}";

                                                                        Map map = {
                                                                          "flat_id": "${ActivityTodayList[index]['get_app_activity_flats'][i]['id']}",
                                                                          "flat_name": ActivityTodayList[index]['get_app_activity_flats'][i]['flat_name'],
                                                                          "existing_total": (ActivityTodayList[index]['get_app_activity_flats'][i]['progress'] - ActivityTodayList[index]['get_app_activity_flats'][i]['flat_progress']),
                                                                        };

                                                                        columnsMap.add(map);
                                                                      }
                                                                    }else if(ActivityTodayList[index]['reporting_unit'] == "FOOTING"){
                                                                      reportingUnit = "FOOTING";

                                                                      selectedFooting = "";
                                                                      // _controllers.clear();
                                                                      todayProgressValidation.clear();
                                                                      columnsMap.clear();
                                                                      _controllers = List.generate(ActivityTodayList[index]['get_app_activity_footings'].length, (i) => TextEditingController());
                                                                      for(int i = 0; i<ActivityTodayList[index]['get_app_activity_footings'].length; i++){

                                                                        todayProgressValidation.add(false);
                                                                        selectedFooting = selectedFooting + ActivityTodayList[index]['get_app_activity_footings'][i]['footing_name'];

                                                                        Map map = {
                                                                          "footing_name": ActivityTodayList[index]['get_app_activity_footings'][i]['footing_name'],
                                                                          "footing_id": "${ActivityTodayList[index]['get_app_activity_footings'][i]['id']}",
                                                                          "new_progress":"${ActivityTodayList[index]['get_app_activity_footings'][i]['footing_progress']}",
                                                                        };

                                                                        columnsMap.add(map);
                                                                      }
                                                                    }else if(ActivityTodayList[index]['reporting_unit'] == "OTHER"){
                                                                      reportingUnit = "OTHER";
                                                                      otheActID = "${ActivityTodayList[index]['get_app_activity_other'][0]['id']}";
                                                                      otherUnit = "${ActivityTodayList[index]['get_app_activity_other'][0]['other_unit']}";
                                                                      aProgress.text = "${ActivityTodayList[index]['get_app_activity_other'][0]['other_progress']}";
                                                                      getOtherUnit(context,"$selectedSubactivityID");


                                                                    }
                                                                    // }

                                                                  });

                                                                },
                                                              ),
                                                            ],
                                                          ):Container(),
                                                        ],
                                                      ),
                                                      Container(
                                                        width: 80 * SizeConfig.widthMultiplier,
                                                        child: Text(ActivityTodayList[index]['sub_activity_name'],
                                                            style: DTextStyle.bodyLineBold),
                                                      ),
                                                      SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                      Text("Unit : "+ActivityTodayList[index]['reporting_unit'],
                                                          style: DTextStyle.bodyLineBold),
                                                      SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                      ActivityTodayList[index]['reporting_unit'] == "COLUMN"?Column(children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 80 * SizeConfig.widthMultiplier,
                                                              child: Text("Floor : ${ActivityTodayList[index]['get_app_activity_columns'][index]['floor_name']}",
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            physics: ScrollPhysics(),
                                                            itemCount: ActivityTodayList[index]['get_app_activity_columns'].length,
                                                            itemBuilder: (BuildContext context, int subIndex) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(ActivityTodayList[index]['get_app_activity_columns'][subIndex]['column_name'],
                                                                        style: DTextStyle.bodyLineBold),/*
                                                                  Text("Previous Progress : "+ActivityTodayList[index]['get_activity_columns'][subIndex]['column_name'],
                                                                      style: DTextStyle.bodyLineBold),*/
                                                                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                                                    Text("Today's Progress : ${ActivityTodayList[index]['get_app_activity_columns'][subIndex]['column_progress']}",
                                                                        style: DTextStyle.bodyLine),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ],)
                                                      : ActivityTodayList[index]['reporting_unit'] == "FLOOR"?Column(children: [
                                                        Container(
                                                          width: 80 * SizeConfig.widthMultiplier,
                                                          child: Row(
                                                            children: [
                                                              Text("Floor : "+ActivityTodayList[index]['get_app_activity_floors'][0]['floor_name'],
                                                                  style: DTextStyle.bodyLineBold),
                                                              SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                                              Text("Today's Progress : ${ActivityTodayList[index]['get_app_activity_floors'][0]['floor_progress']}",
                                                                  style: DTextStyle.bodyLine),
                                                            ],
                                                          ),
                                                        ),
                                                      ],)
                                                      : ActivityTodayList[index]['reporting_unit'] == "FLAT"?Column(children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 80 * SizeConfig.widthMultiplier,
                                                              child: Text("Floor : "+ActivityTodayList[index]['get_app_activity_flats'][0]['floor_name'],
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            physics: ScrollPhysics(),
                                                            itemCount: ActivityTodayList[index]['get_app_activity_flats'].length,
                                                            itemBuilder: (BuildContext context, int subIndex) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(ActivityTodayList[index]['get_app_activity_flats'][subIndex]['flat_name'],
                                                                        style: DTextStyle.bodyLineBold),/*
                                                                  Text("Previous Progress : "+ActivityTodayList[index]['get_activity_columns'][subIndex]['column_name'],
                                                                      style: DTextStyle.bodyLineBold),*/
                                                                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                                                                    Text("Today's Progress : ${ActivityTodayList[index]['get_app_activity_flats'][subIndex]['flat_progress']}",
                                                                        style: DTextStyle.bodyLine),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ],)
                                                      : ActivityTodayList[index]['reporting_unit'] == "FOOTING"?Column(children: [
                                                        ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            padding: EdgeInsets.zero,
                                                            shrinkWrap: true,
                                                            physics: ScrollPhysics(),
                                                            itemCount: ActivityTodayList[index]['get_app_activity_footings'].length,
                                                            itemBuilder: (BuildContext context, int subIndex) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text("Footing : ", style: DTextStyle.bodyLineBold),/*
                                                                  Text("Previous Progress : "+ActivityTodayList[index]['get_activity_columns'][subIndex]['column_name'],
                                                                      style: DTextStyle.bodyLineBold),*/
                                                                    SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                                                    Text("${ActivityTodayList[index]['get_app_activity_footings'][subIndex]['footing_name']}",
                                                                        style: DTextStyle.bodyLine),
                                                                    SizedBox(width: 5 * SizeConfig.widthMultiplier,),
                                                                    Text("Today's Progress : ", style: DTextStyle.bodyLineBold),/*
                                                                  Text("Previous Progress : "+ActivityTodayList[index]['get_activity_columns'][subIndex]['column_name'],
                                                                      style: DTextStyle.bodyLineBold),*/
                                                                    SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                                                    Text("${ActivityTodayList[index]['get_app_activity_footings'][subIndex]['footing_progress']}",
                                                                        style: DTextStyle.bodyLine),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ],)
                                                     : ActivityTodayList[index]['reporting_unit'] == "OTHER"?Column(children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 80 * SizeConfig.widthMultiplier,
                                                              child: Text("Reporting Unit : OTHER",
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: 45 * SizeConfig.widthMultiplier,
                                                              child: Text("Other Unit : "+ActivityTodayList[index]['get_app_activity_other'][0]['other_unit'],
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                            Container(
                                                              width: 45 * SizeConfig.widthMultiplier,
                                                              child: Text("Today's Progress : ${ActivityTodayList[index]['get_app_activity_other'][0]['other_progress']}",
                                                                  style: DTextStyle.bodyLineBold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],):Container(),



                                                      SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                      Text(ActivityTodayList[index]['comments'],
                                                          style: DTextStyle.bodyLine),
                                                      SizedBox(height: 0.8 * SizeConfig.heightMultiplier,),
                                                      Row(
                                                        children: [

                                                          Flexible(
                                                            child: Divider(height: 2 * SizeConfig.widthMultiplier,color: Colors.grey),
                                                          ),
                                                          SizedBox(width: 2 * SizeConfig.widthMultiplier,)
                                                        ],
                                                      ),

                                                    ],
                                                  );
                                                }),
                                          ),
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 5 * SizeConfig.heightMultiplier,
                              color: Color(0xFFf5f5f5),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected[0] = false;
                                  selected[1] = false;
                                  selected[2] = false;
                                  selected[3] = true;
                                });
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
                                      Padding(
                                        padding:  EdgeInsets.only(top: 2 * SizeConfig.heightMultiplier,right: 3 * SizeConfig.widthMultiplier,),
                                        child: Row( 
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("RECORD REMARKS AND PHOTOS",
                                                style: TextStyle(
                                                  fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Colors.black,
                                                )),
                                            Icon(
                                              selected[3]
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: app_color,
                                              size:3.0 * SizeConfig.heightMultiplier,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: selected[3] == false
                                            ? 3 * SizeConfig.heightMultiplier
                                            : 0,
                                      ),
                                      selected[3]
                                      ? Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("Description",
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
                                          approved == 0?Container(
                                            width: 94 *
                                                SizeConfig.widthMultiplier,
                                            ///height: 6 * SizeConfig.heightMultiplier,
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
                                                      controller: description,
                                                      cursorColor:
                                                      Colors.black,
                                                      keyboardType:
                                                      TextInputType.text,
                                                      textInputAction:
                                                      TextInputAction.next,

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
                                          ): Text(isDescription,
                                              style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color: Colors.black,
                                              )),
                                          SizedBox(
                                            height: 1.5 *
                                                SizeConfig.heightMultiplier,
                                          ),
                                          Text("Upload Photo",
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

                                          remarkPhotoList.length >= 1?
                                          Wrap(
                                            children: [
                                              Container(
                                                height: 12 *
                                                    SizeConfig.heightMultiplier,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemCount: remarkPhotoList.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Container(
                                                          width: 35 *
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
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(
                                                                          Radius.circular(
                                                                            2 *
                                                                                SizeConfig
                                                                                    .imageSizeMultiplier,
                                                                          )),
                                                                      // color: Color(0xFFba3d41),
                                                                      shape: BoxShape.rectangle,),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Container(
                                                                        width: 35 *SizeConfig.widthMultiplier,
                                                                        height: 10 *SizeConfig.heightMultiplier,
                                                                      child: Image.network(remarkPhotoList[index]['is_cloud'] == 1?
                                                                      ApiClient.IMG_BASE_GOOGLE_URL+remarkPhotoList[index]['thumbnail_path']:
                                                                      ApiClient.IMG_BASE_URL+remarkPhotoList[index]['thumbnail_path'],
                                                                        fit: BoxFit.cover,
                                                                        loadingBuilder: (context, child, loadingProgress) {
                                                                          if (loadingProgress == null) return child;

                                                                          return Center(child: Text('Loading...'));
                                                                          // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                                                        },
                                                                        errorBuilder: (context, error, stackTrace) =>
                                                                            Text('Errors!'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(mainAxisAlignment: MainAxisAlignment.end,
                                                                  children: [
                                                                    Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap: () {
                                                                            List<String> imgList = [remarkPhotoList[index]['is_cloud'] == 1?
                                                                            ApiClient.IMG_BASE_GOOGLE_URL+remarkPhotoList[index]['thumbnail_path']:
                                                                            ApiClient.IMG_BASE_URL+remarkPhotoList[index]['thumbnail_path']];
                                                                            //imgList[0] = "${ApiClient.BASE_IMG_URL}${myOrderList['complaint_photo']}";
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => new PhotosViewPage(imgList)),
                                                                            );
                                                                          },
                                                                          child: CircleAvatar(
                                                                            child: Icon(
                                                                              Icons.remove_red_eye,
                                                                              color: app_color,
                                                                              size:3 * SizeConfig.widthMultiplier,
                                                                            ),
                                                                            radius: 3 * SizeConfig.widthMultiplier,backgroundColor: Colors.white,
                                                                          ),
                                                                        ),
                                                                        approved == 0?InkWell(
                                                                          onTap: () {
                                                                            confirmationDialog(context,remarkPhotoList[index]['id'],"",4);
                                                                          },
                                                                          child: CircleAvatar(
                                                                            child: Icon(
                                                                                Icons.delete,
                                                                                color: app_color,
                                                                                size:3 * SizeConfig.widthMultiplier,
                                                                              ),
                                                                            radius: 3 * SizeConfig.widthMultiplier,backgroundColor: Colors.white,
                                                                          ),
                                                                        ):Container(),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              approved == 0?Container(
                                                height: 12 *
                                                    SizeConfig.heightMultiplier,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemCount: isImage.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.all(2.0),
                                                        child: Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                get_image(ImageSource.camera);
                                                              },
                                                              child: Container(
                                                                width: 35 *
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
                                                                  child: _image.length == 0 || isImage.length == (index + 1)?Text(
                                                                      "Click to Upload\n the image",
                                                                      style: TextStyle(
                                                                        fontSize: 1.8 *
                                                                            SizeConfig
                                                                                .textMultiplier,
                                                                        fontFamily: 'Lato',
                                                                        color: Colors.black,
                                                                      ))
                                                                      :Container(
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
                                                              ),
                                                            ),
                                                            SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                                            isImage.length == (index + 1)?
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  get_image(ImageSource.camera);
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding:  EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                                                child: Container(
                                                                  width: 10 *
                                                                      SizeConfig.widthMultiplier,
                                                                  height: 4 *
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
                                                                    child:Icon(
                                                                      Icons.add,
                                                                      color: app_color,
                                                                      size:
                                                                      3.0 * SizeConfig.heightMultiplier,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ):Container()
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ):Container()

                                            ],
                                          )
                                          : Container(
                                            height: 12 *
                                                SizeConfig.heightMultiplier,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics: ScrollPhysics(),
                                                itemCount: isImage.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            get_image(ImageSource.camera);
                                                          },
                                                          child: Container(
                                                            width: 35 *
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
                                                              child: _image.length == 0 || isImage.length == (index + 1)?Text(
                                                                  "Click to Upload\n the image",
                                                                  style: TextStyle(
                                                                    fontSize: 1.8 *
                                                                        SizeConfig
                                                                            .textMultiplier,
                                                                    fontFamily: 'Lato',
                                                                    color: Colors.black,
                                                                  ))
                                                                  :Container(
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
                                                          ),
                                                        ),
                                                        SizedBox(width: 1 * SizeConfig.widthMultiplier,),
                                                        isImage.length == (index + 1)?
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              get_image(ImageSource.camera);
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:  EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                                            child: Container(
                                                              width: 10 *
                                                                  SizeConfig.widthMultiplier,
                                                              height: 4 *
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
                                                                child:Icon(
                                                                  Icons.add,
                                                                  color: app_color,
                                                                  size:
                                                                  3.0 * SizeConfig.heightMultiplier,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ):Container()
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                          SizedBox(height: approved == 0?0:1.5 * SizeConfig.heightMultiplier,),
                                          approved == 0?Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                color: app_color,
                                                splashColor: Colors.yellow[800],
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
                                                    final result = await InternetAddress.lookup('google.com');
                                                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                      if(!description.text.isEmpty){
                                                        if(_image.length >= 1){
                                                         // addPhoto(context);
                                                          addPhoto(context);
                                                        }else{
                                                        showDialog(context: context,builder: (BuildContextcontext) =>
                                                        CustomDialog("Photo is required"));
                                                        }
                                                      }else{
                                                        showDialog(context: context,builder: (BuildContextcontext) =>
                                                          CustomDialog("Description is required"));}
                                                    }
                                                  } on SocketException catch (_) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                        context) =>
                                                            CustomDialog("Check Internet connection"));
                                                  }
                                                },
                                              ),
                                            ],
                                          ):Container(),

                                          SizedBox(height: approved == 0?0:2 * SizeConfig.heightMultiplier,),
                                          approved == 0?Padding(
                                            padding:  EdgeInsets.only(bottom:2 * SizeConfig.heightMultiplier,),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  color: app_color,      
                                                  splashColor: Colors.yellow[800],
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
                                                  child: Text(ApiClient.userType == "2"?'Approval':'Submit For Approval',
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
                                                      final result = await InternetAddress.lookup('google.com');
                                                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                                        submitForApproval(context);
                                                      }else{
                                                        showDialog(context: context,builder: (BuildContext context) =>
                                                                CustomDialog(
                                                                    "Check Internet connection"));
                                                      }

                                                    } on SocketException catch (_) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) =>
                                                              CustomDialog(
                                                                  "Check Internet connection"));
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ):Container(),


                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        revokeComments !=""?
                        Padding(
                          padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                          child: Row(
                            children: [
                              Text("Revoke with Comment\n${revokeComments}",
                                  style: TextStyle(
                                    fontSize: 1.8 *
                                        SizeConfig.textMultiplier,
                                    fontFamily: 'Lato',
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ):Container(),
                        ApiClient.userType == "4" && revoked == 0?Padding(
                          padding:  EdgeInsets.only(bottom:2 * SizeConfig.heightMultiplier,),
                          child: Column(
                            children: [
                              SizedBox(height: 1 *SizeConfig.heightMultiplier,),
                              Row(
                                children: [
                                  SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                                  Text("Revoke with comment:",
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      )),
                                ],
                              ),
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
                                    splashColor: Colors.yellow[800],
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
                                    child: Text('DPR Revoke',
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
                                        final result = await InternetAddress.lookup('google.com');
                                        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                                          if(!revokeWithComments.text.isEmpty){
                                            dprSubmit();
                                          }else{
                                            showDialog(context: context,builder: (BuildContext context) =>
                                                CustomDialog(
                                                    "Please enter revoker comment"));
                                          }


                                        }else{
                                          showDialog(context: context,builder: (BuildContext context) =>
                                              CustomDialog(
                                                  "Check Internet connection"));
                                        }

                                      } on SocketException catch (_) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext
                                            context) =>
                                                CustomDialog(
                                                    "Check Internet connection"));
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ):Container(),

                      ],
                    )
                   :Container(
                        height: 75 * SizeConfig.heightMultiplier,
                        width: 95 * SizeConfig.widthMultiplier,
                        child: Column(children: [
                          SizedBox(height: 15 * SizeConfig.heightMultiplier),
                          Image.asset('assets/icons/no_data_found.png',
                            height: 20 * SizeConfig.widthMultiplier,
                            width: 20 * SizeConfig.widthMultiplier,),
                          SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                          Text("DPR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2.2 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',)),
                          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                          Text("There is no DPR found",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                          SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

                        ])
                    )
                    :Padding(
                      padding: EdgeInsets.only(top: 8 * SizeConfig.heightMultiplier,),
                      child: Center(child: Container(child: CustomDialogLoading1(),)),
                    ),

                  ],
                ),
              ))
        ]));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


  // APIs for Create New DPR
  createNewDPR(BuildContext context,selDate) async{
    showDialog(context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"save_progress_report");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "dpr_date":selDate,
      "created_by":createdBy.text
    };
    print("map >>>>  : ${jsonEncode(map)}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          dprId = decoded['dpr_id'];
          isProject = true;
          selectedDate = selDate;
          getMaterialList(context,2);
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }else{

    }
  }

  // APIs for get Manpower
  viewDPR(BuildContext context,num) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_dpr");
    Map map ={
      "date":selectedDate,
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
    };
    print("map viewDPR : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded  ddd : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {

          isViewDPR = false;
          isProject = true;
          apiFlag = true;
          print("isViewDPR $isViewDPR");
          print("isProject $isProject");

          createdBy.text = decoded['data'][0]['created_by'];
          dprId = decoded['data'][0]['dpr_id'];
          revokeComments = decoded['data'][0]['revoke_comments'];

          revoked = decoded['data'][0]['revoked'];

          if(ApiClient.userType == "2"){
            if(decoded['data'][0]['approved'] == 1 ){ //|| decoded['data'][0]['submitted'] == 0
              approved = 1;
            }else{
              approved = 0;
            }
          }else{
            if(decoded['data'][0]['approved'] == 1 || decoded['data'][0]['submitted'] == 1){
              approved = 1;
            }else{
              approved = 0;
            }
          }



          // submitted: 1, approved: 0, revoked: 0


        //  callMap(context); 9136160375
          getMaterialList(context,1);
          getTodaysManpower(context,1);
          getTodaysMaterialList(context);
          getTodaysActivityList(context);
          viewDprRemarkPhoto(context);

        });

      }else{
        setState(() {
          isViewDPR = false;
          isProject = false;
          apiFlag = true;
        });
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for Add manpower
  addManpower(BuildContext context) async{
    showDialog(context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url ;
    Map map;
    if(isEditManpower){
      url = Uri.parse(ApiClient.BASE_URL+"dpr_update_manpower");
      map ={
        "dpr_manpower_id":"$editManpowerId",
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "daily_progress_id":"$dprId",
        "manpower_id":"$selectedManpowerID",
        "contractor_id":"$selectedContractorID",
        "no_of_skilled_workers":"${skilledWorkers.text}",
        "no_of_unskilled_workers":"${unSkilledWorkers.text}",
        "comments":"${comments.text}",
      };
    }else{
      url = Uri.parse(ApiClient.BASE_URL+"dpr_add_manpower");
      map ={
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "daily_progress_id":"$dprId",
        "manpower_id":"$selectedManpowerID",
        "contractor_id":"$selectedContractorID",
        "no_of_skilled_workers":"${skilledWorkers.text}",
        "no_of_unskilled_workers":"${unSkilledWorkers.text}",
        "comments":"${comments.text}",
      };
    }

    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         // dprId = decoded['dpr_id'];
         // isProject = true;
          isEditManpower = false;
          editManpowerId = "";
          selectedContractor = "Select Contractor";
          selectedContractorID = "";
          skilledWorkers.text = "";
          unSkilledWorkers.text = "";
          comments.text = "";
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
          getTodaysManpower(context,2);
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

    }else{

    }
  }


  // APIs for get Manpower
  getManpowerList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_manpower_lists");
    var response = await http.post(url, headers: {'Authorization': "$userToken"});
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          manPowerList = decoded['data'];
          print("manPowerList : ${manPowerList}");
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

    }else{

    }
  }

  // APIs for get Today Manpower
  getTodaysManpower(BuildContext context,num) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_todays_manpower");
    Map map = {
    "date":selectedDate,
      "daily_progress_id":"$dprId"};
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("manPowerTodayList : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {


          manPowerTodayList = decoded['manpower_list'];
        });
      }else{
        setState(() {
          manPowerTodayList.clear();
        });
        if(decoded['token']){
          if(num == 2){
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(decoded['message']));
          }
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for get Today Material List
  getTodaysMaterialList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_dpr_material_list");
    Map map = {
      "date":selectedDate,
      "daily_progress_id":"$dprId"};
    print("manPowerTodayList : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("manPowerTodayList  ::: : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
           MaterialTodayList = decoded['material_list'];
        });
      }else{
        setState(() {
          MaterialTodayList.clear();
        });
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  getTodaysActivityList(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_activity_report");
    Map map = {
      "date":selectedDate,
      "building_id":"${projectData['building_id']}",
      "daily_progress_id":"$dprId"};
    print("getTodaysActivityList : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("getTodaysActivityList  ::: : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {

          print("approved === > $approved");

          ActivityTodayList = decoded['data']['get_app_activity_progress'];
        });
      }else{
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  viewDprRemarkPhoto(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"view_dpr_remark_photo");
    Map map = {
      "date":selectedDate,
      "building_id":"${projectData['building_id']}",
      "daily_progress_id":"$dprId"};
    print("manPowerTodayList : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("viewDprRemarkPhoto  ::: : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          remarkPhotoList = decoded['data'];
          isDescription = decoded['data'][0]['description'];
          description.text = decoded['data'][0]['description'];
          print("manPowerTodayList remarkPhotoList : ${remarkPhotoList.length}");
        });
      }else{
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }


  // APIs for get Contractor
  getContractorList(id) async{
    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"get_contractor_lists");
    Map map ={
      "manpower_id":"$id",
      "building_id":"${projectData['building_id']}",
    };
    print("map : ss ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded  ss : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          contractorList = decoded['data'];
        });
      }else{
        setState(() {
          contractorList = decoded['data'];
        });
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }


// Select ManPower Dialog
  selectManpower(BuildContext context) async{
  //  FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(Duration(milliseconds: 50), () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: Container(
               // height: 80 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
              // color: Colors.red,
                child: new ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: manPowerList.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return Container(
                          child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                  selectedManpower = manPowerList[index]['man_power_name'];
                                  selectedManpowerID = manPowerList[index]['id'];
                                  selectedContractor = "Select Contractor";
                                  Navigator.pop(context);
                                  getContractorList(selectedManpowerID);
                              });
                            },
                            child: Container(
                              width: 62 * SizeConfig.widthMultiplier,
                            //  color: Colors.white70,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: <
                                    Widget>[
                                  SizedBox(height:SizeConfig.heightMultiplier,),
                                  Text("${manPowerList[index]['man_power_name']}",
                                      textAlign: TextAlign.start,
                                      maxLines:3,
                                      style:TextStyle(
                                        fontSize:
                                        1.7 * SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color:
                                       // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                        Colors.black,
                                      )),
                                  SizedBox(height:  SizeConfig.heightMultiplier,),
                                  Divider(color:Colors.grey),
                                  //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
            );
          });
    });
  }

  // Select ManPower Dialog
  selectMaterial(BuildContext context) async{
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(Duration(milliseconds: 50), () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: Container(
                // height: 80 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
               // color: Colors.white,
                child: new ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: materialList.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return checkMaterial(materialList[index]['id'])?Container():Container(
                          child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMaterial = materialList[index]['material_name'];
                                selectedMaterialID = materialList[index]['id'];
                                mUnit = materialList[index]['unit'];
                                getOpeningBalance(context,selectedMaterialID);
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              width: 62 * SizeConfig.widthMultiplier,
                            //  color: Colors.white70,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: <
                                    Widget>[
                                  SizedBox(height:SizeConfig.heightMultiplier,),
                                  Text("${materialList[index]['material_name']}",
                                      textAlign: TextAlign.start,
                                      maxLines:3,
                                      style:TextStyle(
                                        fontSize:
                                        2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color:Colors.black,
                                      )),
                                  SizedBox(height:  SizeConfig.heightMultiplier,),
                                  Divider(color:Colors.grey),
                                  //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
            );
          });
    });
  }

// Select Contractor Dialog
  selectContractor(BuildContext context) async{
    print("selectContractor : $contractorList");
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(Duration(milliseconds: 50), () {

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(

             // backgroundColor: Colors.transparent,
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: Container(
                height: 80 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
               // color: Colors.white,
                child: new ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: contractorList.length,
                    itemBuilder: (BuildContext context,int index) {
                      return check(contractorList[index]['id'],contractorList[index]['manpower_id'])?
                      Center(
                        child: Container(
                          height: 80 * SizeConfig.heightMultiplier,
                          child: Center(child: Text("contractor already assigned")),
                        ),
                      ):Container(
                          child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                  selectedContractor = contractorList[index]['contractor_name'];
                                  selectedContractorID = contractorList[index]['id'];
                                  Navigator.pop(context);

                              });
                            },
                            child: Container(
                              width: 62 * SizeConfig.widthMultiplier,
                              //color: Colors.white,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: <
                                    Widget>[
                                  SizedBox(height:SizeConfig.heightMultiplier,),
                                  Text(contractorList[index]['contractor_name'],
                                      textAlign: TextAlign.start,
                                      maxLines:3,
                                      style:TextStyle(
                                        fontSize:
                                        2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                      color:Colors.black,
                                        //  Colors.black,
                                      )),
                                  SizedBox(height:  SizeConfig.heightMultiplier,),
                                  Divider(color:Colors.grey),
                                  //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
            );
          });
    });
  }

  bool check(id,manpower_id){

    for(int i = 0; i < manPowerTodayList.length; i++){
    //  if(){
        if(manPowerTodayList[i]['contractor_id'] == id && manPowerTodayList[i]['manpower_id'] ==  selectedManpowerID){
          return true;
        }
    //  } else{return false;}

    }
    return false;
  }

  bool checkMaterial(id){


    for(int i = 0; i < MaterialTodayList.length; i++){
      print( "checkMaterial  ${MaterialTodayList[i]['material_id']}  :: $id");
      if(MaterialTodayList[i]['material_id'] == id){
        return true;
      }
      //  } else{return false;}

    }
    return false;
  }

  // APIs for get Material
  getMaterialList(BuildContext context,num) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_material_lists");
    Map map ={
      "daily_progress_id":"$dprId",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          materialList = decoded['data'];
          print("materialList : ${materialList}");
        });
      }else{
        if(decoded['token']){
          if(num == 2){
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(decoded['message']));
          }

        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for Add manpower
  addMaterial(BuildContext context) async{
    showDialog(context: context, builder: (BuildContext context) => CustomDialogLoading());


    var url ;
    Map map;
    if(isEditMaterial){
      url = Uri.parse(ApiClient.BASE_URL+"update_dpr_material");
      map ={
        "dpr_material_id":"$editMaterialId",
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "daily_progress_id":"$dprId",
        "material_id":"$selectedMaterialID",
        "material_name":"$selectedMaterial",
        "unit":"$mUnit",
        "opening_balance":"$openingBalance",
        "received_today":"${receivedToday.text}",
        "issue_today":"${issueToday.text}",
        "closing_today":"$ClosingBalanc",
        "comments":"${mComments.text}",
      };
    }else{
      url = Uri.parse(ApiClient.BASE_URL+"dpr_add_material");
      map ={
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "daily_progress_id":"$dprId",
        "material_id":"$selectedMaterialID",
        "material_name":"$selectedMaterial",
        "unit":"$mUnit",
        "opening_balance":"$openingBalance",
        "received_today":"${receivedToday.text}",
        "issue_today":"${issueToday.text}",
        "closing_today":"$ClosingBalanc",
        "comments":"${mComments.text}",
      };
    }
    print("jsonMap " + json.encode(map));
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          // dprId = decoded['dpr_id'];
          // isProject = true;
          isEditMaterial = false;
          editMaterialId = "";
          selectedMaterial = "Select Material";
          selectedMaterialID = "";
          issueToday.text = "";
          receivedToday.text = "";
          ClosingBalanc = 0;
          mComments.text = "";
          getTodaysMaterialList(context);
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }else{

    }
  }

  // APIs for get Material Opening Balance
  getOpeningBalance(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_material_opening_balance");
    Map map ={
      "building_id":"${projectData['building_id']}",
      "material_id":"$id"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          openingBalance = "${decoded['opening_balance']}";
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

    }else{

    }
  }

  // Select Contractor Dialog
  DPRConfirmationDialog(BuildContext context,num) async{
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 18 * SizeConfig.heightMultiplier,

              child: Column(children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text('Are you sure you want to create new DPR ?',
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
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 2.0 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
                        color: app_color,
                        splashColor: Colors.yellow[800],
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

                          setState(() {
                            if(num == 1) {
                              isProject = false;
                            }else{
                              isViewDPR = false;
                              isProject = false;
                            }
                            Navigator.pop(context);
                          });
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

  // Delete  confirmation  Dialog
  confirmationDialog(BuildContext context,id,unit,num) async{
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            content: Container(
              height: 18 * SizeConfig.heightMultiplier,

              child: Column(children: <Widget>[
                SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                Text('Are you sure you want to Delete ?',
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
                          Navigator.pop(dialogContext);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 2.0 * SizeConfig.widthMultiplier),
                      child: MaterialButton(
                        color: app_color,
                        splashColor: Colors.yellow[800],
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

                          Navigator.of(context).pop();
                          if(num == 1){
                            getDeleteManPower(context,id);
                          }else if(num == 2){
                            getDeleteMaterial(context,id);
                          }else if(num == 3){
                            getDelet(context,id,unit);
                          }else{
                            deletePhoto(context,id);
                          }

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


  void calculateClosingBalance(int receivedToday, int issueToday) {
    print("receivedToday $receivedToday");
    print("issueToday $issueToday");

    int OB = int.parse(openingBalance);
    setState(() {
      ClosingBalanc = (OB + receivedToday) - issueToday;
    });
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
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // Get Sub Activity List
  getSubactivityList(BuildContext context,activityID) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_sub_activity");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "activity_id":"$activityID",
    };
    print("map : ${map}");
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

    }else{

    }
  }

  // Get Sub Activity List
  getReportingUnit(BuildContext context,reporting_unit_id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_reporting_unit");
    Map map ={
      "reporting_unit_id":"$reporting_unit_id",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         columnsMap.clear();
         _controllers.clear();
         _focusNode.clear();
         reportingUnit = decoded['data'][0]['reporting_unit'];
         if(reportingUnit == "OTHER"){
           getOtherUnit(context,selectedSubactivityID);
         }

         getFootings(context,selectedSubactivityID);
         getFloor(context,selectedSubactivityID);
         getFlat(context,selectedSubactivityID);
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
    }else{

    }
  }
  // Get Sub Activity List
  getOtherUnit(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_other_unit");
    Map map ={
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$id"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded otherUnit : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
         otherUnit = decoded['data']['other_unit'];
         otherQty = decoded['data']['quantity'];
         Progress = "${decoded['existing_total']}";
        });
      }else{
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for Add Columns List
  addActivity(BuildContext context,) async{
    showDialog(
        barrierDismissible: false,context: context,builder: (BuildContext context) => CustomDialogLoading());

    var url;
    if(isEditActivity){
    url = Uri.parse(ApiClient.BASE_URL+"update_dpr_activity");
    }else{
    url = Uri.parse(ApiClient.BASE_URL+"save_record_activity");
    }
//    final String encodedData = json.encode(columnsMap1);
    Map map = {
      "actID":actID,
      "otheActID":"$otheActID",
      "activity_id":"$selectedActivityID",
      "building_id":"${projectData['building_id']}",
      "daily_progress_id":"$dprId",
      "sub_activity_id":"$selectedSubactivityID",
      "comments":aComments.text,
      "floor_id":"$selectedfloorsID",
      "new_progress":aProgress.text,
      "other_unit":otherUnit,
      "unit":reportingUnit,
      "flat_wise_column_progress":columnsMap1,
      "flat_wise_progress":columnsMap1,
      "footings_ids":columnsMap,
    };
    print("jsonMap " + json.encode(map));
    print("userToken :: $userToken");

    var response = await http.post(url, headers: {'Content-type':'application/json','Authorization': "$userToken"}, body: utf8.encode(json.encode(map)));

    Map decoded = jsonDecode(response.body);
    print("statusCode : ${response.statusCode}");
    print("decoded : ${decoded}");
    Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          columnsMap1.clear();
          reportingUnit = "";
          selectedSubactivity = "Select Subactivity";
          isColumnsList.clear();
          todayProgressValidation.clear();
          _controllers.clear();
          _focusNode.clear();
          columnsMap.clear();
          aComments.text = "";
          aProgress.text = "";
          isEditActivity = false;
          getTodaysActivityList(context);


        });
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
        FocusScope.of(context).unfocus();
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

    }
  }

  // APIs for get Columns List
  getColumns(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"show_column_wise_record");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$id",
      "floor_category":"$floor_category",
      "floor_id":"$selectedfloorsID"
    };
    print("map getColumns: ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded getColumns : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          columnsList = decoded['data'];
        //  isColumnsList =  columnsList.length as List<bool>;
          for(int i = 0; i < columnsList.length; i++){
            isColumnsList.add(false);
          }
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

    }else{

    }
  }

  // APIs for get Footings List
  getFootings(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_footings");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$id"
    };
    print("map : ${map}");
    isFootingsList.clear();
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded footingsList : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          selectedFooting = "Select Footing";
          footingsList = decoded['data'];
          for(int i = 0; i < footingsList.length; i++){
            isFootingsList.add(false);
          }
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

    }else{

    }
  }

  // APIs for get Floor List
  getFloor(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_floors");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$id"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded floorsList: ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          floorsList = decoded['data'];

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

    }else{

    }
  }

  // APIs for get Floor List
  getFlat(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_flat_progress");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$id"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded   flatList -- : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          flatList = decoded['data'];
          for(int i = 0; i < flatList.length; i++){
            isFlatList.add(false);
          }
        });
      }else{
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for get Floor Progress
  getFloorProgress(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_floor_progress");
    Map map ={
      "floor_id":"$id",
      "building_id":"${projectData['building_id']}",
      "sub_activity_id":"$selectedSubactivityID"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          floorPreProg = "${decoded['data']}";
        });
      }else{
        if(decoded['token']){
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // Select Floor Dialog
  selectFooting(BuildContext context) async{
    FocusScope.of(context).requestFocus(FocusNode());

    Future.delayed(Duration(milliseconds: 50), () {
      showDialog(barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                         // height: 78 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: Colors.white,
                          child: new ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: footingsList.length,
                              itemBuilder:
                                  (BuildContext context,
                                  int index) {
                                return footingsList[index]['progress'] == 0 ?Container(
                                    child:
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          // selectedColumns = columnsList[index]['column_name'];
                                          //  selectedColumnsID= columnsList[index]['column_id'];
                                          //   Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        width: 62 * SizeConfig.widthMultiplier,
                                        color: Colors.white70,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: <
                                              Widget>[
                                            Row(
                                              children: [
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor: app_color,
                                                  value: isFootingsList[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isFootingsList[index] = value!;
                                                    });
                                                  },
                                                ),
                                                Text("${footingsList[index]['footing_name']}",
                                                    textAlign: TextAlign.start,
                                                    maxLines:3,
                                                    style:TextStyle(
                                                      fontSize:
                                                      2 * SizeConfig.textMultiplier,
                                                      fontFamily: 'Lato',
                                                      color:
                                                      // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                      Colors.black,
                                                    )),
                                              ],
                                            ),
                                            Divider(color:Colors.grey),
                                            //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                          ],
                                        ),
                                      ),
                                    )):Container();
                              }),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: app_color,
                              splashColor: Colors.yellow[800],
                              minWidth: 28 *
                                  SizeConfig.widthMultiplier,
                              height: 4.7 *
                                  SizeConfig.heightMultiplier,
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

                                selectedFooting = "";
                                columnsMap.clear();
                                if(isFootingsList.length >= 1){
                                  var flag = true;
                                for(int i = 0; i<isFootingsList.length; i++){
                                  if(isFootingsList[i]){
                                    setState(() {
                                      if(flag){
                                        flag = false;
                                        selectedFooting = selectedFooting + footingsList[i]['footing_name'];
                                      }else{
                                        print("selectedFooting else  $i");
                                        selectedFooting = selectedFooting +","+ footingsList[i]['footing_name'];
                                      }

                                    });
                                    Map map = {
                                      "footing_name": footingsList[i]['footing_name'],
                                      "footing_id": footingsList[i]['id'],
                                      "new_progress":"100"
                                    };
                                    columnsMap.add(map);
                                  }
                                }
                                }else{
                                  setState(() {
                                    print("selectedFooting else : $selectedFooting");
                                    selectedFooting = "Select Footing";
                                  });
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },

              ),
            );
          });
    });
  }


  // Select Floor Dialog
  selectFloor(BuildContext context,num) async{
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(Duration(milliseconds: 50), () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: Container(
                // height: 80 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
                color: Colors.white,
                child: new ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: floorsList.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return reportingUnit == "FLAT"?floorsList[index]['floor_category'] == 1?Container(
                          child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFloors = floorsList[index]['floor_name'];
                                selectedfloorsID = floorsList[index]['id'];

                                if(num == 2){
                                  getFloorProgress(context,floorsList[index]['id']);
                                }

                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              width: 62 * SizeConfig.widthMultiplier,
                              color: Colors.white70,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: <
                                    Widget>[
                                  SizedBox(height:SizeConfig.heightMultiplier,),
                                  Text("${floorsList[index]['floor_name']}",
                                      textAlign: TextAlign.start,
                                      maxLines:3,
                                      style:TextStyle(
                                        fontSize:
                                        2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color:
                                        // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                        Colors.black,
                                      )),
                                  SizedBox(height:  SizeConfig.heightMultiplier,),
                                  Divider(color:Colors.grey),
                                  //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                ],
                              ),
                            ),
                          )):Container()
                      :Container(
                          child:
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFloors = floorsList[index]['floor_name'];
                                selectedfloorsID = floorsList[index]['id'];
                                floor_category = floorsList[index]['floor_category'];
                                selectedColumns = "Select Columns";
                                isColumnsList.clear();
                                columnsList.clear();
                                columnsMap.clear();
                                if(num == 2){
                                  getFloorProgress(context,floorsList[index]['id']);
                                }

                                getColumns(context,selectedSubactivityID);
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              width: 62 * SizeConfig.widthMultiplier,
                              color: Colors.white70,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: <
                                    Widget>[
                                  SizedBox(height:SizeConfig.heightMultiplier,),
                                  Text("${floorsList[index]['floor_name']}",
                                      textAlign: TextAlign.start,
                                      maxLines:3,
                                      style:TextStyle(
                                        fontSize:
                                        2 * SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        color:
                                        // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                        Colors.black,
                                      )),
                                  SizedBox(height:  SizeConfig.heightMultiplier,),
                                  Divider(color:Colors.grey),
                                  //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                ],
                              ),
                            ),
                          ));
                    }),
              ),
            );
          });
    });
  }

  // Select Columns Dialog
  selectColumns(BuildContext context) async{
    FocusScope.of(context).requestFocus(FocusNode());
    var cFlag = false;
    for(int i = 0; i < columnsList.length; i++){
      if(columnsList[i]['existing_total'] <= 99){
        cFlag = true;
        break;
      }else{
        cFlag = false;
      }

    }
    if(cFlag) {
      Future.delayed(Duration(milliseconds: 50), () {
        showDialog(barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        6 * SizeConfig.widthMultiplier)),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(
                            //   height: 75 * SizeConfig.heightMultiplier,
                            width: 100 * SizeConfig.widthMultiplier,
                            color: Colors.white,
                            child: new ListView.builder(
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: columnsList.length,
                                itemBuilder:
                                    (BuildContext context,
                                    int index) {
                                  return columnsList[index]['existing_total'] <=
                                      99 ? Container(
                                      child:
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // selectedColumns = columnsList[index]['column_name'];
                                            //  selectedColumnsID= columnsList[index]['column_id'];
                                            //   Navigator.pop(context);
                                          });
                                        },
                                        child: Container(
                                          width: 62 *
                                              SizeConfig.widthMultiplier,
                                          color: Colors.white70,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: <
                                                Widget>[
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    checkColor: Colors.white,
                                                    activeColor: Color(
                                                        0xFFf07c01),
                                                    value: isColumnsList[index],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        isColumnsList[index] =
                                                        value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                      "${columnsList[index]['column_name']}",
                                                      textAlign: TextAlign
                                                          .start,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                        fontSize:
                                                        2 * SizeConfig
                                                            .textMultiplier,
                                                        fontFamily: 'Lato',
                                                        color:
                                                        // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                        Colors.black,
                                                      )),
                                                ],
                                              ),
                                              Divider(color: Colors.grey),
                                              //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                            ],
                                          ),
                                        ),
                                      )) : Container();
                                }),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              MaterialButton(
                                color: app_color,
                                splashColor: Colors.yellow[800],
                                minWidth: 28 *
                                    SizeConfig.widthMultiplier,
                                height: 4.7 *
                                    SizeConfig.heightMultiplier,
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
                                  selectedColumns = "";
                                  // _controllers.clear();
                                  todayProgressValidation.clear();
                                  columnsMap.clear();
                                  for (int i = 0; i <
                                      isColumnsList.length; i++) {
                                    if (isColumnsList[i]) {
                                      setState(() {
                                        todayProgressValidation.add(true);
                                        selectedColumns = selectedColumns +
                                            columnsList[i]['column_name'];
                                      });
                                      Map map = {
                                        "column_name": columnsList[i]['column_name'],
                                        "column_id": columnsList[i]['column_id'],
                                        "existing_total": columnsList[i]['existing_total'],
                                        "new_progress": columnsList[i]['new_progress']
                                      };
                                      columnsMap.add(map);
                                    }
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },

                ),
              );
            });
      });
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog("All Columns Completed 100 %"));
    }
  }

  // Select Columns Dialog
  selectFlat(BuildContext context) async{
    for(int i = 0; i<flatList.length; i++){
      setState(() {
        isFlatList[i] = false;
      });

    }
    FocusScope.of(context).requestFocus(FocusNode());

    print("selectedfloorsID $selectedfloorsID");
    print("isFlatList :: ${isFlatList.length}");

    Future.delayed(Duration(milliseconds: 50), () {
      showDialog(barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      6 * SizeConfig.widthMultiplier)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 78 * SizeConfig.heightMultiplier,
                          width: 100 * SizeConfig.widthMultiplier,
                          color: Colors.white,
                          child: new ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: flatList.length,
                              itemBuilder:
                                  (BuildContext context,
                                  int index) {
                                return flatList[index]['floor_id'] == selectedfloorsID && flatList[index]['existing_total'] <= 99 ?Container(
                                    child:
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                         //  selectedFlat = flatList[index]['flat_name'];
                                        //   selectedFlatID= flatList[index]['id'];
                                        //    Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        width: 62 * SizeConfig.widthMultiplier,
                                        color: Colors.white70,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: <
                                              Widget>[
                                            Row(
                                              children: [
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  activeColor: app_color,
                                                  value: isFlatList[index],
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      isFlatList[index] = value!;
                                                    });
                                                  },
                                                ),
                                                Text("${flatList[index]['flat_name']}",
                                                    textAlign: TextAlign.start,
                                                    maxLines:3,
                                                    style:TextStyle(
                                                      fontSize:
                                                      2 * SizeConfig.textMultiplier,
                                                      fontFamily: 'Lato',
                                                      color:
                                                      // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                      Colors.black,
                                                    )),
                                              ],
                                            ),
                                            Divider(color:Colors.grey),
                                            //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                          ],
                                        ),
                                      ),
                                    )):Container();
                              }),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            MaterialButton(
                              color: app_color,
                              splashColor: Colors.yellow[800],
                              minWidth: 28 *
                                  SizeConfig.widthMultiplier,
                              height: 4.7 *
                                  SizeConfig.heightMultiplier,
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
                                selectedFlat = "";
                               _controllers.clear();
                                todayProgressValidation.clear();
                                _focusNode.clear();
                                columnsMap.clear();
                                for(int i = 0; i<isFlatList.length; i++){
                                  if(isFlatList[i]){
                                    setState(() {
                                      todayProgressValidation.add(true);
                                      _controllers.add(new TextEditingController());
                                      _focusNode.add(new FocusNode());
                                      selectedFlat = selectedFlat + flatList[i]['flat_name'];

                                    });
                                    print("flatList id :: ${flatList[i]['flat_id']}");
                                    Map map = {
                                      "flat_id": "${flatList[i]['flat_id']}",
                                      "flat_name": flatList[i]['flat_name'],
                                      "existing_total": flatList[i]['existing_total'],
                                    };
                                    columnsMap.add(map);
                                  }
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },

              ),
            );
          });
    });
  }

  // APIs for get date wise dpr progress
  getDatewiseDPR(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_datewise_dpr_progress");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "status":ApiClient.userType
    };
    print("map getDatewiseDPR : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("DatewiseDPR : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          DatewiseDPR = decoded['data'];
        });
      }else{
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  bool _inProcess = false;

  get_image(ImageSource source) async {
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
      this.setState(() {
        if(ApiClient.imageSize(bytes)){
          _image.add(File(cropped!.path));
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
      if(isImage.length == _image.length){
        isImage.add(true);
        _image = _image;
      }

      print(" print == ::: $_image");
    //  print(_image!.lengthSync());
    });
  }

   String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

/*  Future getImageSize() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final bytes = pickedImage.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }    }); }*/
  // Get Delete Activity List
  getDelet(BuildContext context,id,unit) async{
    var url = Uri.parse(ApiClient.BASE_URL+"remove_dpr_whole_activity");
    Map map ={
      "act_id":"$id",
      "unit":unit,
      "daily_progress_id":"$dprId",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        getTodaysActivityList(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }
  }

  // Get Delete ManPower List
  getDeleteManPower(BuildContext context,id) async{
    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"dpr_remove_manpower");
    Map map ={
      "dpr_manpower_id":"$id",
      "daily_progress_id":"$dprId",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    Navigator.of(context).pop();
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        getTodaysManpower(context,1);
       // getTodaysMaterialList(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }
  }

  // Get Delete Material List
  getDeleteMaterial(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"remove_dpr_material");
    Map map ={
      "dpr_material_id":"$id",
      "daily_progress_id":"$dprId",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
      //  getTodaysManpower(context,1);
         getTodaysMaterialList(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }
  }

  deletePhoto(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"delete_dpr_photo");
    Map map ={
      "daily_progress_id":"$dprId",
      "photo_id":"$id",
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("response.statusCode : ${response.statusCode}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        //  getTodaysManpower(context,1);
      viewDprRemarkPhoto(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));
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

    }
  }

  addPhoto(BuildContext context) async {

    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var postUri = Uri.parse(ApiClient.BASE_URL + "dpr_add_remark_photos");

    try {
      var dio = Dio();

      print("1 ${_image[0].path}");
    //  print("2 ${_image[1].path}");

      var photo = [];
      for(int i = 0 ; i< _image.length; i++ ){
        photo.add({await MultipartFile.fromFile(_image[i].path, filename: 'img$i.jpg')}.toList());
      }

      FormData formData = FormData.fromMap({
        "daily_progress_id": "$dprId",
        "description": description.text,
        "photo_count": _image.length,
        "photo": photo
      });
      Map map = {
        "daily_progress_id": "$dprId",
        "description": description.text,
        "photo_count": _image.length,
        "photo": photo
      };
      print("map :: $map");

      dio.options.headers['Authorization'] = '$userToken';
      dio.options.headers['Content-Type'] = 'application/json';

      print("FormData  : $formData");

      final  response = await dio.post("$postUri",data: formData);
      print(response.data.toString());

      if (response.statusCode == 200) {
        Navigator.pop(context);
        _image.clear();
        isImage.clear();
        isImage.add(true);
        viewDprRemarkPhoto(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog("Remarks and Photos added successfully"));
        FocusScope.of(context).unfocus();
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog("Remarks and Photos Not Added"));
        FocusScope.of(context).unfocus();
        print("Not Uploaded!");
      }

    }on DioError catch (e) {
      print("Error : ${e.message}");
      print("Error : ${e}");
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog("Your network is very slow. Please try again"));
      FocusScope.of(context).unfocus();
    }




   /* var multipartRequest = new http.MultipartRequest('POST', postUri);

    multipartRequest.headers['Content-type'] = 'application/json';
    multipartRequest.headers['authorization'] = '$userToken';
    multipartRequest.fields['daily_progress_id'] = "$dprId";
    multipartRequest.fields['description'] = description.text;
    multipartRequest.fields['comments'] = rComments.text;

  //  print("_image!.path ==  ${_image[0]!.path}");

    //multipartRequest.files.add(new http.MultipartFile.fromBytes('photo', await MultipartFile.fromFile(data.foto.path, filename: "pic-name.png"),);
   // multipartRequest.files.add(new http.MultipartFile.fromBytes('file1', _image!.path));


     multipartRequest.files.add(new http.MultipartFile.fromBytes('photo',
        await File.fromUri(Uri.parse(_image[0]!.path)).readAsBytes(),
        filename: "${DateTime.now().millisecondsSinceEpoch}img.jpg"));


    multipartRequest.send().then((response) async {
      print("response == " + response.toString());
      print("response ==>>  " + response.statusCode.toString());
    //  Map decoded = jsonDecode(response.body);
     // response.stream.transform(utf8.decoder).listen((value) {
    //    print(value);

        print(await response.stream.transform(utf8.decoder).join());
      if (response.statusCode == 200) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog("Remarks and Photos added successfully"));
        FocusScope.of(context).unfocus();
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog("Remarks and Photos Not Added"));
        FocusScope.of(context).unfocus();
        print("Not Uploaded!");
      }
    });*/
  }

  // confirmation submit For Approval
  submitForApproval(BuildContext context) async{
    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"verify_dpr_submit");
    Map map ={
      "daily_progress_id":"$dprId",
      "role_id":ApiClient.roleID,
      "user_type":ApiClient.userType,
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    print("message' : ${decoded['message']}");
    print("response.statusCode == ' : ${response.statusCode}");
    Navigator.of(context).pop();
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        dprSubmit();
      }else{
        print("message' : ${decoded['message']}");
        if(decoded['token']){
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(decoded['message']));
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(decoded['message']));
    }
  }
  //  submit For Approval
  dprSubmit() async{
    showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"dpr_submit");
    Map map ={
      "daily_progress_id":"$dprId",
      "role_id":ApiClient.roleID,
      "user_type":ApiClient.userType,
      "revoke_comments":revokeWithComments.text,
    };
    print("map : ${jsonEncode(map)}");
    print("Authorization : ${userToken}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("Authorization : ${userToken}");
    print("decoded : ${decoded}");
    print("response.statusCode == ' : ${response.statusCode}");
    Navigator.of(context).pop();
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        Navigator.of(context).pop(true);
        showDialog(
            context: context,
            builder: (BuildContext context) => CustomDialog(decoded['message']));

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

    }
  }

  //  confirmation  Dialog
  submitForApprovalDialog(message) async{
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
                        splashColor: Colors.yellow[800],
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
                          dprSubmit();
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


  void callMap(BuildContext context) {
    _manpower.viewDprId(context,dprId,selectedDate);
  }
}

