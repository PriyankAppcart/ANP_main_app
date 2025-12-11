import 'dart:convert';
import 'dart:io';

import 'package:doer/pages/notification.dart';
import 'package:doer/pages/projects_list.dart';
import 'package:doer/rera/rera_fill.dart';
import 'package:doer/rera/rera_view_list.dart';
import 'package:doer/sqliteDB/DBHelper.dart';
import 'package:doer/sqliteDB/tbl_dashbord.dart';
import 'package:doer/widgets/CustomDialogLoading1.dart';
import 'package:doer/widgets/colors.dart';
import 'package:doer/widgets/tokenExpired.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/colors_file.dart';
//import 'package:upgrader/upgrader.dart';

class DashboardPage extends KFDrawerContent {

  var userToken,userName;
  DashboardPage(userToken){
    this.userToken = userToken;
    this.userName = userName;
  }

  @override
  _DashboardPageState createState() => _DashboardPageState(userToken);
}

class _DashboardPageState extends State<DashboardPage> {

  var userToken;
  _DashboardPageState(userToken,){
    this.userToken = userToken;
  }

   List<bool> selected = [];
  //var selected = <bool>[];

  bool apiFlag = false;
  bool apiStustFlag = false;
  bool internetConnection = true;
  List dataList = [];
  //List <DahboardModel> dahboardModel = [];
  TableDashboard tableDashboard = TableDashboard();

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
        getData(context);
      //  getDataFromDataBase(context);
      }
      else{
        getDataFromDataBase(context);
        setState(() {
          apiFlag = true;
          apiStustFlag = true;
        //  internetConnection = false;
        });
      }
    } on SocketException catch (_) {
      getDataFromDataBase(context);
      setState(() {
        apiFlag = true;
        apiStustFlag = true;
       // internetConnection = false;
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
                      num ==1?IconButton(
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
                          Text("Dashboard",
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
              child:  internetConnection?apiStustFlag?apiFlag?
              Container(
                height: 86 * SizeConfig.heightMultiplier,
                child: GridView.builder(
                  // scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    primary: false,
                    itemCount:dataList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height /1.9),),

                    itemBuilder: (BuildContext context, int index) {
                      return  dataList[index]['task_assign'] == 1 ?Padding(
                        padding:  EdgeInsets.all( 3 * SizeConfig.widthMultiplier),
                        child:  InkWell(
                          onTap: () async {
                            setState(() {
                              for(int i = 0; i < dataList.length; i++){
                                if(i == index){
                                  selected[i] = true;
                                }else{
                                  selected[i] = false;
                                }

                              }
                            });
                            go(context,dataList[index]['task_no']);

                          },
                          child: Container(
                              width: 43 * SizeConfig.widthMultiplier,
                              height: 20 * SizeConfig.heightMultiplier,
                              //  color: Color(0xFF2d7f4f),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  3 * SizeConfig.imageSizeMultiplier,
                                )),
                                color: selected[index]?app_color:Colors.white,
                                shape: BoxShape.rectangle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0.0, 0.75))
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.5 * SizeConfig.heightMultiplier,right: 3 * SizeConfig.widthMultiplier),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(dataList[index]['task_count'] == 0?"":'${dataList[index]['task_count']}',
                                            style: TextStyle(
                                              fontSize: 2 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              color: selected[index]?Colors.white:Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                        Container(
                                          height: 20 * SizeConfig.widthMultiplier,
                                          width: 20 * SizeConfig.widthMultiplier,
                                          child: Image.network(ApiClient.IMG_BASE_URL+dataList[index]['task_icon'],
                                            errorBuilder: (context, object, error) {
                                              return Image.asset('assets/icons/no_image.png',
                                                fit: BoxFit.fill,color: selected[index]?Colors.white:CustomColor.lightBlack,);
                                            },
                                            fit: BoxFit.fill,color: selected[index]?Colors.white:CustomColor.lightBlack,),
                                        ),
                                        SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                                        Text(dataList[index]['task_name'],
                                            style: TextStyle(
                                              fontSize: 2 *
                                                  SizeConfig.textMultiplier,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                              color: selected[index]?Colors.white:Colors.black,
                                            )),

                                      ],
                                    ),
                                  ),

                                ],
                              )),
                        ),
                      ):Container();
                    }),
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
                    Text("Dashboard data",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',)),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                    Text("There is no doer Dashboard data found",
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
                      color: Color(0xFFf07e01),
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
    var url = Uri.parse(ApiClient.BASE_URL+"get_dahboard_details");

    Map map ={
      "role_id":ApiClient.roleID, // userType
    };

    var response = await http.post(url, headers: {'Authorization': "$userToken"}, body: map);

    print("URL :  ${url}");
    print("Authorization : ${userToken}");
    print("map : ${map}");

    Map decoded = jsonDecode(response.body);
    print("decoded : ${decoded}");
    // Navigator.pop(context);
    if(response.statusCode == 200 || response.statusCode == 201){
      if(decoded['status']){
        setState(() {
        //  dataList = decoded['data'];
        //  selected = List(dataList.length);
          selected.clear();
          for(int i = 0; i < decoded['data'].length; i++){

            if(decoded['data'][i]["task_assign"] == 1){

              Map map = {
                "task_id": decoded['data'][i]["task_id"] ,
                "task_no": decoded['data'][i]["task_no"] ,
                "task_name": decoded['data'][i]["task_name"] ,
                "task_icon": decoded['data'][i]["task_icon"] ,
                "task_count": decoded['data'][i]["task_count"] ,
                "task_assign": decoded['data'][i]["task_assign"]
              };
              dataList.add(map);
            }
            if(i == 0){
              selected.add(true);
            }else{
              selected.add(false);
              //selected[i] = false;
            }
          }

          apiFlag = true;
          apiStustFlag = true;

        });

        Map<String, dynamic> row = {
          TableDashboard.dahboard_list :"${json.encode(dataList)}",
        };

        print("dataList ::  ${json.encode(dataList)}");

      //  print("row :::  ${jsonEncode(dataList)}");
        await tableDashboard.deleteall();
        await tableDashboard.insert(row);




      }else{
        if(decoded['token']){
          setState(() {
            apiStustFlag = false;
          });
        }else{
          showDialog(barrierDismissible: false,context: context, builder: (BuildContext context) => TokenExpired());
        }
      }

    }else{

    }

    print('selected $selected');
  }

  go(BuildContext context,nub) async {
   /* if(nub == 4){
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new ReraViewListPage(userToken)));
      if (result != null || result == null) {
        // getFavourite(context);
      }
    }else*/
    print("num == ${ApiClient.userType}");
    print("num == ${nub}");

    if(nub == 5){
     /* final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new NotificationPage(userToken, 1)));
      if (result != null || result == null) {
        // getFavourite(context);
      }*/
    } else if(nub == 6){
      getDataFromDataBase(context);

    }else {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new ProjectListPage(userToken, 1, nub)));
      if (result != null || result == null) {
        // getFavourite(context);
      }
    }

  }
  getDataFromDataBase(BuildContext context) async {

    final allRows = await tableDashboard.queryAllRows();
    List l = json.decode(allRows[0]['dahboard_list']);

    print("Iterable ${json.encode(l)}");
    setState(() {
      dataList.clear();
      selected.clear();
      dataList = l;

      print("dataList length ${dataList.length}");

      for(int i = 0; i < dataList.length; i++){
        if(i == 0){
          selected.add(true);
        }else{
          selected.add(false);
        }
      }
      apiFlag = true;
      apiStustFlag = true;
    });

  }


}
