import 'package:flutter/material.dart';

class PayWall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Paywall Popup'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showFullScreenPaywall(context),
          child: Text('Open Paywall'),
        ),
      ),
    );
  }

  void _showFullScreenPaywall(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing when tapping outside
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.all(0), // Full screen dialog
          child: FullScreenPaywall(),
        );
      },
    );
  }
}

class FullScreenPaywall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paywall'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Exclusive Content',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Unlock premium features and content by subscribing.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Subscribe Now'),
              onPressed: () {
                // Handle subscription logic here
              },
            ),
          ],
        ),
      ),
    );
  }
}
