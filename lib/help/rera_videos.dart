import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class ReraVideos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Text("1. RERA DOER",
              style: TextStyle(
                fontSize: 2 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1ZDKXNwCJQcmnIcdO0-lHLPKDfZnS06Q7/view?usp=sharing");
            },
            child: Text("  1.1 RERA save/submit",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1RMAyw_rIbc35D-cn-x7o2ZUOQD5zNz7B/view?usp=sharing");
            },
            child: Text("  1.2 Rejected RERA resubmit",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("2. RERA CHECKER",
              style: TextStyle(
                fontSize: 2 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1TRyEWQntGv52Kz_J-eR10G6aMc7rKgDg/view?usp=sharing");
            },
            child: Text("  2.1 RERA approval by checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1W6vfG6J372fmIaFAUuMpxwckHPQ4s7DZ/view?usp=sharing");
            },
            child: Text("  2.2 RERA reject from checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1dl4Pvx5G1VrK3GkbbR6rS33YsNCp2sXE/view?usp=sharing");
            },
            child: Text("  2.3 Revoked RERA accept by checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("3. RERA REVOKER",
              style: TextStyle(
                fontSize: 2 *
                    SizeConfig.textMultiplier,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          InkWell(
            onTap: () async {
              playVideo("https://drive.google.com/file/d/1-mjCPKqjj3hfVCJ-_MNlx_0dF0IAtXLf/view?usp=sharing");
            },
            child: Text("  3.1 Revoke RERA from revoker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
        ],
      ),
    );
  }

  void playVideo(String url) async {
    if (await canLaunch(url)) {
    //  await launch(url);
      await launch(url, enableJavaScript: true);
    } else {
      throw 'Could not launch $url';
    }
  }

}
