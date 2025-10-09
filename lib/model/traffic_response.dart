import 'package:hqr/utils/convert_utils.dart';

class TrafficViolations {
  final String description;
  final String location;
  final String violationTime;
  final String violationStatus;
  final String enforcementAgency;
  final String detectionAgency;

  TrafficViolations({
    this.description = '',
    this.location = '',
    this.violationTime = '',
    this.violationStatus = '',
    this.enforcementAgency = '',
    this.detectionAgency = '',
  });

  factory TrafficViolations.fromJson(Map<String, dynamic> json) =>
      TrafficViolations(
        description: ConvertUtils.getString(json['description']),
        location: ConvertUtils.getString(json['location']),
        violationTime: ConvertUtils.getString(json['violationTime']),
        violationStatus: ConvertUtils.getString(json['violationStatus']),
        enforcementAgency: ConvertUtils.getString(json['enforcementAgency']),
        detectionAgency: ConvertUtils.getString(json['detectionAgency']),
      );
}
