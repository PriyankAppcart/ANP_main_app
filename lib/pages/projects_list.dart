
import 'dart:convert';
import 'dart:io';

import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/dpr/dpr_selected_view_list.dart';
import 'package:doer/dpr/dpr_view_list.dart';
import 'package:doer/handingover_checklist/hc_list.dart';
import 'package:doer/handingover_checklist/hc_selected_view_list.dart';
import 'package:doer/handingover_checklist/hc_view_list.dart';
import 'package:doer/quality_checklist/qc_selected_view_list.dart';
import 'package:doer/quality_checklist/qc_view_list.dart';
import 'package:doer/rera/rera_selected_view_list.dart';
import 'package:doer/rera/rera_view_list.dart';
import 'package:doer/sqliteDB/tbl_project.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;

import '../util/colors_file.dart';

class ProjectListPage extends KFDrawerContent {

  var userToken,backFlag,num;
  ProjectListPage(userToken,backFlag,num){
    this.userToken = userToken;
    this.backFlag = backFlag;
    this.num = num;
  }

  @override
  ProjectListPageState createState() => ProjectListPageState(userToken,backFlag,num);
}

class ProjectListPageState extends State<ProjectListPage> {

  TableProject tableProject = TableProject();
  var userToken,backFlag,num;
  ProjectListPageState(userToken,backFlag,num){
    this.userToken = userToken;
    this.backFlag = backFlag;
    this.num = num;
  }

  List<bool> selected = [];
  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;
  List dataList = [];
  var title = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");
    getTitle();
    apiCall(context);
  }
  getTitle(){
    setState(() {
      if(num == 1){
        title = "DPR-Project";
      }else if(num == 2){
        title = "Quality Checklist-Project";
      }else if(num == 3){
        title = "Handing Over Checklist-Project";
      }else if(num == 4){
        title = "RERA-Project";
      }
    });  }
  apiCall(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          internetConnection = true;
        });
        getData(context);
      }
      else{
        getDataFromDataBase(context);

      }
    } on SocketException catch (_) {
      getDataFromDataBase(context);
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
                      backFlag ==1?IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 3.0 * SizeConfig.heightMultiplier,
                        ),
                        onPressed: () => Navigator.pop(context,""),
                      ):
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.bars,color: Colors.white,
                          size: 6.0 * SizeConfig.imageSizeMultiplier,),
                        onPressed: widget.onMenuPressed,
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
              child: internetConnection?apiStustFlag?apiFlag?
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  InkWell(
                      onTap: ()async {

                        setState(() {
                          for(int i = 0; i < dataList.length; i++){
                            if(i == index){
                              selected[i] = true;
                            }else{
                              selected[i] = false;
                            }
                          }
                        });

                        if(num == 1){
                          if(ApiClient.userType == "3" || ApiClient.userType == "4"){
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new DPRSelectedViewListPage("DPR Approved",userToken,Colors.green,3,dataList[index]))); // "DPR Approved",Colors.green,3
                            if(result != null || result == null){
                              // getFavourite(context);
                            }
                          }else{
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new DPRViewListPage(userToken,dataList[index])));
                            if(result != null || result == null){
                              // getFavourite(context);
                            }
                          }
                       }else  if(num == 2) {
                          if(ApiClient.userType == "3" || ApiClient.userType == "4"){
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new QCSelectedViewListPage(title,3,userToken,Colors.green,dataList[index])));
                            if(result != null || result == null){
                              // getFavourite(context);
                            }
                          }else {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    new QCViewListPage(
                                        userToken, dataList[index])));
                            if (result != null || result == null) {
                              // getFavourite(context);
                            }
                          }

                        }else  if(num == 3){
                          print("userType == ${ApiClient.userType}");
                          print("num == ${num}");
                          if(ApiClient.userType == "3" || ApiClient.userType == "4"){
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new HCSelectedViewListPage(title,4,userToken,Colors.green,dataList[index])));

                          }else{
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new HCViewListPage(userToken,dataList[index])));
                          }
                       }else  if(num == 4) {
                          if(ApiClient.userType == "3" || ApiClient.userType == "4"){
                          final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new RERASelectedViewListPage("RERA Approved",3,userToken,Colors.green,dataList[index])));

                          }else {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => new ReraViewListPage(userToken,dataList[index])));
                          }

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
                                height: 11 * SizeConfig.heightMultiplier,
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
                                  color: selected[index]?app_color:Colors.grey,
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
                                      Text(dataList[index]['project_name'],
                                          style: TextStyle(
                                            fontSize: 2 *
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),
                                      SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                      Text(dataList[index]['building_name'],
                                          style: TextStyle(
                                            fontSize: 1.8*
                                                SizeConfig.textMultiplier,
                                            fontFamily: 'Lato',
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
                  color: Colors.white,
                  height: 75 * SizeConfig.heightMultiplier,
                  width: 95 * SizeConfig.widthMultiplier,
                  child: Column(children: [
                    SizedBox(height: 20 * SizeConfig.heightMultiplier),
                    Image.asset('assets/icons/no_data_found.png',
                      height: 20 * SizeConfig.widthMultiplier,
                      width: 20 * SizeConfig.widthMultiplier,),
                    SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                    Text("Project Allocation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',)),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Text("There is no any project allocation for you",
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

              ],)))


        ])
    );

  }
  getData(BuildContext context) async{
    // showDialog(context: context, builder: (BuildContext context) => CustomDialogLoading());
    var url = Uri.parse(ApiClient.BASE_URL+"get_assign_project");

    Map map ={
      "role_id":ApiClient.roleID,
    };

    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);

    print("URL :  ${url}");
    print("map :  ${map}");
    print("Authorization : ${userToken}");

    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    // Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
        //  dataList = decoded['data'];
          //  selected = List(dataList.length);

          for(int i = 0; i < decoded['data'].length; i++){
            if(i == 0){
              selected.add(true);
            }else{
              selected.add(false);
            }

            Map map = {
              "project_id": decoded['data'][i]["project_id"] ,
              "project_name": decoded['data'][i]["project_name"] ,
              "building_id": decoded['data'][i]["building_id"] ,
              "building_name": decoded['data'][i]["building_name"] ,
            };
            dataList.add(map);
          }

          apiFlag = true;
          apiStustFlag = true;

        });
        Map<String, dynamic> row = {
          TableProject.project_list :"${json.encode(dataList)}",
        };

        print("dataList ::  ${json.encode(dataList)}");

        //  print("row :::  ${jsonEncode(dataList)}");
        await tableProject.deleteall();
        await tableProject.insert(row);

      }else{
        setState(() {
          apiStustFlag = true;
        });
        if(decoded['token']){

        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }

    print('selected $selected');
  }

  getDataFromDataBase(BuildContext context) async {

    print("project_list ::: ");
    final allRows = await tableProject.queryAllRows();
    print("allRows ::: $allRows ");
    List project_list = json.decode(allRows[0]['project_list']);
    print("project_list ${project_list.length}");
    setState(() {
      dataList = project_list;
      apiFlag = true;
      apiStustFlag = true;
      if(dataList.length >=1){
      for(int i = 0; i < dataList.length; i++) {
        if (i == 0) {
          selected.add(true);
        } else {
          selected.add(false);
        }
      }
      }else{
        internetConnection = false;
      }
      });
  }



}
