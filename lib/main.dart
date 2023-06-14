import 'package:ecommerce_ai/controller/event.dart';
import 'package:ecommerce_ai/data/csv_db.dart';
import 'package:ecommerce_ai/screens/details.dart';
import 'package:ecommerce_ai/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize flutter
  WidgetsFlutterBinding.ensureInitialized();
  // initialize csv database
  await CsvDatabase.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
