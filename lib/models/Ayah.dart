class Ayah {
  final int number;
  final String text;
  final String? transliteration; // Ajouté
  final String? translation;     // Ajouté
  final int numberInSurah;
  final int juz;
  final int page;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    this.transliteration,
    this.translation,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'],
      text: json['text'],
      // Ajuste les clés ci-dessous selon ton JSON (ex: 'en_transliteration', 'fr_translation')
      transliteration: json['transliteration'], 
      translation: json['translation'],
      numberInSurah: json['numberInSurah'],
      juz: json['juz'],
      page: json['page'],
      sajda: json['sajda'] is bool ? json['sajda'] : false,
    );
  }
}