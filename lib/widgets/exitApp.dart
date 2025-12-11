import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/material.dart';

class exitApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0.0,right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: 18.0,
            ),
            margin: EdgeInsets.only(top: 3.5 * SizeConfig.widthMultiplier,left: 2  *SizeConfig.widthMultiplier,right: 2 * SizeConfig.widthMultiplier),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 1 * SizeConfig.heightMultiplier,),

                SizedBox(height: 1 * SizeConfig.heightMultiplier),
                Text('Are you sure you would like to exit KP Doer app? ',  style: TextStyle( fontSize: 1.9 *
                    SizeConfig.textMultiplier, fontFamily: 'Abel')),
                SizedBox(height: 3 * SizeConfig.heightMultiplier),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: Color(0xFF474747),
                      splashColor:  Colors.black45,
                      // minWidth: 30 * SizeConfig.widthMultiplier,
                      height: 4.5 * SizeConfig.heightMultiplier,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.8 * SizeConfig.widthMultiplier)),
                      child: Text('No',
                          style: TextStyle(
                            color:  Colors.white,
                            fontSize:
                            1.6 * SizeConfig.textMultiplier,fontFamily: 'Abel',)),
                      onPressed: ()   {
                        Navigator.of(context).pop();

                      },
                    ),
                    SizedBox(width: 4 * SizeConfig.widthMultiplier,),
                    MaterialButton(
                      color: Color(0xFFf07e01),
                      splashColor:  Colors.yellow[800],
                      // minWidth: 30 * SizeConfig.widthMultiplier,
                      height: 4.5 * SizeConfig.heightMultiplier,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.8 * SizeConfig.widthMultiplier)),
                      child: Text('Yes',
                          style: TextStyle(
                            color:  Colors.white,
                            fontSize:
                            1.6 * SizeConfig.textMultiplier,fontFamily: 'Abel',)),
                      onPressed: ()   {
                        Navigator.of(context).pop(true);

                      },
                    ),
                  ],
                ),
                SizedBox(height: 1 * SizeConfig.heightMultiplier),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

