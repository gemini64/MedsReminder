import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsreminder/components/dialogs.dart';
import 'package:medsreminder/models/medication.dart';
import 'package:medsreminder/models/reminder.dart';
import 'package:medsreminder/services/notification_helper.dart';
import 'package:medsreminder/appdata/application_data.dart';
import 'package:medsreminder/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:medsreminder/providers/medications_provider.dart';
import 'package:medsreminder/providers/reminders_provider.dart';

class MedicationsForm extends StatefulWidget {
  int? id;

  MedicationsForm({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  _MedicationsFormState createState() => _MedicationsFormState();
}

class _MedicationsFormState extends State<MedicationsForm> {
  // set defaults
  List<Reminder> _reminders = [];
  Medication _medication = Medication(
    name: "",
    sUnit: "mg",
    icon: 0,
    daily: 0,
    strength: 0,
  );

  late final _formsPageViewController = PageController();
  int _pageIndex = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<IconData> _leadingIcon = [
    Icons.close,
    Icons.arrow_back_ios,
  ];

  final List<String> _actionText = ["Next", "Submit"];
  final List<String> _titles = [
    "1/2: General info",
    "2/2: Daily reminders",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ('Add medication').toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .overline!
                    .copyWith(fontSize: 12.0, height: 1.8),
                textAlign: TextAlign.left,
              ),
              Text(_titles[_pageIndex]),
            ],
          ),
          leading: IconButton(
            icon: Icon(_leadingIcon[_pageIndex]),
            onPressed: () {
              if (_pageIndex == 0) {
                dismiss();
              } else {
                previuosFormStep();
              }
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (_pageIndex == _formKeys.length - 1) {
                    sendData();
                  } else {
                    nextFormStep();
                  }
                },
                child: Text(
                  _actionText[_pageIndex],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                )),
          ],
        ),
        body: GestureDetector(
          // defocus on outer-tap
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: PageView(
            controller: _formsPageViewController,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              // - - Form Step 1
              Form(
                key: _formKeys[0],
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                          ('What Medication are you taking?').toUpperCase(),
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
                    buildNameField(),
                    buildStrengthField(),
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                        ('(Optional) Pick an icon to help you identify your medication')
                            .toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .overline!
                            .copyWith(fontSize: 12.0, height: 1.6),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      indent: 18,
                    ),
                    buildIconField(),
                  ],
                ),
              ),

              // - - Form Step 2
              Form(
                key: _formKeys[1],
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: Text(
                          ('Setup Reminders for daily assumptions')
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
                    buildToggle(),
                    buildRemsList(),
                    buildAddButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        dismiss();
        return false;
      },
    );
  }

  void loadData() {
    if (widget.id != null) {
      _medication = Provider.of<MedicationsProvider>(context, listen: false)
          .selectById(widget.id!);
      _reminders = Provider.of<RemindersProvider>(context, listen: false)
          .selectByRef(widget.id!);
    }
  }

  void nextFormStep() {
    if (_formKeys[_pageIndex].currentState!.validate()) {
      _formKeys[_pageIndex].currentState!.save();

      _formsPageViewController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

      setState(() {
        _pageIndex++;
      });

      // defocus
      FocusScope.of(context).unfocus();
    }
  }

  void previuosFormStep() {
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );

    setState(() {
      _pageIndex--;
    });
  }

  void dismiss() {
    // dismiss focused field
    FocusScope.of(context).unfocus();
    // show exit confirm dialog
    Dialogs.exitDialog("Exit without saving?",
        "Are you sure you want to exit without saving?", context);
  }

  Future<void> sendData() async {
    if (_formKeys[_pageIndex].currentState!.validate()) {
      _formKeys[_pageIndex].currentState!.save();

      if (_reminders.isEmpty) {
        _medication.daily = 0;
      }

      // remove old data
      if (_medication.id != null) {
        Provider.of<RemindersProvider>(context, listen: false)
            .deleteByRef(_medication.id!);
      }

      // send medication
      int newId = await Provider.of<MedicationsProvider>(context, listen: false)
          .add(_medication);

      // set reference id
      if (_medication.daily == 1) {
        for (int i = 0; i < _reminders.length; i++) {
          _reminders[i].referenceId = newId;
        }
      } else {
        _reminders = [];
      }

      setReminder();

      for (Reminder reminder in _reminders) {
        Provider.of<RemindersProvider>(context, listen: false).add(reminder);
      }

      Navigator.pop(context);
    }
  }

  void setReminder() {
    for (int i = 0; i < _reminders.length; i++) {
      if (_reminders[i].notificationId == null) {
        // set a new id
        _reminders[i].notificationId = _reminders[i].hashCode;
      }

      // schedule notification
      NotificationHelper().scheduleNotificationsDaily(
          _reminders[i].notificationId!,
          "It's time for your medicine!",
          _medication.name +
              " • " +
              "Take ${_reminders[i].pills} at ${Utils.prettyTime(_reminders[i].time)}",
          Utils.timeToDate(_reminders[i].time!),
          jsonEncode(
              {"id": _reminders[i].notificationId, "type": "medication"}));
    }
  }

  // - - Form 1 - Fields

  // medication's icon
  Widget buildIconField() {
    return Row(
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(18, 18, 9, 18),
            child: Image(
              image: AssetImage(ApplicationData.pillsIcons[_medication.icon]!),
              width: 64.0,
            )),
        Expanded(
            flex: 1,
            child: Container(
              width: 80,
              padding: EdgeInsets.fromLTRB(9, 18, 18, 18),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                onPressed: pickIcon,
                child: const Text('OPEN ICONPICKER'),
              ),
            )),
      ],
    );
  }

  pickIcon() async {
    int? newValue = await Dialogs.showIconPicker(
        context: context, iconPack: ApplicationData.pillsIcons);
    print(newValue);
    if (newValue != null) {
      setState(() {
        _medication.icon = newValue;
      });
    }
  }

  // medication's name
  Widget buildNameField() {
    return Container(
        padding: EdgeInsets.all(18.0),
        child: TextFormField(
          autofocus: true,
          maxLength: 40,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0))),
            hintText: "This medication's name...",
            labelText: "Name*",
            helperText: "",
          ),
          initialValue: (_medication.name == "") ? null : _medication.name,
          onSaved: (String? value) {
            setState(() {
              _medication.name = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Medication's name is required";
            }
            return null;
          },
        ));
  }

  // strength and measurement unit
  Widget buildStrengthField() {
    return Row(
      children: [
        Expanded(
          child: Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: TextFormField(
                maxLength: 8,
                decoration: InputDecoration(
                  counterText: "",
                  icon: Icon(Icons.medication),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0))),
                  hintText: "",
                  labelText: "Strength (Optional)",
                ),
                initialValue: (_medication.strength == 0)
                    ? null
                    : _medication.strength.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onSaved: (String? value) {
                  if (value != null && value.isNotEmpty) {
                    setState(() {
                      _medication.strength = int.parse(value);
                    });
                  } else {
                    setState(() {
                      _medication.strength = 0;
                    });
                  }
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final n = num.tryParse(value);
                    if (n == null) {
                      return '"$value" is not a valid number';
                    }
                  }
                  return null;
                },
              )),
          flex: 3,
        ),
        // Unit DropDown
        Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 18, 18),
              child: DropdownButton<String>(
                value: _medication.sUnit,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                //style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _medication.sUnit = newValue!;
                  });
                },
                items: ApplicationData.medsUnits
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
      ],
    );
  }

  // - - Form 2 - Fields
  Widget buildToggle() {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 9.0, 9.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text("Assume daily",
                  style: Theme.of(context).textTheme.bodyText2),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Switch(
                value: (_medication.daily == 0 ? false : true),
                onChanged: (value) {
                  setState(() {
                    _medication.daily = (value ? 1 : 0);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddButton() {
    if (_medication.daily == 1) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)))),
          onPressed: () {
            setState(() {
              _reminders.add(pushReminder());
            });
          },
          child: const Text('Add a Reminder'),
        ),
      );
    }

    return SizedBox();
  }

  Widget buildRemsList() {
    if (_medication.daily == 1) {
      return ListView.builder(
        itemCount: _reminders.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _reminders.removeAt(i);
                  });
                },
                child: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  //padding: .fromLTRB(9.0, 9.0, 9.0, 9.0),
                  child: Icon(Icons.remove_circle,
                      color: Theme.of(context).errorColor),
                ),
              ),
              // time picker
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 9.0, 9.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      hintText: Utils.prettyTime(_reminders[i].time),
                      helperText: "",
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _reminders[i].time!,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );

                      if (pickedTime != null) {
                        setState(() {
                          _reminders[i].time = pickedTime;
                        });
                      }
                    },
                  ),
                ),
              ),
              // pills quantity
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.fromLTRB(9.0, 0.0, 18.0, 9.0),
                  child: TextFormField(
                    maxLength: 8,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.0))),
                      hintText: "How many pills...",
                      labelText: "Q.ty*",
                      counterText: "",
                      helperText: "",
                    ),
                    initialValue: _reminders[i].pills.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (String? value) {
                      setState(() {
                        _reminders[i].pills = int.parse(value!);
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "A number of pills is required";
                      }

                      final n = num.tryParse(value);
                      if (n == null) {
                        return "Not a valid number";
                      }

                      if (n < 1) {
                        return "Not a valid number";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return SizedBox();
  }

  Reminder pushReminder() {
    return Reminder(
      referenceId: 0,
      taken: 0,
      pills: 1,
      time: TimeOfDay(hour: 8, minute: 0),
    );
  }
}
