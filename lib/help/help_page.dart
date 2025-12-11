
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/help/help_video.dart';
import 'package:doer/rera/rera_fill.dart';
import 'package:doer/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/foundation.dart';

import '../util/colors_file.dart';

class HelpPage extends KFDrawerContent {

  var userToken,backFlag;
  HelpPage(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  @override
  HelpPageState createState() => HelpPageState(userToken,backFlag);
}

class HelpPageState extends State<HelpPage> {

  var userToken,backFlag;
  HelpPageState(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  List dataList = ["DPR Videos","Quality Checklist Videos","Handing Over Checklist Videos","RERA Videos"];
  List ImagesList = ["dpr","Quality_C","Handing","RERA"];
  List<bool> selected = [true,false,false,false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiClient.drawerFlag = "1";
    print("userToken $userToken");

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
                          Text("Help",
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
              child: Container(
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
                          (MediaQuery.of(context).size.height /1.7),),

                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
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
                                if (kDebugMode){

                                }

                              }
                            });
                            print("dataList[index] :: ${dataList[index]}");
                             Navigator.push(context, MaterialPageRoute(builder: (context) => new HelpVideos(dataList[index])));

                          },
                          child: Container(
                              width: 43 * SizeConfig.widthMultiplier,
                              height: 25 * SizeConfig.heightMultiplier,
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                  Container(
                                    height: 20 * SizeConfig.widthMultiplier,
                                    width: 20 * SizeConfig.widthMultiplier,
                                    child: Image.asset('assets/icons/${ImagesList[index]}.png',
                                      fit: BoxFit.fill,color: selected[index]?Colors.white:CustomColor.lightBlack,),
                                  ),
                                  SizedBox(height: 4 * SizeConfig.heightMultiplier,),
                                  Padding(
                                    padding:  EdgeInsets.only(left: 5 * SizeConfig.widthMultiplier,right: 5 * SizeConfig.widthMultiplier),
                                    child: Text(dataList[index],
                                        style: TextStyle(
                                          fontSize: 2 *
                                              SizeConfig.textMultiplier,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          color: selected[index]?Colors.white:Colors.black,
                                        )),
                                  ),

                                ],
                              )),
                        ),
                      );
                    }),
              ))




        ])
    );

  }


}
