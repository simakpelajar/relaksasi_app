import 'package:sqflite/sqflite.dart';

class MeditationSeeder {
  static Future<void> seed(Database db) async {
    final List<Map<String, dynamic>> meditations = [
      {
        "title": "Suara Ombak Laut",
        "category": "Alam",
        "description":
            "Deburan ombak yang menghantam pantai dengan lembut menghadirkan ketenangan alami, membebaskan pikiran seperti berada di tepi laut yang damai.",
        "duration": 0,
        "image_path": "assets/images/alam_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Suara Api Unggun",
        "category": "Imajinatif",
        "description":
            "Letupan kayu yang terbakar perlahan menciptakan kehangatan, seakan duduk bersama di sekitar api unggun di malam yang sunyi dan damai.",
        "duration": 0,
        "image_path": "assets/images/imajinatif_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Suasana Kota yang Tenang",
        "category": "Perkotaan yang tenang",
        "description":
            "Biasanya penuh hiruk pikuk, kini kota terasa tenang. Suara kendaraan yang jauh dan hembusan angin lembut menciptakan ruang refleksi di tengah gedung-gedung tinggi.",
        "duration": 0,
        "image_path": "assets/images/perkotaan_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Melodi Hujan",
        "category": "Alam",
        "description":
            "Rintik hujan yang jatuh perlahan menciptakan melodi alami yang mengalun lembut, membangkitkan kenangan dan membawa rasa damai dalam hati.",
        "duration": 0,
        "image_path": "assets/images/alam_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Musik Harpa Malam",
        "category": "Instrumental",
        "description":
            "Alunan harpa yang tenang dan lembut mengisi malam dengan kedamaian, mengantar kita ke suasana rileks yang mendalam dan penuh harmoni.",
        "duration": 0,
        "image_path": "assets/images/instrumental_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Suara Di Kafe",
        "category": "Perkotaan yang tenang",
        "description":
            "Kombinasi suara gelas, langkah kaki, dan percakapan pelan menciptakan nuansa nyaman layaknya berada di kafe kecil yang hangat dan santai.",
        "duration": 0,
        "image_path": "assets/images/perkotaan_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Lembutnya Angin",
        "category": "Alam",
        "description":
            "Desiran angin yang menyentuh dedaunan menghadirkan ketenangan, seolah membisikkan kedamaian dalam setiap hembusan yang melewati.",
        "duration": 0,
        "image_path": "assets/images/alam_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Petualangan di Hutan",
        "category": "Imajinatif",
        "description":
            "Suara hutan yang hidup dengan kicauan burung dan hembusan dedaunan menghadirkan rasa petualangan yang menantang sekaligus menenangkan.",
        "duration": 0,
        "image_path": "assets/images/imajinatif_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Melodi Gitar Akustik",
        "category": "Instrumental",
        "description":
            "Petikan gitar akustik yang jernih membawa kita dalam suasana hangat, santai, dan penuh perasaan, seperti duduk di sore yang tenang.",
        "duration": 0,
        "image_path": "assets/images/instrumental_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
      {
        "title": "Tunggu Matahari Terbit",
        "category": "Imajinatif",
        "description":
            "Keheningan menjelang pagi berpadu dengan suara alam yang perlahan bangun, menciptakan suasana syahdu saat menanti matahari menyinari dunia.",
        "duration": 0,
        "image_path": "assets/images/imajinatif_kategori.png",
        "audio_path": "assets/audio/suara_airlaut.mp3",
        "playCount": 0,
      },
    ];

    for (var meditation in meditations) {
      await db.insert('meditations', meditation);
    }
  }
}