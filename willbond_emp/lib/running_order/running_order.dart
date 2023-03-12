
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond_emp/Design_page_error_fether/Error_Found_Page.dart';
import 'package:willbond_emp/Item_details_Running_order/Item_details_Running_Order.dart';
import 'package:willbond_emp/homeWite1.dart';

import '../URL_LOGIC.dart';


import 'package:persian_number_utility/persian_number_utility.dart';
//الطلبات الحاليه
// ignore: camel_case_types
class Running_order extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiRunning_order();
  }

}

//الطلبات الحاليه
// ignore: camel_case_types
class UiRunning_order extends State<Running_order>{
//الطلبات الحاليه


  int sates=0;
String dropdownValue="";

  TextEditingController email=new TextEditingController();

  var visible=false;

  // ignore: non_constant_identifier_names
  Map? data_offer;

  ScrollController? controller;
  // ignore: non_constant_identifier_names
  List? _All = [];
//  final _saved = new Set<Object>();
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;


  Future getRefrich() async {
    numpage=0;
    _All!.clear();
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    getData("");
    controller = new ScrollController()
      ..addListener(_scrollListener);


  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  void _scrollListener() {
    if (controller?.position.pixels == controller?.position.maxScrollExtent) {
      if(numpage<test+2) {
        isLoading=true;
        startLoader();
//        startLoader();
      }else{
        setState(() {
//          isLoading=false;
//          isLoading = !isLoading;
        });
      }
    }
  }

  void startLoader() {
    setState(() {
//      fetchData();
      getData("");

    });
  }



  Future getData(var search) async {
    setState(() {
      isLoading = true ;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.running_order+"$numpage"+"&size=15");
    isLoading = true;
    setState(() {
      isLoading = true;
//      data_offer.clear();
//      _All.clear();
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response responseOffer = await http.get(
        Uri.parse(URL_LOGIC.running_order+"$numpage"+"&size=10")
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
//      print("data_offer  > $data_offer");
      data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
      _All!.addAll(data_offer?["resultData"]["resultData"]??[]);
      numpage++;

      print(_All);

//      count

      // print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
      totalRow = data_offer?["resultData"]["totalItemsCount"];
      var x=  totalRow / 10 ;
      test=x.toInt();

      isLoading = false ;
      _loader();
//      isLoading = !isLoading;
    }else  if(data_offer?["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
//    retoken_list=1;
    });
    refrech_token();
    return;
    }
    });
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
    });
  }



  // ignore: non_constant_identifier_names
  Future getData_search(var search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.running_order_serch+"$search"+"&page=$numpage"+"&size=10");
    isLoading = true;
    setState(() {
      isLoading = true;
//      data_offer.clear();
//      _All.clear();
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
    http.Response responseOffer = await http.get(
        Uri.parse(URL_LOGIC.running_order_serch+search+"&page=$numpage"+"&size=10")
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
//      print(data_offer.toString());
      print("all item with sates >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
      data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
//      _All.addAll(data_offer["resultData"]["resultData"]);
      _All!.addAll(data_offer?["resultData"]["resultData"]??[]);
      numpage++;

      print(_All);

//      count

      // print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
      totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
      var x=  totalRow / 10 ;
      test=x.toInt();

      isLoading = false ;
      _loader();
//      isLoading = !isLoading;
    });
  }


// ignore: non_constant_identifier_names
Future getData_search_sates(var search) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? token = prefs.getString('token');

  print(URL_LOGIC.running_order_serch_sates+"$search"+"&page=$numpage"+"&size=15");
  isLoading = true;
  setState(() {
    isLoading = true;
//      data_offer.clear();
//      _All.clear();
  });
  Map<String, String> timeOutMessage = {
    'state': 'timeout',
    'content': 'server is not responding'
  };

  // offer
//  final headers = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
  http.Response responseOffer = await http.get(
      Uri.parse(URL_LOGIC.running_order_serch_sates+search+"&page=$numpage"+"&size=10")
//      ,headers: headers,
    ,headers: {"Authorization":"$token"},
  )
      .timeout(Duration(seconds: 90), onTimeout: () {
    return Future.value(http.Response(json.encode(timeOutMessage), 500));
  }).catchError((err) {
    // nothing
  });
  data_offer = json.decode(responseOffer.body);

  print(data_offer.toString());
  setState(() {


    try{
      if( data_offer?["status"].toString().trim()!="null" ) {
        setState(() {
          // print("status >>>>>>   is       ${data_offer["status"].toString()}");
          sates = 500;
        });
      }
    }on Exception catch (_) {
      print("throwing new error");
      throw Exception("Error on server");
    }

    print("all item> Sates  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
    _All!.addAll(data_offer?["resultData"]["resultData"]??[]);
    numpage++;

    print(_All);


//    print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
    totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
    var x=  totalRow / 10 ;
    test=x.toInt();

    isLoading = false ;
    _loader();
//      isLoading = !isLoading;

    print("?????????????????????????????");
    // print(" status "+data_offer["status"].toString());

  });
}




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
            top: false,
            child: Scaffold(
          appBar: AppBar(title: Text("الطلبات الحاليه",
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


          body:_All==null?HomeWiting1()
              :
          sates==500? Error_Found_Page()
              :
          RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child: Directionality(textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  Stack(

                    children: [

                      SearchAppBar(),

                      // drop down list use sates order
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: EdgeInsets.only(top: 70),
                          child:   InkWell(

                            onTap: () =>
                            {
                              print("object"),
                            },
                            child:sates_error(),
                          ),
                        ),
                      ),


                      Padding(padding: EdgeInsets.only(top: 130),
                        child: _All==null?HomeWiting1()
                            :listItem_new(),
                      ),

                      _loader()
                    ],
                  )
              ),
            ),
          ),
        )
        )
    );
  }


// ignore: non_constant_identifier_names
Widget sates_error(){
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
      padding: EdgeInsets.only(
          top: 0, left: 22, right: 22),
      child: Container(

//        padding: EdgeInsets.only(left: 22, right: 22),
        height: 48,
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.only(left: 22,right:22),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0x42221f1f),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),

        child:
        Center(
          child:  DropdownButtonHideUnderline(
              child:

              DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            hint:Text("") ,
            items: <String>['','قيد التسليم', 'قيد التصنيع'].map((String value) {
//            items: <String>["حالة الطلب",'جاهز للتسليم', 'قيد التصنيع','قيد المراجعه'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    new Text(value,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              );
            }).toList(),

            onChanged: (val) {
              print(val);
              setState(() {
                dropdownValue=val.toString();
                if(val.toString().trim()==""){
                  email.text="";
                  _All!.clear();
                  numpage=0;
                  getData("");
                }

                if(val.toString().trim()=="قيد التسليم"){
                  _All!.clear();
                  email.text="";
                  numpage=0;
                  sates=0;
                  getData_search_sates("5");
                }
                if(val.toString().trim()=="قيد التصنيع"){
                  _All!.clear();
                  email.text="";
                  sates=0;
                  numpage=0;
                  getData_search_sates("4");
                }
                if(val.toString().trim()=="قيد المراجعه"){
                  _All!.clear();
                  email.text="";
                  numpage=0;
                  sates=0;
                  getData_search_sates("3");
                }

              });

            },
          )),
        ),
      ),
    )
      ,
    );
}





  // ignore: non_constant_identifier_names
  Widget SearchAppBar(){
    return

      Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xff212660),
        child: Padding(
            padding: EdgeInsets.only(left: 13.0, right: 13.0,top: 5,bottom: 9),
            child:
            Directionality(
              textDirection: TextDirection.rtl,
              child:
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),

                child: TextFormField(
                    onChanged: (val){
                      print(val);
                      if(val.isEmpty){
                        _All!.clear();
                        numpage=0;
                        getData("");
//                        dropdownValue="حالة الطلب";
                      }else{
                        print(val);
                        _All!.clear();
                        numpage=0;
//                        dropdownValue="حالة الطلب";
                        getData_search(val.toEnglishDigit().toString().toString());
                      }
                    },

                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                        child: Icon(Icons.search),
                      ),
                      focusColor: Color(0xff212660),
                      hintText:  'ابحث رقم الطلب/ اسم  مقدم الطلب',
                    ),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff212660),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    )
                ),
              ),
//                    InkWell(
////                      onTap: ()=>  Navigator.push(context,MaterialPageRoute(builder: (context) => SerchHome()),),
//                      child:   Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Icon(Icons.search, color: Color(0xff4f008d),),
//                          Text("ابحث",
//                            textAlign: TextAlign.right,
//                            textDirection: TextDirection.rtl,
//                            style: TextStyle(
//                                color: Colors.grey[400],
//                                fontSize: 16.0
//                            ),),
//                        ],
//                      ),
//                    ),
            )
//              ),
        ),
      )


    ;
  }




  // ignore: non_constant_identifier_names
  Widget listItem_new() {
    print("???????????????????????????");
    print("widget >> $_All");
    if(_All==null){
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text("",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),


                new Image(image: AssetImage('assets/search.png'),
                  width: 114,height: 165,),
              ],
            ),
          )
      );
    }


    else{
      return  Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
//            height: 80,
            child: new ListView.builder(
//              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 0,
              ),
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 2,
//                  childAspectRatio: .80
//              ),
              // SliverGridDelegateWithFixedCrossAxisCount
              controller: controller,
              itemCount: _All == null ? 0 : _All
                  !.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return

                  Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 10.0),
                      child:
                      Column(
                        children: [


                          Container(

                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: InkWell(
                                    onTap: () =>
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Item_details_Runnig_order(
                                                      id: _All![index]["id"]
                                                          .toString(),))
                                        ),
                                    child: Column(
                                      children: <Widget>[

                                        //تاريخ
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(_All![index]["submitDate"]!=null?'${_All![index]["submitDate"].toString().substring(0,10)}'
                                                :"لا يوجد تاريخ ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ],
                                        ),

//                                  رقم الطلب
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [


                                            Text('رقم الطلب ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),


                                            SizedBox(width: 11,),

                                            Text('${_All![index]["id"].toString()}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),

                                          ],
                                        ),


                                        //orderTotal
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [


                                            Text('${_All![index]["orderTotal"].toString()}',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Color(0xff000000),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,

                                                )
                                            ),

                                            SizedBox(width: 7,),

                                            Text('جنيه',
                                                style: TextStyle(
                                                  fontFamily: 'Cairo',
                                                  color: Color(0xff000000),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,

                                                )
                                            ),

                                          ],
                                        ),

                                        // user name , sates order
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            // user name
                                            Row(
//                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                //customerName
                                                Icon(Icons.person,color: Color(0xff707070),),
                                                Text('  ${_All![index]["customerMobileDto"]["customerName"].toString()} ',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Color(0xff000000),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      fontStyle: FontStyle.normal,

                                                    ),
                                                ),
                                              ],
                                            ),


                                            //  sates order
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                Text('  ${_All![index]["orderStatus"]["description"].toString()} ',
                                                    style: TextStyle(
                                                      fontFamily: 'Cairo',
                                                      color: Color(0xff000000),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w700,
                                                      fontStyle: FontStyle.normal,

                                                    )
//                                                      ),
                                                ),

//                                                      Expanded(
//                                                        flex: 1,child:
                                                Icon(Icons.arrow_forward_ios,color: Color(0xff707070),),
//                                                      ),

                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 3,),
                                        Divider(height: 1,color: Colors.black,),

                                      ],
                                    )
                                )
                            ),
                          ),


                        ],
                      ),


                    ),
                  )
                    ;
              },
            ),
          )
      )
      ;
    }

  }

  Widget _loader() {
    return isLoading
        ? new Align(
      child: new Container(
        width: 70.0,
        height: 70.0,
        child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(child: new CircularProgressIndicator())),
      ),
      alignment: FractionalOffset.bottomCenter,
    )
        : new SizedBox(
      width: 0.0,
      height: 0.0,
    );
  }
}