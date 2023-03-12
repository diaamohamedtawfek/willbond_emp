import 'package:flutter/material.dart';

class HomeWiting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UIHomeWiting();
  }

}
bool isLoading = true;

class UIHomeWiting extends State<HomeWiting>{



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 110,
                      child: _loader(),
                    ),

                    Text(
                        "انتظر قليلا.......",
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Color(0xffffffff),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                        textAlign: TextAlign.left
                    )

                  ],
                )
            )

    ;
  }


  Widget _loader() {
    return isLoading
        ? new Align(
      child: new Container(
        width: 110.0,
        height: 110.0,
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
