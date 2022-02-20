import 'package:flutter/material.dart';
import 'package:medsreminder/components/medication_widget.dart';
import 'package:medsreminder/components/placeholder_widgets.dart';
import 'package:medsreminder/providers/medications_provider.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:provider/provider.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationsProvider>(
        builder: (context, medsProvider, child) {
      List<Medication> daily = medsProvider.byType('daily');
      List<Medication> asneeded = medsProvider.byType('asneeded');

      return ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
            alignment: Alignment.centerLeft,
            child: Text(
              'MY MEDICATIONS',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 9, 0, 18),
            alignment: Alignment.centerLeft,
            child: Text(
              'Assume Daily',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          // - - - - - -
          ListView.builder(
            itemCount: daily.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return MedicationWidget(medication: daily[i]);
            },
          ),
          (daily.isEmpty)
              ? PlaceholderWidgets.medicationsPlaceholder(context)
              : SizedBox(),
          SizedBox(
            height: 25.0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 18, 0, 4),
            alignment: Alignment.centerLeft,
            child: Text(
              'MY MEDICATIONS',
              style: Theme.of(context).textTheme.overline,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(18, 9, 0, 18),
            alignment: Alignment.centerLeft,
            child: Text(
              'As Needed',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            indent: 18,
          ),
          // - - - - - -
          ListView.builder(
            itemCount: asneeded.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return MedicationWidget(medication: asneeded[i]);
            },
          ),
          (asneeded.isEmpty)
              ? PlaceholderWidgets.medicationsPlaceholder(context)
              : SizedBox(),
        ],
      );
    });
  }
}
