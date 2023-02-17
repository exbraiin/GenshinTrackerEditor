import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/datafield.dart';
import 'package:data_editor/widgets/mouse_button.dart';
import 'package:flutter/material.dart';

class GsGridItem extends StatelessWidget {
  final Color color;
  final String label;
  final String version;
  final Widget? child;
  final GsValidLevel validLevel;
  final VoidCallback? onTap;

  const GsGridItem({
    super.key,
    this.onTap,
    this.child,
    this.version = '',
    this.validLevel = GsValidLevel.none,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return MouseButton(
      onTap: onTap,
      builder: (context, hover, child) {
        final scale = hover ? 1.05 : 1.0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          transform: Matrix4.diagonal3Values(scale, scale, 1),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(hover ? 1 : 0.6),
            border: Border.all(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: hover
                ? const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    )
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.black26,
                      )
                    ],
                  ),
                ),
              ),
            ),
            _getBanner(),
            _getInvalidBanner(),
          ],
        ),
      ),
    );
  }

  Widget _getInvalidBanner() {
    const offset = Offset(2, -2);
    if (validLevel == GsValidLevel.error) {
      return Positioned.fill(
        child: ClipRect(
          child: Transform.translate(
            offset: offset,
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
            offset: offset,
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
            color: Colors.lightBlue,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
