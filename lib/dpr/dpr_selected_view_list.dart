
import 'dart:convert';
import 'dart:io';

import 'package:doer/quality_checklist/qc_list.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import '../util/colors_file.dart';

class DPRSelectedViewListPage extends KFDrawerContent {

  var title,userToken;
  var color,status,projectData;
  DPRSelectedViewListPage(title,userToken, Color color,status,projectData){
    this.title = title;
    this.userToken = userToken;
    this.color = color;
    this.status = status;
    this.projectData = projectData;
  }

  @override
  DPRSelectedViewListPageState createState() => DPRSelectedViewListPageState(title,userToken,color,status,projectData);
}

class DPRSelectedViewListPageState extends State<DPRSelectedViewListPage> {

  var title,userToken;
  var color,status,projectData;
  DPRSelectedViewListPageState(title,userToken,color,status,projectData){
    this.title = title;
    this.userToken = userToken;
    this.color = color;
    this.status = status;
    this.projectData = projectData;
  }

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;
  List DPRCollection = [];
  List DatewiseDPR = [];
  var selectedDate;
  var selectFromDate = "From Date",selectToDate = "TO Date";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiCall(context);
  }
  apiCall(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
        getDPRProgress(context,0);
        getDatewiseDPR(context);
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
                          Text(title,
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
              child: internetConnection?apiStustFlag?apiFlag?
              Column(
                children: [
                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                  Row(
                    children: [
                      SizedBox(width:2 * SizeConfig.widthMultiplier,),
                      /*  Text("Select Date",
                              style: TextStyle(
                                fontSize: 1.8 *
                                    SizeConfig.textMultiplier,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),*/
                      GestureDetector(
                        onTap: () async {
                          getDate(context,1);
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
                                }}
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

                              selectFromDate =  ApiClient.todaysDate(newDateTime);

                            });
                          }
                        },
                        child: Container(
                          width: 32 * SizeConfig.widthMultiplier,
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
                                Container(
                                  child: Text(selectFromDate != "From Date"?"${ApiClient.dataFormatYear(selectFromDate)}":selectFromDate,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig
                                                .textMultiplier,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      )),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  color: app_color,
                                  size: 5.0 *
                                      SizeConfig.imageSizeMultiplier,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      GestureDetector(
                        onTap: () async {
                          getDate(context,1);
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
                                }}
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

                              selectToDate =  ApiClient.todaysDate(newDateTime);

                            });
                          }
                        },
                        child: Container(
                          width: 32 * SizeConfig.widthMultiplier,
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

                                  child: Text(selectToDate != "TO Date"?"${ApiClient.dataFormatYear(selectToDate)}":selectToDate,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig
                                                .textMultiplier,
                                        fontFamily: 'Lato',
                                        color: Colors.black,
                                      )),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.calendarAlt,
                                  color: app_color,
                                  size: 5.0 *
                                      SizeConfig.imageSizeMultiplier,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                      MaterialButton(
                        color: app_color,
                        splashColor: app_color,

                        height: 4.7 *
                            SizeConfig.heightMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .circular(1.8 *
                                SizeConfig
                                    .widthMultiplier)),
                        child: Text('Filter',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 2 *
                                    SizeConfig
                                        .textMultiplier)),
                        onPressed: ()  {
                          // selectFromDate = "From Date",selectToDate = "TO Date";
                          if(selectFromDate != "From Date"){
                            if(selectToDate != "TO Date"){
                              getDPRProgress(context,1);
                            }else{
                              showDialog(context: context,builder: (BuildContext
                              context) =>
                                  CustomDialog("Select TO Date is required"));
                            }
                          }else{
                            showDialog(context: context,builder: (BuildContext
                            context) =>
                                CustomDialog("Select From Date is required"));
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                  DPRCollection.length >=1?ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: DPRCollection.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  InkWell(
                          onTap: ()async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new DprDetailsPage(userToken,projectData,DPRCollection[index]['dpr_date'])));
                            if(result != null || result == null){
                              getDPRProgress(context,0);
                              getDatewiseDPR(context);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3 * SizeConfig.widthMultiplier),
                            child: Container(
                              width:  100 * SizeConfig.widthMultiplier,
                              //  height: 13 * SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  3 * SizeConfig.imageSizeMultiplier,
                                )),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0.0, 0.75))
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:  3 * SizeConfig.widthMultiplier,
                                    height: 10 * SizeConfig.heightMultiplier,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            3 * SizeConfig.imageSizeMultiplier,
                                          ),
                                          bottomLeft: Radius.circular(
                                            3 * SizeConfig.imageSizeMultiplier,
                                          )
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0.0, 0.75))
                                      ],
                                      color: color,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                                    child: Container(
                                      width: 87 * SizeConfig.widthMultiplier,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(DPRCollection[index]['report_code'],
                                              style: TextStyle(
                                                fontSize: 1.8 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color: Colors.black,
                                              )),
                                          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(ApiClient.dataFormatYear(DPRCollection[index]['dpr_date']),
                                                  style: TextStyle(
                                                    fontSize: 1.8*
                                                        SizeConfig.textMultiplier,
                                                    fontFamily: 'MyriadPro',
                                                  )),
                                              status == "4"?Text(DPRCollection[index]['revoked'] == 1?"Revoked":"Approved",
                                                  style: TextStyle(
                                                    fontSize: 1.8*
                                                        SizeConfig.textMultiplier,
                                                    fontFamily: 'MyriadPro',
                                                  )):Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  :Container(
                      height: 75 * SizeConfig.heightMultiplier,
                      width: 95 * SizeConfig.widthMultiplier,
                      child: Column(children: [
                        SizedBox(height: 20 * SizeConfig.heightMultiplier),
                        Image.asset('assets/icons/no_data_found.png',
                          height: 20 * SizeConfig.widthMultiplier,
                          width: 20 * SizeConfig.widthMultiplier,),
                        SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                        Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 2.2 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',)),
                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                        Text("There is no $title data found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                        SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

                      ])
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
                    Text(title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',)),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Text("There is no $title data found",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                    SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

                  ])
              )
              :Center(child: Container(height:80 * SizeConfig.heightMultiplier, child: CustomDialogLoading1(),))
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
              ],))))

        ])
    );
  }

// APIs for get date wise dpr progress
  getDPRProgress(BuildContext context,num) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_data_dpr_status");
    Map map;
    if(num == 0){
      map ={
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "status":"$status"
      };
    }else{
      map ={
        "project_id":"${projectData['project_id']}",
        "building_id":"${projectData['building_id']}",
        "status":"$status",
        "from_date":selectFromDate,
        "to_date":selectToDate

      };
    }
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("DatewiseDPR == : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          DPRCollection = decoded['data'];
          apiFlag = true;
          apiStustFlag = true;
        });
      }else{
        setState(() {
          apiStustFlag = false;
        });
        if(!decoded['token']){
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }
  }
  // APIs for get date wise dpr progress
  getDatewiseDPR(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_datewise_dpr_progress");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "status":"$status"
    };
    print("map : ${map}");
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

  void getDate(BuildContext context, int i) {}
}
