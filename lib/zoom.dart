import 'dart:io';

import 'package:flutter/material.dart';

class Zoom extends StatelessWidget {
  final data;
  Zoom({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('zoom'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top:25.0),
          child: Image.file(File(data.toString()),width: MediaQuery.of(context).size.width,height:MediaQuery.of(context).size.height*0.85,),
        ),
      ),
    );
  }
}
