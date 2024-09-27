import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:followup/Model/DeviceInformation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:followup/DBOperations/DBProvider.dart';

class DeviceInformationController {
  Future<List<DeviceInformation>> DeviceInformationOnSqlLite(
      String a_sDeviceId) async {
    List<DeviceInformation> deviceInformationList = [];
    final Database db = await DBProvider().initDb();

    try {
      final List<Map<String, dynamic>> loginInforMap = await db.query(
        'DeviceInformation',
        where: 'DeviceID = ? ',
        whereArgs: [a_sDeviceId],
      );
      await db.close();

      loginInforMap.forEach((map) {
        final visit = DeviceInformation.fromMap(map);
        deviceInformationList.add(visit);
      });
    } catch (exception) {}
    return deviceInformationList;
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
}
