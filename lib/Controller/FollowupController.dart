import 'package:followup/DBOperations/DBProvider.dart';
import 'package:followup/WebApi/SyncData.dart';
import 'package:intl/intl.dart';

class FollowupController {
  void downloadFollowups() async {
    try {
      List<dynamic> lst =
          await SyncData().downloadData("api/Followup/downloadFollowup");
      int index = 0;

      var db = await DBProvider().db;

      String vdt = DateFormat("dd/MM/yyyy").format(DateTime.now());

      for (var item in lst) {
        Map<String, dynamic> map_fup = {
          "childid": lst[index]["childid"],
          "vdt": lst[index]["vdt"],
          "visitno": lst[index]["visitno"],
          "status": lst[index]["status"],
        };
        index++;

        await db!.insert("followups", map_fup);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
