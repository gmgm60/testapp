import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<File> files = [];
  final List<Uint8List> webFiles = [];

  void _selectFiles() async {
    final result = await FilePicker.platform.pickFiles();

    if (kIsWeb) {
      final List<Uint8List>? files =
          result?.files.map((file) => file.bytes!).toList();
      if (files != null) {
        setState(() {
          webFiles.addAll(files);
        });
      }
    } else {
      final List<File>? files =
          result?.paths.whereType<String>().map((path) => File(path)).toList();

      if (files != null) {
        setState(() {
          this.files.addAll(files);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            if(kIsWeb)
            Text(
              '${webFiles.isNotEmpty ? (webFiles.last.lengthInBytes / 1024).toStringAsFixed(2) : "0"} Kb',
              style: Theme.of(context).textTheme.headline4,
            )
            else
            Text(
              '${files.isNotEmpty ? (files.last.lengthSync() / 1024).toStringAsFixed(2) : "0"} Kb',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectFiles,
        tooltip: 'pick',
        child: const Icon(Icons.file_open_outlined),
      ),
    );
  }
}
