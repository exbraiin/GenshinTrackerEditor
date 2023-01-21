import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/style/style.dart';
import 'package:flutter/material.dart';

class GsGridView extends StatelessWidget {
  final List<Widget> children;

  const GsGridView({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
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
      child: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          maxCrossAxisExtent: 120,
        ),
        children: children,
      ),
    );
  }
}

class GsGridItem extends StatelessWidget {
  final Color color;
  final String label;
  final GsValidLevel validLevel;
  final String version;
  final VoidCallback? onTap;

  const GsGridItem({
    super.key,
    this.onTap,
    this.version = '',
    this.validLevel = GsValidLevel.none,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.lerp(Colors.white, color, 0.6),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        _getBanner(),
        _getInvalidBanner(),
      ],
    );
  }

  Widget _getInvalidBanner() {
    if (validLevel == GsValidLevel.error) {
      return Positioned.fill(
        child: ClipRect(
          child: Transform.translate(
            offset: const Offset(5, -5),
            child: const Banner(
              message: 'Invalid',
              location: BannerLocation.topEnd,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    if (validLevel == GsValidLevel.warn2) {
      return Positioned.fill(
        child: ClipRect(
          child: Transform.translate(
            offset: const Offset(5, -5),
            child: const Banner(
              message: 'Missing',
              location: BannerLocation.topEnd,
              color: Colors.orange,
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _getBanner() {
    if (version.isEmpty) return const SizedBox();
    if (Database.i.getNewByVersion(version)) {
      return const Positioned.fill(
        child: ClipRect(
          child: Banner(
            location: BannerLocation.topEnd,
            message: 'New',
            color: Colors.green,
          ),
        ),
      );
    }
    if (Database.i.getUpcomingByVersion(version)) {
      return const Positioned.fill(
        child: ClipRect(
          child: Banner(
            location: BannerLocation.topEnd,
            message: 'Upcoming',
            color: Colors.orange,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
