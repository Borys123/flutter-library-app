class Book {
  String indeks, tytul, autor, gatunek, rok, opis, jezyk, stron, wydawnictwo, oprawa, wydanie, zdjecie;

  Book(this.indeks, this.tytul, this.autor, this.gatunek, this.opis, this.rok, this.jezyk, this.stron, this.wydawnictwo, this.oprawa, this.wydanie, this.zdjecie);

  Book.fromJson(Map<String, dynamic> json) {
    indeks = json['indeks'];
    tytul = json['tytul'];
    autor = json['autor'];
    gatunek = json['gatunek'];
    opis = json['opis'];
    rok = json['rok'];
    jezyk = json['jezyk'];
    stron = json['stron'];
    wydawnictwo = json['wydawnictwo'];
    oprawa = json['oprawa'];
    wydanie = json['wydanie'];
    zdjecie = json['zdjecie'];
  }
}