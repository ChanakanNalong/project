// TODO Implement this library.
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_vision/flutter_vision.dart';

class YoloWebSocketService {
  late WebSocketChannel channel;
  late FlutterVision vision;
  Uint8List? imageBytes;
  bool isLoaded = false;
  bool isDetecting = false;
  List<Map<String, dynamic>> yoloResults = [];

  Future<void> init(String websocketUrl) async {
    channel = WebSocketChannel.connect(Uri.parse(websocketUrl));
    vision = FlutterVision();
    await loadYoloModel();
    channel.stream.listen((data) {
      imageBytes = data as Uint8List;
      if (isDetecting) {
        yoloOnFrame(imageBytes!);
      }
    });
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/best_float32.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: true,
    );
    isLoaded = true;
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
      yoloResults = result;
    }
  }

  Future<void> startDetection() async {
    isDetecting = true;
  }

  Future<void> stopDetection() async {
    isDetecting = false;
    yoloResults.clear();
  }

  Future<void> dispose() async {
    await vision.closeYoloModel();
    channel.sink.close();
  }

  List<Map<String, dynamic>> getResults() {
    return yoloResults;
  }

  Uint8List? getImageBytes() {
    return imageBytes;
  }

  bool get isModelLoaded => isLoaded;
}