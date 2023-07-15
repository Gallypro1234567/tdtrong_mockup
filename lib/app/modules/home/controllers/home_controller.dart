import 'dart:io';

import 'package:get/get.dart';
import 'package:tdtrong_mockup/app/common/connector.dart';
import 'package:tdtrong_mockup/app/models/finger_scan_model.dart';
import 'package:tdtrong_mockup/app/widget/app_loading.dart';

class HomeController extends GetxController {
  var face = Biometrics().obs;
  var finger = Biometrics().obs;
  var fingerModel = Finger().obs;

  void onSubmit({int? type}) async {
    // type = 0 : face,  type = 1 : finger scan
    if ((type ?? 0) == 0) {
      loading(loadingText: 'Đang xử lý'.obs);
      var res = await Connector.post(
          imageBase64: face.value.base64!, fileName: face.value.hash256!);
      Get.back();
      if (res.success) {
        cautionDialog('Upload thành công', title: 'Thông báo');
        return;
      }
      cautionDialog(res.message, title: 'Thông báo');
    }
    if ((type ?? 0) == 1) {
      loading(loadingText: 'Đang xử lý'.obs);
      var res = await Connector.post(
          imageBase64: finger.value.base64!, fileName: finger.value.hash256!);
      Get.back();
      if (res.success) {
        cautionDialog('Upload thành công', title: 'Thông báo');
        return;
      }
      cautionDialog(res.message, title: 'Thông báo');
    }
  }
}

class Biometrics {
  String? name;
  File? file;
  String? base64;
  String? hash256;
  Biometrics({this.name, this.file, this.base64, this.hash256});
}
