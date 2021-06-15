export 'depot_service.dart';
export 'transaction_service.dart';
export 'user_service.dart';
export 'chats_service.dart';

// String _baseUrl = '192.168.56.1:9000';
// Uri url(String path, [Map<String, dynamic>? params]) =>
//     Uri.http(_baseUrl, path, params);

String _baseUrl = 'kang-galon.herokuapp.com';
Uri url(String path, [Map<String, dynamic>? params]) =>
    Uri.https(_baseUrl, path, params);
