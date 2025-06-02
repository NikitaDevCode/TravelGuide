import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class TimerController extends GetxController {
  Timer? _timer;
  final _repeatSendCodeSeconds = 30.obs;
  int get repeatSendCodeSeconds => _repeatSendCodeSeconds.value;
  final _isRepeatSendCode = false.obs;
  bool get isRepeatSendCode => _isRepeatSendCode.value;
  void startTimer() {
    _isRepeatSendCode.value = false;
    _repeatSendCodeSeconds.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_repeatSendCodeSeconds.value > 0) {
        _repeatSendCodeSeconds.value--;
      }
      else {
        _isRepeatSendCode.value = true;
        _timer?.cancel();
      }
    });
  }
}