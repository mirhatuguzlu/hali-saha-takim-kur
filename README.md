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
- **Maç günü yoklaması:** O hafta gelecek oyuncuları işaretleme; takımlar sadece gelenlerle kurulur.
- **Puan önerisi:** Üst üste 3 maç kazanan oyuncuya puan artırma önerisi; onaylanınca puan 1 artar (en fazla 5).
- **Maç grupları:** Farklı maç grupları oluşturma ve aralarında geçiş; her grubun oyuncu listesi ayrı saklanır.

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

1. Farklı puanlarla en az 4 oyuncu ekle (ör. 5, 4, 2, 1 yıldız).
2. **Takımları Kur**'a bas; Takım A ve Takım B, her takımın toplam gücü ve altta "Güç farkı" görünür.
3. Kişi sayıları en fazla 1 farklıdır (7 oyuncuda 4–3).
4. **Yeniden Karıştır**'a bas; eşit puanlı oyuncuların yeri değişebilir, güç farkı yine en düşük seviyede kalır.
5. Geri ok ile oyuncu listesine dönülür.

### Özellik 3: Kaleci

1. **+** ile oyuncu eklerken **Kaleci** kutusunu işaretle; listede oyuncunun yanında kaleci simgesi görünür.
2. Toplam en az 4 oyuncu olacak şekilde 2 kaleci ekle.
3. **Takımları Kur**'a bas; iki kaleci farklı takımlara düşer.
4. **Yeniden Karıştır**'a birkaç kez bas; kaleciler hiçbir zaman aynı takımda toplanmaz, kişi farkı en fazla 1 kalır.

### Özellik 4: WhatsApp için kopyalama

1. En az 2 oyuncu ekleyip **Takımları Kur**'a bas.
2. Sağ üstteki **Kopyala**'ya bas; altta "Kopyalandı" bildirimi görünür.
3. WhatsApp grubuna (ya da herhangi bir metin alanına) yapıştır; "Takım A (güç X): …" ve "Takım B (güç Y): …" satırları gelir.
4. **Yeniden Karıştır** sonrası tekrar kopyalayınca yeni takımlar kopyalanır.

### Özellik 5: Maç sonucu

1. En az 2 oyuncu ekle; listede her oyuncunun altında "G 0 · B 0 · M 0" görünür.
2. **Takımları Kur**'a, ardından **Sonucu Kaydet**'e bas.
3. İki takımın gol sayısını gir (ör. 3 – 1) ve **Kaydet**'e bas; "Sonuç kaydedildi" bildirimi görünür.
4. Geri ok ile listeye dön; kazanan takımdakilerde G, kaybedenlerde M bir artmıştır (beraberlikte herkeste B).
5. Sayfayı yenile; galibiyet/beraberlik/mağlubiyet sayıları korunur.

### Özellik 6: Maç günü yoklaması

1. En az 3 oyuncu ekle; her oyuncunun solunda işaretli **Geliyor** kutusu görünür.
2. O hafta gelmeyecek bir oyuncunun kutusunun işaretini kaldır.
3. **Takımları Kur**'a bas; işareti kaldırılan oyuncu takımlarda yer almaz.
4. Sonucu kaydedip geri dön; gelmeyen oyuncu listede kalır, G/B/M sayıları değişmez.
5. İşaretli oyuncu sayısı 2'nin altına düşünce **Takımları Kur** pasif olur.

### Özellik 7: Puan önerisi

1. 2 oyuncu ekleyip **Takımları Kur**'a bas, aynı oyuncunun takımının kazandığı bir skorla **Sonucu Kaydet**.
2. Aynı oyuncunun takımı üst üste 3 maç kazanana kadar tekrarla (beraberlik ya da mağlubiyet seriyi sıfırlar).
3. Oyuncu listesinde o oyuncunun yanında yeşil **Puanı artır** (yukarı ok) simgesi görünür.
4. Simgeye bas, **Artır**'ı onayla; oyuncunun yıldızı 1 artar ve simge kaybolur. Puanı 5 olan oyuncuya öneri çıkmaz.

### Özellik 8: Maç grupları

1. Sağ üstte geçerli grup adı görünür (ilk açılışta **Ana grup**); mevcut oyuncular bu gruptadır.
2. Grup adına bas, **Yeni grup**'u seç, bir ad yaz (ör. "Salı") ve **Oluştur**'a bas; boş bir oyuncu listesi açılır.
3. Bu gruba birkaç oyuncu ekle.
4. Grup menüsünden **Ana grup**'a geç; eski oyuncular görünür, yeni gruptakiler görünmez.
5. Sayfayı yenile; seçili grup ve her grubun listesi korunur.

## Geliştirme süreci

Her iş Trello panosunda bir kart olarak "Yapılacak" sütununda başlar ve üzerinde çalışılırken "Devam Ediyor"a taşınır. Her kart için ayrı bir `feature/...` dalı açılır, iş bir pull request ile `main`'e birleştirilir ve PR bağlantısı karta eklenir. Kabul kriterleri doğrulandıktan sonra kart "Tamamlandı"ya taşınır.
