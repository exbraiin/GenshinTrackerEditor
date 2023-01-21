import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/screens/info_screen.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// TODO: LIST
// * Filter dialog or/and search?
// * Add icons to food types.

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
        scrollbars: false,
        physics: const BouncingScrollPhysics(),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.pushWidget(() => const InfoScreen()),
          ),
          const SizedBox(width: 8),
          StreamBuilder(
            initialData: Database.i.saving.value,
            stream: Database.i.saving,
            builder: (context, snapshot) {
              if (snapshot.data!) return const CircularProgressIndicator();
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => Database.i.save(),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Database.i.load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString());
          if (!snapshot.hasData) return const Text('Loading...');

          return StreamBuilder(
            stream: Database.i.modified,
            initialData: Database.i.modified,
            builder: (context, snapshot) {
              return GsGridView(
                children: GsConfigs.getAllConfigs()
                    .map((e) => e.toGridItem(context))
                    .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
