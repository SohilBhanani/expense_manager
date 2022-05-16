import 'package:flutter/material.dart';

class ExpandedSection extends StatefulWidget {
  final Widget? child;
  final bool expand;
  const ExpandedSection({this.expand = false, this.child});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with TickerProviderStateMixin {
  late AnimationController expandController;
  late AnimationController fadeController;
  late Animation<double> animation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animation = CurvedAnimation(
      // reverseCurve: Curves.ease,
      parent: expandController,
      curve: Curves.ease,
    );
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(fadeController);
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
      fadeController.forward();
    } else {
      fadeController.reverse();
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  Scaffold(
        //   appBar: AppBar(),
        //   body: Center(
        // child:
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: widget.child,
            ));
    // ),
    // );
  }
}
