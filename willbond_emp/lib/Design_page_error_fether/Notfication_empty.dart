import 'package:flutter/material.dart';


// ignore: camel_case_types
class Notfication_empty extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_Notfication_empty();
  }

}

// ignore: camel_case_types
class Ui_Notfication_empty extends State<Notfication_empty>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [

          SizedBox(height: 100,),
          Image(
            image: AssetImage('assets/noti_empity.png'),
            width: 120,
            height: 120,
          ),

          SizedBox(height: 50,),

          Text('لا يوجد لديك تنبيهات في الوقت الحالي',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 5,),





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
                  child: Text('الرئيسية',
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