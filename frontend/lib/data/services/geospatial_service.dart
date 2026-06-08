import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class WeatherData {
  final double temp;
  final double humidity;
  final String condition;
  final String station;

  WeatherData({required this.temp, required this.humidity, required this.condition, required this.station});
}

class InpeAlert {
  final String type;
  final String severity;
  final DateTime date;

  InpeAlert({required this.type, required this.severity, required this.date});
}

class GeospatialService {
  static const String inmetBaseUrl = 'https://apitempo.inmet.gov.br';

  Future<WeatherData> fetchWeatherData(LatLng location) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return WeatherData(
      temp: 24.5,
      humidity: 62,
      condition: 'Céu Limpo',
      station: 'A701 - São Paulo',
    );
  }

  Future<List<InpeAlert>> fetchInpeAlerts(LatLng location) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return [
      InpeAlert(type: 'Foco de Calor', severity: 'Baixa', date: DateTime.now().subtract(const Duration(days: 2))),
    ];
  }
  /// URL do Sentinel Hub para a camada de NDVI
  String getSentinelLayerUrl(String layerId, List<LatLng> polygon) {
    return "https://services.sentinel-hub.com/ogc/wms/YOUR_ID?REQUEST=GetMap&LAYERS=$layerId&BBOX=-46.7,-23.6,-46.5,-23.4&WIDTH=512&HEIGHT=512&FORMAT=image/png";
  }
}
