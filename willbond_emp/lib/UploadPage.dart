// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:willbond_emp/URL_LOGIC.dart';
// import 'package:path/path.dart';
// import 'package:async/async.dart';
// import 'package:http_parser/http_parser.dart';
//
// class UploadPage extends StatefulWidget {
//   UploadPage({Key? key, this.url}) : super(key: key);
//   final String? url;
//
//   @override
//   _UploadPageState createState() => _UploadPageState();
// }
//
// class _UploadPageState extends State<UploadPage> {
//
//   File? file;
//   var serverReceiverPath = "https://www.developerlibs.com/upload";
//
//
//
//
//   Future<String> uploadImage(filename) async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('token');
// //    final headers1 = {'Content-Type': 'application/json',"Accept":"application/json","Authorization":"$token"};
//
// //    Map<String, String> headers = {"Authorization":"$token"};
//     var request = http.MultipartRequest(
//       "POST",
//       Uri.parse(
//         URL_LOGIC.uplodeImage+"image.jpg",
//       ),
//     );
//     //add text fields
//
//     request.headers["Authorization"]=token;
//
// //    request.fields["type"] = type;
// //    request.fields["note"] = note;
// //    for (var item in filename) {
//       var ext = filename.split('.').last;
//       var pic = await http.MultipartFile.fromPath("file", filename, contentType: MediaType('image', ext));
//       request.files.add(pic);
// //    }
//
//     //add multipart to request
//
//     var response = await request.send();
//     var responseData = await response.stream.toBytes();
//     var responseString = String.fromCharCodes(responseData);
//
//     var d = jsonDecode(responseString);
// //    JSON.decode(response.body);
// //   var c= json.decode(utf8.decode(responseByteArray));
//
//     return  d.toString();
//
// //    var uri = Uri.parse("http://pub.dartlang.org/packages/create");
// //    var request = new http.MultipartRequest("POST", uri);
// //    request.fields['user'] = 'nweiz@google.com';
// //    request.files.add(new http.MultipartFile.fromFile(
// //        'package',
// //        new File('build/package.tar.gz'),
// //        contentType: MediaType('application', 'x-tar')));
// //        request.send().then((response) {
// //      if (response.statusCode == 200) print("Uploaded!");
// //    });
//
// //    SharedPreferences prefs = await SharedPreferences.getInstance();
// //    //Return String
// //    String token = prefs.getString('token');
// //
// //    var request = http.MultipartRequest(
// //      "POST",
// //      Uri.parse(
// //        URL_LOGIC.uplodeImage,
// //      ),
// //    );
// //    Map<String, String> headers = {
// //      'Content-Type': 'multipart/form-data',
// //      'token': token
// //    };
// //    request.headers['token'] = token;
// //    request.headers["Content-Type"]='multipart/form-data';
// //    request.fields["name"] = "hardik";
// //
// //    request.fields["email"] = "h@gmail.com";
// //    request.fields["mobile"] = "00000000";
// //    request.fields["address"] = "afa";
// //    request.fields["city"] = "fsf";
// //
// //    if (filename != null) {
// ////      print(filename.path.split(".").last);
// //      request.files.add(
// //        http.MultipartFile.fromBytes(
// //
// //          "avatar",
// //          filename.readAsBytesSync(),
// //          filename: "test.${filename.path.split(".").last}",
// //          contentType:
// //          MediaType("image", "${filename.path.split(".").last}",headers),
// //        ),
// //      );
// //    }
// //    request.fields["reminder_interval"] = "1";
// //
// //    request.send().then((onValue) {
// //      print(onValue.statusCode);
// //
// //      print(onValue.headers);
// //      print(onValue.contentLength);
// //    });
//
// //    var request = http.MultipartRequest('POST', Uri.parse(URL_LOGIC.uplodeImage),);
// //    request.files.add(await http.MultipartFile.fromPath('picture', filename));
// //    var res = await request.send();
// //    print("?>>>>>>"+res.toString());
// //    return res.reasonPhrase;
//   }
//
//
//   // ignore: non_constant_identifier_names
//   Upload(File imageFile) async {
//     var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//     var length = await imageFile.length();
//
//     var uri = Uri.parse(URL_LOGIC.uplodeImage);
//
//     var request = new http.MultipartRequest("POST", uri);
//     var multipartFile = new http.MultipartFile('file', stream, length,
//         filename: basename(imageFile.path));
//     //contentType: new MediaType('image', 'png'));
//
//     request.files.add(multipartFile);
//     var response = await request.send();
//     print(response.statusCode);
//     response.stream.transform(utf8.decoder).listen((value) {
//       print(value);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Flutter File Upload Example',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             file != null
//                 ? Container(
//               height: 160.0,
//               width: 160.0,
//               decoration: BoxDecoration(
//                 color: const Color(0xff7c94b6),
//                 image: DecorationImage(
//                   image: ExactAssetImage(file?.path??""),
//                   fit: BoxFit.cover,
//                 ),
//                 border: Border.all(color: Colors.red, width: 5.0),
//                 borderRadius:
//                 BorderRadius.all(const Radius.circular(20.0)),
//               ),
//             )
//                 : SizedBox(
//               width: 0.0,
//             ),
//             SizedBox(
//               height: 100.0,
//             ),
//             file != null
//                 ? RaisedButton(
//               child: Text("Upload Image"),
//               onPressed: () async {
//                 var res = await uploadImage(file?.path??"");
// //                var res = await uploadImage(file.path);
//                 setState(() {
//                   print(res);
//                 });
//               },
//             )
//                 : SizedBox(
//               width: 50.0,
//             ),
//             file == null
//                 ? RaisedButton(
//               child: Text("Open Gallery"),
//               onPressed: () async {
//                 file = await ImagePicker.pickImage(
//                     source: ImageSource.gallery);
//                 setState(() {});
//               },
//             )
//                 : SizedBox(
//               width: 0.0,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }