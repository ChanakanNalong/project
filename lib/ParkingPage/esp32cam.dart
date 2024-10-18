import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RealTimeImageScreen extends StatefulWidget {
  @override
  _RealTimeImageScreenState createState() => _RealTimeImageScreenState();
}

class _RealTimeImageScreenState extends State<RealTimeImageScreen> {
  WebSocketChannel? _channel;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    // เชื่อมต่อกับ ESP32-CAM WebSocket Server
    _channel = IOWebSocketChannel.connect('ws://your-esp32-ip:81');

    // ฟังข้อมูลที่ถูกส่งมาจาก ESP32-CAM
    _channel?.stream.listen((data) {
      if (data is Uint8List) {
        // อัพเดทภาพใหม่ที่ได้รับ
        setState(() {
          _imageBytes = data;
        });
      }
    }, onError: (error) {
      print('Error: $error');
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32-CAM Real-Time Viewer'),
      ),
      body: Center(
        child: _imageBytes != null
            ? Image.memory(
                _imageBytes!,
                gaplessPlayback: true, // ช่วยให้ภาพเปลี่ยนแบบลื่นไหล
              )
            : Text('Waiting for image stream...'),
      ),
    );
  }
}