import 'package:doer/util/ApiClient.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

class HandingOverHistory extends StatelessWidget {

  var ho_history_data;

  HandingOverHistory({
    @required this.ho_history_data,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: ho_history_data.length,
        itemBuilder: (BuildContext context, int subIndex) {
          return ho_history_data[subIndex]['doer_comments'] != "" || ho_history_data[subIndex]['checker_comments'] != ""
              || ho_history_data[subIndex]['handingover_check_list_photo'].length >= 1?
          Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              ho_history_data[subIndex]['doer_comments'] != ""?
              Text("Doer Comment:\n"+ho_history_data[subIndex]['doer_comments'],
                  style: TextStyle(
                    fontSize: 1.8 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    color: Colors.black,
                  )):Container(),
              SizedBox(height: ho_history_data[subIndex]['doer_comments'] != ""?1 * SizeConfig.heightMultiplier:0),
              ho_history_data[subIndex]['checker_comments'] != ""?

              Text("Checker Comment:\n"+ho_history_data[subIndex]['checker_comments'],
                  style: TextStyle(
                    fontSize: 1.8 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    color: Colors.black,
                  )):Container(),
              SizedBox(height: 1 * SizeConfig.heightMultiplier,),
              ho_history_data[subIndex]['handingover_check_list_photo'].length >= 1?
              Container(
                height: 12 *
                    SizeConfig.heightMultiplier,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: ho_history_data[subIndex]['handingover_check_list_photo'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            Container(
                              width: 35 *
                                  SizeConfig.widthMultiplier,
                              height: 10 *
                                  SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      2 *
                                          SizeConfig
                                              .imageSizeMultiplier,
                                    )),
                                // color: Color(0xFFba3d41),
                                shape: BoxShape.rectangle,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Container(
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
                                        image: NetworkImage(ho_history_data[subIndex]['handingover_check_list_photo'][index]['is_cloud'] == 1?
                                        ApiClient.IMG_BASE_GOOGLE_URL+ho_history_data[subIndex]['handingover_check_list_photo'][index]['thumbnail_path']:
                                        ApiClient.IMG_BASE_URL+ho_history_data[subIndex]['handingover_check_list_photo'][index]['thumbnail_path']),
                                        fit: BoxFit.cover,
                                      ),

                                    )),
                              ),
                            ),
                            SizedBox(width: 1 * SizeConfig.widthMultiplier,),

                          ],
                        ),
                      );
                    }),
              ):Container(),
              SizedBox(width: 2 * SizeConfig.widthMultiplier,),
              Text(ho_history_data[subIndex]['status'] == 1? "Saved\n ${ho_history_data[subIndex]['created_by']}":
              ho_history_data[subIndex]['status'] == 2?"Submitted\n ${ho_history_data[subIndex]['created_by']}":
              ho_history_data[subIndex]['status'] == 6?"Revoked\n ${ho_history_data[subIndex]['created_by']}":
              ho_history_data[subIndex]['status'] == 5? "Rejected\n ${ho_history_data[subIndex]['created_by']}":"Accepted\n ${ho_history_data[subIndex]['created_by']}",
                  style: TextStyle(
                    fontSize: 1.8 *
                        SizeConfig.textMultiplier,
                    fontFamily: 'Lato',
                    color: ho_history_data[subIndex]['status'] == 1?Colors.black:
                    ho_history_data[subIndex]['status'] == 2?Colors.orange:
                    ho_history_data[subIndex]['status'] == 3 || ho_history_data[subIndex]['status'] == 4?
                    Colors.green:Colors.red,
                  )),

              /*   Row(
                children: [
                  ho_history_data[subIndex]['handingover_check_list_photo'].length >= 1? Container(
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
                          image: NetworkImage(ApiClient.IMG_BASE_URL+ho_history_data[subIndex]['handingover_check_list_photo'][0]['thumbnail_path']),
                          fit: BoxFit.cover,
                        ),
                      )):Container(),
                  SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                  Text(ho_history_data[subIndex]['status'] == 1? "Saved\n ${ho_history_data[subIndex]['created_at']}":ho_history_data[subIndex]['created_at'],
                      style: TextStyle(
                        fontSize: 1.8 *
                            SizeConfig.textMultiplier,
                        fontFamily: 'Lato',
                        color: Colors.black,
                      )),
                ],
              ),*/

              Divider()
            ],
          ):Container();
        });
  }

}
