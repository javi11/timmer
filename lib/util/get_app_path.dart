import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.absolute.path;
}
