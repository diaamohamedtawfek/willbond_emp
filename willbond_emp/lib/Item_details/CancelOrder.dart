import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:willbond_emp/Home/Home.dart';
import 'package:willbond_emp/progress_dialog.dart';

import '../URL_LOGIC.dart';
class CancelOrder extends StatefulWidget{

  CancelOrder({Key? key, this.id, this.direction}) : super(key: key);

  final String? id;
  final String? direction;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiCancelOrder();
  }

}


class UiCancelOrder extends State<CancelOrder>{


  TextEditingController email=new TextEditingController();

  @override
  void initState() {
    super.initState();
    getData("");
//    controller = new ScrollController()
//      ..addListener(_scrollListener);
  }


  // ignore: non_constant_identifier_names
  Map? data_offer;
  // ignore: non_constant_identifier_names
  List? _All = [];
  
  Future getData(var search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.rejectFlag_or_cancel_order+"0&page=0&size=1000");
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
    http.Response responseOffer = await http.get(
        Uri.parse(URL_LOGIC.rejectFlag_or_cancel_order+"0&page=0&size=1000")
//      ,headers: headers,
      ,headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(responseOffer.body);

    setState(() {
      if(data_offer?["status"]==null){
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      data_offer = json.decode(responseOffer.body);
//      numpage++;
      
//      _All.addAll(data_offer[""])
      _All!.addAll(data_offer?["resultData"]["resultData"]??[]);
      print(data_offer.toString());

      for(int i=0;i<_All!.length;i++){
        FruitsList(name:_All![i]["cancelledLookupDescription"],index: _All![i]["id"]);
      }

    }else  if(data_offer?["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
//    retoken_list=1;\
    refrech_token();
    });

    return;
    }
    });
  }



  int? id ;

//  List<FruitsList> fList = [
//    FruitsList(
//      index: 1,
//      name: "Mango",
//    ),
//    FruitsList(
//      index: 2,
//      name: "Apple",
//    ),
//    FruitsList(
//      index: 3,
//      name: "Banana",
//    ),
//    FruitsList(
//      index: 4,
//      name: "Cherry",
//    ),
//  ];



  String radioItem = 'Mango';


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return  Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(

          appBar: AppBar(title: Text("أسباب الغاء الطلب ",
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



          body:
          ListView(
            padding: EdgeInsets.only(left: 15,right: 15,top: 22),
            children: [
              Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text('ما هي أسباب الغاء الطلب؟',
                    style: TextStyle(
                      color: Color(0xde000000),
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),


              SizedBox(height: 3,),
//          Container(
//            height: 350.0,
//            child: Column(
//              children:
//              fList.map((data) => RadioListTile(
//                title: Text("${data.name}"),
//                groupValue: id,
//                value: data.index,
//                onChanged: (val) {
//                  setState(() {
//                    radioItem = data.name ;
//                    id = data.index;
//                  });
//                },
//              )).toList(),
//            )
//          ),
//                  Expanded(
//                      child:
//                      Container(
//                        height: 350.0,
//                        child:
                        Column(
                          children:
                          _All!.map((data) => RadioListTile(
                            title: Text("${data["cancelledLookupDescription"].toString()}"),
                            groupValue: id,
                            value: int.parse("${data["id"]}"),
                            onChanged: (val) {
                              setState(() {
                                print(data["cancelledLookupDescription"].toString());
                                print(data["id"].toString());
//                                radioItem = data.name ;
                                id = int.parse(data["id"].toString());
                              });
                            },
                          )).toList(),
                        ),
//                      ),
//                  ),




                SizedBox(height: 10,),



                  //email
                  TextFormField(
                    minLines: 5,
                      maxLines: 11,
                      cursorColor: Color(0xff212660),
                      controller: email,
//                                validator: (value)=>!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)?"Enter Valid Email like  info@gmail.com ":null,
                      decoration: InputDecoration(
                        focusColor: Color(0xff212660),
                        border: OutlineInputBorder(),
                        labelText: 'اسباب الغاء الطلب؟',
                        hintText:  'اسباب الغاء الطلب؟',
//                        errorText: _validate_username ? "يرجي التاكد من البريد الالكتروني أو رقم الجوال" : null,
                      ),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff212660),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      )
                  ),


                  SizedBox(height: 30,),
                  
                  InkWell(
                    onTap: ()=> check_chose(),
                    child: Container(
                      margin: EdgeInsets.only(left: 40,right: 40),
                      height: 45,
                      decoration: BoxDecoration(
                        color:Color(0xff212660),
                        borderRadius: BorderRadius.circular(23),
                      ),

                      child: Center(
                        child: Text('موافق',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ),
                  )

                ],
              )
            ],
          ),
        )
    );
  }



  // ignore: non_constant_identifier_names, missing_return
  Future<List?> check_chose() async {
    if (id != null) {

        if (email.text.toString().isNotEmpty) {

          Map<String, dynamic> body ={
            "id": widget.id,
            "cancelRejectReason": email.text.toString(),
            "orderCancelledList": [
              {
                "cancelledLookup": {
                  "id": id
                }
              }
            ]
          };

          _sendItemData(body);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: null,
                content: Text(
                  "يجب اضافه ", textDirection: TextDirection.rtl,),
                actions: [
//            okButton,
                ],
              );
            },
          );
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
  // ignore: missing_return
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
      debugPrint("?????????");
      print("body is : "+body.toString());
      print("url is : "+URL_LOGIC.cancel_order);

      final encoding = Encoding.getByName('utf-8');
      String jsonBody = json.encode(body);
      final headers = {'Content-Type': 'application/json',"Authorization":"$token"};
      final response = await http.post(
          Uri.parse(URL_LOGIC.cancel_order),
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

        if(data_offer?["status"]==null){

        if(datauser["errorStatus"]==false || datauser["errorStatus"]=="false"){
          if(widget.direction==null) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Home()));
          }else{
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
//            Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Home()));
          }
        }
        else{
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

      }else  if(data_offer?["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
//    retoken_list=1;\
      refrech_token();
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
      getData("search");
//      getData_user("search");
    });
  }




}

class FruitsList {
  String? name;
  int? index;
  FruitsList({this.name, this.index});
}