import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart'as intl;


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../URL_LOGIC.dart';
import '../progress_dialog.dart';
import 'ShowFilter_Data.dart';

class FiltterListHome extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UIFiltterListHome();
  }

}

class UIFiltterListHome extends State<FiltterListHome> {

  // ignore: non_constant_identifier_names
  var start_date,end_date;

  var monthNames = ["يناير", "فبراير", "مارس", "ابريل", "مايو", "يونيو",
    "يوليو", "أغسطس", "سبتمبر", "أكتوبر", "نوفمبر", "ديسمبر", "ديسمبر"
  ];
  Future _selectDate() async {


    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('MMMM',);
//    final DateFormat formatter = DateFormat('yyyy-MMMM-dd',);
    final String formatted = formatter.format(now);
    print("formatted>>>>>>>>$formatted");


    print("object");
    DateTime selectedDate2 = DateTime.now();

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2901,8));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        String v=picked.toString();
        v.substring(0,10);
        start_date=v.substring(0,10);
//        _controller.text ="$x";

//        useris=x;
//          Future.delayed(Duration(seconds: 1)).then((value) {
//            _controller.text ="${x}";
//          });
        print(">>>>>>>>>>>>>>$v");

        print(">>>>>>>>>>>>>>${v.substring(5,7)}");
        int d=int.parse(v.substring(5,7))-1;
        // ignore: unnecessary_statements
        monthNames[d];
        print(">>>>>>>>>>>>>>${ monthNames[d]}");
//        _controller.text ="${x}";

      });
  }

  Future _selectDate_end() async {

    print("object");
    DateTime selectedDate2 = DateTime.now();

    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2901,8));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        String v=picked.toString();
        v.substring(0,10);
        var x="${v.substring(0,10)}";
        end_date=v.substring(0,10);
//        _controller.text ="$x";

        print(">>>>>>>>>>>>>>$x");

        print(">>>>>>>>>>>>>>${v.substring(5,7)}");
        int d=int.parse(v.substring(5,7))-1;
        // ignore: unnecessary_statements
        monthNames[d];
        print(">>>>>>>>>>>>>>${ monthNames[d]}");
//        _controller.text ="${x}";

      });
  }

  // ignore: non_constant_identifier_names
  String input_from_price="0" , input_to_price="1" , input_from_discount="0" ,input_to_discount="1" , input_rate="5" ;


  changePrice() async{
    setState(() {
      minPrice=1;
      maxPrice=100000;
    });

  }
  RangeValues values= RangeValues(1, 100000);
  // ignore: non_constant_identifier_names
  var values_list;

  RangeLabels labels= RangeLabels(
      "1","100000");
//  RangeValues values_discont;

//  RangeLabels labels_discont;

  double? minPrice;
  double? maxPrice;

  @override
  void initState() {
    super.initState();
//    getData();
//    getRefrich();
    minPrice=1;
    maxPrice=100000;

    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd',);
//    final DateFormat formatter = DateFormat('yyyy-MMMM-dd',);
    final String formatted = formatter.format(now);
    print("formatted>>>>>>>>$formatted");

    start_date=formatted;
    end_date=formatted;
  }


 void opendate(){
    minPrice=1;
    maxPrice=100000;

    final DateTime now = DateTime.now();
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd',);
//    final DateFormat formatter = DateFormat('yyyy-MMMM-dd',);
    final String formatted = formatter.format(now);
    print("formatted>>>>>>>>$formatted");

    start_date=formatted;
    end_date=formatted;
  }

  Map? data, datasection;
  List? userData=[];
  List?  userDataSection=[];
  List<Map<String, bool>> productMap= [];

//  Map<String, bool> valuesid;
  HashMap valuesid = new HashMap<int, String>();



  Future getRefrich() async {
//    getData();
    await Future.delayed(Duration(seconds: 3));
  }



  RangeValues _currentRangeValues =  RangeValues(1, 100000);




  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    if (userData != null) {
      return Scaffold(
          appBar: AppBar(title:
          Text("تصفية النتائج",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xffffffff),
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,


              )
          ),
            backgroundColor: Color(0xff212660),
            iconTheme: new IconThemeData(color: Color(0xff212660)),
          ),
          body: Text("")
      );
    } else {
      return
        Directionality(
          textDirection: TextDirection.rtl,
          child:
          Scaffold(

              appBar: AppBar(

                title:Text("تصفية النتائج",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xffffffff),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,


                    )
                ),

                backgroundColor: Color(0xff212660),
                iconTheme: new IconThemeData(color: Color(0xffffffff)),
              ),

              body: ListView(
                physics: PageScrollPhysics(),
                padding: EdgeInsets.only(left: 18,right: 18),

                children: <Widget>[



                  Directionality(
                    textDirection: TextDirection.rtl,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        SizedBox(height: 22,),

                        Text("تكلفة الطلب",
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Color(0xff000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,


                            ),
                          textDirection: TextDirection.rtl,
                        ),
                        //السعر
//                        Directionality(
//                            textDirection: TextDirection.ltr,
//                            child:
//                      ExpansionTile(
//                          title: new Text(SetLocalization.of(context).getTranslateValue('price_filter')),
//                          backgroundColor: Theme
//                              .of(context)
//                              .accentColor
//                              .withOpacity(0.025),
//                          children: <Widget>[

                            Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[

                                  SizedBox(height: 20,),

                                  // from  --  to
                                  Padding(
                                    padding: EdgeInsets.only(left: 13,right: 13),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text('من',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Text('الي ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                    ],
                                  ),
                                  ),

                                  Container(
                                    height: 80,
                                    child:
                                    RangeSlider(

                                      inactiveColor:Color(0xffdddddd) ,
                                      activeColor: Color(0xffdbb354),
                                      min: minPrice??0.0,
                                      max: maxPrice??0.0,
                                      labels: RangeLabels(
                                        _currentRangeValues.start.round().toString(),
                                        _currentRangeValues.end.round().toString(),
                                      ),
                                      values: _currentRangeValues,
//                                      values: values,
//                                      values: RangeValues(minPrice, maxPrice),
                                      divisions: 10000,
                                      // num part
//                                      labels: labels,
                                      onChanged: (RangeValues value) {
                                        _currentRangeValues = values;


                                        print('START: ${value
                                            .start}, END: ${value
                                            .end}');
                                        setState(() {

                                          input_from_price = "${value.start}";
                                          input_to_price = "${value.end}";

                                          print("price>>> $input_from_price");
                                          values = value;
                                          labels =
                                              RangeLabels(
                                                  '${value.start.toInt()
                                                      .toString()}\$',
                                                  '${value.end.toInt()
                                                      .toString()}\$');
                                        });
                                      },
                                    ),

                                  ),
                                ]
                            ),

//                          ]
//                      ),
//                        ),


//                        SizedBox(height: 63),

                        Text('تاريخ الطلب',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),


                        SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

//                            Expanded(
//                                flex: 1,
//                              child:
                              Text('من',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),

//                            ),
//                            Expanded(
//                                flex: 1,
//                                child:
                                Text('الي ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
//                  ),



                          ],
                        ),

                        Container(
                          height: 54,
                          decoration: BoxDecoration(
//                            color: Colors.amber,
                            color: Color(0xfffbfbfb),
                            border: Border.all(
                              color: Color(0xff707070),
                              width: 0.20000000298023224,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child:  Container(
//                            color: Colors.red,
                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: Row(
//                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    //startDate
                                    Expanded(
                                        flex: 2,
                                        child: Container(child:InkWell(
                                          onTap: () =>
                                          {
                                            _selectDate(),
                                          },
                                          child: startDate(),
                                        ),
                                        )
                                    ),

                                    Padding(padding: EdgeInsets.only(top: 7,bottom: 7),
                                      child: VerticalDivider(
                                        color: Color(0xff707070),
                                        thickness: 2, width: 40,
//                                      indent: 200,
//                                      endIndent: 200,
                                      ),
                                    ),

//                                    endDate
                                    Expanded(
                                        flex: 2,
                                        child: InkWell(
                                          onTap: () =>
                                          {
                                            _selectDate_end(),
                                          },
                                          child:endDate(),
                                        )
                                    ),



                                  ],
                                ),)

                              ],
                            ),
                          )

                        ),




                        SizedBox(height: 50),

                        // button
//                        Directionality(
//                            textDirection: TextDirection.rtl,
//                            child:
                            Row(
                              children: <Widget>[
                                Expanded(flex: 3, // login
                                  child: new Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child: Material(
                                        borderRadius: BorderRadius.circular(40.0),
                                        color: Color(0xff212660),
                                        elevation: 0.0,
                                        child: MaterialButton(
                                          onPressed: () {
                                            DateTime tempDate = new intl.DateFormat("yyyy-MM-dd").parse(start_date);
                                            DateTime tempDateEnd = new intl.DateFormat("yyyy-MM-dd").parse(end_date);
//                                            check();
                                            if (tempDate.isAfter(tempDateEnd) )
                                            {
                                            print( "is between");
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return   AlertDialog(
                                                  title: null,
                                                  content: Text("يجب ان يكون تاريخ البدايه اصغر من تاريخ النهايه "),
//                                                  content: Text("يجب اختيار بدايه التاريخ الي نهايه التاريخ بشكل صحيح "),
                                                  actions: [
//            okButton,
                                                  ],
                                                );
                                              },
                                            );

                                            }
                                            else
                                            {
                                            print( "NO GO!");

                                            Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => ShowDataFiltter(idUser: "response.body",
                                              url: "order-mobile/filter-customer-order?orderTotalFrom=$input_from_price&orderTotalTo=$input_to_price&submitDateFrom=$start_date&submitDateTo=$end_date",
                                            )),
                                            );

                                            }

                                          },
                                          minWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Text("تصفية النتائج",
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Color(0xffffffff),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: 0.14,

                                              )
                                          ),
                                        )),
                                  ),
                                ),


                                Expanded(child: Text(""), flex: 1,),



                                // مسح
                                Expanded(
                                  flex: 3,
                                  child: new Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 0),
                                    child:Container(
                                      height: 45,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:Color(0xff212660),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(23),
                                      ),




                                      child:   Material(
                                        borderRadius: BorderRadius.circular(40.0,),
                                        color: Color(0xffffffff),
                                        elevation: 0.0,


                                        child: MaterialButton(
                                          onPressed: () {
                                            //check();
//                                            Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                                builder: (BuildContext context) => FiltterListHome()));

                                            setState ((){
                                              opendate();
                                              _currentRangeValues =  RangeValues(1, 100000);
//                                              changeprice();
                                              minPrice=1;
                                              maxPrice=100000;

                                            });
                                          },
                                          minWidth: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child:Text("مسح",
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: Color(0xff212660),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                                letterSpacing: 0.14,

                                              )
                                          ),

                                        ),
                                      )),
                                    ),


                                 ),
                              ],
                            )


//                        )
                      ],
                    ),
                  )
                ],
              )


          )
      )
    ;
    }

  }



  Widget startDate(){
    return Container(
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
              flex: 1,
              child: Icon(Icons.arrow_drop_down,color: Color(0xff707070),)
          ),

          Expanded(
              flex: 1,
              child:new Text("${start_date.toString().substring(8,10)}",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,


                  )
              )
          ),

          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text("${monthNames[int.parse(start_date.toString().substring(5,7))-1]}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff000000),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  new Text("${start_date.toString().substring(0,4)}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff707070),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,


                      )
                  ),
                ],
              )
          ),

          Expanded(
              flex: 1,
              child: Icon(Icons.date_range,color: Color(0xff707070),)
          ),





        ],
      ),
    );
  }

  Widget endDate(){
    return Container(
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


          Expanded(
              flex: 1,
              child: Icon(Icons.arrow_drop_down,color: Color(0xff707070),)
          ),

          Expanded(
              flex: 1,
              child:new Text("${end_date.toString().substring(8,10)}",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xff000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,


                  )
              )
          ),

          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text("${monthNames[int.parse(end_date.toString().substring(5,7))-1]}",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff000000),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  new Text("${end_date.toString().substring(0,4)}",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff707070),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,


                      )
                  ),
                ],
              )
          ),

          Expanded(
              flex: 1,
              child: Icon(Icons.date_range,color: Color(0xff707070),)
          ),



        ],
      ),
    );
  }







  ProgressDialog? pr;
  // ignore: missing_return
  Future<bool?> check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _login();
      }else{
        print('not connected');
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
    } on SocketException catch (_) {
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
  
  
  

//   //to login
  // ignore: missing_return
  Future<List?> _login() async {
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr!.show();
//    Map<String,String> timeOutMessage = {'state':'timeout','content':'server is not responding'};
    try{

//      Map<String, Object> body = {
//          "input_from_price": input_from_price,
//          "input_to_price": input_to_price,
//          "input_from_discount": input_from_discount,
//          "input_to_discount": input_to_discount,
//          "input_rate": input_rate,
//          "filter_cat": _selecteCategorys
//      };

//      print("body is :"+body.toString());
//      username_api="magdy";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      //Return String
      String? token = prefs.getString('token');
//      String urls_ndf=URL_LOGIC.sind_Fillter;
//      final encoding = Encoding.getByName('utf-8');
//      String jsonBody = json.encode(body);
//      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(
          Uri.parse(URL_LOGIC.sind_Fillter),
//        body:jsonBody,
//        encoding: encoding,
        headers: {"Authorization":"$token"},
      );
      var dataUser = json.decode(response.body);
//      var code=datauser["code"];
//      var actions=datauser["action"];
      debugPrint("code >>> ");
      debugPrint(dataUser.toString());
//      debugPrint("message >>> "+actions);


      pr!.hide().then((isHidden) {
        print(isHidden);
      });

      Navigator.push(
        context, MaterialPageRoute(builder: (context) => ShowDataFiltter(idUser: response.body,
        url: "order-mobile/filter-customer-order?orderTotalFrom=10&orderTotalTo=10000&submitDateFrom=$start_date&submitDateTo=$end_date",
      )),
      );



//
////    || message.toString().trim() != "Your Mobile Has Been Confirmed !"
//      if(code.trim() == "014"){
//        Navigator.push(
//          context, MaterialPageRoute(builder: (context) => HomApp()),
//        );
//      }else {
//        xz();
//      }


    }catch(exception){
      print("object ??"+exception.toString());
      pr!.hide().then((isHidden) {
        print(isHidden);
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return   AlertDialog(
            title: null,
            content: Text("يرجي التاكد من الاتصال بل النترنت او المدخلات"),
            actions: [
//            okButton,
            ],
          );
        },
      );
    }
  }
//
}