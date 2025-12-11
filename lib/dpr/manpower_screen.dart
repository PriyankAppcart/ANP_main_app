import 'dart:convert';
import 'dart:io';

import 'package:doer/style/text_style.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/pages/login_page.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ManpowerPage extends StatefulWidget {

  var userToken,projectData,selectedDate,dprId;
  ManpowerPage(projectData,userToken,selectedDate,dprId) {
    this.projectData = projectData;
    this.userToken = userToken;
    this.selectedDate = selectedDate;
    this.dprId = dprId;
  }

  @override
  ManpowerPageState createState() => ManpowerPageState(projectData,userToken,selectedDate,dprId);

}

class ManpowerPageState extends State<ManpowerPage> {

  var userToken,projectData,selectedDate,dprId;
  ManpowerPageState(projectData,userToken,selectedDate,dprId) {
    this.projectData = projectData;
    this.userToken = userToken;
    this.selectedDate = selectedDate;
    this.dprId = dprId;
  }

  var selectedManpower = "Select Manpower",selectedManpowerID,editManpowerId,isEditManpower = false,approved;
  List manPowerList = [];
  List manPowerTodayList = [];
  var selectedContractor = "Select Contractor",selectedContractorID;
  List contractorList = [];

  final skilledWorkers = TextEditingController();
  final FocusNode skilledWorkersFocus = FocusNode();
  final unSkilledWorkers = TextEditingController();
  final FocusNode unSkilledWorkersFocus = FocusNode();
  final comments = TextEditingController();
  final FocusNode commentsFocus = FocusNode();

  void viewDprId (BuildContext context,id, date){
    context.findRootAncestorStateOfType<ManpowerPageState>();
    print("id :: $id");
    print("date :: $date");
   setState(() {
      selectedDate = date;
      dprId = id;
    });
    getTodaysManpower(context,1);
  }

  @override
  void initState() {
    // TODO: implement initState
    ApiClient.drawerFlag = "0";
    super.initState();
    getManpowerList(context);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return  Column(
      mainAxisAlignment:
      MainAxisAlignment.start,
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text("Select Manpower",
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
            selectManpower(context);
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
                    color: Color(0xFFf07c01),
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
                    color: Color(0xFFf07c01),
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
          height:
          6 * SizeConfig.heightMultiplier,
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
          height:
          6* SizeConfig.heightMultiplier,
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
              color: Color(0xFFf07e01),
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
                            width: 80 * SizeConfig.widthMultiplier,
                            child: Text(manPowerTodayList[index]['man_power_name'],
                                style: DTextStyle.bodyLineBold),
                          ),
                          approved == 0?IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color(0xFFf07c01),
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
                                getContractorList(context,selectedManpowerID);
                              });
                            },
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
    );


  }
// Select ManPower Dialog
  selectManpower(BuildContext context) async{
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
                                getContractorList(context,selectedManpowerID);
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
                                  Text("${manPowerList[index]['man_power_name']}",
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

  // Select Contractor Dialog
  selectContractor(BuildContext context) async{
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
                height: 80 * SizeConfig.heightMultiplier,
                width: 100 * SizeConfig.widthMultiplier,
                color: Colors.white,
                child: new ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: contractorList.length,
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return check(contractorList[index]['id'],contractorList[index]['manpower_id'])?Container():Container(
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
  getTodaysManpower(BuildContext context, num) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_todays_manpower");
    Map map = {
      "date":selectedDate,
      "daily_progress_id":"$dprId"};
    print("manPowerTodayList map : ${map}");
    print("manPowerTodayList userToken : ${userToken}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("manPowerTodayList : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
          setState(() {
            this.approved = decoded['approved'];
            this.manPowerTodayList = decoded['manpower_list'];
          });


      }else{
        if(decoded['token']){
          if(num == 2){
            showDialog(
                context: context,
                builder: (BuildContext context) => CustomDialog(decoded['message']));
          }
        }else{
        //  showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }

  // APIs for get Contractor
  getContractorList(BuildContext context,id) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_contractor_lists");
    Map map ={
      "manpower_id":"$id"
    };
    print("map : ss ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
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

    }else{

    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }


}
