import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

mixin ImageApi {
  // Pick image from mobile (gallery or camera)
  Future<XFile?> pickImageMobile(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: source);
  }

  // Pick image from web
  Future<Uint8List?> pickImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      return result.files.first.bytes;
    }
    return null;
  }
}
