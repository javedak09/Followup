import 'package:followup/DBOperations/DBProvider.dart';
import 'package:followup/WebApi/SyncData.dart';
import 'package:intl/intl.dart';

class LoginController {
  Future<String?> downloadUsers() async {
    try {
      List<dynamic> lst =
          await SyncData().downloadData("api/Login/downloadUsers_Json");
      var db = await DBProvider().db;

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
        int i = await db!.insert("users", map_users);

        return "Data downloaded successfully";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<String?> Authenticate(String userid, String passwd) async {
    try {
      var db = await DBProvider().db;

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

  Future<String?> userLog(
      String? userid, String? imei, String? loginstatus) async {
    try {
      var db = await DBProvider().db;

      String mydt = DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.now());

      Map<String, dynamic> lst = {
        "userid": userid,
        "entrydate": mydt,
        "imei": imei,
        "loginstatus": loginstatus,
      };

      int? a = await db!.insert("userslog", lst);
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
