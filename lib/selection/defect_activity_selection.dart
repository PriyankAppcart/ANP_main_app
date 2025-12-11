import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import '../util/colors_file.dart';

class DefectActivitySelection extends StatelessWidget {

  var defectActivityList;
  final Function(String, int) onSelected;

  DefectActivitySelection({
    @required this.defectActivityList,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(3 * SizeConfig.widthMultiplier),
          ),
      child:  new ListView.builder(
    padding: EdgeInsets.zero,
        shrinkWrap: true,
        primary: false,
        itemCount: defectActivityList.length,
        itemBuilder:
            (BuildContext context,
            int index) {
      print("defect_activity  :: ${defectActivityList[index]['checklist_status']} : ${defectActivityList[index]['defect_activity_name']}" );
          return Container(
              child: GestureDetector(
                onTap: () {
                  onSelected(defectActivityList[index]['defect_activity_name'],defectActivityList[index]['id']);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier,
                  color: Colors.white70,
                  margin: EdgeInsets.all(2 * SizeConfig.widthMultiplier),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <
                        Widget>[
                     // SizedBox(height:SizeConfig.heightMultiplier,),
                      Center(
                        child: Row(
                          crossAxisAlignment:CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 1 * SizeConfig.widthMultiplier,
                                height: 2 * SizeConfig.heightMultiplier,
                                color:defectActivityList[index]['checklist_status'] == "S"?app_color:
                                defectActivityList[index]['checklist_status'] == "AD"?Colors.green:
                                defectActivityList[index]['checklist_status'] == "REV"?Colors.red:
                                defectActivityList[index]['checklist_status'] == "RD"?Colors.red:
                                Colors.white
                            ),
                            SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                            Container(
                              width: 70 * SizeConfig.widthMultiplier,
                              child: Text(defectActivityList[index]['checklist_status'] == "S"?"${defectActivityList[index]['defect_activity_name']} : Saved":
                              defectActivityList[index]['checklist_status'] == "AD"?"${defectActivityList[index]['defect_activity_name']} : Accepted":
                              defectActivityList[index]['checklist_status'] == "RD"?"${defectActivityList[index]['defect_activity_name']} : Rejected":
                              defectActivityList[index]['checklist_status'] == "REV"?"${defectActivityList[index]['defect_activity_name']} : Revoked":
                              defectActivityList[index]['defect_activity_name'],
                                  textAlign: TextAlign.start,
                                  maxLines:2,
                                  style:DTextStyle.bodyLine),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:  SizeConfig.heightMultiplier,),
                      Divider(color:Colors.grey),
                      //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                    ],
                  ),
                ),
              ));
        }),
    );
  }
}
