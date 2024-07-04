import 'package:share/share.dart';

class ShareUtils {
  static void shareProfile(String shareableLink) {
    Share.share('Check out my profile and expenses: $shareableLink');
  }
}
