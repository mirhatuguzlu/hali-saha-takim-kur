# Halı Saha Takım Kur

Halı saha maçı öncesi oyuncuları güç puanlarına göre iki dengeli takıma ayıran Flutter uygulaması.

## Problem

Arkadaş grupları halı sahada takımları genelde rastgele ya da "kaptanlar sırayla seçer" yöntemiyle kuruyor. Sonuçta iyi oyuncular aynı takımda toplanıyor, maç ilk on dakikada kopuyor ve "takımı kim kurdu" tartışması her hafta yeniden başlıyor.

## Kimin için

Haftalık halı saha maçı yapan arkadaş grupları ve özellikle maçı organize eden kişi için. Organizatör oyuncuları bir kez puanlayarak kaydeder; her maç öncesi gelenleri seçip tek tuşla adil iki takım çıkarır.

## Özellikler

- **Oyuncu listesi:** İsim ve 1–5 arası güç puanıyla oyuncu ekleme, silme; liste cihazda saklanır.
- **Dengeli takım kurma:** Oyuncuları kişi sayısı ve toplam güç bakımından en yakın iki takıma ayırma, güç farkını gösterme, yeniden karıştırma.

## Pano

İş takibi: TRELLO_LINKI_BURAYA

## Çalıştırma

Gereksinim: Flutter 3.x

```bash
flutter pub get
flutter run -d chrome
```

Testler:

```bash
flutter test
```

## Özellikleri deneme

### Özellik 1: Oyuncu listesi

### Özellik 2: Dengeli takım

## Geliştirme süreci

Her iş Trello panosunda bir kart olarak "Yapılacak" sütununda başlar ve üzerinde çalışılırken "Devam Ediyor"a taşınır. Her kart için ayrı bir `feature/...` dalı açılır, iş bir pull request ile `main`'e birleştirilir ve PR bağlantısı karta eklenir. Kabul kriterleri doğrulandıktan sonra kart "Tamamlandı"ya taşınır.
