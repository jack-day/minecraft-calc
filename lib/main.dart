import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'minecraft-calc-app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalculatorState(),
      child: MinecraftCalculatorApp(),
    ),
  );
}
