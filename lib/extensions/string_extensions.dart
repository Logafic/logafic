import 'package:logafic/data_model/routing_data.dart';

// Yönlendirme için kullanılan uzantı
extension StringExtensions on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    print('queryParameters :${uriData.queryParameters} Path: ${uriData.path}');
    return RoutingData(
        queryParameters: uriData.queryParameters, route: uriData.path);
  }
}

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}  ...' : data;
}
