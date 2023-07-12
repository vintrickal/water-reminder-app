import 'package:get/get.dart';

class LandingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxInt _tabPosition = 0.obs;

  get tabPosition => _tabPosition.value;

  Future<void> setTabPosition(int data) async {
    _tabPosition.update((val) {
      _tabPosition = RxInt(data);
    });
  }
}
