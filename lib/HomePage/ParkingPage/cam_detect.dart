// TODO Implement this library.
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_vision/flutter_vision.dart';

class YoloWebSocket extends StatefulWidget {
  const YoloWebSocket({Key? key}) : super(key: key);

  @override
  State<YoloWebSocket> createState() => _YoloWebSocketState();

}

class _YoloWebSocketState extends State<YoloWebSocket> {
  late WebSocketChannel channel;
  late FlutterVision vision;
  Uint8List? imageBytes;
  bool isLoaded = false;
  bool isDetecting = false;
  List<Map<String, dynamic>> yoloResults = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    channel = WebSocketChannel.connect(Uri.parse('ws://172.16.10.249:81'));
    vision = FlutterVision();
    await loadYoloModel();
    channel.stream.listen((data) {
      setState(() {
        imageBytes = data as Uint8List;
      });
      if (isDetecting) {
        yoloOnFrame(imageBytes!);
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await vision.closeYoloModel();
    channel.sink.close();
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/best_float32.tflite',
        modelVersion: "yolov8",
        numThreads: 1,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(Uint8List imageBytes) async {
    final result = await vision.yoloOnFrame(
      bytesList: [imageBytes],
      imageHeight: 480,
      imageWidth: 640,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / 640; // Width of the image from ESP32
    double factorY = screen.height / 480; // Height of the image from ESP32

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}%",
            style: const TextStyle(
              backgroundColor: Colors.white,
              color: Colors.black,
              fontSize: 14.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32-CAM Real-Time Detection'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          imageBytes != null
              ? Image.memory(
                  imageBytes!,
                  fit: BoxFit.cover,
                )
              : const Center(child: Text('Waiting for image stream...')),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Text(
                'Objects detected: ${yoloResults.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 75,
            width: size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}