import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond_emp/Design_page_error_fether/Error_Found_Page.dart';
import 'package:willbond_emp/Item_details_Running_order/Item_details_Archef_Order.dart';

import '../URL_LOGIC.dart';


import 'package:persian_number_utility/persian_number_utility.dart';

//ارشيف الطلبات
// ignore: camel_case_types
class Arseff_order extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //l TODO: implement createState
    return UiRunning_order();
  }
}


// ignore: camel_case_types
class  UiRunning_order extends State<Arseff_order>{


  int sates=0;

  String dropdownValue="حالة الطلب";

  TextEditingController email=new TextEditingController();

  var visible=false;

  // ignore: non_constant_identifier_names
  Map? data_offer;

  ScrollController? controller;
  // ignore: non_constant_identifier_names
  List _All = [];
  bool isLoading = false;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int numpage = 0;
  int totalRow=0;
  int test=0;


  Future getRefrich() async {
    numpage=0;
    _All.clear();
    getData("");
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    print("arseff");
    getData("");
    controller = new ScrollController()
      ..addListener(_scrollListener);


//    Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print(URL_LOGIC.arseeff_order+"$numpage"+"&size=15");
    setState(() {
      isLoading = true;
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json"};
    http.Response responseOffer = await http.get(
        Uri.parse(URL_LOGIC.arseeff_order+"$numpage"+"&size=10")
      ,headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(responseOffer.body);


    setState(() {

      print(data_offer?["status"]??"");
      if(data_offer?["status"]==null){
      print(data_offer.toString());
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print("arsef order result");
      data_offer = json.decode(responseOffer.body);
      print(data_offer.toString());
      _All.addAll(data_offer?["resultData"]["resultData"]??[]);
      numpage++;

      print(_All);
      print("totalItemsCount > ${data_offer?["resultData"]["totalItemsCount"]}");
      totalRow = data_offer?["resultData"]["totalItemsCount"];
      var x=  totalRow / 10 ;
      test=x.toInt();

      isLoading = false ;
      _loader();
      }else  if(data_offer?["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
//          retoken_list=1;
          refrech_token();
        });
        return;
      }

    });
  }



  // ignore: non_constant_identifier_names
  Future getData_search(var search) async {
    setState(() {
      isLoading = true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print(URL_LOGIC.arseeff_order_serch + "$search" + "&page=$numpage" +
        "&size=15");
    isLoading = true;
    setState(() {
      isLoading = true;
    });
    Map<String, String> timeOutMessage = {
      'state': 'timeout',
      'content': 'server is not responding'
    };

    // offer
//    final headers = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
    http.Response responseOffer = await http.get(
        Uri.parse(URL_LOGIC.arseeff_order_serch + search + "&page=$numpage" + "&size=15")
//      ,headers: headers,
      , headers: {"Authorization": "$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    data_offer = json.decode(responseOffer.body);

    setState(() {
      print(data_offer.toString());
      if (data_offer?["status"] == null) {
        print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
        data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
        _All.addAll(data_offer?["resultData"]["resultData"]??[]);
        numpage++;

        print(_All);

        print(
            "totalItemsCount > ${data_offer?["resultData"]["totalItemsCount"]}");
        totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
        var x = totalRow / 15;
        test = x.toInt();

        isLoading = false;
        _loader();
      } else if (data_offer?["status"].toString() == "401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
//          retoken_list=1;
          refrech_token();
        });
        return;
      }
    });
  }


//  // ignore: non_constant_identifier_names
//  Future getData_search_sates(var search) async {
//    setState(() {
//      isLoading = true ;
//      _loader();
//    });
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    //Return String
//    String token = prefs.getString('token');
//
//    print(URL_LOGIC.running_order_serch_sates+"$search"+"&page=$numpage"+"&size=15");
//    isLoading = true;
//    setState(() {
//      isLoading = true;
////      data_offer.clear();
////      _All.clear();
//    });
//    Map<String, String> timeOutMessage = {
//      'state': 'timeout',
//      'content': 'server is not responding'
//    };
//
//    // offer
////    final headers = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
//    http.Response responseOffer = await http.get(
//      URL_LOGIC.running_order_serch_sates+search+"&page=$numpage"+"&size=10"
////      ,headers: headers,
//      ,headers: {"Authorization":"$token"},
//    )
//        .timeout(Duration(seconds: 90), onTimeout: () {
//      return Future.value(http.Response(json.encode(timeOutMessage), 500));
//    }).catchError((err) {
//      // nothing
//    });
//    data_offer = json.decode(responseOffer.body);
//
//    print(data_offer.toString());
//
//    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//    setState(() {
//      print(data_offer.toString());
//      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
////      print("data_offer  > $data_offer");
//      data_offer = json.decode(responseOffer.body);
////      print(data_offer["resultData"]);
//      _All.addAll(data_offer["resultData"]["resultData"]);
//      numpage++;
//
//      print(_All);
//
////      count
//
//      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
//      totalRow = data_offer["resultData"]["totalItemsCount"];
//      var x=  totalRow / 10 ;
//      test=x.toInt();
//
//      isLoading = false ;
//      _loader();
////      isLoading = !isLoading;
//    });
//  }


  // ignore: non_constant_identifier_names
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
    final response = await http.post(Uri.parse(URL_LOGIC.refrechToken),
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

  // ignore: non_constant_identifier_names
  Future getRefrich_all() async {
    setState(() {
      numpage=0;

      getData("search");
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text("ارشيف الطلبات ",
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

//                      Text("data"),
//                     //list item

                      SerachAppBar(),



                      Padding(padding: EdgeInsets.only(top: 65),
                        child: listItem_new(),),


                      _loader()
                    ],
                  )
              ),
            ),
          ),
        )
    );
  }



  // ignore: non_constant_identifier_names
  Widget SerachAppBar(){
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
                        _All.clear();
                        numpage=0;
                        getData("");
                        dropdownValue="حالة الطلب";
                      }else{
                        print(val);
                        _All.clear();
                        numpage=0;
                        dropdownValue="حالة الطلب";
                        getData_search(val.toString().toEnglishDigit().toString());
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
    if(totalRow==0){
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Wrap(
//
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
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
                  .length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return

                  Center(
                    child:
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 11),
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
                                                    Item_details_Archef_order(
                                                      id: _All[index]["id"]
                                                          .toString(),))
                                        ),
                                    child: Column(
                                      children: <Widget>[

                                        //تاريخ
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(
//                                              margin: EdgeInsets.only(bottom: 9),
                                              padding: EdgeInsets.only(left: 11,right: 11),
                                              height: 31,
                                              decoration: BoxDecoration(
                                                color: Color(0xffdddddd),
                                                borderRadius: BorderRadius.circular(2),
                                              ),

                                              child:  Text(_All[index]["orderStatus"]!=null?'${_All[index]["orderStatus"]["description"].toString()}'
                                                :"لا يوجد تاريخ ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontFamily: 'Cairo',
                                              ),
                                                textAlign: TextAlign.center,
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

                                            Text('${_All[index]["id"].toString()}',
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


                                            Text('${_All[index]["orderTotal"].toString()}',
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
                                                Text(_All[index]["customerMobileDto"]==null?""
                                                  :
                                                  '  ${_All[index]["customerMobileDto"]["customerName"].toString()} ',
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

                                                Text(_All[index]["submitDate"]!=null?'${_All[index]["submitDate"].toString().substring(0,10)}'
                                                    :"لا يوجد تاريخ ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily: 'Cairo',
                                                  ),
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