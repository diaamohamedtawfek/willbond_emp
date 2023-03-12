import 'package:flutter/material.dart';


class NetworkError extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_NetworkError();
  }

}

// ignore: camel_case_types
class Ui_NetworkError extends State<NetworkError>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [

          Image(
            image: AssetImage('assets/no_wifi.png'),
            width: 120,
            height: 120,
          ),

          SizedBox(height: 50,),

          Text('لا يوجد اتصال بالإنترنت!',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 5,),

          Text('تأكد من اتصالك بالإنترنت وحاول مرة أخرى',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
            textDirection: TextDirection.rtl,
          ),



          SizedBox(height: 50,),


          InkWell(
            onTap: ()=> Navigator.pop(context),
            child:  Container(
                margin: EdgeInsets.only(left: 70,right: 70),
                height: 45,
                decoration: BoxDecoration(
                  color: Color(0xff212660),
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x1a212660),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),

                child: Center(
                  child: Text('أعد المحاولة مجدداً',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                )
            ),
          )

        ],
      ),
    );
  }

}