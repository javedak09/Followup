import 'package:followup/DBOperations/DBProvider.dart';
import 'package:followup/WebApi/SyncData.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/DeviceInformation.dart';
import '../Widget/Message.dart';
import 'DeviceInformationController.dart';

class LoginController {
  Future<String?> downloadUsers() async {
    try {
      List<dynamic> lst =
          await SyncData().downloadData("api/Login/downloadUsers_Json");
      Database db = await DBProvider().initDb();

      int index = 0;

      for (var item in lst) {
        Map<String, dynamic> map_users = {
          "userid": lst[index]["userid"],
          "passwd": lst[index]["passwd"],
          "userstatus": lst[index]["userstatus"],
          "isadmin": lst[index]["isadmin"],
          "role": lst[index]["role"],
          "imei": lst[index]["imei"],
        };
        index++;
        int i = await db.insert("users", map_users);

        return "Data downloaded successfully";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String?> Authenticate(String userid, String passwd) async {
    try {
      Database? db = await DBProvider().initDb();

      List<Map<String, dynamic>> lst = await db!.query(
        "users",
        columns: ["userid", "passwd", "userstatus"],
        whereArgs: [userid, passwd, 1],
        where: "userid = ? and passwd = ? and userstatus = ?",
      );

      if (lst.length <= 0) {
        return "User does not exist";
      } else {
        return "Login Successfully";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
