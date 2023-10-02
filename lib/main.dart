import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/exporter.dart';
import 'package:data_editor/screens/info_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Editor',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
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
          const Tooltip(
            message: 'Export as CSV',
            child: IconButton(
              icon: Icon(Icons.download_rounded),
              onPressed: GsExporter.exportAll,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.pushWidget(const InfoScreen()),
          ),
          const SizedBox(width: 8),
          StreamBuilder(
            initialData: Database.i.saving.value,
            stream: Database.i.saving,
            builder: (context, snapshot) {
              return IconButton(
                icon: snapshot.data!
                    ? const AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                onPressed: snapshot.data! ? null : Database.i.save,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Database.i.load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.multiply,
                  ),
                  image: const AssetImage(GsGraphics.bgImg),
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            );
          }

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
