
import 'dart:convert';

import 'package:doer/quality_checklist/qc_fill.dart';
import 'package:doer/quality_checklist/qc_list.dart';
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

import '../util/colors_file.dart';

class QCSelectedViewListPage extends KFDrawerContent {

  var title,num,userToken;
  var color,projectData;
  QCSelectedViewListPage(title,num,userToken, Color color,projectData){
    this.title = title;
    this.num = num;
    this.userToken = userToken;
    this.color = color;
    this.projectData = projectData;
  }

  @override
  QCSelectedViewListPageState createState() => QCSelectedViewListPageState(title,num,userToken,color,projectData);
}

class QCSelectedViewListPageState extends State<QCSelectedViewListPage> {

  var title,num,userToken;
  var color,projectData;
  QCSelectedViewListPageState(title,num,userToken,color,projectData){
    this.title = title;
    this.num = num;
    this.userToken = userToken;
    this.color = color;
    this.projectData = projectData;
  }

  List checklistCollection = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    getChecklistCollection(context);
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
              child: ListView.builder(
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
                        if(result != null ){
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
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(checklistCollection[index]['after_phase'] == 0?
                                          "${ApiClient.dataFormatYear(checklistCollection[index]['date'])}  Phase : Before":
                                          "${ApiClient.dataFormatYear(checklistCollection[index]['date'])} Phase : After",
                                              style: TextStyle(
                                                fontSize: 1.8*
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'MyriadPro',
                                              )),
                                          Text(checklistCollection[index]['after_phase'] == 0?checklistCollection[index]['status'] == 3 ?"Approved":
                                          checklistCollection[index]['status'] == 4 ?"Approved with comment":"":"",
                                              style: TextStyle(
                                                fontSize: 1.6*
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'MyriadPro',
                                              )),
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
                  }))

        ])
    );

  }
  getChecklistCollection(BuildContext context) async{
    var url = Uri.parse(ApiClient.BASE_URL+"get_quality_checklists");
    Map map ={
      "project_id":"${projectData['project_id']}",
      "building_id":"${projectData['building_id']}",
      "role_id":ApiClient.roleID,
      "user_type":"${ApiClient.userType}",
      "status":"$num"
    };
    print("map : ${map}");
    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);
    Map decoded = jsonDecode(response.body);
    print("decoded building_id : ${decoded}");
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
          checklistCollection = decoded['qc_lists'];
        });
      }else{
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
    }
    else if(checklistCollection['reporting_unit'] == "FOOTING"){
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
