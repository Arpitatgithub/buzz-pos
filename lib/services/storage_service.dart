import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {

  final supabase =
      Supabase.instance.client;

  Future<String> uploadProductImage()
      async {

    final result =
    await FilePicker.platform
        .pickFiles(
  type: FileType.image,
);

    if (result == null) {
      return '';
    }

    final file =
        File(result.files.single.path!);

    final fileName =
        DateTime.now()
            .millisecondsSinceEpoch
            .toString();

    await supabase.storage
        .from('product-images')
        .upload(
          fileName,
          file,
        );

    final imageUrl =
        supabase.storage
            .from('product-images')
            .getPublicUrl(
              fileName,
            );

    return imageUrl;
  }
}