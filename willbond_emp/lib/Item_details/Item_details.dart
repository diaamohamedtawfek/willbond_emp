import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:willbond_emp/Item_details/CancelOrder.dart';
import 'package:willbond_emp/Item_details/Complet_doneItem.dart';
import 'package:willbond_emp/Item_details/RejectOrder.dart';

import '../URL_LOGIC.dart';
import 'Constants.dart';


// ignore: camel_case_types
class Item_details extends StatefulWidget{


  Item_details({Key? key, this.id}) : super(key: key);

  final String? id;


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiItem_details();
  }

}

// ignore: camel_case_types
class UiItem_details extends State<Item_details>{




  var visible=false;

  // ignore: non_constant_identifier_names
  Map? data_offer;

  ScrollController? controller;
  // ignore: non_constant_identifier_names
  List _All = [];
//  final _saved = new Set<Object>();
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
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    print(URL_LOGIC.find_bu_id_item+widget.id.toString());
    isLoading = true;
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
        Uri.parse(URL_LOGIC.find_bu_id_item+widget.id.toString())
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
      print(data_offer?["resultData"]);
      print(data_offer?["resultData"]['orderDetailsList'].length);
//      _All.addAll(data_offer["resultData"]);
      numpage++;

      print(_All);

//      count

//      print("totalItemsCount > ${data_offer["resultData"]["totalItemsCount"]}");
//      totalRow = data_offer["resultData"]["totalItemsCount"];
//      var x=  totalRow / 15 ;
//      test=x.toInt();

      isLoading = false ;
      _loader();
    }else  if(data_offer?["status"].toString()=="401") {
    print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
    setState(() {
      refrech_token();
    });

    return;
    }
//      isLoading = !isLoading;
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
//      getData_user("search");
    });
  }







  void choiceAction(String choice){
    if(choice == Constants.close){
      print('Settings');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            CancelOrder(id: widget.id.toString(),)),
      );
    }else if(choice == Constants.rafed){
      print('Subscribe');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
            RejectOrder(id: widget.id,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child:  SafeArea(
          top: false,
            child:Scaffold(

          appBar: AppBar(title: Text(" رقم الطلب  ${widget.id }",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
          ),

            actions: <Widget>[
              PopupMenuButton<String>(
                padding: EdgeInsets.only(left: 30,right: 30),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context){
                  return Constants.choices.map((String choice){
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice,
                        style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),),
                    );
                  }).toList();
                },
              )
            ],

            backgroundColor: Color(0xff212660),
          ),





          body:
          data_offer == null ? _loader()
              :
          SafeArea(child:
          Stack(
            children: [

              Container(
                height: MediaQuery.of(context).size.height-100,
                child: ListView(
                  padding: EdgeInsets.all(10),
                  physics: ScrollPhysics(),
                  children: [


                    dettels_Order(),

                    SizedBox(height: 20,),

                    dettels_customer_createorder(),


                    SizedBox(height: 20,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("أصناف الطلب",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,


                            )
                        ),

                        listItem_new(),
                      ],
                    ),


                    SizedBox(height: 45,),


                    InkWell(
                      onTap: ()=>{
                        _settingModalBottomSheet(context),
                      },
                      child: SafeArea(
                        child: Container(
                          margin: EdgeInsets.only(left: 45,right: 45),
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color(0xff212660),
                            borderRadius: BorderRadius.circular(23),
                          ),

                          child:Center(
                            child:  Text("اعتماد الطلب",
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Color(0xffffffff),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.14,

                                )
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 55,),
                  ],
                ),
              ),







              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(left: 14,right: 14),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color(0xffdddddd),
//                  borderRadius: BorderRadius.circular(23),
                  ),

                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("اجمالي الطلب  ",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,


                          )
                      ),

                      Text(data_offer?['resultData']['orderTotal'].toString()??"",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,


                          )
                      ),
                    ],
                  ),
                ),
              )




            ],
          )),

        )

)    );
  }


  // ignore: non_constant_identifier_names
  Widget dettels_Order() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  topLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                  topRight: Radius.circular(2)
              ),

//                      side: BorderSide(width: 5, color: Colors.white)
            ),
            margin: EdgeInsets.all(0),
            elevation: 1,
            child:
            Wrap(
              direction: Axis.vertical,
              children: [

                //تاريخ الطلب
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text("تاريخ الطلب",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                      ),

                      SizedBox(width: 20,),

                      Text("${data_offer?["resultData"]["submitDate"]
                          .toString()
                          .substring(0, 10)}",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )
                      )
                    ],
                  ),
                ),
//عنوان التسليم
                Padding(
                  padding: EdgeInsets.only(left: 12,right: 12,bottom: 12,),
                  child: Row(
                    children: [
                      Text("عنوان التسليم ",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )
                      ),

                      SizedBox(width: 20,),

                      Text(
                          "${data_offer?["resultData"]["branchLookup"]["description"]
                              .toString()}",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )
                      )
                    ],
                  ),
                )
              ],
            )
        )
    );
  }



  // ignore: non_constant_identifier_names
  Widget dettels_customer_createorder() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  topLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                  topRight: Radius.circular(2)
              ),

//                      side: BorderSide(width: 5, color: Colors.white)
            ),
            margin: EdgeInsets.all(0),
            elevation: 1,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
//                direction: Axis.vertical,
                children: [

                  Padding(
                    padding: EdgeInsets.only(left: 12,right: 12,top: 12,bottom: 5),
                    child: Text("بيانات مقدم الطلب",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xff000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,


                        )
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(left: 12,right: 12,top: 1,bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            //الاسم
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Expanded(flex: 1,
                      child: Text("الاسم ",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,


                                    )
                                ),),
                                Expanded(flex: 3,child: Text(
                                    "${data_offer?["resultData"]["customerMobileDto"]["customerName"].toString()}",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,


                                    )
                                )),


                                SizedBox(width: 20,),


                              ],
                            ),

                            // phone

                           InkWell(
                             onTap: ()=>_launchCaller("${data_offer?["resultData"]["customerMobileDto"]["phoneNumber"].toString()??""}"),
                             child: Row(

                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: [
                                 Expanded(flex: 1,
                                     child:
                                     Text("رقم الجوال ",
                                         style: TextStyle(
                                           fontFamily: 'Cairo',
                                           color: Color(0xff000000),
                                           fontSize: 12,
                                           fontWeight: FontWeight.w400,
                                           fontStyle: FontStyle.normal,


                                         )
                                     )
                                 ),

//                                SizedBox(width: 20,),

                                 Expanded(flex: 3,
                                     child:Text("${data_offer?["resultData"]["customerMobileDto"]["phoneNumber"].toString()}",
                                         style: TextStyle(
                                           fontFamily: 'Cairo',
                                           color: Color(0xff000000),
                                           fontSize: 12,
                                           fontWeight: FontWeight.w400,
                                           fontStyle: FontStyle.normal,


                                         )
                                     )
                                 )
                               ],
                             ),
                           ),

                            // العنوان

                            Row(
                              children: [

                                Expanded(flex: 1,
                                  child:Text("العنوان",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,


                                    )
                                )),

//                                SizedBox(width: 20,),

                                Expanded(flex: 3,
                                  child:Text("${data_offer?["resultData"]["customerMobileDto"]["customerAddress"].toString()}",
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: Color(0xff000000),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,


                                    )
                                ))
                              ],
                            ),
                          ]
                      )
                  )
                ]
            )
        )
    );
  }





  // ignore: non_constant_identifier_names
  Widget listItem_new() {
    return  ListView.builder(

          shrinkWrap: true,
              physics: ScrollPhysics(),
          padding: EdgeInsets.only(
            top: 2.0,
          ),
          controller: controller,
          itemCount: data_offer?["resultData"]['orderDetailsList'] == null ? 0 : data_offer?["resultData"]['orderDetailsList']
              .length,
          itemBuilder: (_, index) {
            return  Column(
                    children: [

                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: 85,
                        child:
                        Center(
                          child:
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child:
//                            Wrap(
//                              children: <Widget>[

                            Stack(
                              children: <Widget>[

                                Container(

                                  child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: InkWell(
//                                      onTap: () =>
//                                      Navigator.push(context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  Item_details(
//                                                    id_item: _All[index]["id"].toString(),))
//                                      ),
                                        child: Row(
                                          children: <Widget>[

                                            // لون
                                            //color conttener
                                            Padding(
                                              padding: EdgeInsets.only(top: 5,),
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: new BoxDecoration(
                                                    color: Color(0xffebebeb),
                                                    borderRadius: BorderRadius
                                                        .circular(8)
                                                ),

                                                child:  data_offer?["resultData"]['orderDetailsList'][index]['items']["colorLookup"]['documentImagePath']!=null?  Container(
                                                  height: 59,
                                                  width: 59,
                                                  margin: EdgeInsets.all(11),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                        "${data_offer?["resultData"]['orderDetailsList'][index]['items']["colorLookup"]['documentImagePath']}",
                                                      ),
//                                                              NetworkImage(
//                                                                  _All[index]["colorLookup"]["documentImagePath"]
//                                                              ),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                                    :
                                                Container(
                                                  height: 49,
                                                  width: 49,
                                                  margin: EdgeInsets.all(11),
                                                  decoration: BoxDecoration(

                                                    color: Color(int.parse(
                                                        "0xff${data_offer?["resultData"]['orderDetailsList'][index]['items']["colorLookup"]["colorValue"]??""}")),
//                                                        color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
//                                                        color: Hexcolor("#"+_All[index]["colorLookup"]["colorValue"]),
                                                    borderRadius: BorderRadius
                                                        .circular(2),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(int.parse(
                                                            "0xff${data_offer?["resultData"]['orderDetailsList'][index]['items']["colorLookup"]["colorValue"]??""}")),
//                                                            color: Color(0xff+ int.parse(_All[index]["colorLookup"]["colorValue"], radix: 16)),
                                                        offset: Offset(0, 1),
                                                        blurRadius: 1,
                                                        spreadRadius: 0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),


                                            SizedBox(width: 11,),


                                            //  سمك ودرجه المقاومه   واللون
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,

                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [

                                                    Expanded(
                                                        flex: 3 ,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 0,
                                                              right: 5,
                                                              top: 0),
                                                          child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                          Row(
                                                            children: [
                                                              Text(
                                                                data_offer?['resultData']['orderDetailsList'][index]['items']['colorLookup']['description']
                                                                    .toString()??"",
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
//                                                            )
                                                              ),




                                                              Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                          left: 15,
                                                                          right: 15,
                                                                          top: 7),
                                                                      child:
//                                                            Expanded(
//                                                                flex: 3,
//                                                                child:
                                                                      Text(
                                                                        data_offer?['resultData']['orderDetailsList'][index]["itemQuantity"].toString()
                                                                            .toString()??""+
                                                                            " * "+
                                                                            data_offer!['resultData']['orderDetailsList'][index]["itemPrice"].toString() ,
                                                                        style: TextStyle(
                                                                          fontFamily: 'Cairo',
                                                                          color: Color(
                                                                              0xff000000),
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontStyle: FontStyle
                                                                              .normal,
                                                                        ),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      )

//                                                        ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),


                                                        )
                                                    ),

                                                    Expanded(
                                                        flex: 3 ,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 0,
                                                              right: 0,
                                                              top: 0),
                                                          child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                          Wrap(
                                                            direction: Axis.horizontal,
                                                            children: [
                                                              Text("  سمك   "+
                                                                  data_offer!['resultData']['orderDetailsList'][index]['items']['itemThicknessList'][0]["thicknessLookup"]['description']
                                                                      .toString(),
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
//                                                            )
                                                              ),

                                                              Wrap(
                                                                children: [
                                                                  Text("   درجة المقاومة   "+
                                                                      data_offer!['resultData']['orderDetailsList'][index]['items']['itemFireResistanceDegreeList'][0]["fireResistanceDegreeLookup"]['description']
                                                                          .toString(),

                                                                    style: TextStyle(
                                                                      fontFamily: 'Cairo',
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      fontStyle: FontStyle
                                                                          .normal,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  )
                                                                ],
                                                              ),

//
////                                                        ),
//                                                                )
//                                                            ),
                                                            ],
                                                          ),


                                                        )
                                                    ),

                                                  ],
                                                ),
                                              ),
                                              flex: 3,
                                            ),

                                            //price
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,

                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [

                                                    Expanded(
                                                        flex: 1 ,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                              left: 0,
                                                              right: 0,
                                                              top: 0),
                                                          child:
//                                                        Expanded(
//                                                            flex: 1,
//                                                            child:
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${
                                                                    data_offer!['resultData']['orderDetailsList'][index]["itemQuantity"].toDouble()*
                                                                double.parse(data_offer!['resultData']['orderDetailsList'][index]["itemPrice"])
                                                                }"+"  جنيه  ",
//                                                                data_offer['resultData']["orderTotal"].toString()+" جنيه ".toString(),
                                                                style: TextStyle(
                                                                  fontFamily: 'Cairo',
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight
                                                                      .w400,
                                                                  fontStyle: FontStyle
                                                                      .normal,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
//                                                            )
                                                              ),
                                                            ],
                                                          ),


                                                        )
                                                    ),


                                                  ],
                                                ),
                                              ),
                                              flex: 1,
                                            ),

                                          ],
                                        ),
                                      )
                                  ),
                                ),

                              ],
                            ),

//                              ],
//                            )
                          ),
                        ),
                      ),

                      Divider(
                        height: 1,
                        color: Colors.black,
                      )
                    ],
                  )
            ;
          },
        )
        ;
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


  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        elevation: 12,
        backgroundColor: Colors.white,
//        backgroundColor: Colors.transparent,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(30.0),
//              topRight: Radius.circular(30.0)),
//
//        ),
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return  SafeArea(
              child:Padding(
            padding: EdgeInsets.only(left: 1,right: 1),
            child:
            Complet_doneItem(id: widget.id.toString(),),
          )
          );
        }
    );
  }


  _launchCaller(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}