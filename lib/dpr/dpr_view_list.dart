
import 'dart:convert';
import 'dart:io';

import 'package:doer/dpr/dpr_selected_view_list.dart';
import 'package:doer/widgets/CustomDialog.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import '../util/colors_file.dart';

class DPRViewListPage extends KFDrawerContent {

  var userToken,projectData;
  DPRViewListPage(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  @override
  DPRViewListPageState createState() => DPRViewListPageState(userToken,projectData);
}

class DPRViewListPageState extends State<DPRViewListPage> {

  var userToken,projectData;
  DPRViewListPageState(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;
  List DPRCollection = [];
  var total_dpr = 0,in_progress_dpr_count = 0,submitted_dpr_count=0,approved_dpr_count=0,revoked_dpr_count = 0;
  var _isVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

 /*   if(ApiClient.userType == "1"){
      _isVisible = true;
    }*/
    apiCall(context);
  }
  apiCall(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
        getDPRProgress(context);
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
                          Text("DPR-Project",
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
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                              Text("Total Count",
                                  style: TextStyle(
                                    fontSize: 1.8 *
                                        SizeConfig.textMultiplier,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                              SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                              Text("${total_dpr}",
                                  style: TextStyle(
                                    fontSize: 2 *
                                        SizeConfig.textMultiplier,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF474747),
                                  )),
                            ],
                          ),),

                        Expanded(
                          child: InkWell(
                            onTap: (){
                              if(approved_dpr_count == 0){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => CustomDialog("There is no any DPR Approved"));
                              }else{
                                getSelectedList(context,"DPR Approved",Colors.green,3);
                              }
                            },
                            child: Row(
                              children: [
                                Text("Approved",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                Text("$approved_dpr_count",
                                    style: TextStyle(
                                      fontSize: 2 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),)
                      ],
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              if(in_progress_dpr_count == 0){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => CustomDialog("There is no any DPR in progress"));
                              }else{
                                print("ApiClient.userType :: "+ApiClient.userType);
                                if(ApiClient.userType == "2") {
                                  getSelectedList(context, "DPR In Progress",app_color, 1);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                                Text("In Progress",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                Text("${in_progress_dpr_count}",
                                    style: TextStyle(
                                      fontSize: 2 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                              ],
                            ),
                          ),),

                        Expanded(
                          child: InkWell(
                            onTap: (){
                              if(submitted_dpr_count == 0){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => CustomDialog("There is no any DPR Submitted"));
                              }else{
                               if(ApiClient.userType == "1") {
                                 getSelectedList(
                                     context, "DPR Submitted", Colors.red, 2);
                               }
                              }
                            },
                            child: Row(
                              children: [
                                Text(ApiClient.userType == "1"?"Submitted":"For Review",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                Text("$submitted_dpr_count",
                                    style: TextStyle(
                                      fontSize: 2 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          ),)
                      ],
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              if(revoked_dpr_count == 0){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => CustomDialog("There is no any DPR in Revoked"));
                              }else{
                                print("ApiClient.userType :: "+ApiClient.userType);
                                if(ApiClient.userType == "2") {
                                  getSelectedList(context, "DPR In Revoked",app_color, 4);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                                Text("Revoked",
                                    style: TextStyle(
                                      fontSize: 1.8 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                Text("${revoked_dpr_count}",
                                    style: TextStyle(
                                      fontSize: 2 *
                                          SizeConfig.textMultiplier,
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      color: app_color,
                                    )),
                              ],
                            ),
                          ),),
                      ],
                    ),
                    SizedBox(height: 2 * SizeConfig.heightMultiplier,),
                    ApiClient.userType == "1"?
                        in_progress_dpr_count == 0 ?
                                Container(
                                height: 75 * SizeConfig.heightMultiplier,
                                width: 95 * SizeConfig.widthMultiplier,
                                child: Column(children: [
                                  SizedBox(height: 20 * SizeConfig.heightMultiplier),
                                  Image.asset('assets/icons/no_data_found.png',
                                    height: 20 * SizeConfig.widthMultiplier,
                                    width: 20 * SizeConfig.widthMultiplier,),
                                  SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                                  Text(ApiClient.userType == "1"?"In Progress DPR":"For Review Progress DPR",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 2.2 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',)),
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Text("There is no DPR in progress",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                                  SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

                                ])
                            )
                            :ListView.builder(
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
                                    getDPRProgress(context);
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
                                            color: ApiClient.userType == "1"?app_color:Colors.red,
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
                                                Text(ApiClient.dataFormatYear(DPRCollection[index]['dpr_date']),
                                                    style: TextStyle(
                                                      fontSize: 1.8*
                                                          SizeConfig.textMultiplier,
                                                      fontFamily: 'MyriadPro',
                                                    )),
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
                       :submitted_dpr_count == 0?
                        Container(
                            height: 75 * SizeConfig.heightMultiplier,
                            width: 95 * SizeConfig.widthMultiplier,
                            child: Column(children: [
                              SizedBox(height: 20 * SizeConfig.heightMultiplier),
                              Image.asset('assets/icons/no_data_found.png',
                                height: 20 * SizeConfig.widthMultiplier,
                                width: 20 * SizeConfig.widthMultiplier,),
                              SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                              Text(ApiClient.userType == "1"?"In Progress DPR":"For Review Progress DPR",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.2 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',)),
                              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                              Text("There is no DPR in progress",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2 * SizeConfig.textMultiplier,fontFamily: 'Lato',)),
                              SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

                            ])
                        )
                       :ListView.builder(
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
                                    getDPRProgress(context);
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
                                            color: ApiClient.userType == "1"?app_color:Colors.red,
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
                                                Text(ApiClient.dataFormatYear(DPRCollection[index]['dpr_date']),
                                                    style: TextStyle(
                                                      fontSize: 1.8*
                                                          SizeConfig.textMultiplier,
                                                      fontFamily: 'MyriadPro',
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
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
                      Text("DPR data",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',)),
                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                      Text("There is no DPR data found",
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

        ]),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 1 * SizeConfig.heightMultiplier),
        child: Visibility(
          visible: _isVisible,
          child: FloatingActionButton(
            child: Icon(Icons.add,color: Colors.white,),
            backgroundColor: app_color,
            onPressed: () async {
              final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => new DprDetailsPage(userToken,projectData,"1")));
              if(result != null || result == null){
                getDPRProgress(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> getSelectedList(BuildContext context, String title,  Color color,int status) async {

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new DPRSelectedViewListPage(title,userToken,color,status,projectData)));
    if(result != null || result == null){
      // getFavourite(context);
    }
  }

// APIs for get date wise dpr progress
  getDPRProgress(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_dpr_collection");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "role_id":ApiClient.roleID,
      "user_type":ApiClient.userType,
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("DatewiseDPR aa : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          DPRCollection = decoded['in_progress_record'];
          total_dpr = decoded['total_dpr'];
          in_progress_dpr_count = decoded['in_progress_dpr_count'];
          submitted_dpr_count= decoded['submitted_dpr_count'];
          approved_dpr_count=decoded['approved_dpr_count'];
          revoked_dpr_count = decoded['revoked_dpr_count'];
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
}