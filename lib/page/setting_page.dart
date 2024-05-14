import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/dialog/setting_confirmation.dart';

class SettingPage extends StatefulWidget {
  final Function onChangedPreference;
  const SettingPage({
    super.key,
    required this.onChangedPreference,
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
    bool alwaysAskConfirmation = await AppPreferences.getAlwaysAsk();

    setState(() {
      _alwaysAskConfirmation = alwaysAskConfirmation;
      _alwaysExpanded = alwaysExpanded;
    });
  }

  Future<void> _savePreferences() async {
    await AppPreferences.setExpanded(_alwaysExpanded);
    await AppPreferences.setAlwaysAsk(_alwaysAskConfirmation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color.fromRGBO(5, 105, 220, 1),
            fontWeight: FontWeight.bold,
            fontFamily: 'sharp',
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(201, 226, 255, 1),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            size: 30,
            color: Color.fromRGBO(5, 105, 220, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 12),
              child: const Text(
                'Configure Behavior :',
                style: TextStyle(
                  fontFamily: 'sharp',
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            // switch untuk always Expanded
            SwitchListTile(
              title: const Text(
                'Always Expand Tile',
                style: TextStyle(
                  fontFamily: 'sharp',
                  fontSize: 14,
                ),
              ),
              activeColor: const Color.fromRGBO(5, 105, 220, 1),
              activeTrackColor: const Color.fromRGBO(201, 226, 255, 1),
              inactiveTrackColor: const Color.fromRGBO(201, 226, 255, 1),
              inactiveThumbColor: const Color.fromARGB(255, 229, 72, 77),
              value: _alwaysExpanded,
              onChanged: (value) async {
                setState(() {
                  _alwaysExpanded = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text(
                'Always Ask Delete Confirmation',
                style: TextStyle(fontFamily: 'sharp', fontSize: 14,),
              ),
              activeColor: const Color.fromRGBO(5, 105, 220, 1),
              activeTrackColor: const Color.fromRGBO(201, 226, 255, 1),
              inactiveTrackColor: const Color.fromRGBO(201, 226, 255, 1),
              inactiveThumbColor: const Color.fromARGB(255, 229, 72, 77),
              value: _alwaysAskConfirmation,
              onChanged: (value) async {
                setState(() {
                  _alwaysAskConfirmation = value;
                });
              },
            ),

            const Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SettingConfirmationDialog(
                        title: 'Warning!',
                        message:
                            'Are you sure you want save this setting? This action will restart the app',
                        saveSettings: _savePreferences,
                      ),
                    );
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'sharp',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Color.fromRGBO(201, 226, 255, 1),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
