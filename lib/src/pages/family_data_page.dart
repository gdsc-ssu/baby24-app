import 'package:flutter/material.dart';

class FamilyDataPage extends StatefulWidget {
  const FamilyDataPage({Key? key}) : super(key: key);

  @override
  State<FamilyDataPage> createState() => _FamilyDataPageState();
}

class _FamilyDataPageState extends State<FamilyDataPage> {
  final List<Map<String, dynamic>> familyMembers = [
    {
      'name': 'Sarah Norman',
      'contact': '010-1234-5678',
      'role': 'Parent',
      'characteristics': 'Hearing impairment',
      'expanded': false,
    },
    {
      'name': 'James Leeds',
      'contact': '010-2345-6789',
      'role': 'Parent',
      'characteristics': '',
      'expanded': false,
    },
    {
      'name': 'Bebe',
      'contact': '',
      'role': 'Baby',
      'characteristics': '',
      'expanded': false,
    },
  ];

  final List<String> roles = ['Caregiver', 'Parent', 'Baby'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Family Data'),
        leading: BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 36,
              child: Image.asset(
                'assets/icons/family.png',
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Family Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...familyMembers.asMap().entries.map((entry) {
              int idx = entry.key;
              var member = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ExpansionTile(
                    initiallyExpanded: member['expanded'] == true,
                    title: Text(
                      member['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w500)),
                            TextFormField(
                              initialValue: member['name'],
                              onChanged: (val) => setState(() => familyMembers[idx]['name'] = val),
                            ),
                            const SizedBox(height: 12),
                            const Text('Contact', style: TextStyle(fontWeight: FontWeight.w500)),
                            TextFormField(
                              initialValue: member['contact'],
                              onChanged: (val) => setState(() => familyMembers[idx]['contact'] = val),
                            ),
                            const SizedBox(height: 12),
                            const Text('Role', style: TextStyle(fontWeight: FontWeight.w500)),
                            DropdownButton<String>(
                              value: member['role'],
                              isExpanded: true,
                              items: roles.map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              )).toList(),
                              onChanged: (val) => setState(() => familyMembers[idx]['role'] = val),
                            ),
                            const SizedBox(height: 12),
                            const Text('Characteristics', style: TextStyle(fontWeight: FontWeight.w500)),
                            TextFormField(
                              initialValue: member['characteristics'],
                              onChanged: (val) => setState(() => familyMembers[idx]['characteristics'] = val),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
} 