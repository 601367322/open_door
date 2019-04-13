import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/strings.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

var dio = Dio();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getTemporaryDirectory().then((tempDir) {
      String tempPath = tempDir.path;
      dio.interceptors.add(CookieManager(PersistCookieJar(
        dir: tempPath,
        ignoreExpires: true,
      )));
    });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("开门"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A5FEA6D4D03726E050A10A7E1C5ABC");
                },
                child: Text("单元门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A5FEEE2DB73068E050A10A7E1C5ACC");
                },
                child: Text("北门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A67BB3B4632E56E050A10A7E1C6D83");
                },
                child: Text("南门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A62D7C7E1FF9EBE050A10A7E1C5FD9");
                },
                child: Text("东门南"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A693FBED504B75E050A10A7E1C6641");
                },
                child: Text("东门北"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A62D7C7E20F9EBE050A10A7E1C5FD9");
                },
                child: Text("6号楼大门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A631E13D4B111DE050A10A7E1C5FFA");
                },
                child: Text("7号楼大门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A67BB3B4632E56E050A10A7E1C6D83");
                },
                child: Text("8号楼大门"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  openDoor("63A62D7C7E21F9EBE050A10A7E1C5FD9");
                },
                child: Text("9号楼大门"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _login() async {
    try {
      var response = await dio.post(
        "https://api.lookdoor.cn/func/hjapp/user/v1/login.json",
        data: {
          "pNn": "13488616135",
          "newDeviceId": "862400044009578",
          "equipmentFlag": "2",
          "pWd": "e10adc3949ba59abbe56e057f20f883e",
          "deviceId": "862400044009578",
          "userNum": "13488616135",
        },
        options: Options(
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")),
      );
      print(response.data.toString());
      if (response.data["code"] == 200)
        return true;
      else
        Fluttertoast.showToast(msg: response.data["message"]);
    } catch (e) {
      Fluttertoast.showToast(msg: "网络错误");
    }
    return false;
  }

  openDoor(doorId) async {
    _login().then((success) async {
      if (success) {
        try {
          var response = await dio.post(
            "https://api.lookdoor.cn/func/hjapp/house/v1/pushOpenDoorBySn.json",
            data: {
              "equipmentId": doorId,
              "userNum": "13488616135",
            },
            options: Options(
              contentType:
                  ContentType.parse("application/x-www-form-urlencoded"),
            ),
          );
          print(response.data.toString());
          parseData(response.data);
        } catch (e) {
          Fluttertoast.showToast(msg: "网络错误\n" + e.toString());
        }
      }
    });
  }

  int parseData(responseData) {
    int code = responseData["code"];
    switch (code) {
      case 200:
        Fluttertoast.showToast(msg: "操作成功");
        break;
      default:
        var message = responseData["message"];
        if (isEmpty(message)) {
          Fluttertoast.showToast(msg: "网络错误");
        } else {
          Fluttertoast.showToast(msg: message);
        }
    }
    return code;
  }
}
