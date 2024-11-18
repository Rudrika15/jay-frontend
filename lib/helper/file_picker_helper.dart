import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> internalFilePicker() async {
  FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowedExtensions: ['jpg', 'bmp'],
      type: FileType.custom,
      compressionQuality: 10);
  return (pickedFile != null) ? File(pickedFile.files.first.xFile.path) : null;
}

Future<File?> takePhoto() async {
  XFile? xFile = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 50);
  return (xFile != null) ? File(xFile.path) : null;
}
