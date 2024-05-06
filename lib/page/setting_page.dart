import 'package:flutter/material.dart';
import 'package:wallink_v1/database/app_preferences.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    super.key,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _alwaysExpanded = false;
  bool _alwaysAskConfirmation = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    bool alwaysExpanded = await AppPreferences.isExpanded();
    bool alwaysAskConfirmation = await AppPreferences.isAlwaysAsk();

    setState(() {
      _alwaysAskConfirmation = alwaysAskConfirmation;
      _alwaysExpanded = alwaysExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Configure Behavior :',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              // switch untuk always Expanded
              SwitchListTile(
                title: const Text('Always Expand Tile'),
                inactiveTrackColor: const Color.fromRGBO(238, 238, 238, 1.0),
                activeColor: const Color.fromRGBO(0, 173, 181, 1.0),
                inactiveThumbColor: const Color.fromRGBO(57, 62, 70, 1.0),
                value: _alwaysExpanded,
                onChanged: (value) async {
                  await AppPreferences.setExpanded(value);
                  setState(() {
                    _alwaysExpanded = value;
                  });

                  print("set ke ${await AppPreferences.isExpanded()}");
                },
              ),

              SwitchListTile(
                title: const Text('Always Ask Delete Confirmation'),
                inactiveTrackColor: const Color.fromRGBO(238, 238, 238, 1.0),
                activeColor: const Color.fromRGBO(0, 173, 181, 1.0),
                inactiveThumbColor: const Color.fromRGBO(57, 62, 70, 1.0),
                value: _alwaysAskConfirmation,
                onChanged: (value) async {
                  await AppPreferences.setAlwaysAsk(value);
                  setState(() {
                    _alwaysAskConfirmation = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
