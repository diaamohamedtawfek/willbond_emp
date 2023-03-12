import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:willbond_emp/startapp/SplashScrean.dart';

import 'Design_page_error_fether/Error_Found_Page.dart';

void main() {
  runApp(MyApp());
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    appBar: AppBar(title: Text(""),
      backgroundColor: Color(0xff212660),
      iconTheme: new IconThemeData(color: Color(0xffffffff)),
      elevation: 2.0,
    ),
    body: Center(
      child: Error_Found_Page()
//      Text(
//        "لم يتم الوصول الي الخادم بعد",
//        style: Theme.of(context).textTheme.title,
//      ),
    ),
  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Willbound',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),


      // builder: (BuildContext context, Widget widget) {
      //   ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      //     return buildError(context, errorDetails);
      //   };
      //
      //   return widget;
      // },


//      home: UploadPage()
      home: SplashScrean(),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}





