import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

class FlatSelection extends StatelessWidget {

  var flatList,isFlatList,selectedfloorsID;
  final VoidCallback onCountSelected;
  final Function(List,List<bool>) onCountChanged;
  List<bool> todayProgressValidation = [];
  var selectedFlat;
  List columnsMap = [];

  FlatSelection({
    @required this.flatList,
    @required this.isFlatList,
    @required this.selectedfloorsID,
    required this.onCountChanged,
    required this.onCountSelected,
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
    return AlertDialog(
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              6 * SizeConfig.widthMultiplier)),
      content: StatefulBuilder(
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
                        itemCount: flatList.length,
                        itemBuilder:
                            (BuildContext context,
                            int index) {
                          return flatList[index]['floor_id'] == selectedfloorsID && flatList[index]['existing_total'] <= 99 ?Container(
                              child:
                              GestureDetector(
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .start,
                                    children: <
                                        Widget>[
                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Color(0xFFf07c01),
                                            value: isFlatList[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isFlatList[index] = value!;
                                              });
                                            },
                                          ),
                                          Text("${flatList[index]['flat_name']}",
                                              textAlign: TextAlign.start,
                                              maxLines:3,
                                              style:TextStyle(
                                                fontSize:
                                                2 * SizeConfig.textMultiplier,
                                                fontFamily: 'Lato',
                                                color:
                                                // check(manPowerList[index]['id'])?Colors.red:Colors.black,
                                                Colors.black,
                                              )),
                                        ],
                                      ),
                                      Divider(color:Colors.grey),
                                      //manPowerList.last?SizedBox(height: 10 * SizeConfig.heightMultiplier,):Container(),
                                    ],
                                  ),
                                ),
                              )):Container();
                        }),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: Color(0xFFf07e01),
                        splashColor: Colors.yellow[800],
                        minWidth: 28 *
                            SizeConfig.widthMultiplier,
                        height: 4.7 *
                            SizeConfig.heightMultiplier,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .circular(1.8 *
                                SizeConfig
                                    .widthMultiplier)),
                        child: Text('Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 2 *
                                    SizeConfig
                                        .textMultiplier)),
                        onPressed: () async {

                          selectedFlat = "";
                          // _controllers.clear();
                          todayProgressValidation.clear();
                         // _focusNode.clear();
                        //  _controllers.clear();
                        //  columnsMap.clear();
                          for(int i = 0; i<isFlatList.length; i++){
                            if(isFlatList[i]){
                              setState(() {
                                todayProgressValidation.add(true);
                                selectedFlat = selectedFlat + flatList[i]['flat_name'];

                              });
                              print("flatList id :: ${flatList[i]['flat_id']}");
                              Map map = {
                                "flat_id": "${flatList[i]['flat_id']}",
                                "flat_name": flatList[i]['flat_name'],
                                "existing_total": flatList[i]['existing_total'],
                              };
                              columnsMap.add(map);
                            }

                          }
                          onCountChanged(columnsMap,todayProgressValidation);
                          onCountSelected();
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

      ),
    );
  }
}
