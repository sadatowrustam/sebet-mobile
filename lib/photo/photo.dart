import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sebet/IpAddress.dart';
class Photo extends StatefulWidget {
  String img;
  String name;
  Photo({required this.img,required this.name});


  @override
  State<Photo> createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.name,style: TextStyle(color: Colors.black),) ,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [

              Container(alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height-100,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: (widget.img != null)
                      ? PhotoView(
                    backgroundDecoration: BoxDecoration(color: Colors.white),
                        imageProvider: CachedNetworkImageProvider(
                        "${IpAddres().ipAddress}/" + widget.img,


                  ),
                      )
                      : Image.asset("assets/images/spinner.gif")),
            ],
          ),
        ),
      ),
    );
  }
}
