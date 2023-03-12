import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:willbond_emp/Arseff_order/Arseff_order.dart';
import 'package:willbond_emp/Item_details/Item_details.dart';
import 'package:willbond_emp/feltter/filtterlist.dart';
import 'package:willbond_emp/notofiaction/Notofication.dart';
import 'package:willbond_emp/running_order/running_order.dart';
import 'package:willbond_emp/startapp/ChangePassword.dart';
import 'package:willbond_emp/startapp/Login.dart';
import 'package:willbond_emp/startapp/Update_profile.dart';

import 'package:http_parser/http_parser.dart';

import '../URL_LOGIC.dart';
import '../progress_dialog.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiHome();
  }

}


class UiHome extends State<Home>{
  TextEditingController email=new TextEditingController();

  int retoken_list=0;
  // final FirebaseMessaging? _messaging = FirebaseMessaging();
  // TextEditingController email=new TextEditingController();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // FlutterLocalNotificationsPlugin fltrNotification;

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


  // ignore: non_constant_identifier_names
  Map? data_user_map;
//  List data_user_list;


  Future getRefrich() async {
    numpage=0;
    _All!.clear();
    getData("");
    getData_user("");
    await Future.delayed(Duration(seconds: 1));
  }



  @override
  void initState() {
    super.initState();
    // * ----------------<
    getData("");
    getData_user("");
    // * ----------------<
    controller = new ScrollController()
      ..addListener(_scrollListener);



    // _messaging. getToken().then((token) {
    //   print("token  >>>>>>>$token");
    //   _sendItemData(token);
    // });


//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//
//         var androidInitilize = new AndroidInitializationSettings('wellbond');
//         var iOSinitilize = new IOSInitializationSettings();
//         var initilizationsSettings =
//         new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
//         fltrNotification = new FlutterLocalNotificationsPlugin();
//         fltrNotification.initialize(initilizationsSettings, onSelectNotification: notificationSelected);
//
// //        var datauser = json.decode(message.body);
//
//         print("onMessage: $message");
//         print("onMessage: ${message["notification"]["body"]}");
//
//         _showNotification("${message["notification"]["body"]}");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//         Navigator.pushNamed(context, '/Home');
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
  }


  // Future _showNotification(String s) async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "Channel ID", "Desi programmer", "This is my channel",
  //       importance: Importance.max);
  //   var iSODetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //   new NotificationDetails(android: androidDetails, iOS: iSODetails);
  //
  //   await fltrNotification.show(
  //       10, "WellBond", "$s",
  //       generalNotificationDetails, payload: "Task");
  // }



  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }









  //token
  // ignore: missing_return
  Future<List?> _sendItemData(token) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
//    var id= prefs.getString('idUser');
    Map<String, dynamic> body = {
      "deviceToken":token
    };

    print("url firebase "+URL_LOGIC.token_firebase_send);
    String? tokenLogin = prefs.getString('token');
    try{
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      final headers = {'Content-Type': 'application/json',"Authorization":"$tokenLogin"};
//      final headers = {"Authorization":"$token_login"};
      //http://freemoneyforums.com/apps/api/clinets//gettoken/id/token
      final response = await http.put(
          Uri.parse(URL_LOGIC.token_firebase_send),
        headers: headers,
        encoding: encoding,
        body:jsonBody,
//        headers: headers,
      );
      var dataUser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      print("token>>?? "+dataUser.toString());

//      pr.hide().then((isHidden) {
//        print(isHidden);
//      });

//      if(datauser["code"]=="009"){
//
//        SharedPreferences prefs = await SharedPreferences.getInstance();
//        prefs.setString('idUser', datauser["userid"]);
//
//        Navigator.push(
//            context, MaterialPageRoute(builder: (context) => HomApp()));
//      }else{
//
//      }
//


    }catch(exception){
      print("object ??"+exception.toString());
//      pr.hide().then((isHidden) {
//        print(isHidden);
//      });
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
    }
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



  // ignore: non_constant_identifier_names
  Future getData_user(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.getInfo_dataUser);
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
//    http.Response response_offer = await http.get(
//      URL_LOGIC.listItem_Home+"${numpage}"+"&size=15"
//      ,headers: {"Authorization":"$token"},
//    )
//        .timeout(Duration(seconds: 90), onTimeout: () {
//      return Future.value(http.Response(json.encode(timeOutMessage), 500));
//    }).catchError((err) {
//      // nothing
//    });
//    data_offer = json.decode(response_offer.body);



    // data user
    http.Response dataUserInfo = await http.get(
        Uri.parse(URL_LOGIC.getInfo_dataUser),
      headers: {"Authorization":"$token"},

    ).timeout(Duration(seconds: 90),onTimeout: (){
      return Future.value(http.Response(json.encode(timeOutMessage),500));
    }).catchError((err){
      // nothing
    });
    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print( json.decode(dataUserInfo.body).toString());
    data_user_map = json.decode(dataUserInfo.body);
    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    setState(() {
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//
//      isLoading = false ;
//      _loader();

      if(data_user_map?["status"]==null){
      data_user_map = json.decode(dataUserInfo.body);
//      data_user_list =data_user_map["resultData"]["resultData"];
      print("data user info >>>>>>>>>> $data_user_map");
      print("data user info imafe >>>>>>>>>> ${data_user_map?["resultData"]["profileImagePath"]}");

      }else  if(data_offer?["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
          retoken_list=1;
        });
        refrech_token();
//        return;
      }
    });
  }


  Future getData(var search) async {
    setState(() {
      isLoading=true;
      _loader();
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.listItem_Home+"$numpage"+"&size=15");
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
        Uri.parse(URL_LOGIC.listItem_Home+"$numpage"+"&size=10")
      ,headers: {"Authorization":"$token"},
    )
        .timeout(Duration(seconds: 90), onTimeout: () {
      return Future.value(http.Response(json.encode(timeOutMessage), 500));
    }).catchError((err) {
      // nothing
    });
    if(responseOffer.statusCode!=200){
      exitApp();
    }
    data_offer = json.decode(responseOffer.body);


    setState(() {
      print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
      if(data_offer?["status"]==null){
        setState(() {
          data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
          _All?.addAll(data_offer?["resultData"]["resultData"]??[]);
//          _All.clear();
          numpage++;

          print(_All);

//      count

          print("totalItemsCount > ${data_offer?["resultData"]["totalItemsCount"]}");
          totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
          var x=  totalRow / 10 ;
          test=x.toInt();
        });



//      isLoading = !isLoading;
      }else  if(data_offer?["status"].toString()=="401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
          retoken_list=1;
        });
        refrech_token();
//        return;
      }
      isLoading = false ;
      _loader();
//      data_user_map = json.decode(data_user_info.body);
////      data_user_list =data_user_map["resultData"]["resultData"];
//      print("data user info >>>>>>>>>> $data_user_map");
//      print("data user info imafe >>>>>>>>>> ${data_user_map["resultData"]["profileImagePath"]}");
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
          exitApp();
//          showDialog(
//            context: context,
//            builder: (BuildContext context) {
//              return   AlertDialog(
//                title: null,
//                content: Text("${datauserxx["errorResponsePayloadList"][0]["arabicMessage"]}",textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontFamily: 'Cairo',
////                      color: Color(0xffffffff),
//                      fontSize: 12,
//                      fontWeight: FontWeight.w400,
//                      fontStyle: FontStyle.normal,
//                    )
//                ),
//              );
//            },
//          );
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
      getData_user("search");
    });
  }

  // ignore: non_constant_identifier_names
  Future getData_search(var search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? token = prefs.getString('token');

    print(URL_LOGIC.listItem_Home_serch + "$search" + "&page=$numpage" +
        "&size=15");
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
        Uri.parse(URL_LOGIC.listItem_Home_serch + search + "&page=$numpage" + "&size=15")
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
//      print(data_offer.toString());
      if (data_offer?["status"] == null) {
        print("all item>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//      print("data_offer  > $data_offer");
        data_offer = json.decode(responseOffer.body);
//      print(data_offer["resultData"]);
        _All?.addAll(data_offer?["resultData"]["resultData"]??[]);
        numpage++;

        print(_All);

//      count

        print(
            "totalItemsCount > ${data_offer?["resultData"]["totalItemsCount"]}");
        totalRow = data_offer?["resultData"]["totalItemsCount"]??0;
        var x = totalRow / 15;
        test = x.toInt();

        isLoading = false;
        _loader();
//      isLoading = !isLoading;
      } else if (data_offer?["status"].toString() == "401") {
        print(">>>>>>>+++++++++++++++++++>>>>>>>>>>>?????????????");
        setState(() {
          retoken_list = 1;
        });
        refrech_token();
        return;
      }
    });
  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text("الرئيسية",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              )
          ),
            backgroundColor: Color(0xff212660),
              actions: <Widget>[

                // change list
//                Padding(padding: EdgeInsets.only(left: 1, right: 1),
//                    child: Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
////                  color: Colors.white,
//
//                      ),
//                      child: IconButton(
//                        icon:  Image.asset('assets/filter_icon.png',color: Color(0xffffffff),),
//                        tooltip: 'Show Snackbar',
//                        onPressed: () {
//                          Navigator.push(context,MaterialPageRoute(builder: (context) => FiltterListHome()),);
//                        },
//                      ),
//                    )
//                ),
              ]
          ),


          drawer: drwable(),



          body: RefreshIndicator(
            onRefresh: getRefrich,
            color: Colors.white,
            backgroundColor: Colors.black,
            child:Directionality(textDirection: TextDirection.rtl,
              child: Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child:
                  Stack(

                    children: [

//                      Text("data"),
//                     //list item

                      SerachAppBar(),

//                      SizedBox(height: 200,),
                      Padding(padding: EdgeInsets.only(top: 70),child: listItem_new(),),

                      _loader(),
                    ],
                  )

              ),
            ),
          ),
        )
    );
  }







  Widget drwable(){

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xffffffff), //This will change the drawer background to blue.
//          canvasColor: Color(0xff212660), //This will change the drawer background to blue.
          //other styles
        ),
        child:
        Drawer(
          child: ListView(
//            reverse: true,
//            shrinkWrap: true,
            scrollDirection: Axis.vertical,
//            physics: FixedExtentScrollPhysics(),
            padding: EdgeInsets.zero,
            children: <Widget>[

              data_user_map==null?
              SizedBox(height: 100,)
                  :
              data_user_map!.isEmpty?
              SizedBox(height: 100,)
                  :
                  // image and data user
              Visibility(
                visible: data_user_map==null?false : true,
                child: InkWell(
                  onTap: ()=>{
                    diloge_uplodeImage()
                  },

                    child: Container(
//                  width: 328,
                      height: 200,
                      padding: EdgeInsets.all(11),
                      margin: EdgeInsets.only(top: 0,bottom: 18),
//                margin: EdgeInsets.only(left: 18,right: 18,top: 35,bottom: 18),
                      decoration: new BoxDecoration(
                        color: Color(0xff212660),
//                  color: Color(0x24a6a8bf),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [BoxShadow(
                            color: Color(0x29000000),
                            offset: Offset(0,3),
                            blurRadius: 6,
                            spreadRadius: 0
                        ) ],
                      ),

                      child:
                      data_user_map?["resultData"]==null?null:
                      data_user_map==null?null
                      :
                      data_user_map?["resultData"]!=null?
                      Center(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // image
                          Container(
                              height: 80, width: 80,
                              decoration: BoxDecoration(
                              shape: BoxShape.circle
                              ),

                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child:  CachedNetworkImage(
                                height: 80,width:80,
                                fit: BoxFit.fill,
                                imageUrl:data_user_map?["resultData"]["profileImagePath"]??"",
                                // "https://is4-ssl.mzstatic.com/image/thumb/Purple115/v4/5f/f6/6d/5ff66d4e-9935-d909-8817-dfdcac5fb2ce/source/512x512bb.jpg",
                                placeholder: (context, url) =>const Center(child: CircularProgressIndicator(),),
                                errorWidget: (context, url, error) => Image.asset('assets/iii.png',height: 52,width:52,),
                              ),
                            ),
                            ),




                          Text(
                              data_user_map?["resultData"]["fullName"]!=null?
                              data_user_map!["resultData"]["fullName"].toString()
                                  : ""
                              ,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xffffffff),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              )
                          ),
                          Text(
                              data_user_map?["resultData"]["userEmail"]!=null?data_user_map!["resultData"]["userEmail"].toString()
                                  : ""
                              ,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Color(0xffffffff),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              )
                          ),

                        ],
                      )
                      )
                          :null,
                    ),

                ),
              ),
              // Drawer items go in here



              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
//                    verticalDirection: VerticalDirection.up,
                children: [
                  //   الطبات الحالية
                  ListTile(
                    leading: Image.asset('assets/order_icon.png',color: Colors.black,height: 24,width: 24, ),
                    title: Transform(
                      transform: Matrix4.translationValues(25, 0.0, 0.0),
                      child:Text('الطبات الحالية ',
                        style: const TextStyle(
                            color:   Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Cairo",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0,
                        )
                    )
                    ),
                    onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => Running_order()
                      )
                      )
                    },
                  ),


                  //  أرشيف الطلبات
                  ListTile(
                    leading: Image.asset('assets/drafticon.png',color: Colors.black,height: 24,width: 24, ),
                      title: Transform(
                          transform: Matrix4.translationValues(25, 0.0, 0.0),
                          child:Text('أرشيف الطلبات',
                              style: const TextStyle(
                                color:   Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Cairo",
                                fontStyle:  FontStyle.normal,
                                fontSize: 16.0,
                              )
                      )
                      ),
                      onTap: () =>
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Arseff_order() ))
                  ),




                  //  التنبيهات
                  ListTile(
                    leading: Image.asset('assets/notfication.png',color: Colors.black,height: 24,width: 24, ),
                    title: Transform(
                        transform: Matrix4.translationValues(25, 0.0, 0.0),
                        child:Text('التنبيهات',
                        style: const TextStyle(
                            color:   Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Cairo",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        )
                    )
                    ),
                      onTap: () =>
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Notofication() ))
                  ),



                  //          حسابي
                  ListTile(
                    leading: Icon(Icons.perm_identity,color: Colors.black,),
                    title: Transform(
                      transform: Matrix4.translationValues(25, 0.0, 0.0),
                      child:Text('حسابي',
                        style: const TextStyle(
                            color:   Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Cairo",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        )
                    )
                    ),
                    onTap: () => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => UpdateProfile(
                        id: data_user_map?["resultData"]["id"].toString()??"" ,
                        address: data_user_map?["resultData"]["address"].toString()??"",
                        fullName: data_user_map?["resultData"]["fullName"].toString()??"",
                        phoneNumber: data_user_map?["resultData"]["phoneNumber"].toString()??"",
                      )))
                    },
//                    onTap: () =>
//                        Navigator.push(
//                            context, MaterialPageRoute(builder: (context) => Favorite())),
                  ),

                  //تغيير كلمة السر
                  ListTile(
                    leading: SizedBox(
                        height: 24.0,
                        width: 24.0, // fixed width and height
                        child: Icon(Icons.lock_open,color: Colors.black,)
                    ),
//                leading: Icon(Icons.favorite_border,color: Colors.white,),
                    title: Transform(
                        transform: Matrix4.translationValues(25, 0.0, 0.0),
                        child:Text('تغيير كلمة السر',
                        style: const TextStyle(
                            color:   Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Cairo",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        )
                    )
                    ),
                      onTap: () =>
                      {
                        data_user_map==null?Text("")
                        :
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => ChangePassword(
                              id_user: data_user_map!["resultData"]["id"]
                                  .toString(),)))
                      }
                  ),


                  //تسجيل خروج
                  ListTile(
                    onTap: ()=> exitApp(),
                    leading: Icon(Icons.exit_to_app,color:Colors.black,),
                    title: Transform(
                      transform: Matrix4.translationValues(25, 0.0, 0.0),
                      child:Text('تسجيل خروج',
                        style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Cairo",
                            fontStyle:  FontStyle.normal,
                            fontSize: 16.0
                        )
                    ),
                  )
                  ),
                  //>>> face book


                  SizedBox(height: 60,),


                  Center(
                    child: Text("Wellbond",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),
                  ),

                  Center(
                    child: Text("نسخة رقم 1.0",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        )
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
//          )


      ),
    );
  }

  exitApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
//    String reToken = prefs.getString('reToken');
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => Login()));
//    SystemNavigator.pop();
  }



  // ignore: non_constant_identifier_names
  diloge_uplodeImage(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return   AlertDialog(
          title: null,
          content: Text("هل تريد تغير صور البروفيل الخاص بك ",textAlign: TextAlign.center,
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
          OutlineButton(
            onPressed: ()=>Navigator.pop(context),
            child: Text("الغاء "),
          ),

            OutlineButton(
              onPressed: () async =>{

                Navigator.pop(context),
                // file = await ImagePicker.pickImage(
                // source: ImageSource.gallery),
                setState(() async {
                  var res = await uploadImage(file!.path);
//                var res = await uploadImage(file.path);
                  setState(() {
                    print(res);
                  });
                }),

                },
              child: Text("موافق "),
            ),

          ],
        );
      },
    );
  }

  File? file;
  Future<String> uploadImage(filename) async {


    ProgressDialog  pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.show();
    print("start upload ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
//    final headers1 = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};

//    Map<String, String> headers = {"Authorization":"$token"};
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        URL_LOGIC.uplodeImage+"image.jpg",
      ),
    );
    //add text fields

    request.headers["Authorization"]=token!;
//    request.fields["type"] = type;
    var ext = filename.split('.').last;
    var pic = await http.MultipartFile.fromPath("file", filename, contentType: MediaType('image', ext));
    request.files.add(pic);
//    }

    //add multipart to request

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var d = jsonDecode(responseString);
//    JSON.decode(response.body);
//   var c= json.decode(utf8.decode(responseByteArray));
    Map dd= jsonDecode(responseString);
    if(dd["errorStatus"].toString()=="false"){
      Future.delayed(Duration(seconds: 1)).then((value) async {
        pr.hide();
//        _All.clear();
//        data_offer.clear();
        data_user_map!.clear();
//        data_user_list.clear();;
        getData_user("");
      });
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return   AlertDialog(
            title: null,
            content: Text("لقد حدث خطا في تحميل الصوره",textAlign: TextAlign.center,
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
    }

    return  d.toString();
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
//    Container(
////                  padding: EdgeInsets.all(10.0),
//                  decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
//                      border: Border.all(
//                          width: 1.0,
//                          color: Colors.grey[300]
//                      )
//                  ),
//                  child:
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child:
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),

                      child: TextFormField(
//                        inputFormatters: <TextInputFormatter>[
//                          WhitelistingTextInputFormatter.digitsOnly
//                        ],
//                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]"))],
                        onChanged: (val){
                          print(val);
                          if(val.isEmpty){
                           _All!.clear();
                           numpage=0;
                           getData("");
                          }else{
                            print(val);
                            _All!.clear();
                            numpage=0;
                            getData_search(val.toEnglishDigit().toString());
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
          child: Container(
width: MediaQuery.of(context).size.width,
            child:  Column(
//              direction: Axis.vertical,
//              crossAxisAlignment: WrapCrossAlignment.center,
//              alignment: WrapAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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

                InkWell(
                  onTap: ()=>getRefrich(),
                  child:  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.only(left: 22,right: 22,top: 7,bottom: 7),
                    color: Color(0xff212660),
                    child:Text('اعاده التحميل',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

      );
    }else{
      return
        _All!.isEmpty?
        Container(
            width: MediaQuery.of(context).size.width,

            child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 15,right: 15)
              ,child: Text('لا يوجد بيانات',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

            InkWell(
              onTap: ()=>getRefrich(),
              child:  Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.only(left: 22,right: 22,top: 7,bottom: 7),
                color: Color(0xff212660),
                child:Text('اعاده التحميل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
        )

        :
        Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
//            height: 80,
            child: new ListView.builder(
//              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 0,
              ),
              controller: controller,
              itemCount: _All == null ? 0 : _All!
                  .length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return
                      Center(
                          child:
                          Padding(
                            padding: const EdgeInsets.only(left:20.0,right:20.0,bottom:10.0,top:0.0),
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
                                                      Item_details(
                                                        id: _All![index]["id"]
                                                            .toString(),))
                                          ),
                                          child: Column(
                                            children: <Widget>[

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _All?[index]["submitDate"]!=null?
                                                    '${_All?[index]["submitDate"].toString().substring(0,10)??""}'
                                                      :"لا يوجد تاريخ ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),
                                                ],
                                              ),


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

                                                  Text('${_All?[index]["id"].toString()??""}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily: 'Cairo',
                                                    ),
                                                  ),

                                                ],
                                              ),




                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [


                                                      Text('${_All?[index]["orderTotal"].toString()??""}',
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

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [


//                                                      Expanded(
//                                                          flex: 1,child:
                                                      Icon(Icons.person,color: Color(0xff707070),),
//                                                      ),


//                                                      Expanded(
//                                                          flex: 1,
//                                                        child:
                                                        Text(
                                                            '  ${_All?[index]["customerMobileDto"]["customerName"].toString()??""} ',
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

//                  )
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