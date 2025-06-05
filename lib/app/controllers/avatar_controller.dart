import '/libraries/system_packages.dart';
import '/libraries/custom_packages.dart';

class AvatarController extends GetxController {
  final _avatarImage = File('').obs;
  File get avatarImage => _avatarImage.value;
  Future<void> pickAvatarImage() async {
    final imagePicker = ImagePicker();
    final filePicker = await imagePicker.pickImage(source: ImageSource.gallery);
    if (filePicker != null) {
      _avatarImage.value = File(filePicker.path);
    }
  }
}