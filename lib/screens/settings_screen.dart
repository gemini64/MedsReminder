import 'package:flutter/material.dart';
import 'package:medsreminder/providers/preferences_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _theme;

  @override
  void initState() {
    super.initState();

    _theme = Provider.of<PreferencesProvicer>(context, listen: false).theme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Settings",
          textAlign: TextAlign.center,
        ),
        // return to previus screen
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      // Options
      body: Consumer<PreferencesProvicer>(
        builder: (context, preferences, child) {
          return ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(18.0, 9.0, 9.0, 9.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("Dark theme",
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: (_theme == "dark"),
                          onChanged: (value) {
                            preferences.switchTheme();
                            setState(() {
                              _theme = (_theme == "dark") ? "light" : "dark";
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
