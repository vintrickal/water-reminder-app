import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends GetxController {
  RxBool _didUserExist = false.obs;
  RxString _userId = ''.obs;

  get didUserExist => _didUserExist.value;
  get userId => _userId.value;

  getSharedPref() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('user_id');

    if (userId == null) {
      _didUserExist.update((val) {
        _didUserExist.value = false;
      });
    } else {
      _userId.update((val) {
        _userId.value = userId;
      });

      _didUserExist.update((val) {
        _didUserExist.value = true;
      });
    }
    // await prefs.remove('user_id');
  }
}
