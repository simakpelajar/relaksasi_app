import 'package:flutter/material.dart';
import 'package:relax_fik/features/alarm/models/alarm_model.dart';
import 'package:relax_fik/features/alarm/services/alarm_service.dart';
import 'package:relax_fik/features/alarm/ui/add_alarm_screen.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmService _alarmService = AlarmService();
  List<AlarmModel> _alarms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAlarm();
    _loadAlarms();
  }

  Future<void> _initializeAlarm() async {
    await _alarmService.initializeAlarm();
  }

  Future<void> _loadAlarms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _alarms = await _alarmService.getAlarms();
    } catch (e) {
      // Handle error
      debugPrint('Error loading alarms: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jadwal Meditasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _alarms.isEmpty
              ? _buildEmptyState()
              : _buildAlarmList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAlarmScreen(),
            ),
          );

          if (result == true) {
            _loadAlarms();
          }
        },
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildEmptyState() {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.alarm_off,
              size: 80,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Jadwal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Jadwalkan sesi meditasi Anda untuk tetap konsisten dalam menjaga ketenangan pikiran',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAlarmScreen(),
                  ),
                );

                if (result == true) {
                  _loadAlarms();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Buat Jadwal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmList() {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          final alarm = _alarms[index];
          final isActive = alarm.isActive == 1;
          final textColor = isActive ? Colors.white : Colors.black87;
          
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isActive 
                    ? [primaryColor, primaryColor.withOpacity(0.8)]
                    : [Colors.grey[300]!, Colors.grey[200]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isActive ? primaryColor : Colors.grey).withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isActive 
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Icon(
                          Icons.alarm,
                          color: isActive ? Colors.white : Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alarm.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isActive 
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.grey[500],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                alarm.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive ? Colors.white : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isActive,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.white.withOpacity(0.3),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[300],
                        onChanged: (value) async {
                          await _alarmService.toggleAlarmStatus(
                            alarm.id!,
                            value ? 1 : 0,
                          );
                          _loadAlarms();
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: isActive ? Colors.white.withOpacity(0.2) : Colors.grey[400]!.withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Time and date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: textColor,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            alarm.time,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today,
                            color: textColor,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            alarm.date,
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      // Delete button
                      InkWell(
                        onTap: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Hapus Jadwal'),
                              content: const Text('Anda yakin ingin menghapus jadwal meditasi ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await _alarmService.deleteAlarm(alarm.id!);
                            _loadAlarms();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isActive 
                                ? Colors.white.withOpacity(0.2)
                                : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: isActive ? Colors.white : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}