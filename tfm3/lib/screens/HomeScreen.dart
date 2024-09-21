import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_home_app/utils/AppSpaces.dart';
import 'package:smart_home_app/widgets/buttons.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:typed_data';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _pumpState = 'NO Data';
  tfl.Interpreter? _interpreter;
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.137.184:8080'), // Replace with your ESP8266 IP
  );

  Map<String, dynamic> sensorData = {
    'temp': '0.0',
    'humidity': '0.0',
    'heat': '0.0'
  };

  @override
  void initState() {
    super.initState();
    loadModel();
    channel.stream.listen((message) {
      print("Received: $message"); // Debug print statement
      try {
        var newSensorData = jsonDecode(message);
        setState(() {
          sensorData = newSensorData;
        });
        predictPumpState();
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    });
  }

  Future<void> loadModel() async {
    final interpreterOptions = tfl.InterpreterOptions();
    _interpreter = await tfl.Interpreter.fromAsset(
      'assets/weather_model.tflite',
      options: interpreterOptions,
    );
  }

  Uint8List _encodeInput(double humidity, double temperature) {
    var input = Float32List(2);
    input[0] = humidity;
    input[1] = temperature;
    return input.buffer.asUint8List();
  }

  void sendPumpState(bool state) {
    String message = jsonEncode({'pumpState': state});
    channel.sink.add(message);
  }

  void predictPumpState() {
    double humidity = double.parse(sensorData['heat']);
    double temperature = double.parse(sensorData['temp']);

    if (_interpreter != null) {
      var input = _encodeInput(humidity, temperature);
      var output = List<double>.filled(1, 0).reshape([1, 1]);
      _interpreter!.run(input, output);
      var reshapedOutput = output.reshape([1, 1]);
      bool pumpActivated = reshapedOutput[0][0] > 0.5;
      setState(() {
        _pumpState = pumpActivated ? 'activated' : 'not activated';
      });
      sendPumpState(pumpActivated); // Send pump state to ESP8266
    } else {
      print("Model not loaded");
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Smart Irrigation",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
          child: Column(
            children: [
              AppSpaces.vertical10,
              Expanded(
                child: Row(
                  children: [
                    HomeButton(
                      image: "icons/tem.png",
                      text: 'Temperature',
                      text1: '${sensorData['temp']} °C',
                      onTap: () {},
                    ),
                    AppSpaces.horizontal20,
                    HomeButton(
                      image: "icons/hum1.png",
                      text: 'Humidity percentage',
                      text1: '${sensorData['humidity']} %',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              AppSpaces.vertical20,
              Expanded(
                child: Row(
                  children: [
                    HomeButton(
                      image: "icons/hum2.png",
                      text: "Soil Humidity",
                      text1: "${sensorData['heat']} ",
                      onTap: () {},
                    ),
                    AppSpaces.horizontal20,
                    HomeButton(
                      image: "icons/pump.png",
                      text1: _pumpState,
                      text: 'Water Pump',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              AppSpaces.vertical20,
            ],
          ),
        ),
      ),
    );
  }
}
