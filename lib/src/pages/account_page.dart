import 'package:flutter/material.dart'; 
import 'family_data_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 32),
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/icons/avatar.png'), 
          ),
          const SizedBox(height: 12),
          const Text(
            'Sarah',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('My Account'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Family Data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyDataPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_in_talk_outlined),
            title: const Text('Emergency Contact'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
} 