import '/libraries/custom_packages.dart';

class CustomPageController extends GetxController {
  final _currentPageIndex = 0.obs;
  int get currentPageIndex => _currentPageIndex.value;

  void changePage(int index) {
    _currentPageIndex.value = index;
  }
}