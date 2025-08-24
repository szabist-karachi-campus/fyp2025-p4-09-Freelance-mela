import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:html' as html;
import 'dart:typed_data';

class SupabaseHelper {
  static Future<String> uploadFile(html.File? file, String phone) async {
    final supabase = Supabase.instance.client;
    String filename = file!.name;
    String extension = filename.split('.').last;
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String uniqueFilename = '$filename-$timestamp.$extension';
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    final fileBytes = reader.result as Uint8List?;
    await supabase.storage.from('free').uploadBinary(
          uniqueFilename,
          fileBytes!,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );
    final publicURL =
        supabase.storage.from('free').getPublicUrl(uniqueFilename);
    return publicURL.isNotEmpty ? publicURL : '';
  }
}
