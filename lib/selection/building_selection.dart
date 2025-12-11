import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

class BuildingSelection extends StatelessWidget {

  var buildingList;
  final Function(String, int) onSelected;

  BuildingSelection({
    @required this.buildingList,
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
        itemCount: buildingList.length,
        itemBuilder:
            (BuildContext context,
            int index) {
          return Container(
              child: GestureDetector(
                onTap: () {
                  onSelected(buildingList[index]['building_name'],buildingList[index]['building_id']);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 100 * SizeConfig.widthMultiplier,
                  color: Colors.white70,
                  margin: EdgeInsets.all(3.5 * SizeConfig.widthMultiplier),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <
                        Widget>[
                     // SizedBox(height:SizeConfig.heightMultiplier,),
                      Text("${buildingList[index]['building_name']} ",
                          textAlign: TextAlign.start,
                          maxLines:2,
                          style:DTextStyle.bodyLine),
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
