import 'package:doer/style/text_style.dart';
import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

class RoomSelection extends StatelessWidget {

  var roomList;
  final Function(String, int) onSelected;

  RoomSelection({
    @required this.roomList,
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
        itemCount: roomList.length,
        itemBuilder:
            (BuildContext context,
            int index) {
          return Container(
              child: GestureDetector(
                onTap: () {
                  onSelected(roomList[index]['room_type'],roomList[index]['id']);
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
                      Row(
                        children: [
                          Container(
                              width: 1 * SizeConfig.widthMultiplier,
                              height: 2 * SizeConfig.heightMultiplier,
                              color:roomList[index]['room_status'] == "S"?Colors.orange:
                              roomList[index]['room_status'] == "AR"?Colors.green:
                              roomList[index]['room_status'] == "REV"?Colors.red:
                              roomList[index]['room_status'] == "R"?Colors.red:Colors.white
                          ),
                          SizedBox(width: 2 * SizeConfig.widthMultiplier,),
                          Text(roomList[index]['room_status'] == "S"? "${roomList[index]['room_type']} : Saved":
                          roomList[index]['room_status'] == "AR"? "${roomList[index]['room_type']} : Accepted":
                          roomList[index]['room_status'] == "REV"? "${roomList[index]['room_type']} : Revoked":
                          roomList[index]['room_status'] == "R"? "${roomList[index]['room_type']} : Rejected"   :roomList[index]['room_type'],
                              textAlign: TextAlign.start,
                              maxLines:2,

                              style:TextStyle(
                                //color: colors,
                               // fontWeight: fontWeightName,
                                fontSize:1.7 * SizeConfig.textMultiplier,
                              )),
                        ],
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
