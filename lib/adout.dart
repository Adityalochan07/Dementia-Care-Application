import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final startLocationController = TextEditingController();
  final destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Google Maps'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: startLocationController,
              decoration: InputDecoration(
                labelText: 'Start Location',
              ),
            ),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final startLocation = startLocationController.text;
                final destination = destinationController.text;
                final url =
                    'https://www.google.com/maps/dir/?api=1&origin=$startLocation&destination=$destination&travelmode=driving';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              
              child: Text('Open Google Maps'),
               style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
  ),
            ),
          ],
        ),
      ),
    );
  }
}
