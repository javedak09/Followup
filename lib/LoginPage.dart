import 'package:followup/CustomAlertDialog.dart';
import 'package:followup/GlobalVariables.dart';
import 'package:followup/SampleEntry.dart';
import 'package:followup/WebApi/SyncData.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:followup/Controller/LoginController.dart';
import 'Controller/DeviceInformationController.dart';
import 'Model/DeviceInformation.dart';
import 'Widget/Message.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final usernmeController = TextEditingController();
  final passwdController = TextEditingController();
  String deviceInformation = "";
  bool? isDeviceRegistered;

  @override
  void initState() {
    super.initState();
    GetDeviceInformationSqlLite();
  }

  void downloadUsers() async {
    try {
      String? str = await LoginController().downloadUsers();
    } catch (e) {
      print(e);
    }
  }

  void loginUser() async {
    String? str = await LoginController()
        .Authenticate(usernmeController.text, passwdController.text);
    if (str == "Login Successfully") {
      str = await LoginController().userLog(usernmeController.text, "", "s");

      if (str != "" && str != null) {
        CustomAlertDialog.ShowAlertDialog(context, str.toString());
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SampleEntry()));
      }
    } else {
      CustomAlertDialog.ShowAlertDialog(context, str.toString());
      str = await LoginController().userLog(usernmeController.text, "", "f");

      if (str != "" && str != null) {
        CustomAlertDialog.ShowAlertDialog(context, str.toString());
      }
    }
  }

  void testFunc() {
    List<List<dynamic>> lst = [
      [1, 2],
      [3, 4],
      ["a", "c", "d"]
    ];
    print(lst[2][2]);

    var count = 0;

    for (int a = 0; a <= lst.length - 1; a++) {
      print(lst[a]);
      for (int b = 0; b <= lst[a].length - 1; b++) {
        print(lst[a][b]);
      }
    }
  }

  Future<String> getUniqueDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String uniqueId = '';

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        uniqueId = androidInfo.androidId;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        uniqueId = iosInfo.identifierForVendor;
      }
    } catch (e) {
      print('Failed to get unique device ID: $e');
    }

    return uniqueId;
  }

  void GetDeviceInformationSqlLite() async {
    try {} catch (exception) {
      Utils().toastMessage(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        Text(
          textAlign: TextAlign.center,
          "${GlobalVariables.APP_NAME}",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        Text(
          textAlign: TextAlign.center,
          "${GlobalVariables.APP_TITLE}",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: usernmeController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.purple,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwdController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: Colors.purple.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.purple,
            ),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            loginUser();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Dont have an account? ",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            //SyncData().fetchLoginTestData();
            downloadUsers();
          },
          child: const Text(
            "Download Users",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
