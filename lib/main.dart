import 'package:fb/firebase/read_listview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MaterialApp(
    home: ReadListview(),
    debugShowCheckedModeBanner: false,
  ));
}
