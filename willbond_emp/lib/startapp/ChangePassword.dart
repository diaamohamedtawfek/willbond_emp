import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond_emp/progress_dialog.dart';

import '../URL_LOGIC.dart';

class ChangePassword extends StatefulWidget{

  // ignore: non_constant_identifier_names
  ChangePassword({Key? key, this.id_user}) : super(key: key);

  // ignore: non_constant_identifier_names
  final String? id_user;
//  final String password;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiChangePassword();
  }
}

class UiChangePassword extends State<ChangePassword>{


final _formKey = GlobalKey<FormState>();
  // ignore: non_constant_identifier_names
  bool _validate_password = false;
  TextEditingController password=new TextEditingController();
  // ignore: non_constant_identifier_names
  TextEditingController old_password=new TextEditingController();
  // ignore: non_constant_identifier_names
  bool _validate_repassord = false;
  TextEditingController repassord=new TextEditingController();


ProgressDialog? pr;
// ignore: missing_return
Future<List?> _sendItemData() async {

  //to send order
  pr = new ProgressDialog(context);
  pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
  pr!.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
  try{
    Map<String, dynamic> body = {
      "userId" : widget.id_user ,
      "currentPassword": old_password.text.toString() ,
      "newPassword" : password.text.toString()
    };

    debugPrint("?????????");
    print("body is : "+body.toString());
    print("url is : "+URL_LOGIC.change_password);

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
        Uri.parse(URL_LOGIC.change_password),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    //"message":"You Logined To Your Account ."
    var dataUser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
    debugPrint(dataUser.toString());


//      debugPrint("message >>> "+actions);

    Future.delayed(Duration(seconds: 1)).then((value) async {
      pr!.hide();
      if(dataUser["errorStatus"]==true || dataUser["errorStatus"]=="true"){
//        print("object");
////          setState(() {
//        _validate=false;
//        _validate_username=false;
//        if (_formKey.currentState.validate()) {
//          // If the form is valid, display a Snackbar.
////            Scaffold.of(context)
////                .showSnackBar(SnackBar(content: Text(datauser["errorResponsePayloadList"][0]["arabicMessage"])));
//        }
//          _formKey.currentState;
//            _validate=false;
//          });
      } else{
//          saveToken(datauser);
        print("login");

        Navigator.pop(context);
        Navigator.pop(context);
//        var token=datauser["resultData"]["tokenPair"]["jwt"];
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('token',token.toString());
//        Navigator.push(
//          context,
//          MaterialPageRoute(builder: (context) =>
//              Home()),
//        );
      }


    });

//      if(datauser["code"]=="009"){
//
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('idUser', datauser["userid"]);
//
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => HomApp()));
//      }else{
//        showDilogFieldLogin(datauser["message"]);
//      }



  }catch(exception){
    Future.delayed(Duration(seconds: 3)).then((value) {
      pr!.hide();
//            _validate_username=true;
//            _validate=true;
      setState(() {
        print("object ??"+exception.toString());
        pr!.hide().then((isHidden) {
          print(isHidden);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return   AlertDialog(
              title: null,
              content: Text("يرجي التاكد من الاتصال بل النترنت"),
              actions: [
//            okButton,
              ],
            );
          },
        );
//            Navigator.pop(context, true);
      });
    });

  }
}




bool _passwordVisible = false;
bool _repasswordVisible = false;
bool _oldpasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: AppBar(
            title: Text("تغيير كلمة السر",
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


          body: Padding(
            padding: EdgeInsets.all(17),
            child:
            Form(
              key: _formKey,
              child:ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    SizedBox(height: 60,),

                    //passowrd
                    TextFormField(
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        cursorColor: Color(0xff212660),
                        controller: password,
                        obscureText: !_passwordVisible,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return  'الرقم السري';
                          }
                          return null;
                        },
//                        validator: (value) =>
//                        !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                            .hasMatch(value)
//                            ? "Enter Valid password  "
////                            ? "Enter Valid password like  info@gmail.com "
//                            : null,
                        decoration: InputDecoration(

                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),

                          focusColor: Color(0xff212660),
                          border: OutlineInputBorder(),
                          labelText: 'كلمة السر الجديدة',
                          hintText: 'كلمة السر الجديدة',
                          errorText: _validate_password
                              ? "كلمة السر الجديدة"
                              : null,
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff212660),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),

                    SizedBox(height: 10,),

                    new Text(" قوة كلمة السر :",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),

                      textDirection: TextDirection.rtl,
                    ),

                    new Text("يجب أن تحتوى على ( 8 ) أحرف على الأقل (كبيرة وصغيرة)  ورقم واحد على الأقل",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,


                        )
                    ),

                    SizedBox(height: 50,),

                    // re_passowrd
                    TextFormField(
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                      obscureText: !_repasswordVisible,
                        cursorColor: Color(0xff212660),
                        controller: repassord,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return  'الرقم السري';
                          }else{
                            if(password.text.toString() != repassord.text.toString()){
                              return  ' الرقم السري غير صحيح';
                            }else{
                              _sendItemData();
                            }
                          }
                          return null;
                        },
//                        validator: (value) => password.text.toString() != repassord.text.toString(),
//                        !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                            .hasMatch(value)
//                            ? "Enter Valid Email like  info@gmail.com "
//                            : null,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _repasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _repasswordVisible = !_repasswordVisible;
                              });
                            },
                          ),

                          focusColor: Color(0xff212660),
                          border: OutlineInputBorder(),
                          labelText: 'تأكيد كلمة السر الجديدة',
                          hintText: 'تأكيد كلمة السر الجديدة',
                          errorText: _validate_repassord
                              ? "تأكيد كلمة السر الجديدة"
                              : null,
                        ),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff212660),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),


                    SizedBox(height: 50,),
                    //old password
                    TextFormField(
                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                        cursorColor: Color(0xff212660),
                        controller: old_password,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return  'الزقم السري القديم';
                          }
                          return null;
                        },
//                        validator: (value) => password.text.toString() != repassord.text.toString(),
//                        !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                            .hasMatch(value)
//                            ? "Enter Valid Email like  info@gmail.com "
//                            : null,
                    obscureText: !_oldpasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _oldpasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _oldpasswordVisible = !_oldpasswordVisible;
                              });
                            },
                          ),

                          focusColor: Color(0xff212660),
                          border: OutlineInputBorder(),
                          labelText: 'الزقم السري القديم',
                          hintText: 'الزقم السري القديم',
                          errorText: _validate_repassord
                              ? "الزقم السري القديم"
                              : null,
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
                      onTap: ()=>{
                      if (_formKey.currentState!.validate()) {
//                        _sendItemData();
          }
                      },
                      child: Container(

                          margin: EdgeInsets.only(left: 46, right: 46),
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff212660),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          child: Center(
                            child: Text('تغيير كلمة السر',
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
          ),
        )
    )
    );
  }

}