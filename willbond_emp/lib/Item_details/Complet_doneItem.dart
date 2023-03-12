import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:willbond_emp/Home/Home.dart';
import 'package:intl/intl.dart' as intl_date;
import 'package:willbond_emp/progress_dialog.dart';
import '../URL_LOGIC.dart';


// ignore: camel_case_types
class Complet_doneItem extends StatefulWidget{


  Complet_doneItem({Key? key, this.id}) : super(key: key);

  final String? id;


  @override
  State<StatefulWidget> createState() {
    return UiItem_details();
  }

}

// ignore: camel_case_types
class UiItem_details extends State<Complet_doneItem>{

  String? day,month,year;


  String? x;
  Future _selectDate() async {
    print("object");


    DateTime selectedDate = DateTime.now();

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(int.parse(year!), int.parse(month!),int.parse(day!)),
        lastDate: DateTime(2201,8));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String v=picked.toString();
        v.substring(0,10);
        x="${v.substring(0,10)}";
        email.text ="$x";

        print(">>>>>>>>>>>>>>$x");
        email.text ="$x";

      });
  }


//  bool _validate_username = false;
  TextEditingController email=new TextEditingController();

  String? _radioValue; //Initial definition of radio button value
  int? choice;
  void radioButtonChanges(String? value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case '1':
          choice = 4;
//          choice = "قيد التصنيع";
          break;
        case '2':
          choice =5;
          email.text="";
//          choice = "جاهز للتسليم";
//            type = "emp";
          break;
//        default:
//          choice = "جاهز للتسليم";
//            type = "emp";
      }
      setState(() {
        // ignore: unnecessary_statements
        choice;
      });
      debugPrint(choice.toString()); //Debug the choice in console
    });
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    String formatDateYear = intl_date.DateFormat('yyyy').format(now);
    String formatDateMonth = intl_date.DateFormat('MM').format(now);
    String formatDateDay= intl_date.DateFormat('dd').format(now);
    print(formatDateYear);
    print(formatDateMonth);
    print(formatDateDay);
    day=formatDateDay;
    month=formatDateMonth;
    year=formatDateYear;

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[

        Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .start,
                crossAxisAlignment: CrossAxisAlignment
                    .start,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 1),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(
                            width: 1.0,
                            color: Colors.white
//                                  color: Colors.grey[300]
                        )
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .start,
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [

                        Text('حالة الطلب',
                          style: TextStyle(
                            color: Color(0xde000000),
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),


                        Column(

                          mainAxisAlignment: MainAxisAlignment
                              .start,
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              children: <Widget>[
                                Radio(
                                  activeColor: Colors
                                      .black,
                                  value: '1',
                                  groupValue: _radioValue,
                                  onChanged: radioButtonChanges,
                                ),
                                Text(
                                  "قيد التصنيع",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .start,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              children: <Widget>[
                                Radio(
                                  value: '2',
                                  groupValue: _radioValue,
                                  onChanged: radioButtonChanges,
                                ),
                                Text(
                                  "جاهز للتسليم",
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),

                        SizedBox(height: 20,),

                        Text('المدة المتوقعة لتجهيز الطلب',
                          style: TextStyle(
                            color: Color(0xde000000),
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),


                        SizedBox(height: 20,),



                        //name


                        InkWell(
                          onTap: () =>
                          {
                          if(choice==4){
                            _selectDate(),
                          }else{
                          }
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 500,
                              minWidth: 200,
                              minHeight: 50,
                            ),
                            child: TextFormField(
                              enabled: false,
                              controller: email,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'ادخل التاريخ';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ادخل التاريخ',
                                hintText: 'ادخل التاريخ',
hintStyle:  TextStyle(
                                  color: Color(0xde000000),
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                              ),
                              style: TextStyle(
                                color: Color(0xde000000),
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
//                              ),
                        ),


                        SizedBox(height: 20,),

                        Divider(height: 1,color: Colors.black26,),

                       Directionality(
                           textDirection: TextDirection.ltr,
                           child:  Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [


                           InkWell(
                               onTap: ()=> Navigator.pop(context),
                               child: Text('الغاء',
                                 style: TextStyle(
                                   color: Colors.black,
                                   fontSize: 13,
                                   fontFamily: 'Cairo',
                                   fontWeight: FontWeight.w600,
                                 ),
                               )
                           ),

                           SizedBox(height: 40,width: 40,),

                           InkWell(
                             onTap: ()=> {
                               check_chose()
                             },
                             child: Text('موافق',
                               style: TextStyle(
                                 color: Colors.black,
                                 fontSize: 13,
                                 fontFamily: 'Cairo',
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                           )
                         ],
                       )
                       )
                      ],
                    ),

                  ),

                ],
              ),)
        ),
      ],
    )  ;
  }




// ignore: camel_case_types, missing_return, non_constant_identifier_names
  Future<List?> check_chose() async {
    if (choice != null) {
      if(choice==4){
        if (email.text.toString().isNotEmpty) {

          Map<String, dynamic> body ={
            "orderId" : widget.id ,
            "statusId" : choice ,
            "deliveryReadyDate" : email.text.toString()
          };

          _sendItemData(body);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: null,
                content: Text(
                  "يجب اضافه تاريخ التسليم ", textDirection: TextDirection.rtl,),
                actions: [
//            okButton,
                ],
              );
            },
          );
        }
      }else{

        Map<String, dynamic> body ={
          "orderId" : widget.id ,
          "statusId" : choice ,
//          "deliveryReadyDate" : email.text.toString()
        };
        _sendItemData(body);

      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: null,
            content: Text(
              "يجب اختيار الحاله", textDirection: TextDirection.rtl,),
            actions: [
//            okButton,
            ],
          );
        },
      );
    }
  }


  ProgressDialog? pr;
// ignore: camel_case_types, missing_return
  Future<List?> _sendItemData(Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    //to send order
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr!.show();


//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{
//      Map<String, dynamic> body ={
//        "orderId" : widget.id ,
//        "statusId" : choice ,
//        "deliveryReadyDate" : email.text.toString()
//      };

      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.done_order);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.post(
          Uri.parse(URL_LOGIC.done_order),
        body:jsonBody,
        encoding: encoding,
          headers: headers
//        headers: headers,
      );
      //"message":"You Logined To Your Account ."
      var datauser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint(datauser.toString());


//      debugPrint("message >>> "+actions);

      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr!.hide();
        if(datauser["status"]==null){
        if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Home()));

        }else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: null,
                content: Text(
                  "حدث خطا", textDirection: TextDirection.rtl,),
                actions: [
//            okButton,
                ],
              );
            },
          );
        }
        }else  if(datauser["status"].toString()=="401") {
          print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
          setState(() {
            refrech_token();
//            retoken_list=1;
          });

          return;
        }

      });

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


  Future refrech_token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? reToken = prefs.getString('reToken');
    String? token = prefs.getString('token');


    Map<String, dynamic> body = {
      "refreshToken": reToken
    };
    debugPrint("?????????");
    print("body is :"+body.toString());
    print("url is :"+URL_LOGIC.refrechToken);

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
    final response = await http.post(
        Uri.parse(URL_LOGIC.refrechToken),
      body:jsonBody,
      encoding: encoding,
      headers: headers,
    );
    var datauserxx = json.decode(response.body);
    debugPrint(datauserxx.toString());


    Future.delayed(Duration(seconds: 3)).then((value)  {
      setState(()  async {
        if(datauserxx["errorStatus"]==true || datauserxx["errorStatus"]=="true"){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return   AlertDialog(
                title: null,
                content: Text("${datauserxx["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cairo',
//                      color: Color(0xffffffff),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )
                ),
              );
            },
          );
        }
        else{
//          saveToken(datauser);
          print("refresh Token");
          print(datauserxx.toString());

          var token=datauserxx["resultData"]["tokenPair"]["jwt"];
          var retoken=datauserxx["resultData"]["tokenPair"]["refreshToken"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token',token.toString());
          prefs.setString('reToken',retoken.toString());

          getRefrich_all();
        }
      });

    });


  }

  Future getRefrich_all() async {
    setState(() {
//      getData("search");
//      getData_user("search");
    });
  }



}

