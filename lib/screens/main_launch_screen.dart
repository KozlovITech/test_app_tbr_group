import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/image_data.dart';
import '../api/launch_data.dart';
import '../models/model_image.dart';
import '../models/model_launch.dart';
import '../models/model_repo_data.dart';

class MainLaunchScreen extends StatefulWidget {
  const MainLaunchScreen({Key? key});

  @override
  State<MainLaunchScreen> createState() => _MainLaunchScreenState();
}

class _MainLaunchScreenState extends State<MainLaunchScreen> {
  late Future<List<LaunchData>> futureLaunchData;
  late Future<List<List<String>>> futureRocketImages;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    futureRocketImages = fetchRocketImages();
    futureLaunchData = fetchLaunchData(getRocketIdFromIndex(activeIndex));
  }
  Future<List<List<String>>> fetchRocketImages() async {
    final List<List<String>> rocketImagesList = [];

    for (final rocketId in rocketIds) {
      final url = 'https://api.spacexdata.com/v3/rockets/$rocketId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> flickrImages = data['flickr_images'];

        if (flickrImages.isNotEmpty) {
          rocketImagesList.add(flickrImages.cast<String>());
        } else {
          rocketImagesList.add([]);
        }
      } else {
        rocketImagesList.add([]);
      }
    }

    return rocketImagesList;
  }

  Future<List<LaunchData>> fetchLaunchData(String rocketID) async {
    final url = 'https://api.spacexdata.com/v3/launches?rocket_id=$rocketID';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<LaunchData> launches = [];

      for (final launch in data) {
        final launchData = LaunchData.fromJson(launch);
        launches.add(launchData);
      }

      return launches;
    } else {
      throw Exception('Failed to load launch data');
    }
  }

  void updateDataAndImages(int newIndex) {
    setState(() {
      activeIndex = newIndex;
      futureRocketImages = fetchRocketImages();
      futureLaunchData = fetchLaunchData(getRocketIdFromIndex(activeIndex));
    });
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
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<List<String>>>(
              future: futureRocketImages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(139, 192, 60, 1.0),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final rocketImagesList = snapshot.data!;
                  final rocketImages = rocketImagesList[activeIndex];
                  return ModelImage(
                    images: rocketImages,
                    activeIndex: activeIndex,
                    onPageChanged: (index, _) {
                      final rocketImagesList = snapshot.data!;
                      final newIndex = index % rocketImagesList.length;
                      if (rocketImagesList[newIndex].isNotEmpty) {
                        updateDataAndImages(newIndex);
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Failed to load rocket images',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No rocket images found'),
                  );
                }
              },
            ),

            const SizedBox(
              height: 10,
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
                            color: Colors.white,
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
                                futureLaunchData = fetchLaunchData(
                                    getRocketIdFromIndex(activeIndex));
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
