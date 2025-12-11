import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doer/pages/view_photos.dart';
import 'package:doer/selection/building_selection.dart';
import 'package:doer/selection/project_selection.dart';
import 'package:doer/selection/stage_selection.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import '../selection/trade_selection.dart';
import '../util/colors_file.dart';

class ReraFillPage extends KFDrawerContent {
  var userToken, projectData, num;
  ReraFillPage(userToken, projectData, num) {
    this.userToken = userToken;
    this.projectData = projectData;
    this.num = num;
  }

  @override
  ReraFillPageState createState() =>
      ReraFillPageState(userToken, projectData, num);
}

class ReraFillPageState extends State<ReraFillPage> {
  var userToken, projectData, num;
  ReraFillPageState(userToken, projectData, num) {
    this.userToken = userToken;
    this.projectData = projectData;
    this.num = num;
  }

  List stageList = [];
  var particulars = "";
  var percentage = "";
  var selectedStage = "Select Stage";
  var selectedTrade = 'Select Trade';
  var selectedStageID = [];
  var tradeName = "Select trade", tradeID = 0;
  List viewReraList = [];

  final comments = TextEditingController();
  final FocusNode commentsFocus = FocusNode();

  List<File> _image = [];
  List<bool> isImage = [true];
  var selectedDate = "Select Date", status = 0, rera_id = 0;
  var doer_comments = " ", checker_comments = " ", revoker_comments = "";
  bool reraTeam = false;
  bool backOfficeTeam = false;

  final revokeWithComments = TextEditingController();
  final FocusNode revokeWithCommentsFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("num $num");
    print("projectData ::  $projectData");
    selectedDate = ApiClient.todaysDate(DateTime.now());
    if (num == 0) {
      getReraTrades(context);
      // getReraStages(context);
    } else {
      viewRera(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: app_color,
          height: 25 * SizeConfig.heightMultiplier,
        ),
        Column(children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        5 * SizeConfig.widthMultiplier,
                      ),
                      bottomRight: Radius.circular(
                        5 * SizeConfig.widthMultiplier,
                      )),
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
                              Text("RERA",
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  )),
                              Text(
                                  ApiClient.userName + " " + ApiClient.roleName,
                                  style: TextStyle(
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
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
          Expanded(
              flex: 14,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                        padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            Text("Project",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(
                              height: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            Text("${projectData['project_name']}",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox(
                              height: 1 * SizeConfig.heightMultiplier,
                            ),
                            Text("Building",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: app_color,
                                )),
                            SizedBox(
                              height: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            Text("${projectData['building_name']}",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.lightBlack,
                                )),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            num == 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select trade",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (tradesList.length >= 1) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    TradeSelection(
                                                      tradeList: tradesList,
                                                      onSelected: (name, id) {
                                                        print("name : $name");
                                                        print("id : $id");
                                                        setState(() {
                                                          tradeName = name;
                                                          tradeID = id;
                                                          getReraStages(
                                                              context, tradeID);
                                                        });
                                                      },
                                                    ));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialog(
                                                        "Stage List Not available"));
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
                                            padding: EdgeInsets.all(
                                                2 * SizeConfig.widthMultiplier),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(tradeName,
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
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        Text("Trade : $selectedTrade",
                                            style: TextStyle(
                                              fontSize: 1.8 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              color: CustomColor.lightBlack,
                                            )),
                                      ]),
                            num == 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Select Stage",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (stageList.length >= 1) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    StageSelection(
                                                      stageList: stageList,
                                                      onSelected: (name, id,
                                                          part, perc) {
                                                        print("name : $name");
                                                        print("id : $id");
                                                        print(
                                                            "particulars : $part");
                                                        print(
                                                            "percentage : $perc");
                                                        setState(() {
                                                          selectedStage = name;
                                                          selectedStageID = id;
                                                          particulars = part;
                                                          percentage = perc;
                                                        });
                                                      },
                                                    ));
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialog(
                                                        "Stage List Not available"));
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
                                            padding: EdgeInsets.all(
                                                2 * SizeConfig.widthMultiplier),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(selectedStage,
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
                                      particulars != ""
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 0.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                Text(
                                                    "Particulars : $particulars",
                                                    style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontFamily: 'Lato',
                                                      color: Colors.black,
                                                    )),
                                                SizedBox(
                                                  height: 1 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                                Text(
                                                    "Percentage : $percentage %",
                                                    style: TextStyle(
                                                      fontSize: 1.8 *
                                                          SizeConfig
                                                              .textMultiplier,
                                                      fontFamily: 'Lato',
                                                      color: Colors.black,
                                                    )),
                                                SizedBox(
                                                  height: 0.5 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      dateOfcompletion(),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Stage : $selectedStage",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: CustomColor.lightBlack,
                                          )),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      dateOfcompletion(),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      Text("Particulars : $particulars",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      Text("Percentage : $percentage %",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                    ],
                                  ),
                            SizedBox(
                                height: doer_comments != " "
                                    ? 1 * SizeConfig.heightMultiplier
                                    : 0),
                            doer_comments != " "
                                ? Text("Doer Comment : \n$doer_comments",
                                    style: TextStyle(
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: CustomColor.lightBlack,
                                    ))
                                : Container(),
                            SizedBox(
                                height: doer_comments != " "
                                    ? 1 * SizeConfig.heightMultiplier
                                    : 0),
                            checker_comments != " "
                                ? Text("Checker Comment : \n$checker_comments",
                                    style: TextStyle(
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: CustomColor.lightBlack,
                                    ))
                                : Container(),
                            revoker_comments != ""
                                ? Text("Revoker Comment : \n$revoker_comments",
                                    style: TextStyle(
                                      fontSize: 1.8 * SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      color: CustomColor.lightBlack,
                                    ))
                                : Container(),
                            SizedBox(
                              height: 2 * SizeConfig.heightMultiplier,
                            ),
                            Text("Upload Photo",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: Colors.black,
                                )),
                            ApiClient.userType == "1"
                                ?
                                    Text("Maximum 2 Images allowed",
                                style: TextStyle(
                                  fontSize: 1.8 * SizeConfig.textMultiplier,
                                  fontFamily: 'Lato',
                                  color: const Color.fromARGB(255, 178, 32, 21),
                                )):SizedBox(),
                            SizedBox(
                              height: 0.5 * SizeConfig.heightMultiplier,
                            ),
                            viewReraList.length >= 1
                                ? Wrap(
                                    children: [
                                      Container(
                                        height:
                                            12 * SizeConfig.heightMultiplier,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemCount: viewReraList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Container(
                                                  width: 35 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                  height: 10 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
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
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              width: 35 *
                                                                  SizeConfig
                                                                      .widthMultiplier,
                                                              height: 10 *
                                                                  SizeConfig
                                                                      .heightMultiplier,
                                                              child:
                                                                  Image.network(
                                                                ApiClient
                                                                        .IMG_BASE_URL +
                                                                    viewReraList[
                                                                            index]
                                                                        [
                                                                        'thumbnail_path'],
                                                                fit: BoxFit
                                                                    .cover,
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;

                                                                  return Center(
                                                                      child: Text(
                                                                          'Loading...'));
                                                                  // You can use LinearProgressIndicator or CircularProgressIndicator instead
                                                                },
                                                                errorBuilder: (context,
                                                                        error,
                                                                        stackTrace) =>
                                                                    Text(
                                                                        'Errors!'),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    List<String>
                                                                        imgList =
                                                                        [
                                                                      ApiClient
                                                                              .IMG_BASE_URL +
                                                                          viewReraList[index]
                                                                              [
                                                                              'photo_path']
                                                                    ];
                                                                    //imgList[0] = "${ApiClient.BASE_IMG_URL}${myOrderList['complaint_photo']}";
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              new PhotosViewPage(imgList)),
                                                                    );
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove_red_eye,
                                                                      color:
                                                                          app_color,
                                                                      size: 3 *
                                                                          SizeConfig
                                                                              .widthMultiplier,
                                                                    ),
                                                                    radius: 3 *
                                                                        SizeConfig
                                                                            .widthMultiplier,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                                /*  status == 3?InkWell(
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
                                                          ):Container(),*/
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
                                      ApiClient.userType == "1"
                                          ? status == 4
                                              ? Container(
                                                  height: 12 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding: EdgeInsets.zero,
                                                      shrinkWrap: true,
                                                      physics: ScrollPhysics(),
                                                      itemCount: isImage.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  get_image(
                                                                      ImageSource
                                                                          .camera);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: 35 *
                                                                      SizeConfig
                                                                          .widthMultiplier,
                                                                  height: 10 *
                                                                      SizeConfig
                                                                          .heightMultiplier,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(
                                                                      2 *
                                                                          SizeConfig
                                                                              .imageSizeMultiplier,
                                                                    )),
                                                                    // color: Color(0xFFba3d41),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: _image.length ==
                                                                                0 ||
                                                                            isImage.length ==
                                                                                (index +
                                                                                    1)
                                                                        ? Text(
                                                                            "Click to Upload\n the image",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 1.8 * SizeConfig.textMultiplier,
                                                                              fontFamily: 'Lato',
                                                                              color: Colors.black,
                                                                            ))
                                                                        : Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(
                                                                              2 * SizeConfig.imageSizeMultiplier,
                                                                            )),
                                                                            // color: Color(0xFFba3d41),
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                            image:
                                                                                new DecorationImage(
                                                                              image: FileImage(_image[index]),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          )),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 1 *
                                                                    SizeConfig
                                                                        .widthMultiplier,
                                                              ),
                                                              isImage.length ==
                                                                      (index +
                                                                          1)
                                                                  ? InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          get_image(
                                                                              ImageSource.camera);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.all(2 *
                                                                                SizeConfig.widthMultiplier),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              10 * SizeConfig.widthMultiplier,
                                                                          height:
                                                                              4 * SizeConfig.heightMultiplier,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(
                                                                              2 * SizeConfig.imageSizeMultiplier,
                                                                            )),
                                                                            // color: Color(0xFFba3d41),
                                                                            shape:
                                                                                BoxShape.rectangle,
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.grey,
                                                                              width: 1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: app_color,
                                                                              size: 3.0 * SizeConfig.heightMultiplier,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                )
                                              : Container()
                                          : ApiClient.userType == "2"
                                              ? status == 2 || status == 4
                                                  ? Container(
                                                      // height: 12 *
                                                      //     SizeConfig
                                                           //   .heightMultiplier,
                                                      // child: ListView.builder(
                                                      //     scrollDirection:
                                                      //         Axis.horizontal,
                                                      //     padding:
                                                      //         EdgeInsets.zero,
                                                      //     shrinkWrap: true,
                                                      //     physics:
                                                      //         ScrollPhysics(),
                                                      //     itemCount:
                                                      //         isImage.length,
                                                      //     itemBuilder:
                                                      //         (BuildContext
                                                      //                 context,
                                                      //             int index) {
                                                      //       return Padding(
                                                      //         padding:
                                                      //             const EdgeInsets
                                                      //                 .all(2.0),
                                                      //         child: Row(
                                                      //           children: [
                                                      //             InkWell(
                                                      //               onTap: () {
                                                      //                 get_image(
                                                      //                     ImageSource
                                                      //                         .camera);
                                                      //               },
                                                      //               child:
                                                      //                   Container(
                                                      //                 width: 35 *
                                                      //                     SizeConfig
                                                      //                         .widthMultiplier,
                                                      //                 height: 10 *
                                                      //                     SizeConfig
                                                      //                         .heightMultiplier,
                                                      //                 decoration:
                                                      //                     BoxDecoration(
                                                      //                   borderRadius:
                                                      //                       BorderRadius.all(Radius.circular(
                                                      //                     2 * SizeConfig.imageSizeMultiplier,
                                                      //                   )),
                                                      //                   // color: Color(0xFFba3d41),
                                                      //                   shape: BoxShape
                                                      //                       .rectangle,
                                                      //                   border:
                                                      //                       Border.all(
                                                      //                     color:
                                                      //                         Colors.grey,
                                                      //                     width:
                                                      //                         1,
                                                      //                   ),
                                                      //                 ),
                                                      //                 child:
                                                      //                     Center(
                                                      //                   child: _image.length == 0 ||
                                                      //                           isImage.length == (index + 1)
                                                      //                       ? Text("Click to Upload\ the image",
                                                      //                           style: TextStyle(
                                                      //                             fontSize: 1.8 * SizeConfig.textMultiplier,
                                                      //                             fontFamily: 'Lato',
                                                      //                             color: Colors.black,
                                                      //                           ))
                                                      //                       : Container(
                                                      //                           decoration: BoxDecoration(
                                                      //                           borderRadius: BorderRadius.all(Radius.circular(
                                                      //                             2 * SizeConfig.imageSizeMultiplier,
                                                      //                           )),
                                                      //                           // color: Color(0xFFba3d41),
                                                      //                           shape: BoxShape.rectangle,
                                                      //                           image: new DecorationImage(
                                                      //                             image: FileImage(_image[index]),
                                                      //                             fit: BoxFit.cover,
                                                      //                           ),
                                                      //                         )),
                                                      //                 ),
                                                      //               ),
                                                      //             ),
                                                      //             SizedBox(
                                                      //               width: 1 *
                                                      //                   SizeConfig
                                                      //                       .widthMultiplier,
                                                      //             ),
                                                      //             isImage.length ==
                                                      //                     (index +
                                                      //                         1)
                                                      //                 ? InkWell(
                                                      //                     onTap:
                                                      //                         () {
                                                      //                       setState(() {
                                                      //                         get_image(ImageSource.camera);
                                                      //                       });
                                                      //                     },
                                                      //                     child:
                                                      //                         Padding(
                                                      //                       padding:
                                                      //                           EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                                                      //                       child:
                                                      //                           Container(
                                                      //                         width: 10 * SizeConfig.widthMultiplier,
                                                      //                         height: 4 * SizeConfig.heightMultiplier,
                                                      //                         decoration: BoxDecoration(
                                                      //                           borderRadius: BorderRadius.all(Radius.circular(
                                                      //                             2 * SizeConfig.imageSizeMultiplier,
                                                      //                           )),
                                                      //                           // color: Color(0xFFba3d41),
                                                      //                           shape: BoxShape.rectangle,
                                                      //                           border: Border.all(
                                                      //                             color: Colors.grey,
                                                      //                             width: 1,
                                                      //                           ),
                                                      //                         ),
                                                      //                         child: Center(
                                                      //                           child: Icon(
                                                      //                             Icons.add,
                                                      //                             color: app_color,
                                                      //                             size: 3.0 * SizeConfig.heightMultiplier,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   )
                                                      //                 : Container()
                                                      //           ],
                                                      //         ),
                                                      //       );
                                                      //     }),
                                                    )
                                                  : Container()
                                              : Container()
                                    ],
                                  )
                                : Container(
                                    height: 12 * SizeConfig.heightMultiplier,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        itemCount: isImage.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    get_image(
                                                        ImageSource.camera);
                                                  },
                                                  child: Container(
                                                    width: 35 *
                                                        SizeConfig
                                                            .widthMultiplier,
                                                    height: 10 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
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
                                                      child: _image.length ==
                                                                  0 ||
                                                              isImage.length ==
                                                                  (index + 1)
                                                          ? Text(
                                                              "Click to Upload\n the image",
                                                              style: TextStyle(
                                                                fontSize: 1.8 *
                                                                    SizeConfig
                                                                        .textMultiplier,
                                                                fontFamily:
                                                                    'Lato',
                                                                color: Colors
                                                                    .black,
                                                              ))
                                                          : Container(
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
                                                              image:
                                                                  new DecorationImage(
                                                                image: FileImage(
                                                                    _image[
                                                                        index]),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            )),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 1 *
                                                      SizeConfig
                                                          .widthMultiplier,
                                                ),
                                                isImage.length == (index + 1)
                                                    ? InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            get_image(
                                                                ImageSource
                                                                    .camera);
                                                          });
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(2 *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          child: Container(
                                                            width: 10 *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            height: 4 *
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
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                color:
                                                                    app_color,
                                                                size: 3.0 *
                                                                    SizeConfig
                                                                        .heightMultiplier,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                            ApiClient.userType == "1" &&
                                    (status == 0 || status == 4)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 2 * SizeConfig.heightMultiplier,
                                      ),
                                      Text("Comments",
                                          style: TextStyle(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            color: Colors.black,
                                          )),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      Container(
                                        width: 94 * SizeConfig.widthMultiplier,
                                        height:
                                            10 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(
                                            2 * SizeConfig.imageSizeMultiplier,
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
                                                    SizeConfig.widthMultiplier,
                                                height: 10 *
                                                    SizeConfig.heightMultiplier,
                                                child: TextFormField(
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
                                        height: 6 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            color: app_color,
                                            splashColor: app_color,
                                            minWidth:
                                                28 * SizeConfig.widthMultiplier,
                                            height: 4.7 *
                                                SizeConfig.heightMultiplier,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.8 *
                                                        SizeConfig
                                                            .widthMultiplier)),
                                            child: Text('Send to RERA Checker',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier)),
                                            onPressed: () async {
                                              try {
                                                if (isImage.length <= 3) {
                                                  final result =
                                                  await InternetAddress
                                                      .lookup('google.com');

                                                  if (result.isNotEmpty &&
                                                      result[0]
                                                          .rawAddress
                                                          .isNotEmpty) {
                                                    if (selectedStage !=
                                                        "Select Stage") {
                                                      if (_image.length >= 1) {
                                                        if (!comments
                                                            .text.isEmpty) {
                                                          // saveRERA(context,2);
                                                          submitForApprovalDialog(
                                                              "Are you sure want to submit for RERA Checker",
                                                              2);
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (
                                                                  BuildContextcontext) =>
                                                                  CustomDialog(
                                                                      "Comments is required"));
                                                        }
                                                      } else {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (
                                                                BuildContextcontext) =>
                                                                CustomDialog(
                                                                    "Photo is required"));
                                                      }
                                                    } else {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (
                                                              BuildContextcontext) =>
                                                              CustomDialog(
                                                                  "Select Stage is required"));
                                                    }
                                                  }
                                                }else {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (
                                                          BuildContextcontext) =>
                                                          CustomDialog(
                                                              "Please select only 2 images"));
                                                }
                                              }on SocketException catch (_) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialog(
                                                            "Check internet connection"));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : ApiClient.userType == "2" &&
                                        (status == 0 ||
                                            status == 2 ||
                                            status == 4 ||
                                            status == 5)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height:
                                                2 * SizeConfig.heightMultiplier,
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
                                            width:
                                                94 * SizeConfig.widthMultiplier,
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
                                                      controller: comments,
                                                      cursorColor: Colors.black,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      focusNode: commentsFocus,
                                                      maxLines: 3,
                                                      onFieldSubmitted:
                                                          (value) {
                                                        commentsFocus.unfocus();
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
                                            height:
                                                6 * SizeConfig.heightMultiplier,
                                          ),
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
                                                    SizeConfig.widthMultiplier,
                                                height: 4.7 *
                                                    SizeConfig.heightMultiplier,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(1.8 *
                                                            SizeConfig
                                                                .widthMultiplier)),
                                                child: Text('Approval',
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
                                                    if (result.isNotEmpty &&
                                                        result[0]
                                                            .rawAddress
                                                            .isNotEmpty) {
                                                      if (selectedStage !=
                                                          "Select Stage") {
                                                        if (!comments
                                                            .text.isEmpty) {
                                                          // saveRERA(context,3);
                                                          submitForApprovalDialog(
                                                              "Are you sure want to approve?",
                                                              3);
                                                        } else {
                                                          showDialog(
                                                              context:
                                                              context,
                                                              builder: (
                                                                  BuildContextcontext) =>
                                                                  CustomDialog(
                                                                      "Comments is required"));
                                                        }
                                                      } else {
                                                        showDialog(
                                                            context: context,
                                                            builder: (
                                                                BuildContextcontext) =>
                                                                CustomDialog(
                                                                    "Select Stage is required"));
                                                      }
                                                    }
                                                  }
                                                    on SocketException catch (_) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CustomDialog(
                                                                "Check internet connection"));
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                width: 2 *
                                                    SizeConfig.widthMultiplier,
                                              ),
                                              MaterialButton(
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
                                                        await InternetAddress
                                                            .lookup(
                                                                'google.com');
                                                    if (result.isNotEmpty &&
                                                        result[0]
                                                            .rawAddress
                                                            .isNotEmpty) {
                                                      if (selectedStage !=
                                                          "Select Stage") {
                                                        if (!comments
                                                            .text.isEmpty) {
                                                          //  saveRERA(context,4);
                                                          submitForApprovalDialog(
                                                              "Are you sure want to Reject?",
                                                              4);
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContextcontext) =>
                                                                  CustomDialog(
                                                                      "Comments is required"));
                                                        }
                                                      } else {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContextcontext) =>
                                                                CustomDialog(
                                                                    "Select Stage is required"));
                                                      }
                                                    }
                                                  } on SocketException catch (_) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CustomDialog(
                                                                "Check internet connection"));
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                            ApiClient.userType == "4" && status == 3
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 1 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        children: [
                                          Text("Revoke with comment:",
                                              style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color: Colors.black,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height:
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      Container(
                                        width: 94 * SizeConfig.widthMultiplier,
                                        height:
                                            10 * SizeConfig.heightMultiplier,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(
                                            2 * SizeConfig.imageSizeMultiplier,
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
                                                    SizeConfig.widthMultiplier,
                                                height: 10 *
                                                    SizeConfig.heightMultiplier,
                                                child: TextFormField(
                                                  style: new TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .heightMultiplier,
                                                    fontFamily: 'Lato',
                                                  ),
                                                  controller:
                                                      revokeWithComments,
                                                  cursorColor: Colors.black,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  focusNode:
                                                      revokeWithCommentsFocus,
                                                  maxLines: 3,
                                                  onFieldSubmitted: (value) {
                                                    revokeWithCommentsFocus
                                                        .unfocus();
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
                                            0.5 * SizeConfig.heightMultiplier,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          MaterialButton(
                                            color: app_color,
                                            splashColor: app_color,
                                            minWidth:
                                                28 * SizeConfig.widthMultiplier,
                                            height: 4.7 *
                                                SizeConfig.heightMultiplier,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(1.8 *
                                                        SizeConfig
                                                            .widthMultiplier)),
                                            child: Text('Revoke',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2 *
                                                        SizeConfig
                                                            .textMultiplier)),
                                            onPressed: () async {
                                              try {
                                                final result =
                                                    await InternetAddress
                                                        .lookup('google.com');
                                                if (result.isNotEmpty &&
                                                    result[0]
                                                        .rawAddress
                                                        .isNotEmpty) {
                                                  // saveRERA(context,5);
                                                  if (!revokeWithComments
                                                      .text.isEmpty) {
                                                    submitForApprovalDialog(
                                                        "Are you sure want to Revoke?",
                                                        5);
                                                  } else {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CustomDialog(
                                                                "Please enter revoker comment"));
                                                  }
                                                }
                                              } on SocketException catch (_) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialog(
                                                            "Check internet connection"));
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: 6 * SizeConfig.heightMultiplier,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ]),
      ],
    ));
  }

  List tradesList = [];
  getReraTrades(BuildContext context) async {
    var url = Uri.parse(ApiClient.BASE_URL + "get_rera_trades");
    Map map = {
      "role_id": ApiClient.roleID,
      "user_type": "${ApiClient.userType}",
      "project_id": "${projectData['project_id']}",
      "building_id": "${projectData['building_id']}",
    };
    //log(map as String);
    print("map getReraStages : ${jsonEncode(map)}");
    print("map getReraStages : ${ApiClient.BASE_URL + "get_rera_trades"}");
    print("map getReraStages : ${userToken}");
    var response = await http.post(url,
        headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded getReraStages :${jsonEncode(decoded)}");
    tradesList = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        setState(() {
          tradesList = decoded['data'];
        });
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

  getReraStages(BuildContext context, tradeID) async {
    var url = Uri.parse(ApiClient.BASE_URL + "get_rera_stages");
    Map map = {
      "role_id": ApiClient.roleID,
      "user_type": "${ApiClient.userType}",
      "project_id": "${projectData['project_id']}",
      "building_id": "${projectData['building_id']}",
      "selectedTrade": "$tradeID",
    };
    print("map getReraStages : ${map}");
    var response = await http.post(url,
        headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded getReraStages : ${decoded}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        setState(() {
          stageList = decoded['data'];
        });
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

  viewRera(BuildContext context) async {
    var url = Uri.parse(ApiClient.BASE_URL + "view_rera");
    print(url);
    Map map = {
      "role_id": ApiClient.roleID,
      "user_type": "${ApiClient.userType}",
      "project_id": "${projectData['project_id']}",
      "building_id": "${projectData['building_id']}",
      "rera_id": "${projectData['id']}",
      "stage_id": "${projectData['stage_id']}",
    };
    print("map : ${jsonEncode(map)}");
    print("userToken : $userToken");
    var response = await http.post(url,
        headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded view Rera : ${decoded}");
    log("decoded view Rera : ${decoded}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (decoded['status']) {
        setState(() {
          particulars = decoded['data'][0]['particulars'];
          percentage = "${decoded['data'][0]['percentage']}";
          viewReraList = decoded['data'][0]['rera_photos'];
          selectedStage = "${decoded['data'][0]['stage_no']}";
          selectedTrade = "${decoded['data'][0]['trade_name']}";
          var addstage = decoded['data'][0]['stage_id'];
          selectedStageID.add(addstage);
          selectedDate = decoded['data'][0]['completion_date'];
          status = decoded['data'][0]['status'];
          doer_comments = decoded['data'][0]['doer_comments'];
          checker_comments = decoded['data'][0]['checker_comments'];
          revoker_comments = decoded['data'][0]['revoke_comments'];
          rera_id = projectData['id'];
        });
        log("---particulars$particulars");
        log("---percentage$percentage");
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

  saveRERA(BuildContext context, sta) async {
    var commentss;
    if (sta == 5) {
      commentss = revokeWithComments.text;
    } else {
      commentss = comments.text;
    }

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CustomDialogLoading());
    var postUri = Uri.parse(ApiClient.BASE_URL + "save_rera_stages");

    try {
      var dio = Dio();

      print("_image.length ${_image.length}");
      //  print("2 ${_image[1].path}");
      var photo = [];
      if (_image.length >= 1) {
        for (int i = 0; i < _image.length; i++) {
          log('in if image');
          photo.add({
            await MultipartFile.fromFile(_image[i].path, filename: 'img$i.jpg')
          }.toList());
        }
      }

      Map map = {
        "status": "$sta",
        "rera_id": "$rera_id",
        "revoker_comments": revokeWithComments.text,
        "role_id": ApiClient.roleID,
        "user_type": "${ApiClient.userType}",
        "project_id": "${projectData['project_id']}",
        "building_id": "${projectData['building_id']}",
        "selectedTrade": tradeID,
        "stage_id": selectedStageID,
        "date": selectedDate,
        "comments": commentss,
        "photo_count": _image.length,
        "photo": photo
      };

      List aaaa = [];
      for (int i = 0; i < selectedStageID.length; i++) {
        Map map = {
          "s_id": selectedStageID[i],
        };
        aaaa.add(map);
      }

      print("FormData map : $map");
      print("selectedStageID =====: ${selectedStageID.length}");
      print("aaaa =====: ${aaaa.length}");
      print("aaaa =====: ${aaaa}");

      FormData formData = FormData.fromMap({
        "status": "$sta",
        "rera_id": "${projectData['id']}",
        "revoker_comments": revokeWithComments.text,
        "role_id": ApiClient.roleID,
        "user_type": "${ApiClient.userType}",
        "project_id": "${projectData['project_id']}",
        "building_id": "${projectData['building_id']}",
        "selectedTrade": tradeID,
        "stage_id": aaaa,
        "date": selectedDate,
        "comments": commentss,
        "photo_count": _image.length,
        "photo": photo
      });
      dio.options.headers['Authorization'] = '$userToken';
      dio.options.headers['Content-Type'] = 'application/json';

      print("selectedStageID : $selectedStageID");
      print("FormData  fields : ${formData.fields}");
      print("FormData files  : ${formData.files}");

      final response = await dio.post("$postUri", data: formData);

      print("response =======  : ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context);
        Navigator.pop(context, true);

        showDialog(
            context: context,
            builder: (BuildContext context) =>
                CustomDialog(response.data['message']));
        FocusScope.of(context).unfocus();
      } else {
        Navigator.pop(context);
        Navigator.pop(context, true);
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                CustomDialog(response.data['message']));
        FocusScope.of(context).unfocus();
        print("Not Uploaded!");
      }
    } on DioError catch (e) {
      print("Error : ${e.message}");
      print("Error : ${e}");
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog("Not Added"));
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

  bool _inProcess = false;

  get_image(ImageSource source) async {
    print("fgdhg");

    this.setState(() {
      _inProcess = true;
    });
    var image = await ImagePicker()
        .pickImage(source: source, maxHeight: 592, maxWidth: 360); // moto x4
    // var image = await ImagePicker.pickImage( imageQuality: 90, source: ImageSource.camera, );
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
              backgroundColor: Colors.white,
            )
          ]);

      final bytes = (await image.readAsBytes()).lengthInBytes;
      this.setState(() {
        if (ApiClient.imageSize(bytes)) {
          _image.add(File(cropped!.path));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                  "Failed to upload an image. The image maximum size is 2MB."));
        }

        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }

    setState(() {
      if (isImage.length == _image.length) {
        isImage.add(true);
        _image = _image;
      }

      print(" print == ::: $_image");
      //  print(_image!.lengthSync());
    });
  }

  //  confirmation  Dialog
  submitForApprovalDialog(message, flag) async {
    showDialog(
        context: context,
        builder: (dialogContex) {
          return AlertDialog(
            content: Container(
              height: 25 * SizeConfig.heightMultiplier,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 2 * SizeConfig.heightMultiplier,
                  ),
                  Text('$message',
                      style: TextStyle(
                        fontSize: 2 * SizeConfig.textMultiplier,
                        color: Colors.black,
                      )),
                  SizedBox(
                    height: 5 * SizeConfig.heightMultiplier,
                  ),
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
                              borderRadius: BorderRadius.circular(
                                  2.8 * SizeConfig.widthMultiplier),
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
                          minWidth: 28 * SizeConfig.widthMultiplier,
                          height: 4.7 * SizeConfig.heightMultiplier,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  1.8 * SizeConfig.widthMultiplier)),
                          child: Text('Yes',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 2 * SizeConfig.textMultiplier)),
                          onPressed: () {
                            //  Navigator.pop(context);
                            Navigator.of(context).pop();
                            saveRERA(context, flag);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  dateOfcompletion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Date of Completion",
            style: TextStyle(
              fontSize: 1.8 * SizeConfig.textMultiplier,
              fontFamily: 'Lato',
              color: Colors.black,
            )),
        SizedBox(
          height: 0.5 * SizeConfig.heightMultiplier,
        ),
        GestureDetector(
          onTap: () async {
            DateTime dateToday = DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 23, 59, 59);

            print("dateToday : $dateToday");

            DateTime? newDateTime = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day - 30),
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
                        dayBackgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return app_color;
                          }
                          return Colors.white;
                        }),
                      )),
                  child: child!,
                );
              },
            );
            if (newDateTime != null) {
              setState(() {
                print("newDateTime : $newDateTime");
                selectedDate = ApiClient.todaysDate(newDateTime);
              });
            }
          },
          child: Container(
            width: 94 * SizeConfig.widthMultiplier,
            // height: 7 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                2 * SizeConfig.imageSizeMultiplier,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${ApiClient.dataFormatYear(selectedDate)}",
                      style: TextStyle(
                        fontSize: 1.8 * SizeConfig.textMultiplier,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      )),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: app_color,
                    size: 3.0 * SizeConfig.heightMultiplier,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
