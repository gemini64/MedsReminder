import 'package:flutter/material.dart';
import 'package:medsreminder/providers/preferences_provider.dart';
import 'package:medsreminder/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(physics: NeverScrollableScrollPhysics(), children: [
      Container(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                            ('General')
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(fontSize: 12.0, height: 1.6)),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 18,
                      ),
      // settings button
      InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
          child: Column(children: [
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(18.0),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.settings,
                    size: 30.0,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Settings",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(9.0),
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_forward_ios),
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
              ],
            ),
            const Divider(height: 1, thickness: 1, indent: 66.0),
          ])),
    ]);
  }
}
