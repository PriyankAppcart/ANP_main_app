import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class DPRVideos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Text("1. DPR DOER",
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
              playVideo("https://drive.google.com/file/d/1tvrDbc9hHiIBBjERDEJXSukMuWR4CgI8/view?usp=sharing");
            },
            child: Text("  1.1 DPR save/submit",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("2. DPR CHECKER",
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
              playVideo("https://drive.google.com/file/d/1YhECCdY1nfSOvN0d0Int__Ir5B8Mpzef/view?usp=sharing");
            },
            child: Text("  2.1 DPR approval by checker",
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
              playVideo("https://drive.google.com/file/d/1zLObw9qx7ALnFrAWV-nh7aVT1mTM56-g/view?usp=sharing");
            },
            child: Text("  2.2 Revoked DPR accept by checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("3. DPR REVOKER",
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
              playVideo("https://drive.google.com/file/d/1BPn47NN3XiXo7AH0fNZE_zUViqP_V6vw/view?usp=sharing");
            },
            child: Text("  3.1 Revoke DPR from revoker",
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
