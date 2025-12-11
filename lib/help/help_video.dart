
import 'package:doer/dpr/dpr_details.dart';
import 'package:doer/help/dpr_videos.dart';
import 'package:doer/help/handing_over_checklist_videos.dart';
import 'package:doer/help/quality_checklist_videos.dart';
import 'package:doer/help/rera_videos.dart';
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

class HelpVideos extends KFDrawerContent {

  var title;
  HelpVideos(title){
    this.title = title;
  }

  @override
  HelpVideosState createState() => HelpVideosState(title);
}

class HelpVideosState extends State<HelpVideos> {

  var title;
  HelpVideosState(title){
    this.title = title;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);

    return Scaffold(
        backgroundColor: Color(0xFFf5f5f5),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

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
              child: Column(
                children: [
                  title == "DPR Videos"?DPRVideos():
                  title == "Quality Checklist Videos"?QualityChecklistVideos():
                  title == "Handing Over Checklist Videos"?HandingOverChecklistVideos():
                  ReraVideos(),
                ],
              ))




        ])
    );

  }


}
