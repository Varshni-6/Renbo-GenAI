import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hotline {
  final String name; // e.g. "KIRAN Mental Health Helpline"
  final String
      description; // e.g. "For mental health support, stress, anxiety, depression"
  final String contactPerson; // e.g. "Trained Mental Health Counselors"
  final String phone;

  Hotline({
    required this.name,
    required this.description,
    required this.contactPerson,
    required this.phone,
  });
}

class HotlinesScreen extends StatelessWidget {
  HotlinesScreen({super.key});

  final List<Hotline> hotlines = [
    // Hotline(
    //   name: "KIRAN Mental Health Helpline",
    //   description: "24/7 support for stress, anxiety, depression, suicidal thoughts.",
    //   contactPerson: "Trained Mental Health Counselors",
    //   phone: "18005990019",
    // ),
    // Hotline(
    //   name: "Vandrevala Foundation Helpline",
    //   description: "Support for emotional distress, depression, suicidal thoughts.",
    //   contactPerson: "Counselors at Vandrevala Foundation",
    //   phone: "18602662345",
    // ),
    Hotline(
      name: "Sammy",
      description:
          "Support for emotional distress, depression, suicidal thoughts.",
      contactPerson: "Counselors for every emotional distress",
      phone: "8939395353",
    ),
    // Hotline(
    //   name: "Snehi (Delhi-based NGO)",
    //   description: "Emotional support for suicide prevention & crisis intervention.",
    //   contactPerson: "Snehi Volunteer Counselors",
    //   phone: "9582208181",
    // ),
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mental Wellness Hotlines",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              title: Text(
                hotline.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotline.description),
                  const SizedBox(height: 4),
                  Text(
                    "Contact Person: ${hotline.contactPerson}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () => _makePhoneCall(hotline.phone),
              ),
            ),
          );
        },
      ),
    );
  }
}
