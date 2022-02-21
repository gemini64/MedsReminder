import 'package:flutter/material.dart';

class PlaceholderWidgets {
  static Widget appointmentPlaceholder(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No appointments to show",
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Set one with the + button",
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }

  static Widget medicationsPlaceholder(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No prescription to show",
                style: Theme.of(context).textTheme.bodyText1),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Add one with the + button",
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    );
  }
}
