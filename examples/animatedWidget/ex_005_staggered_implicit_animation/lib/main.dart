import 'package:flutter/material.dart';
import 'package:animator/animator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: Scaffold(body: MyStatefulWidget()),
    );
  }
}

class MyImplicitStaggeredWidget extends StatelessWidget {
  const MyImplicitStaggeredWidget({Key? key}) : super(key: key);

  static const String _title = 'Implicit Staggered Animation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStaggeredWidgetState();
}

class _MyStaggeredWidgetState extends State<MyStatefulWidget> {
  bool selected = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Column(
        children: [
          Text('Using AnimateWidget'),
          SizedBox(height: 20),
          Expanded(
            child: AnimateWidget(
              duration: const Duration(milliseconds: 2000),
              builder: (context, animate) {
                final padding = animate
                    .setCurve(Interval(0.250, 0.375, curve: Curves.ease))
                    .call(
                      selected
                          ? const EdgeInsets.only(bottom: 16.0)
                          : const EdgeInsets.only(bottom: 75.0),
                    );
                final opacity = animate
                    .setCurve(Interval(0.0, 0.100, curve: Curves.ease))
                    .call(
                      selected ? 0.5 : 1.0,
                    )!;
                final containerWidget = animate
                    .setCurve(Interval(0.125, 0.250, curve: Curves.ease))
                    .call(selected ? 50.0 : 150.0, 'containerWidget')!;
                final containerHeight = animate
                    .setCurve(Interval(0.250, 0.375, curve: Curves.ease))
                    .call(selected ? 50.0 : 150.0, 'containerHeight')!;
                final color = animate
                    .setCurve(Interval(0.500, 0.750, curve: Curves.ease))
                    .call(
                      selected ? Colors.indigo[100] : Colors.orange[400],
                    );
                final borderRadius = animate
                    .setCurve(Interval(0.375, 0.500, curve: Curves.ease))
                    .call(
                      selected
                          ? BorderRadius.circular(4.0)
                          : BorderRadius.circular(75.0),
                    );
                return Center(
                  child: Container(
                    width: 300.0,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    child: Container(
                      padding: padding,
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: containerWidget,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: Colors.indigo[300]!,
                              width: 3.0,
                            ),
                            borderRadius: borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Flutter's staggered Animation

class FlutterStaggerDemo extends StatefulWidget {
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<FlutterStaggerDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void didUpdateWidget(covariant FlutterStaggerDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          border: Border.all(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        child: StaggerAnimation(controller: _controller.view),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key? key, required this.controller})
      :

        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.

        opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16.0),
          end: const EdgeInsets.only(bottom: 75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.500,
              0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300]!,
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
