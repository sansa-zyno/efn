/*import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

class LatestNewsReadMore extends StatefulWidget {
  String head, img, desc, date;
  LatestNewsReadMore(this.head, this.img, this.desc, this.date);

  @override
  State<LatestNewsReadMore> createState() => _LatestNewsReadMoreState();
}

class _LatestNewsReadMoreState extends State<LatestNewsReadMore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.head,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.img,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.desc,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              /*Text(
                                              "Published on ${newsData[index]["datte"]} ${newsData[index]["ttime"]}",
                                              style: TextStyle(
                                                  fontStyle:
                                                      FontStyle.italic),
                                              textAlign: TextAlign.center,
                                            ),*/
            ],
          ),
        )
      ],
    );
  }
}*/
