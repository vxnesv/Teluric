import 'package:latlong2/latlong.dart';

enum AreaCategory {
  reforestation('Reflorestamento', '🌱'),
  spring('Nascente', '💧'),
  agroforest('Agrofloresta', '🌿'),
  preservation('Preservação', '🛡️');

  const AreaCategory(this.label, this.emoji);
  final String label;
  final String emoji;
}

enum RegenerationStatus { growing, stable, atRisk }

class AreaModel {
  final String id;
  final String name;
  final AreaCategory category;
  final List<LatLng> polygon;
  final double scoreEnv;
  final double carbonEstimate;
  final double ndviChange;
  final double biomassChange;
  final RegenerationStatus status;
  final String lastUpdate;
  final List<TimelineEvent> events;
  final List<double> ndviHistory;
  final List<double> carbonHistory;


  const AreaModel({
    required this.id,
    required this.name,
    required this.category,
    required this.polygon,
    required this.scoreEnv,
    required this.carbonEstimate,
    required this.ndviChange,
    required this.biomassChange,
    required this.status,
    required this.lastUpdate,
    required this.events,
    required this.ndviHistory,
    required this.carbonHistory,
  });
}

class TimelineEvent {
  final String title;
  final String date;
  final String icon;
  final bool isAlert;

  const TimelineEvent({
    required this.title,
    required this.date,
    required this.icon,
    this.isAlert = false,
  });
}


final List<AreaModel> mockAreas = [
  AreaModel(
    id: 'area_001',
    name: 'Floresta das Vertentes',
    category: AreaCategory.reforestation,

    polygon: [
      LatLng(-23.491, -46.625),
      LatLng(-23.491, -46.590),
      LatLng(-23.520, -46.590),
      LatLng(-23.520, -46.625),
    ],
    scoreEnv: 82,
    carbonEstimate: 2.3,
    ndviChange: 18,
    biomassChange: 2.1,
    status: RegenerationStatus.growing,
    lastUpdate: 'Há 2 dias',
    ndviHistory: [0.41, 0.43, 0.44, 0.46, 0.48, 0.49, 0.51, 0.52, 0.53, 0.55, 0.57, 0.59],
    carbonHistory: [1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.3],
    events: const [
      TimelineEvent(
        title: 'IA detectou crescimento vegetal +8%',
        date: '28 mai 2025',
        icon: '🛰️',
      ),
      TimelineEvent(
        title: 'Nova captura orbital processada',
        date: '14 mai 2025',
        icon: '📡',
      ),
      TimelineEvent(
        title: 'Certificado ESG emitido',
        date: '01 mai 2025',
        icon: '🏅',
      ),
      TimelineEvent(
        title: 'Risco de seca detectado — nível baixo',
        date: '10 abr 2025',
        icon: '⚠️',
        isAlert: true,
      ),
      TimelineEvent(
        title: 'Área registrada no sistema',
        date: '01 jan 2025',
        icon: '✅',
      ),
    ],
  ),
  AreaModel(
    id: 'area_002',
    name: 'Nascente Rio Verde',
    category: AreaCategory.spring,

    polygon: [
      LatLng(-23.540, -46.640),
      LatLng(-23.540, -46.620),
      LatLng(-23.556, -46.620),
      LatLng(-23.556, -46.640),
    ],
    scoreEnv: 64,
    carbonEstimate: 0.8,
    ndviChange: 7,
    biomassChange: 0.6,
    status: RegenerationStatus.stable,
    lastUpdate: 'Ontem',
    ndviHistory: [0.38, 0.38, 0.39, 0.39, 0.40, 0.40, 0.41, 0.41, 0.42, 0.42, 0.43, 0.43],
    carbonHistory: [0.4, 0.5, 0.5, 0.6, 0.6, 0.7, 0.7, 0.7, 0.8, 0.8, 0.8, 0.8],
    events: const [
      TimelineEvent(
        title: 'Análise hídrica concluída',
        date: '25 mai 2025',
        icon: '💧',
      ),
      TimelineEvent(
        title: 'Nova captura orbital processada',
        date: '10 mai 2025',
        icon: '📡',
      ),
      TimelineEvent(
        title: 'Área registrada no sistema',
        date: '01 mar 2025',
        icon: '✅',
      ),
    ],
  ),
  AreaModel(
    id: 'area_003',
    name: 'Agrofloresta Serra Negra',
    category: AreaCategory.agroforest,

    polygon: [
      LatLng(-23.510, -46.660),
      LatLng(-23.510, -46.635),
      LatLng(-23.530, -46.635),
      LatLng(-23.530, -46.660),
    ],
    scoreEnv: 91,
    carbonEstimate: 3.7,
    ndviChange: 23,
    biomassChange: 3.4,
    status: RegenerationStatus.growing,
    lastUpdate: 'Hoje',
    ndviHistory: [0.48, 0.49, 0.51, 0.53, 0.55, 0.57, 0.58, 0.60, 0.62, 0.63, 0.65, 0.67],
    carbonHistory: [1.8, 1.9, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.7],
    events: const [
      TimelineEvent(
        title: 'Recorde de biomassa detectado',
        date: '30 mai 2025',
        icon: '🏆',
      ),
      TimelineEvent(
        title: '2º Certificado ESG emitido',
        date: '15 mai 2025',
        icon: '🏅',
      ),
      TimelineEvent(
        title: 'IA detectou crescimento vegetal +12%',
        date: '01 mai 2025',
        icon: '🛰️',
      ),
      TimelineEvent(
        title: 'Área registrada no sistema',
        date: '01 nov 2024',
        icon: '✅',
      ),
    ],
  ),
];

const double globalScore = 847;
const double totalCarbon = 6.8;
const int certificatesIssued = 3;