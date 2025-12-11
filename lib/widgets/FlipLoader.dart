import 'package:flutter/material.dart';
import 'dart:math';

import '../util/SizeConfig.dart';
import '../util/colors_file.dart';


class ColorLoader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  ColorLoader({this.radius = 40.0, this.dotRadius = 5.0});

  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation_rotation;
  late Animation<double> animation_radius_in;
  late Animation<double> animation_radius_out;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    print(dotRadius);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animation_radius_in = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animation_radius_out = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0)
          radius = widget.radius * animation_radius_in.value;
        else if (controller.value >= 0.0 && controller.value <= 0.25)
          radius = widget.radius * animation_radius_out.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width:  40 * SizeConfig.widthMultiplier,
      height: 40 * SizeConfig.widthMultiplier,
      //color: site_color12,
      child: Stack(children: [
        Center(
          child:IconButton(
            icon:  Image.asset("assets/icons/app_icon.png",
                height: 10 * SizeConfig.widthMultiplier,
                width: 10 * SizeConfig.widthMultiplier,

                fit: BoxFit.fill), onPressed: () {  },
          ),),
        Center(
          child: new RotationTransition(

            turns: animation_rotation,
            child: new Container(
              //color: Colors.limeAccent,
              child: new Center(
                child: Stack(
                  children: <Widget>[

                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color:site_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0),
                        radius * sin(0.0),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: app_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 1 * pi / 4),
                        radius * sin(0.0 + 1 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: site_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 2 * pi / 4),
                        radius * sin(0.0 + 2 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: app_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 3 * pi / 4),
                        radius * sin(0.0 + 3 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: site_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 4 * pi / 4),
                        radius * sin(0.0 + 4 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: app_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 5 * pi / 4),
                        radius * sin(0.0 + 5 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: site_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 6 * pi / 4),
                        radius * sin(0.0 + 6 * pi / 4),
                      ),
                    ),
                    new Transform.translate(
                      child: Dot(
                        radius: dotRadius,
                        color: app_color,
                      ),
                      offset: Offset(
                        radius * cos(0.0 + 7 * pi / 4),
                        radius * sin(0.0 + 7 * pi / 4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],

      ),
    );
  }

  @override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({required this.radius, required this.color});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),

      ),
    );
  }
}