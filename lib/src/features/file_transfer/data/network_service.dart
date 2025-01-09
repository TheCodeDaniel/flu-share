import 'package:dio/dio.dart';
import '../domain/entities/device.dart';

class NetworkService {
  final Dio _dio = Dio();

  Future<List<Device>> scanDevices() async {
    return [
      Device(id: '1', name: 'MacBook Pro', ipAddress: '192.168.1.2'),
      Device(id: '2', name: 'Android Phone', ipAddress: '192.168.1.3'),
    ];
  }

  Future<void> sendRequest(String ipAddress, Map<String, dynamic> data) async {
    final response = await _dio.post('http://$ipAddress/request', data: data);
    if (response.statusCode != 200) throw Exception('Failed to send request');
  }
}
