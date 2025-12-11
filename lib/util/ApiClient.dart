import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';

class ApiClient {
// production

  /* static final String BASE_URL = "http://34.133.129.206/production/api/v1/";
  static final String IMG_BASE_URL = "http://34.133.129.206/production/storage/app/";
  static final String IMG_BASE_GOOGLE_URL = "https://storage.googleapis.com/kp_stagging_photos/production/";*/

// stagging
//
//   static final String BASE_URL = "http://34.41.222.187/stagging/api/v1/";
//   static final String IMG_BASE_URL =
//       "http://34.41.222.187/stagging/storage/app/";
//   static final String IMG_BASE_GOOGLE_URL =
//       "https://storage.googleapis.com/kp_stagging_photos/stagging/";

  static final String BASE_URL = "http://192.168.1.86:81/ANP_SAFETY/api/v1/";
  static final String IMG_BASE_URL = "http://192.168.1.86:81/ANP_SAFETY/storage/app/";
  static final String IMG_BASE_GOOGLE_URL =
      "https://storage.googleapis.com/kp_stagging_photos/stagging/";

  static String drawerFlag = "0";
  static String roleName = "";
  static String roleID = "";
  static String userName = "";
  static String userType = "";

  static String todaysDate(date) {
    var months, days;
    months = "${date.month}";
    days = "${date.day}";
    if (date.month <= 9) {
      months = "0$months";
    }
    if (date.day <= 9) {
      days = "0$days";
    }
    print("dates $date");
    //selectDate =  "${dates.year}-$months-$days";
    return "${date.year}-$months-$days";
  }

  static String dataFormatYear(m) {
    DateTime dateTime = DateTime.parse(m);
    String year = new DateFormat.y().format(dateTime);
    String month = new DateFormat.MMM().format(dateTime);
    String day = new DateFormat.d().format(dateTime);

    print("$year,$month,$day");
    return "$day $month $year";
  }

  static String dataFormatDayTime(m) {
    DateTime dateTime = DateTime.parse(m);
    String year = new DateFormat.y().format(dateTime);
    String month = new DateFormat.MMM().format(dateTime);
    String day = new DateFormat.d().format(dateTime);

    String h = new DateFormat.Hms().format(dateTime);

    print("$year,$month,$day $h");
    return "$day $month $year $h";
  }

  static dateDifference(date) {
    String formatedDay = date;
    print("date  : ${date.substring(0, 10)}");
    print("Time  : ${date.substring(11, 19)}");

    DateTime dob = DateTime.parse(date.substring(0, 10));
    Duration dur = DateTime.now().difference(dob);
    String differenceInYears = (dur.inDays).floor().toString();

    if (differenceInYears == "0") {
      DateTime dob =
          DateTime.parse("${date.substring(0, 10)} ${date.substring(11, 19)}");
      Duration dur = DateTime.now().difference(dob);
      String differenceInHours = (dur.inHours).floor().toString();
      String differenceInMinutes = (dur.inMinutes).floor().toString();

      if (differenceInHours == "0") {
        formatedDay = "$differenceInMinutes Minutes ago";
      } else {
        formatedDay =
            "$differenceInHours Hours ${int.parse("$differenceInMinutes") - (60 * int.parse("$differenceInHours"))} Minutes ago";
      }
    } else if (differenceInYears == "1") {
      formatedDay = "Yesterday ${date.substring(11, 19)}";
    } else {
      DateTime dateTime = DateTime.parse(date.substring(0, 10));
      String year = new DateFormat.y().format(dateTime);
      String month = new DateFormat.MMM().format(dateTime);
      String day = new DateFormat.d().format(dateTime);

      formatedDay = "$day $month $year ${date.substring(11, 19)}";
    }
    print("Time  : ${differenceInYears}");
    print("Time 1 1  : ${dur.toString()}");

    // return new Text(differenceInYears + ' years');

    return formatedDay;
  }

  static bool imageSize(bytes) {
    var kb = bytes / 1024;
    var mb = kb / 1024;

    if (1.0 < mb) {
      print("kb  :: $mb");
      return false;
    } else {
      print("mb  :: $mb");
      return true;
    }
  }
}
