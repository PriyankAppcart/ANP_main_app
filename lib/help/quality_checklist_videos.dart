import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class QualityChecklistVideos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * SizeConfig.heightMultiplier,),
          Text("1. Quality Checklist DOER",
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
              playVideo("https://drive.google.com/file/d/1yEyZmcZfYkOT__PANsU3B9rlOrqZBEDJ/view?usp=sharing");
            },
            child: Text("  1.1 Quality Checklist save/submit before",
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
              playVideo("https://drive.google.com/file/d/1cUzUAqv0UjOGEVpL7g_uUXvCPMFmhPoh/view?usp=sharing");
            },
            child: Text("  1.2 Quality Checklist save/submit after",
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
              playVideo("https://drive.google.com/file/d/1P9JzXnwzhavnh2hOLRtDSLt83sWfdIyB/view?usp=sharing");
            },
            child: Text("  1.3 Rejected quality checklist before",
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
              playVideo("https://drive.google.com/file/d/1z-QWAvqByAv-rKlKhx7M3apfIU6k1q0C/view?usp=sharing");
            },
            child: Text("  1.4 Rejected quality checklist after",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("2. Quality Checklist CHECKER",
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
              playVideo("https://drive.google.com/file/d/1sZeU-p0Yt7Kntcp_hF-a6naF-P4My9Ri/view?usp=sharing");
            },
            child: Text("  2.1 Before - quality checklist approval by checker",
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
              playVideo("https://drive.google.com/file/d/1a3h1okpSpO2Dm44OyqIxR4dx94zsf-DC/view?usp=sharing");
            },
            child: Text("  2.2 After - quality checklist approval by checker",
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
              playVideo("https://drive.google.com/file/d/1eGgqK7z0Bm9K1ALAAkr0XaeLS9JyM5D-/view?usp=sharing");
            },
            child: Text("  2.3 Before - quality checklist reject by checker",
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
              playVideo("https://drive.google.com/file/d/1JEhSlaiPVRIvejWmsdrldPsnLQjM_QJM/view?usp=sharing");
            },
            child: Text("  2.4 After- quality checklist reject by checker",
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
              playVideo("https://drive.google.com/file/d/19KuIDzkQx1wprclhoLN6boXjC9koiPap/view?usp=sharing");
            },
            child: Text("  2.5 Revoked quality checklist accept by checker",
                style: TextStyle(
                  fontSize: 2 *
                      SizeConfig.textMultiplier,
                  fontFamily: 'Lato',
                  color: Colors.blue,
                )),
          ),
          SizedBox(height: 1.5 * SizeConfig.heightMultiplier,),
          Text("3. Quality Checklist REVOKER",
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
              playVideo("https://drive.google.com/file/d/1iXS-Y2SDKaQwrXuxd9k0uwzmirvZM7Gy/view?usp=sharing");
            },
            child: Text("  3.1 Revoke quality checklist from revoker",
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
