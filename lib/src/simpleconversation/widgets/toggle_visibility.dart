import 'package:flutter/cupertino.dart';

class ToggleVisibility extends StatelessWidget {
  ToggleVisibility({required this.isVisible, required this.child, this.animated = true});

  final bool isVisible;
  final Widget child;
  bool animated;

  @override
  Widget build(BuildContext context) {
    if (animated) {
      return AnimatedOpacity(opacity: isVisible ? 1 : 0, duration: const Duration(milliseconds: 500), child: child);
    } else {
      return isVisible ? child : const SizedBox.shrink();
    }
  }
}
