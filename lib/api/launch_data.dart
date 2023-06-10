import 'package:intl/intl.dart';

class LaunchData {
  final String launchDateUtc;
  final String missionName;
  final String rocketName;
  final String siteNameLong;
  final String rocketID;

  LaunchData({
    required this.launchDateUtc,
    required this.missionName,
    required this.rocketName,
    required this.siteNameLong,
    required this.rocketID,
  });

  factory LaunchData.fromJson(Map<String, dynamic> json) {
    return LaunchData(
      launchDateUtc: json['launch_date_utc'],
      missionName: json['mission_name'],
      rocketName: json['rocket']['rocket_name'],
      siteNameLong: json['launch_site']['site_name_long'],
      rocketID: json['rocket']['rocket_id'],

    );
  }

  String getFormattedDate() {
    final launchDate = DateTime.parse(launchDateUtc);
    return DateFormat('dd/MM/yyyy').format(launchDate);
  }

  String getFormattedTime() {
    final launchDate = DateTime.parse(launchDateUtc);
    return DateFormat('hh:mm a').format(launchDate);
  }
}


