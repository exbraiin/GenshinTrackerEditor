import 'package:data_editor/configs.dart';
import 'package:data_editor/db/database.dart';
import 'package:data_editor/importer.dart';
import 'package:data_editor/screens/info_screen.dart';
import 'package:data_editor/style/style.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/gs_grid_view.dart';
import 'package:data_editor/widgets/text_style_parser.dart';
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF222222),
          surfaceTintColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
        ),
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
          _BusyWidget(
            message: 'Import Achievements from Paimon.moe',
            icon: Icons.download_rounded,
            onPressed: () => _onImportAchievements(context),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => context.pushWidget(const InfoScreen()),
          ),
          const SizedBox(width: 8),
          _BusyWidget(
            message: 'Save',
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

          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              decoration: GsStyle.kMainDecoration,
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

  Future<void> _onImportAchievements(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    try {
      final c = await Importer.importAchievementsFromPaimonMoe();
      if (c == null) return;

      messenger.showSnackBar(
        SnackBar(
          content: TextParserWidget(
            'Groups: ('
            '<color=pyro>${c.grpRmv}</color> | '
            '<color=geo>${c.grpMdf}</color> | '
            '<color=dendro>${c.grpAdd}</color>)\n'
            'Achievements: ('
            '<color=pyro>${c.achRmv}</color> | '
            '<color=geo>${c.achMdf}</color> | '
            '<color=dendro>${c.achAdd}</color>)',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: bgColor,
        ),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text(
            'Could not import!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: bgColor,
        ),
      );
    }
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
