import 'package:doer/util/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../util/colors_file.dart';

class PhotosViewPage extends StatefulWidget {

 var imgList;
PhotosViewPage(imgList){
  this.imgList = imgList;
}

  @override
  _PhotosViewPageState createState() => _PhotosViewPageState(imgList);
}

class _PhotosViewPageState extends State<PhotosViewPage> {

  var imgList;
  _PhotosViewPageState(imgList){
    this.imgList = imgList;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("imgList.length ${imgList.length}");
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Text('Back',
            style: TextStyle(
              color:  Colors.white,
              fontWeight: FontWeight.bold,
              fontSize:
              2 * SizeConfig.textMultiplier,fontFamily: 'Abel',)),
        backgroundColor: app_color,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Container(
              color: Colors.white,
            height: 100 * SizeConfig.heightMultiplier,
            width: 100 * SizeConfig.widthMultiplier,

              child: PhotoViewGallery.builder(
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.imgList[index]),
                    initialScale: PhotoViewComputedScale.contained * 0.8,
                    heroAttributes: PhotoViewHeroAttributes(tag: imgList[index]),
                  );
                },
                itemCount: imgList.length,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 90.0,
                      height: 90.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5 * SizeConfig.widthMultiplier,
                        backgroundColor:Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(app_color),
                        // semanticsLabel: "Downloading file abc.mp3",
                        // semanticsValue: "Percent " + (100).toString() + "%",
                        value: event == null
                            ? 0
                            : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );


  }


}
