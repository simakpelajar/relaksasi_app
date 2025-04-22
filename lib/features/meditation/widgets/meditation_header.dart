import 'package:flutter/material.dart';

class MeditationHeader extends StatelessWidget {
  // Parameter untuk jumlah alarm yang aktif
  final int alarmCount;

  const MeditationHeader({
    Key? key,
    required this.alarmCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Header y
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5263F3),
            Color.fromARGB(255, 9, 9, 9),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(106, 56, 18, 105).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar dengan efek glow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipOval(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/Avatar.png',
                    fit: BoxFit.cover,
                    width: 60, // Ukuran avatar yang dikecilkan
                    height: 60,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Greeting dan informasi alarm dengan warna yang dimainkan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Hello, ',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE0E0FF),
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Color(0xFF9BA4FF),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Zhafran!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Color(0xFF9BA4FF),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.alarm,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$alarmCount alarm aktif',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}