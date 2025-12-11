import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class HandingOverChecklistVideos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Text("1. Handing Over Checklist DOER",
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
              playVideo("https://drive.google.com/file/d/1bvbzlBqhywWUyjbsAVHXdEjZyvrClaEi/view?usp=sharing");
            },
            child: Text("  1.1 Handing over checklist save/submit",
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
              playVideo("https://drive.google.com/file/d/1zTgdDt_A5RUiTAQ9_cUp729vfzTF8pgG/view?usp=sharing");
            },
            child: Text("  1.2 Rejected handing over checklist save/submit",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("2. Handing Over Checklist CHECKER",
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
              playVideo("https://drive.google.com/file/d/1KhpDgJUkkwD5S6DcUfOKeoxtTU15hKCu/view?usp=sharing");
            },
            child: Text("  2.1 Handing over checklist accepted by checker",
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
              playVideo("https://drive.google.com/file/d/1-milGfwbI9hn79HE9Dga0dlZMtld7DVS/view?usp=sharing");
            },
            child: Text("  2.2 Handing over checklist rejected by checker",
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
              playVideo("https://drive.google.com/file/d/1HLPYqR0S5sCO2EqqaS8FU0KwcxrEb1Tf/view?usp=sharing");
            },
            child: Text("  2.3 Revoked handing over checklist accept by checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("3. Handing Over Checklist REVOKER",
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
              playVideo("https://drive.google.com/file/d/1d8WiB7W3RQohuoYxav0PHmnJomzScos-/view?usp=sharing");
            },
            child: Text("  3.1 Revoke handing over checklist from revoker",
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
