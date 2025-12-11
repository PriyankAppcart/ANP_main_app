import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import '../pages/view_photos.dart';

class ChecklistHistory extends StatelessWidget {

  var checklist_history_data;

  ChecklistHistory({
    @required this.checklist_history_data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: checklist_history_data.length,
        itemBuilder: (BuildContext context, int subIndex) {
        //  print("is_cloud ==  ${checklist_history_data[subIndex]['check_list_photo'][0]['is_cloud']}");

          return checklist_history_data[subIndex]['doer_comments'] != "" || checklist_history_data[subIndex]['checker_comments'] != ""
              || checklist_history_data[subIndex]['check_list_photo'].length >= 1?
          Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              checklist_history_data[subIndex]['doer_comments'] != ""?
              Text("Doer Comment:\n"+checklist_history_data[subIndex]['doer_comments'],
                  style: TextStyle(
                    fontSize: 1.8 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    color: Colors.black,
                  )):Container(),
              SizedBox(height: checklist_history_data[subIndex]['doer_comments'] != ""?1 * SizeConfig.heightMultiplier:0),
              checklist_history_data[subIndex]['checker_comments'] != ""?

              Text("Checker Comment:\n"+checklist_history_data[subIndex]['checker_comments'],
                  style: TextStyle(
                    fontSize: 1.8 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    color: Colors.black,
                  )):Container(),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              Row(
                children: [
                  checklist_history_data[subIndex]['check_list_photo'].length >= 1?
                  GestureDetector(
                    onTap: (){
                      var imgList = [];
                      print("is_cloud : ${checklist_history_data[subIndex]['check_list_photo'][0]['is_cloud']}");
                      if("${checklist_history_data[subIndex]['check_list_photo'][0]['is_cloud']}" == "1"){
                        imgList.add(ApiClient.IMG_BASE_GOOGLE_URL+checklist_history_data[subIndex]['check_list_photo'][0]['thumbnail_path']);
                      }else{
                        imgList.add(ApiClient.IMG_BASE_URL+checklist_history_data[subIndex]['check_list_photo'][0]['thumbnail_path']);
                      }
                      //imgList[0] = "${ApiClient.BASE_IMG_URL}${myOrderList['complaint_photo']}";

                      print("imgList :: $imgList");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => new PhotosViewPage(imgList)),
                      );
                    },
                    child: Container(
                        width: 30 * SizeConfig.widthMultiplier,
                        height: 10 * SizeConfig.heightMultiplier,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(
                                2 *
                                    SizeConfig
                                        .imageSizeMultiplier,
                              )),
                          // color: Color(0xFFba3d41),
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                            image: NetworkImage(checklist_history_data[subIndex]['check_list_photo'][0]['is_cloud'] == 1?
                            ApiClient.IMG_BASE_GOOGLE_URL+checklist_history_data[subIndex]['check_list_photo'][0]['thumbnail_path']:
                            ApiClient.IMG_BASE_URL+checklist_history_data[subIndex]['check_list_photo'][0]['thumbnail_path']),
                            fit: BoxFit.cover,
                          ),
                        )),
                  ):Container(),
                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                  Text(checklist_history_data[subIndex]['checklist_status']+ "\n"+
                      "${ApiClient.dataFormatDayTime(checklist_history_data[subIndex]['create_date'])}",
                      style: TextStyle(
                        fontSize: 1.8 *
                            SizeConfig.textMultiplier,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      )),
                ],
              ),
              Divider()
            ],
          ):Container();
        });
  }

}
