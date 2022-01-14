import 'package:get/get.dart';

class MainController extends GetxController {
  final token = "".obs;

  changeToken(String id) => token.value = id;
}
