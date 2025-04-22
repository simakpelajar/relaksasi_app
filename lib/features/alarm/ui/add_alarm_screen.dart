import 'package:flutter/material.dart';
import 'package:relax_fik/core/utils/date_formatter.dart';
import 'package:relax_fik/features/alarm/models/alarm_model.dart';
import 'package:relax_fik/features/alarm/services/alarm_service.dart';
import 'package:relax_fik/features/meditation/models/meditation_model.dart';

class AddAlarmScreen extends StatefulWidget {
  final Meditation? meditation;

  const AddAlarmScreen({
    Key? key,
    this.meditation,
  }) : super(key: key);

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final AlarmService _alarmService = AlarmService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimateController = TextEditingController();

  String _selectedCategory = 'relaksasi';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAlarmEnabled = true;
  bool _isLoading = false;

  // List of all available categories with Indonesian names
  final List<Map<String, dynamic>> _categories = [
    {'name': 'relaksasi', 'label': 'Relaksasi'},
    {'name': 'fokus', 'label': 'Fokus'},
    {'name': 'tidur', 'label': 'Tidur'},
    {'name': 'alam', 'label': 'Alam'},
    {'name': 'instrumental', 'label': 'Instrumental'},
    {'name': 'perkotaan', 'label': 'Perkotaan'},
    {'name': 'imajinatif', 'label': 'Imajinatif'},
  ];

  @override
  void initState() {
    super.initState();

    if (widget.meditation != null) {
      _titleController.text = widget.meditation!.title;

      final categoryMatch = _categories.where(
        (category) => category['name'].toLowerCase() == widget.meditation!.category.toLowerCase(),
      ).toList();

      if (categoryMatch.isNotEmpty) {
        _selectedCategory = categoryMatch[0]['name'];
      }

      _estimateController.text = widget.meditation!.duration.toString();
    }
  }

  // Get icon for category
  Widget _getCategoryIcon(String category, {Color? iconColor}) {
    final color = iconColor ?? Colors.grey;
    
    switch (category.toLowerCase()) {
      case 'relaksasi':
        return Icon(Icons.self_improvement, size: 20, color: color);
      case 'fokus':
        return Icon(Icons.center_focus_strong, size: 20, color: color);
      case 'tidur':
        return Icon(Icons.nightlight_round, size: 20, color: color);
      case 'alam':
        return Icon(Icons.forest, size: 20, color: color);
      case 'instrumental':
        return Icon(Icons.music_note, size: 20, color: color);
      case 'perkotaan':
        return Icon(Icons.location_city, size: 20, color: color);
      case 'imajinatif':
        return Icon(Icons.cloud, size: 20, color: color);
      default:
        return Icon(Icons.category, size: 20, color: color);
    }
  }

  String _getCategoryLabel(String categoryName) {
    final match = _categories.where((category) => category['name'] == categoryName).toList();
    return match.isNotEmpty ? match[0]['label'] : 'Kategori';
  }

  Future<void> _saveAlarm() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan isi semua kolom yang diperlukan'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final alarm = AlarmModel(
        meditationId: widget.meditation?.id,
        title: _titleController.text,
        category: _selectedCategory,
        time: _formatTime(_selectedTime),
        date: DateFormatter.formatAlarmDate(_selectedDate),
        isActive: _isAlarmEnabled ? 1 : 0,
      );

      await _alarmService.addAlarm(alarm);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving alarm: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan jadwal'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showCustomTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentHour = _selectedTime.hour;
            final currentMinute = _selectedTime.minute;
            final primaryColor = Theme.of(context).primaryColor;

            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pilih Waktu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      "${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: FixedExtentScrollController(
                                initialItem: currentHour,
                              ),
                              physics: const FixedExtentScrollPhysics(),
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (index) {
                                setModalState(() {
                                  _selectedTime = TimeOfDay(
                                    hour: index,
                                    minute: currentMinute,
                                  );
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 24,
                                builder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: currentHour == index
                                          ? primaryColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: currentHour == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: currentHour == index
                                            ? primaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: FixedExtentScrollController(
                                initialItem: currentMinute,
                              ),
                              physics: const FixedExtentScrollPhysics(),
                              itemExtent: 50,
                              perspective: 0.005,
                              diameterRatio: 1.2,
                              onSelectedItemChanged: (index) {
                                setModalState(() {
                                  _selectedTime = TimeOfDay(
                                    hour: currentHour,
                                    minute: index,
                                  );
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: currentMinute == index
                                          ? primaryColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      index.toString().padLeft(2, '0'),
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: currentMinute == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: currentMinute == index
                                            ? primaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedTime = TimeOfDay(hour: currentHour, minute: currentMinute);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _estimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwalkan Meditasi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const Icon(
                            Icons.alarm_add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jadwalkan Meditasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Atur waktu untuk berdamai dengan pikiran',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Pilih Waktu & Tanggal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () => _showCustomTimePicker(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _formatTime(_selectedTime),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  DateFormatter.formatDay(_selectedDate),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _isAlarmEnabled
                                ? primaryColor.withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isAlarmEnabled
                                  ? primaryColor.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notifications_active,
                                    color: _isAlarmEnabled ? primaryColor : Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Aktifkan Alarm',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: _isAlarmEnabled ? primaryColor : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _isAlarmEnabled,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    _isAlarmEnabled = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.spa, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Detail Meditasi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Nama Meditasi',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            hintText: 'Masukkan nama meditasi',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.edit, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                            color: Colors.white, // Ensuring white background
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            isDense: true,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Kategori',
                              labelStyle: TextStyle(color: Colors.grey[700]),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white, // White background
                            ),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            dropdownColor: Colors.white, // White dropdown menu background
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedCategory = newValue!;
                              });
                            },
                            items: _categories.map<DropdownMenuItem<String>>((Map<String, dynamic> category) {
                              return DropdownMenuItem<String>(
                                value: category['name'],
                                child: Row(
                                  children: [
                                    _getCategoryIcon(category['name'], iconColor: primaryColor),
                                    const SizedBox(width: 10),
                                    Text(category['label']),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _estimateController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Durasi (menit)',
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            hintText: 'Masukkan durasi meditasi',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: Icon(Icons.timer, color: primaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryColor, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveAlarm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'Simpan Jadwal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}