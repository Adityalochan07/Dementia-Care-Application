import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class reminder extends StatelessWidget {
  get debugShowCheckedModeBanner => null;

  @override
  Widget build(BuildContext context) {
    void openCalendarApp() async {
      final String urlScheme =
          Platform.isIOS ? 'calshow:' : 'content://com.android.calendar/time/';
      final url = Uri.parse(urlScheme);
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'Could not launch $url';
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Tap on + to add reminder'),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () {
              openCalendarApp();
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.orange,
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class ExampleWidget extends StatefulWidget {
//   @override
//   _ExampleWidgetState createState() => _ExampleWidgetState();
// }

// class _ExampleWidgetState extends State<ExampleWidget>
//     with TickerProviderStateMixin {
//   AnimationController _animationController;
//   Animation<double> _animation;
//   bool _isOpen = false;

//   @override
//   void initState() {
//     super.initState();
//     _animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     _animation = CurvedAnimation(
//         parent: _animationController, curve: Curves.easeInOutCirc);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: AnimatedOpacity(
//               duration: Duration(milliseconds: 500),
//               opacity: _isOpen ? 0.0 : 1.0,
//               child: FloatingActionButton(
//                 onPressed: _toggle,
//                 child: Icon(Icons.add),
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 500),
//             bottom: _isOpen ? 100 : 16,
//             right: 16,
//             child: Transform.rotate(
//               angle: _isOpen ? _animation.value * 0.75 * 2 * 3.14 : 0.0,
//               child: FloatingActionButton(
//                 onPressed: () {},
//                 child: Icon(Icons.camera),
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 500),
//             bottom: _isOpen ? 170 : 16,
//             right: _isOpen ? 100 : 16,
//             child: Transform.rotate(
//               angle: _isOpen ? _animation.value * 0.75 * 2 * 3.14 : 0.0,
//               child: FloatingActionButton(
//                 onPressed: () {},
//                 child: Icon(Icons.photo),
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 500),
//             bottom: _isOpen ? 100 : 16,
//             right: _isOpen ? 170 : 16,
//             child: Transform.rotate(
//               angle: _isOpen ? _animation.value * 0.75 * 2 * 3.14 : 0.0,
//               child: FloatingActionButton(
//                 onPressed: () {},
//                 child: Icon(Icons.videocam),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _toggle() {
//     if (_isOpen) {
//       _animationController.reverse();
//     } else {
//       _animationController.forward();
//     }
//     setState(() {
//       _isOpen = !_isOpen;
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
// }

