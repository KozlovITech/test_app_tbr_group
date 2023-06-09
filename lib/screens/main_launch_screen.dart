import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/launch_data.dart';
import '../models/model_image.dart';
import '../models/model_image_repo.dart';
import '../models/model_launch.dart';

class MainLaunchScreen extends StatefulWidget {
  const MainLaunchScreen({super.key});

  @override
  State<MainLaunchScreen> createState() => _MainLaunchScreen();
}

class _MainLaunchScreen extends State<MainLaunchScreen> {
  late Future<List<LaunchData>> futureLaunchData;
  int activeIndex = 0;
  final ModelImageRepo modelImageRepo = ModelImageRepo();

  @override
  void initState() {
    super.initState();
    futureLaunchData = fetchLaunchData(activeIndex);
  }

  Future<List<LaunchData>> fetchLaunchData(int activeIndex) async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v3/launches'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<LaunchData> launches = [];

      for (final launch in data) {
        final rocketName = launch['rocket']['rocket_name'];

        if ((activeIndex == 0 && rocketName == 'Falcon 1') ||
            (activeIndex == 1 && rocketName == 'Falcon 9') ||
            (activeIndex == 2 && rocketName == 'Falcon Heavy') ||
            (activeIndex == 3 && rocketName == 'null')) {
          final launchData = LaunchData.fromJson(launch);
          launches.add(launchData);
        }
      }
      return launches;
    } else {
      throw Exception('Failed to load launch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 24),
        color: Colors.black,
        child: Column(
          children: [
            const Text(
              "SpaceX Launches",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ModelImage(
              images: modelImageRepo.imagesRepo,
              activeIndex: activeIndex,
              onPageChanged: (index, _) {
                setState(() {
                  activeIndex = index;
                  futureLaunchData = fetchLaunchData(activeIndex);
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ModelImageRepo().imagesRepo.map<Widget>((e) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    shape: BoxShape.circle,
                    color: activeIndex == ModelImageRepo().imagesRepo.indexOf(e)
                        ? Colors.white
                        : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.only(left: 5),
              child: const Text(
                "Missions",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: FutureBuilder<List<LaunchData>>(
                future: futureLaunchData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(139, 192, 60, 1.0),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final launches = snapshot.data!;
                    if (launches.isEmpty) {
                      return const Center(
                        child: Text(
                          'There is no data on launches of this rocket.',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: launches.length,
                      itemBuilder: (context, index) {
                        final launch = launches[index];
                        return ModelLaunch(launch: launch);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Failed to load launch data',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                futureLaunchData = fetchLaunchData(activeIndex);
                              });
                            },
                            child: const Text(
                              'Retry',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No launches found'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
