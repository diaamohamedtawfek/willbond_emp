import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond_emp/Home/Home.dart';

import '../URL_LOGIC.dart';
import '../progress_dialog.dart';
import 'forgetpassword.dart';

class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiLogin();
  }

}
ProgressDialog? pr;
class UiLogin extends State<Login> {

  bool _validate = false;
  // ignore: non_constant_identifier_names
  bool _validate_username = false;
  TextEditingController email=new TextEditingController();
  TextEditingController password=new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ignore: missing_return
  Future<List?> _sendItemData() async {

    //to send order
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr!.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{
      Map<String, dynamic> body = {
        "userEmail":email.text.toString().trim(),
        "password":password.text.toString().trim()
      };

      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.login);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
          Uri.parse(URL_LOGIC.login),
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

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr!.hide();
        if(datauser["errorStatus"]==true || datauser["errorStatus"]=="true"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("${datauser["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
//                      color: Color(0xffffffff),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )
                ),
                actions: [
//            okButton,
                ],
              );
            },
          );
          print("object");
//          setState(() {
            _validate=false;
            _validate_username=false;
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a Snackbar.
//            Scaffold.of(context)
//                .showSnackBar(SnackBar(content: Text(datauser["errorResponsePayloadList"][0]["arabicMessage"])));
          }
//          _formKey.currentState;
//            _validate=false;
//          });
        }
        else{
//          saveToken(datauser);
        print("login");

            var token=datauser["resultData"]["tokenPair"]["jwt"];
        var retoken=datauser["resultData"]["tokenPair"]["refreshToken"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token',token.toString());
        prefs.setString('reToken',retoken.toString());
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home()));
        }


      });
    }catch(exception){
      Future.delayed(Duration(seconds: 1)).then((value) {
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


  saveToken(datauser) async{
    print(">>>");
    print(datauser["resultData"]["tokenPair"]["jwt"]);
     var token=datauser["resultData"]["tokenPair"]["jwt"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token',token.toString());
    _validate=true;
    _validate_username=true;
  }


  @override
  void initState() {
    super.initState();

   //  email.text="dr_Mona2@gmail.com";
   // // email.text="admin@gmail.com";
   //  password.text="123Aa";
  }


  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xff212660),
      appBar: null,

      body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
              padding: EdgeInsets.only(
                  left: 17, right: 17, top: 35, bottom: 35),
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: new BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(
                      color: Color(0x29000000),
                      offset: Offset(0, 3),
                      blurRadius: 6,
                      spreadRadius: 0
                  )
                  ],
                ),
                child: Padding(padding: EdgeInsets.only(left: 17,right: 17),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [

                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 17, right: 17, top: 17, bottom: 5),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
//                      color: Colors.black,
                                      image: DecorationImage(
                                          image: new AssetImage('assets/logo.png'),
                                          //image: NetworkImage('https://images.unsplash.com/photo-1547665979-bb809517610d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80'),
                                          fit: BoxFit.fill
                                      ),
                                    ),
//                        child: Image(image: AssetImage('assets/logo.png'),fit: BoxFit.fill,height: 100,width: 100,)
                                  ),

                                  new Text("تسجيل الدخول",
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        color: Color(0xff212660),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                      )
                                  ),
                                ],
                              ),
                            ),



                            SizedBox(height: 55,),
                            //email
                            TextFormField(
                                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                cursorColor: Color(0xff212660),
                                controller: email,
//                                validator: (value)=>!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?"Enter Valid Email like  info@gmail.com ":null,
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

                            SizedBox(height: 20,),


//                    SizedBox(height: 20,),

                            //password
                            TextFormField(
                                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                obscureText: !_passwordVisible,
                                controller: password,
//                                obscureText: true,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return  'الرقم السري';
                                  }
                                  return null;
                                },
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

                                  border: OutlineInputBorder(),
                                  labelText: 'الرقم السري',
                                  hintText:  'الرقم السري',
                                  errorText: _validate ? "يرجي التاكد من الرقم السري" : null,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,


                                )
                            ),

                            SizedBox(height: 11,),

                            InkWell(
                              onTap: ()=>Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ForgetPassword())),
                              child:   Text("نسيت كلمة السر أو البريد الالكتروني؟",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xff212660),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),



                            // login
                            new Padding(
                              padding: EdgeInsets.only(left: 15,right: 15,top: 60),
                              child: Material(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Color(0xff212660),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: (){
                                        if (_formKey.currentState!.validate()) {
                                          _sendItemData();
                                        }
//                                check();
                                      },
                                      minWidth: MediaQuery.of(context).size.width,
                                      child: Text("تسجيل دخول",
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
                      ],
                    ) ,
                  ),
                )

              )
          )
      ),
    );
  }


}