import 'package:flutter/material.dart';


// ignore: camel_case_types
class Now_order extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return uinow_order();
  }

}


// ignore: camel_case_types
class uinow_order extends State<Now_order>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
      appBar: AppBar(title:Text("") ,),

          body: Text("data"),
    ));
  }

}