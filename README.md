# Halı Saha Takım Kur

[![CI](https://github.com/mirhatuguzlu/hali-saha-takim-kur/actions/workflows/ci.yml/badge.svg)](https://github.com/mirhatuguzlu/hali-saha-takim-kur/actions/workflows/ci.yml)

Halı saha maçı öncesi oyuncuları güç puanlarına göre iki dengeli takıma ayıran Flutter uygulaması.

**Canlı deneme:** https://mirhatuguzlu.github.io/hali-saha-takim-kur/

## Problem

Arkadaş grupları halı sahada takımları genelde rastgele ya da "kaptanlar sırayla seçer" yöntemiyle kuruyor. Sonuçta iyi oyuncular aynı takımda toplanıyor, maç ilk on dakikada kopuyor ve "takımı kim kurdu" tartışması her hafta yeniden başlıyor.

## Kimin için

Haftalık halı saha maçı yapan arkadaş grupları ve özellikle maçı organize eden kişi için. Organizatör oyuncuları bir kez puanlayarak kaydeder; her maç öncesi gelenleri seçip tek tuşla adil iki takım çıkarır.

## Özellikler

- **Oyuncu listesi:** İsim ve 1–5 arası güç puanıyla oyuncu ekleme, silme; liste cihazda saklanır.
- **Dengeli takım kurma:** Oyuncuları kişi sayısı ve toplam güç bakımından en yakın iki takıma ayırma, güç farkını gösterme, yeniden karıştırma.
- **Kaleci:** Oyuncuyu kaleci olarak işaretleme; kaleciler takımlara ayrı dağıtılır, iki kaleci aynı takıma düşmez.
- **WhatsApp için kopyalama:** Kurulan takımları tek tuşla panoya kopyalayıp gruba yapıştırma.
- **Maç sonucu:** Skoru kaydetme; her oyuncunun galibiyet, beraberlik ve mağlubiyet sayısı tutulur.

## Pano

İş takibi (Trello): https://trello.com/b/bail54yH

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

1. Sağ alttaki **+** butonuna bas.
2. İsim yaz, yıldızlara dokunarak 1–5 arası güç puanı seç ve **Ekle**'ye bas; oyuncu listede yıldızlarıyla görünür.
3. İsim boşken **Ekle**'ye basınca oyuncu eklenmez.
4. Bir oyuncuyu sola/sağa kaydırınca listeden silinir.
5. Sayfayı yenile ya da uygulamayı kapatıp aç; liste korunur.

### Özellik 2: Dengeli takım

### Özellik 3: Kaleci

### Özellik 4: WhatsApp için kopyalama

### Özellik 5: Maç sonucu

## Geliştirme süreci

Her iş Trello panosunda bir kart olarak "Yapılacak" sütununda başlar ve üzerinde çalışılırken "Devam Ediyor"a taşınır. Her kart için ayrı bir `feature/...` dalı açılır, iş bir pull request ile `main`'e birleştirilir ve PR bağlantısı karta eklenir. Kabul kriterleri doğrulandıktan sonra kart "Tamamlandı"ya taşınır.
