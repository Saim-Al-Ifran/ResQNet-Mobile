class DisasterEventModel {
  final String eventType;
  final double latitude;
  final double longitude;
  final String description;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? reportedBy;
  final String? clusterId;
  final String? severity;

  const DisasterEventModel({
    required this.eventType,
    required this.latitude,
    required this.longitude,
    required this.description,
    this.createdAt,
    this.expiresAt,
    this.reportedBy,
    this.clusterId,
    this.severity,
  });
}
