import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:water_reminder_app/global.dart';

class MainController extends GetxController {
  RxBool _didUserExist = false.obs;
  RxString _userId = ''.obs;
  RxString _deviceToken = ''.obs;
  RxBool _isLoading = false.obs;
  RxList _mainUserList = [].obs;

  get didUserExist => _didUserExist.value;
  get userId => _userId.value;
  get deviceToken => _deviceToken.value;
  get isLoading => _isLoading.value;
  get mainUserList => _mainUserList;

  getSharedPref() async {
    _isLoading.update((val) {
      _isLoading.value = true;
    });

    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? userId = prefs.getString('user_id');
    final String? deviceToken = prefs.getString('device_token');
    final fCMToken = await Global.storageService.generateToken();

    if (userId == null) {
      _didUserExist.update((val) {
        _didUserExist.value = false;
      });
    } else {
      if (deviceToken != fCMToken) {
        Map<String, dynamic> item = {'device_token': fCMToken};
        Global.storageService.updateDeviceToken(id: userId, data: item);

        // Store the new generated device token
        _deviceToken.update((val) {
          _deviceToken.value = fCMToken;
        });
      }
      var tempList = await Global.storageService.getCollection(
          collectionName: 'user', keyword: 'user_id', value: userId);

      _mainUserList = RxList(tempList);

      // Store the data to a getx variable
      _userId.update((val) {
        _userId.value = userId;
      });
      _deviceToken.update((val) {
        _deviceToken.value = deviceToken!;
      });

      _didUserExist.update((val) {
        _didUserExist.value = true;
      });
    }
    _isLoading.update((val) {
      _isLoading.value = false;
    });
  }
}
