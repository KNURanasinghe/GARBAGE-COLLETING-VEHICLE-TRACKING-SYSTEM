import 'dart:async'; // Import async library for Timer
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:garbage_loation_tracking_system/Services/myLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final token;
  const HomeScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Position? position;
  String deviceId = ''; // Unique device ID
  String apiUrl = "http://192.168.8.111:3000/vehical/add"; // Your API URL
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    // Generate a unique device ID
    deviceId = UniqueKey().toString();
    // Start the timer when the widget initializes
    startTimer();
  }

  // Method to start the periodic timer
  void startTimer() {
    const Duration interval = Duration(minutes: 15); // 15 minutes interval
    Timer.periodic(interval, (Timer timer) {
      if (isStart) {
        // If the location sharing is active, send the location to the server
        print(("$isStart"));
        sendLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Text("Vehicle Location Sender"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: ApiService.determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          position = snapshot.data as Position;
          // Update the class-level variable
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: isStart
                    ? ElevatedButton(
                        onPressed: () {
                          // Stop sharing location
                          setState(() {
                            isStart = false;
                          });
                        },
                        child: const Text("Stop"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          sendLocation();
                          setState(() {
                            isStart = true;
                          });
                        },
                        child: const Text("Start"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> sendLocation() async {
    // Get current timestamp
    String currentTimeStamp = DateTime.now().toIso8601String();

    var requestBody = jsonEncode({
      "vehicalId": deviceId,
      "lat": position!.latitude.toString(),
      "lan": position!.longitude.toString(),
      "timeStamp": currentTimeStamp,
    });

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-type": "application/json"},
      body: requestBody,
    );

    var jsonResponse = jsonDecode(response.body);
    print('response body $jsonResponse');
    if (jsonResponse['status'] == true) {
      if (jsonResponse.containsKey('data')) {
      } else {
        // Handle case where 'data' key doesn't exist
      }
    }
  }
}
