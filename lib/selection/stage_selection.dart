import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import '../util/colors_file.dart';

class StageSelection extends StatelessWidget {
  var stageList;
  final Function(String, List, String, String) onSelected;
  var selectedName;
  List stageMap = [];
  List<bool> isStage = [];

  StageSelection({
    @required this.stageList,
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
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container(
                      height: 78 * SizeConfig.heightMultiplier,
                      width: 100 * SizeConfig.widthMultiplier,
                      color: Colors.white,
                      child: new ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: stageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            isStage.add(false);
                            return Container(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  //  selectedFlat = flatList[index]['flat_name'];
                                  //   selectedFlatID= flatList[index]['id'];
                                  //    Navigator.pop(context);
                                });
                              },
                              child: Container(
                                width: 62 * SizeConfig.widthMultiplier,
                                color: Colors.white70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: app_color,
                                          value: isStage[index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isStage[index] = value!;
                                            });
                                          },
                                        ),
                                        Text("${stageList[index]['stage_no']}",
                                            textAlign: TextAlign.start,
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              fontFamily: 'Lato',
                                              color:
                                                  // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                  Colors.black,
                                            )),
                                        SizedBox(
                                          width: 2 * SizeConfig.widthMultiplier,
                                        ),
                                        Expanded(
                                          child: Text(
                                              "${stageList[index]['particulars']}",
                                              textAlign: TextAlign.start,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontSize: 2 *
                                                    SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color:
                                                    // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                    Colors.black,
                                              )),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.grey),
                                    //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                  ],
                                ),
                              ),
                            ));
                          }),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          color: app_color,
                          splashColor: app_color,
                          minWidth: 28 * SizeConfig.widthMultiplier,
                          height: 4.7 * SizeConfig.heightMultiplier,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  1.8 * SizeConfig.widthMultiplier)),
                          child: Text('Save',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 2 * SizeConfig.textMultiplier)),
                          onPressed: () async {
                            selectedName = "";

                            for (int i = 0; i < isStage.length; i++) {
                              if (isStage[i]) {
                                setState(() {
                                  selectedName +=
                                      stageList[i]['stage_no'] + " ";
                                });
                                print("flatList id :: ${isStage.length}");
                                stageMap.add(stageList[i]['id']);
                              }
                            }
                            onSelected(selectedName, stageMap, "", "");
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
