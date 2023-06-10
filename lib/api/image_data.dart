import 'package:intl/intl.dart';

class ImageData {
  final String flickrImages;

  ImageData({
    required this.flickrImages,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      flickrImages: json['rocket_id']['flickrImages'][0],
    );
  }
}

