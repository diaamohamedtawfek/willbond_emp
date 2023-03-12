import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond_emp/Home/Home.dart';
import 'package:willbond_emp/progress_dialog.dart';
import '../URL_LOGIC.dart';

class UpdateProfile extends StatefulWidget{

  UpdateProfile({Key? key, this.fullName,this.phoneNumber,this.address,this.id,}) : super(key: key);

  final String? fullName , phoneNumber , address , id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiUpdateProfile();
  }
}

class UiUpdateProfile extends State<UpdateProfile>{


  // ignore: non_constant_identifier_names
  bool _validate_username = false;
  // ignore: non_constant_identifier_names
  bool _validate_phone = false;
  // ignore: non_constant_identifier_names
  bool _validate_address = false;

  TextEditingController name=new TextEditingController();
  TextEditingController phone=new TextEditingController();
  TextEditingController address=new TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  // ignore: missing_return
  void initState() {
    super.initState();

    name.text=widget.fullName??"";
    phone.text=widget.phoneNumber??"";
    address.text=widget.address??"";
  }

  ProgressDialog? pr;
  // ignore: missing_return
  Future<List?> _sendItemData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order //fullName , phoneNumber , address
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr!.show();
//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{
      Map<String, dynamic> body = {
      "id": widget.id,
      "fullName":name.text.toString(),
      "phoneNumber": phone.text.toString(),
      "address": address.text.toString(),
      };

      debugPrint("?????????");
      print("body is :"+body.toString());
      print("url is :"+URL_LOGIC.update_profile);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      print("headers :"+headers.toString());
      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
//      final headers = {'Content-Type': 'application/json'};
      final response = await http.put(
          Uri.parse(URL_LOGIC.update_profile),
        body:jsonBody,
        encoding: encoding,
        headers: headers,
      );
      //"message":"You Logined To Your Account ."
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) {
        pr!.hide();
        if(datauser["errorStatus"]==true || datauser["errorStatus"]=="true"){
          print("object");
//          setState(() {
          _validate_username=false;
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a Snackbar.
//            Scaffold.of(context)
//                .showSnackBar(SnackBar(content: Text(datauser["errorResponsePayloadList"][0]["arabicMessage"])));
          }
//          _formKey.currentState;
//            _validate=false;
//          });
        }else  if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          _validate_username=true;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
                    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                Home()),
          );
//          _formKey.currentState;
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

  bool x=false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(

          appBar: AppBar(title: Text("تعديل الملف الشخصي",
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

          body: ListView(
            children: [
              Padding(padding: EdgeInsets.only(left: 17, right: 17),
                child: Form(
                    key: _formKey,
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [


                            SizedBox(height: 20,),

                            //name
                            TextFormField(
                              enabled: x,
                              controller: name,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return  'الاسم كاملاً';
                                }
                                return null;
                              },
                              //                                          validator: (input) => input.isValidEmail() ? null : "Check your email",
//                                          validator: (val) {
//                                            if (val.isEmpty) {
//                                              return  'الاميل';
//                                            }else{
//                                              isValidEmail();
//                                            }
//                                            return null;
//                                          },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'الاسم كاملاً',
                                hintText:  'الاسم كاملاً',
                                errorText: _validate_username ? "يرجي التاكد من الاسم كاملاً" : null,
                              ),
                            ),

                            SizedBox(height: 20,),


                            //phone
                            TextFormField(
                              enabled: x,
                              controller: phone,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return  'رقم الموبايلً';
                                }
                                return null;
                              },
                              //                                          validator: (input) => input.isValidEmail() ? null : "Check your email",
//                                          validator: (val) {
//                                            if (val.isEmpty) {
//                                              return  'الاميل';
//                                            }else{
//                                              isValidEmail();
//                                            }
//                                            return null;
//                                          },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'رقم الموبايل',
                                hintText:  'رقم الموبايل',
                                errorText: _validate_phone ? "يرجي التاكد من رقم الموبايل" : null,
                              ),
                            ),

                            SizedBox(height: 20,),

                            //address
                            TextFormField(
                              enabled: x,
                              controller: address,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return  'العنوان';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'العنوان',
                                hintText:  'العنوان',
                                errorText: _validate_address ? "يرجي التاكد من العنوان" : null,
                              ),
                            ),

                            SizedBox(height: 20,),



                            // login
                            new Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 60),
                              child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Color(0xff212660),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
//                                          _sendItemData();
                                        setState(() {

                                          if(x!=false){
                                            print("$x");
                                            _sendItemData();
                                          }else{
                                            x = !x;
                                          }
//                                          x = !x;

                                        });

                                        }
//                                check();
                                      },
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Text(x!=true?"تعديل":" تحديث الحساب الشخصي",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            color: Color(0xffffffff),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: 0.14,

                                          )
                                      )
                                  )),
                            ),





                          ],
                        ),

                ),
              ),
            ],
          ),
        )
    );
  }

}