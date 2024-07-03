import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/add_or_edit_note_controller.dart';
import '../../../../localization/local.dart';
import '../../../../models/schedule.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key});

  @override
  _ScheduleFormState createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  RepeatOption _repeatOption = RepeatOption.never;
  CustomInterval? _customInterval;
  int? _customIntervalValue;
  List<WeekDay>? _customWeekDays;
  List<int>? _customDates;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateTime(BuildContext context,
      {required bool isStartDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(isStartDate
            ? (_startDate ?? DateTime.now())
            : (_endDate ?? DateTime.now())),
      );

      if (pickedTime != null) {
        final pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStartDate) {
            _startDate = pickedDateTime;
          } else {
            _endDate = pickedDateTime;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.nameApp.tr)), // Localized app name
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildRepeatOptionDropdown(),
              if (_repeatOption == RepeatOption.custom) _buildCustomOptions(),
              _buildDateButton(context,
                  isStartDate: true, label: L10n.startDate.tr),
              _buildDateButton(context,
                  isStartDate: false, label: L10n.endDate.tr),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatOptionDropdown() {
    return DropdownButtonFormField<RepeatOption>(
      decoration: InputDecoration(labelText: L10n.repeatOption.tr),
      value: _repeatOption,
      onChanged: (value) {
        setState(() {
          _repeatOption = value!;
          _resetCustomOptions();
        });
      },
      items: RepeatOption.values.map((RepeatOption type) {
        return DropdownMenuItem<RepeatOption>(
          value: type,
          child: Text(type.name.tr),
        );
      }).toList(),
    );
  }

  void _resetCustomOptions() {
    _customInterval = null;
    _customIntervalValue = null;
    _customWeekDays = null;
    _customDates = null;
  }

  Widget _buildCustomOptions() {
    return Column(
      children: [
        _buildCustomIntervalDropdown(),
        _buildCustomIntervalValueField(),
        if (_customInterval == CustomInterval.week) _buildWeekDaysSelection(),
        if (_customInterval == CustomInterval.monthDate)
          _buildCustomDatesField(),
      ],
    );
  }

  Widget _buildCustomIntervalDropdown() {
    return DropdownButtonFormField<CustomInterval>(
      decoration: InputDecoration(labelText: L10n.customInterval.tr),
      value: _customInterval,
      onChanged: (value) {
        setState(() {
          _customInterval = value;
        });
      },
      items: CustomInterval.values.map((CustomInterval interval) {
        return DropdownMenuItem<CustomInterval>(
          value: interval,
          child: Text(interval.name.tr),
        );
      }).toList(),
    );
  }

  Widget _buildCustomIntervalValueField() {
    return TextFormField(
      decoration: InputDecoration(labelText: L10n.intervalValue.tr),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        _customIntervalValue = int.tryParse(value ?? '');
      },
    );
  }

  Widget _buildWeekDaysSelection() {
    return Wrap(
      children: WeekDay.values.map((weekDay) {
        return CheckboxListTile(
          title: Text(weekDay.name.tr),
          value: _customWeekDays?.contains(weekDay) ?? false,
          onChanged: (isChecked) {
            setState(() {
              _updateCustomWeekDays(weekDay, isChecked!);
            });
          },
        );
      }).toList(),
    );
  }

  void _updateCustomWeekDays(WeekDay weekDay, bool isChecked) {
    if (isChecked) {
      _customWeekDays ??= [];
      _customWeekDays!.add(weekDay);
    } else {
      _customWeekDays?.remove(weekDay);
    }
  }

  Widget _buildCustomDatesField() {
    return TextFormField(
      decoration: InputDecoration(labelText: L10n.customDates.tr),
      onSaved: (value) {
        _customDates =
            value?.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList();
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveSchedule,
      child: Text(L10n.saveSchedule.tr),
    );
  }

  AddOrEditNoteController controller = Get.find();

  void _saveSchedule() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      Schedule schedule;
      if (_repeatOption == RepeatOption.custom) {
        schedule = Schedule.custom(
          interval: _customInterval!,
          intervalValue: _customIntervalValue!,
          weekDays: _customWeekDays,
          dates: _customDates,
          start: _startDate,
          end: _endDate,
        );
      } else {
        schedule = Schedule(
          repeatOption: _repeatOption,
          startDate: _startDate,
          endDate: _endDate,
        );
      }
      controller.schedule = schedule;
      controller.currentNote != null
          ? controller.currentNote!.repeatInterval = schedule
          : null;
      ;
      print('this is the schedule ${controller.schedule!.startDate}');

      controller.update();
      Get.back();
    }
  }

  Widget _buildDateButton(BuildContext context,
      {required bool isStartDate, required String label}) {
    return ElevatedButton(
      onPressed: () => _selectDateTime(context, isStartDate: isStartDate),
      child: Text(label.tr),
    );
  }
}

class RepeatNoteScreen extends StatefulWidget {
  @override
  _RepeatNoteScreenState createState() => _RepeatNoteScreenState();
}

class _RepeatNoteScreenState extends State<RepeatNoteScreen> {
  RepeatOption _selectedOption = RepeatOption.never;
  CustomInterval? _customInterval;
  List<WeekDay> _customWeekDays = [];
  List<int> _customDates = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    String languageCode = Get.locale?.languageCode ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.repeatOptions.tr),
      ),
      body: Column(
        children: [
          _buildRadioOption(
              title: L10n.repeatNever.tr,
              value: RepeatOption.never,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatDaily.tr,
              value: RepeatOption.daily,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatWeekly.tr,
              value: RepeatOption.weekly,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatMonthlyByDay.tr,
              value: RepeatOption.monthlyByDay,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatMonthlyByDate.tr,
              value: RepeatOption.monthlyByDate,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatYearly.tr,
              value: RepeatOption.yearly,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          _buildRadioOption(
              title: L10n.repeatCustom.tr,
              value: RepeatOption.custom,
              groupValue: _selectedOption,
              onChanged: _onOptionChanged),
          if (_selectedOption == RepeatOption.custom) ...[
            _buildCustomIntervalField(),
            Text(L10n.selectWeekdays.tr),
            _buildWeekDaysSelection(languageCode),
            _buildCustomDatesField(),
          ],
          ElevatedButton(
            onPressed: _saveSchedule,
            child: Text(L10n.save.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required RepeatOption value,
    required RepeatOption groupValue,
    required void Function(RepeatOption?) onChanged,
  }) {
    return ListTile(
      title: Text(title.tr),
      leading: Radio<RepeatOption>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }

  void _onOptionChanged(RepeatOption? value) {
    setState(() {
      _selectedOption = value!;
    });
  }

  Widget _buildCustomIntervalField() {
    return TextField(
      decoration: InputDecoration(labelText: L10n.customInterval.tr),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          var interval = int.tryParse(value);
          if (interval == 0) {
            _customInterval = CustomInterval.day;
          } else if (interval == 1) {
            _customInterval = CustomInterval.week;
          } else if (interval == 2) {
            _customInterval = CustomInterval.monthDate;
          } else if (interval == 3) {
            _customInterval = CustomInterval.monthDay;
          } else if (interval == 4) {
            _customInterval = CustomInterval.year;
          }
        });
      },
    );
  }

  Widget _buildWeekDaysSelection(String languageCode) {
    return Wrap(
      spacing: 8.0,
      children: WeekDay.values.map((weekDay) {
        return ChoiceChip(
          label: Text(weekDay.name.tr),
          selected: _customWeekDays.contains(weekDay),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _customWeekDays.add(weekDay);
              } else {
                _customWeekDays.remove(weekDay);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildCustomDatesField() {
    return TextField(
      decoration: InputDecoration(labelText: L10n.customDates.tr),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _customDates =
              value.split(',').map((e) => int.tryParse(e.trim())!).toList();
        });
      },
    );
  }

  void _saveSchedule() {
    Schedule schedule = Schedule(
      repeatOption: _selectedOption,
      customInterval: _customInterval,
      customWeekDays: _customWeekDays,
      customDates: _customDates,
      startDate: _startDate,
      endDate: _endDate,
    );
    // Save the schedule or pass it back to the previous screen
  }
}
