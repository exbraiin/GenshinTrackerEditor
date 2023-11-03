import 'package:data_editor/db/database.dart';
import 'package:data_editor/db_ext/data_validator.dart';
import 'package:data_editor/style/utils.dart';
import 'package:data_editor/widgets/auto_size_text.dart';
import 'package:data_editor/widgets/mouse_button.dart';
import 'package:flutter/material.dart';

class GsGridItem extends StatelessWidget {
  final Color color;
  final Color? circleColor;
  final String label;
  final String image;
  final String version;
  final Widget? child;
  final GsValidLevel validLevel;
  final VoidCallback? onTap;

  const GsGridItem({
    super.key,
    this.onTap,
    this.child,
    this.circleColor,
    this.image = '',
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
            color: color.withOpacity(hover ? 1 : 0.8),
            border: Border.all(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: hover
                ? const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black54,
                      offset: Offset(2, 2),
                    ),
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
            if (image.isNotEmpty)
              Positioned(
                right: 2,
                bottom: 2,
                child: Image.network(
                  image.toFandom(46),
                  width: 46,
                  height: 46,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, obj, stc) =>
                      const Icon(Icons.info_outline_rounded, size: 32),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (circleColor != null)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Color.lerp(circleColor, Colors.white, 0.4)!,
                        Color.lerp(circleColor, Colors.black, 0.4)!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            if (child != null) child!,
            _getStateBanner(),
            _getInvalidBanner(),
          ],
        ),
      ),
    );
  }

  Widget _getInvalidBanner() {
    const offset = Offset(2, -2);
    if (validLevel.isErrorOrWarn2) {
      return Positioned.fill(
        child: ClipRect(
          child: Transform.translate(
            offset: offset,
            child: Banner(
              message: validLevel.label ?? '',
              location: BannerLocation.topEnd,
              color: validLevel.color ?? Colors.transparent,
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _getStateBanner() {
    if (version.isEmpty) return const SizedBox();
    final state = Database.i.getItemStateByVersion(version);
    if (state == ItemState.none) return const SizedBox();
    return Positioned.fill(
      child: ClipRect(
        child: Banner(
          location: BannerLocation.topEnd,
          message: state.label ?? '',
          color: state.color ?? Colors.transparent,
        ),
      ),
    );
  }
}
