import '/libraries/custom_packages.dart';

class LoadingStateController extends GetxController {
  final _isLoadingState = false.obs;
  bool get isLoadingState => _isLoadingState.value;

  void changeLoadingState() {
    _isLoadingState.value = !_isLoadingState.value;
  }
}