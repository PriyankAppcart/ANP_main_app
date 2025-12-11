
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/rera/rera_fill.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';

class NotificationPage extends KFDrawerContent {

  var userToken,backFlag;
  NotificationPage(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  @override
  NotificationPageState createState() => NotificationPageState(userToken,backFlag);
}

class NotificationPageState extends State<NotificationPage> {

  var userToken,backFlag;
  NotificationPageState(userToken,backFlag){
    this.userToken = userToken;
    this.backFlag = backFlag;
  }

  List<bool> selected = [true,false,false,false,false,false,false,false,false];


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
                colors: [Color(0xFFf07c01),Color(0xFFf07c01)],
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
                          Text("Notification",
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
              child:ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) {
                    return  InkWell(
                      onTap: ()async {
                     /*   final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => new ReraFillPage(userToken)));
                        if(result != null || result == null){
                          // getFavourite(context);
                        }*/
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
                                height: 12 * SizeConfig.heightMultiplier,
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
                                  color: selected[index]?Colors.red:Color(0xFFf07e01),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 2 * SizeConfig.widthMultiplier),
                                child: Container(
                                  width: 87 * SizeConfig.widthMultiplier,
                                  child: Row(

                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child:Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("PIVI115Jan2020CHKL-8570",
                                                style: TextStyle(
                                                  fontSize: 1.8 *
                                                      SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Colors.black,
                                                )),
                                            SizedBox(height: 1 * SizeConfig.heightMultiplier,),
                                            Text("CHECKLIST FOR PCC",
                                                style: TextStyle(
                                                  fontSize: 1.8*
                                                      SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                )),
                                          ],
                                        ),),
                                      Expanded(
                                        flex: 1,
                                        child:Column(
                                          children: [
                                           SizedBox(height: 3 * SizeConfig.heightMultiplier,),
                                            Text("17 Sep 2021",
                                                style: TextStyle(
                                                  fontSize: 1.6*
                                                      SizeConfig.textMultiplier,
                                                  fontFamily: 'Lato',
                                                  color: Color(0xFFf07e01),
                                                )),
                                          ],
                                        ),)


                                    ],),
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


}
