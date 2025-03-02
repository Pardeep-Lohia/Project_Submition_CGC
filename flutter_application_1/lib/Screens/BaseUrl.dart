import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class APIConfig {
  static String getBaseUrl() {
    const String webUrl = "http://localhost:5000"; // Web requires localhost
    const String emulatorUrl = "http://10.0.2.2:5000"; // Android Emulator
    const String iosSimulatorUrl = "http://localhost:5000"; // iOS Simulator
    const String physicalDeviceUrl =
        "http://192.168.1.100:5000"; // Change to your IPv4 address

    if (kIsWeb) {
      return webUrl; // Running on Web
    } else if (Platform.isAndroid) {
      return emulatorUrl; // Running on Android Emulator
    } else if (Platform.isIOS) {
      return iosSimulatorUrl; // Running on iOS Simulator
    } else {
      return physicalDeviceUrl; // Running on a Physical Device (change to your local network IP)
    }
  }
}

class Community {
  final String id; // ✅ Ensure this field exists
  final String name;
  final String description;

  Community({
    required this.id, // ✅ Add this field
    required this.name,
    required this.description,
  });

  // Convert JSON to Community object
  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'], // ✅ Ensure ID is parsed correctly
      name: json['name'],
      description: json['description'],
    );
  }

  // Convert Community object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ✅ Ensure ID is included
      'name': name,
      'description': description,
    };
  }
}

class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message(
      {required this.senderId, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
