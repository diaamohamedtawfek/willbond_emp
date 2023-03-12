import 'package:flutter/material.dart';


// ignore: camel_case_types
class NotFond_Error extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Ui_NotFond_Error();
  }

}

// ignore: camel_case_types
class Ui_NotFond_Error extends State<NotFond_Error>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: [


          SizedBox(height: 70,),
          Image(
            image: AssetImage('assets/error.png'),
            width: 120,
            height: 120,
          ),

          SizedBox(height: 50,),

          Text('الصفحة غير متوفرة!',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
            textDirection: TextDirection.rtl,
          ),

          SizedBox(height: 5,),

          Text('الصفحة التي تبحث عنها غير موجودة حاليا',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Cairo',
            ),
            textDirection: TextDirection.rtl,
          ),



          SizedBox(height: 50,),


//          InkWell(
//            onTap: ()=> Navigator.pop(context),
//            child:  Container(
//                margin: EdgeInsets.only(left: 70,right: 70),
//                height: 45,
//                decoration: BoxDecoration(
//                  color: Color(0xff212660),
//                  borderRadius: BorderRadius.circular(23),
//                  boxShadow: [
//                    BoxShadow(
//                      color: Color(0x1a212660),
//                      offset: Offset(0, 4),
//                      blurRadius: 8,
//                      spreadRadius: 0,
//                    ),
//                  ],
//                ),
//
//                child: Center(
//                  child: Text('أعد المحاولة مجدداً',
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontFamily: 'Cairo',
//                    ),
//                    textDirection: TextDirection.rtl,
//                  ),
//                )
//            ),
//          )

        ],
      ),
    );
  }

}