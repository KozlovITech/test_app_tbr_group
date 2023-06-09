import 'package:flutter/material.dart';
import '../api/launch_data.dart';

class ModelLaunch extends StatelessWidget {
  final LaunchData launch;

  const ModelLaunch({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    final formattedDate = launch.getFormattedDate();
    final formattedTime = launch.getFormattedTime();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      width: 361,
      padding: const EdgeInsets.only(left: 16, top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(28, 28, 28, 1),
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color.fromRGBO(186, 252, 84, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    color: Color.fromRGBO(197, 197, 197, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 26,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    launch.missionName,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    launch.siteNameLong,
                    style: const TextStyle(
                      color: Color.fromRGBO(165, 165, 165, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
