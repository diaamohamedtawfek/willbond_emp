import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiForgetPassword();
  }
}

class UiForgetPassword extends State<ForgetPassword>{


  // ignore: non_constant_identifier_names
  bool _validate_username = false;
  TextEditingController email=new TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            title: Text("استرجاع كلمة السر",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xffffffff),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )
            ),

            backgroundColor: Color(0xff212660),
          ),

          body:Padding(padding: EdgeInsets.all(17),
            child:
            ListView(
              children: [
                Column(
                  children: [

                    SizedBox(height: 75,),

                    Text(
                      "من فضلك أدخل البريد الاكتروني لارسال رابط استرجاع كلمة السر",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),

                    SizedBox(height: 60,),

                    //email
                    TextFormField(
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        cursorColor: Color(0xff212660),
                        controller: email,
                        validator: (value)=>!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!)?"Enter Valid Email like  info@gmail.com ":null,
                        decoration: InputDecoration(
                          focusColor: Color(0xff212660),
                          border: OutlineInputBorder(),
                          labelText: 'البريد الالكتروني أو رقم الجوال',
                          hintText:  'البريد الالكتروني أو رقم الجوال',
                          errorText: _validate_username ? "يرجي التاكد من البريد الالكتروني أو رقم الجوال" : null,
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff212660),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),

                    SizedBox(height: 60,),

                   InkWell(

                     child:  Container(

                       margin: EdgeInsets.only(left: 46,right: 46),
                       width: MediaQuery.of(context).size.width,
                       height: 45,
                       decoration: BoxDecoration(
                         color: Color(0xff212660),
                         borderRadius: BorderRadius.circular(23),
                       ),
                       child:Center(
                         child:  Text('موافق',
                           style: TextStyle(
                             color: Colors.white,
                             fontFamily: 'Cairo',
                           ),
                         ),
                       )
                     ),
                   )
                  ],
                ),

              ],
            ),
          )
        )
    );
  }

}