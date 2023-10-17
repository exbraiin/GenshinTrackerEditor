import 'package:dartx/dartx.dart';
import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/exporter.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/screens/info_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_view.dart';
import 'package:data_editor/widgets/text_style_parser.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
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
    return DropTarget(
      onDragDone: (details) async {
        final file = details.files.firstOrNull;
        if (file == null) return;
        final messenger = ScaffoldMessenger.of(context);
        final bgColor = Theme.of(context).scaffoldBackgroundColor;
        try {
          final c = await Importer.importAchievementsFromAmbrJson(file.path);
          if (c == null) return;

          messenger.showSnackBar(
            SnackBar(
              content: TextParserWidget(
                'Groups: (<color=pyro>${c.$2.removed}</color> | <color=geo>${c.$2.modified}</color> | <color=dendro>${c.$2.added}</color>)\n'
                'Achievements: (<color=pyro>${c.$1.removed}</color> | <color=geo>${c.$1.modified}</color> | <color=dendro>${c.$1.added}</color>)',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: bgColor,
            ),
          );
        } catch (error) {
          messenger.showSnackBar(
            SnackBar(
              content: const Text(
                'Could not import!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: bgColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Data Editor'),
          actions: [
            const _BusyWidget(
              message: 'Export as CSV',
              icon: Icons.upload_rounded,
              onPressed: GsExporter.exportAll,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.info_outline_rounded),
              onPressed: () => context.pushWidget(const InfoScreen()),
            ),
            const SizedBox(width: 8),
            _BusyWidget(
              icon: Icons.save_rounded,
              onPressed: Database.i.save,
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
      ),
    );
  }
}

class _BusyWidget extends StatefulWidget {
  final IconData icon;
  final String? message;
  final AsyncCallback onPressed;

  const _BusyWidget({
    this.message,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_BusyWidget> createState() => _BusyWidgetState();
}

class _BusyWidgetState extends State<_BusyWidget> {
  final notifier = ValueNotifier(false);

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        if (value) {
          return const Center(
            child: IconButton(
              icon: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
              onPressed: null,
            ),
          );
        }

        final button = IconButton(
          icon: Icon(widget.icon),
          onPressed: () async {
            notifier.value = true;
            await widget.onPressed();
            if (!mounted) return;
            notifier.value = false;
          },
        );

        if (widget.message != null) {
          return Tooltip(
            message: widget.message,
            child: button,
          );
        }

        return button;
      },
    );
  }
}
