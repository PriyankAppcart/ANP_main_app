
import 'dart:convert';
import 'dart:io';

import 'package:doer/quality_checklist/qc_fill.dart';
import 'package:doer/quality_checklist/qc_list.dart';
import 'package:doer/quality_checklist/qc_selected_view_list.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../util/colors_file.dart';

class QCViewListPage extends KFDrawerContent {

  var userToken,projectData;
  QCViewListPage(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  @override
  QCViewListPageState createState() => QCViewListPageState(userToken,projectData);
}

class QCViewListPageState extends State<QCViewListPage> {

  var userToken,projectData;
  QCViewListPageState(userToken,projectData){
    this.userToken = userToken;
    this.projectData = projectData;
  }

  List checklistCollection = [];
  var total_qc = 0,in_progress_qc_count = 0,submitted_qc_count = 0,approved_qc_count = 0,rejected_qc_count = 0,revoke_qc_count = 0;

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

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
        getChecklistCollection(context);
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
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    apiCall(context);
    _refreshController.refreshCompleted();
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
                          Text("Quality Checklist View",
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
              SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: SingleChildScrollView(
                  child: Column(
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
                                Text("$total_qc",
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
                                getSelectedList(context,"In Progress",1,app_color);
                              },
                              child: Row(
                                children: [
                                  Text("In Progress",
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  Text("$in_progress_qc_count",
                                      style: TextStyle(
                                        fontSize: 2 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: app_color,
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
                                getSelectedList(context,"Submit for Approval",2,Colors.grey);
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                                  Text("Submit for Approval",
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  Text("$submitted_qc_count",
                                      style: TextStyle(
                                        fontSize: 2 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      )),
                                ],
                              ),
                            ),),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                getSelectedList(context,"Approved",3,Colors.green);
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
                                  Text("$approved_qc_count",
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
                                getSelectedList(context,"Rejected by checker",5,Colors.red);
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 3 * SizeConfig.widthMultiplier,),
                                  Text("Rejected by checker",
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  Text("$rejected_qc_count",
                                      style: TextStyle(
                                        fontSize: 2 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                            ),),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                getSelectedList(context,"Revoked",6,Colors.red);
                              },
                              child: Row(
                                children: [
                                  Text("Revoked",
                                      style: TextStyle(
                                        fontSize: 1.8 *
                                            SizeConfig.textMultiplier,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      )),
                                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                                  Text("$revoke_qc_count",
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
                      checklistCollection.length >= 1? ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: checklistCollection.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  InkWell(
                              onTap: ()async {
                                final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => new FillQCPage(userToken,checklistCollection[index]['id'])));
                                if(result != null){
                                  getChecklistCollection(context);
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
                                          color: ApiClient.userType == "1"?app_color:Colors.grey,
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
                                              Text(checklistCollection[index]['checklist_code'],
                                                  style: TextStyle(
                                                    fontSize: 1.8 *
                                                        SizeConfig.textMultiplier,
                                                    fontFamily: 'Lato',
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                              Text(getUnit(checklistCollection[index]),
                                                  style: TextStyle(
                                                    fontSize: 1.8 *
                                                        SizeConfig.textMultiplier,
                                                    fontFamily: 'Lato',
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                              Text(checklistCollection[index]['after_phase'] == 0?
                                              "${ApiClient.dataFormatYear(checklistCollection[index]['date'])} Phase : Before":
                                              "${ApiClient.dataFormatYear(checklistCollection[index]['date'])} Phase : After",
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
                          :Container(
                          height: 75 * SizeConfig.heightMultiplier,
                          width: 95 * SizeConfig.widthMultiplier,
                          child: Column(children: [
                            SizedBox(height: 20 * SizeConfig.heightMultiplier),
                            Image.asset('assets/icons/no_data_found.png',
                              height: 20 * SizeConfig.widthMultiplier,
                              width: 20 * SizeConfig.widthMultiplier,),
                            SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                            Text(ApiClient.userType == "1"?"In Progress":"Submit For Approved",
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
                      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 1 * SizeConfig.heightMultiplier),
        child: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.white,),
          backgroundColor: app_color,
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new QCListPage(userToken,projectData)));
            print("result :: $result");
            if(result != null || result == null){
              getChecklistCollection(context);
            }
          },
        ),
      ),
    );

  }

  Future<void> getSelectedList(BuildContext context, String title, int i, Color color) async {

    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => new QCSelectedViewListPage(title,i,userToken,color,projectData)));
  }
  getChecklistCollection(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_quality_checklist_collection");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "role_id":ApiClient.roleID,
      "user_type":"${ApiClient.userType}"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          checklistCollection = decoded['in_progress_record'];
          total_qc = decoded['total_qc'];
          in_progress_qc_count = decoded['in_progress_qc_count'];
          submitted_qc_count = decoded['submitted_qc_count'];
          approved_qc_count = decoded['approved_qc_count'];
          rejected_qc_count = decoded['rejected_qc_count'];
          revoke_qc_count = decoded['revoked_qc_count'];

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

}
