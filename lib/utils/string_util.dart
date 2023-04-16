import 'package:html/parser.dart' as parser;

import '../data/models/authentication/user.dart';

class StringUtil {
  static String securityPhone(String phone) {
    if (phone.length == 10) {
      var start = phone.substring(0, 3);
      var end = phone.substring(7, 10);
      return '$start****$end';
    } else if (phone.length == 11) {
      var start = phone.substring(0, 3);
      var end = phone.substring(8, 11);
      return '$start*****$end';
    }
    return '***';
  }

  static String getUserIdentify(AppUser? currentUser) {
    if (currentUser == null) return '';
    if (currentUser.fullName?.isNotEmpty ?? false) {
      return currentUser.fullName!;
    } else if (currentUser.email?.isNotEmpty ?? false) {
      return currentUser.email!;
    }
    return '';
  }

  static String parseHtmlString(String? htmlString) {
    if (htmlString?.isEmpty ?? true) {
      return '';
    }
    final document = parser.parse(htmlString);
    final finalString = parser.parse(document.body?.text).documentElement?.text;
    return finalString ?? '';
  }
}
