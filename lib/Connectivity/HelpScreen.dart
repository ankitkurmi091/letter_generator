import 'package:flutter/material.dart';
import 'package:letter_generator/Connectivity/DevHelp.dart';
import 'package:letter_generator/Screens/FirstInputScreen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DevHelp helpObj = DevHelp();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Letter Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Connect with Developer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String message = controller.text;

                  if (message.isEmpty) {
                    // Show a snackbar or alert if the message is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a message')),
                    );
                    return;
                  }

                  // Send the message
                  helpObj.sendMessageToTelegram(message);

                  // Navigate back to the previous screen or show a confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent successfully!')),
                  );

                  Navigator.push(context, MaterialPageRoute(builder: (context) => FirstInputScreen()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Color(0xFF0096AF),
              ),
                child: const Text('Send Message',
                    style: TextStyle(color: Colors.white,fontSize: 15))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
