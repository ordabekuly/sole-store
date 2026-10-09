# SOLE — Sneaker Store

Flutter capstone MVP және LAB 5: кроссовка таңдауды жеңілдететін мобильді дүкен.
Нысаналы пайдаланушылар — студенттер мен күнделікті аяқ киім іздейтін адамдар.

## Іске қосу

Flutter SDK орнатылған ортада осы қалтадан орындаңыз:

```sh
flutter pub get
flutter run -d chrome
```

Android телефон/эмулятор үшін `flutter devices`, кейін `flutter run -d DEVICE_ID`.

## Мүмкіндіктер

- Discovery: бейімделетін тауар карточкалары, категория сүзгісі.
- Detail: Stack мұқабасы және bookmark белгісі, Row тақырыбы, Wrap баға/рейтинг/тегтер.
- Sticky төменгі жолақ: SafeArea → Row → Expanded → Add to Cart.
- StatefulWidget және setState: таңдаулылар, EU өлшемі, себет саны.
- Bag терезесі: өлшем бойынша саны және жалпы бағасы.
- Offline векторлық иллюстрация: сыртқы сурет немесе желі қажет емес.

Деректер демонстрациялық. Себет пен таңдаулылар тек ағымдағы сессияда сақталады.
Төлем, REST API, база және BLoC кейінгі кезеңдерде қосылады.

## Құрылым

```text
lib/
  main.dart
  models/product.dart
  screens/discovery_screen.dart
  screens/product_detail_screen.dart
  widgets/product_art.dart
test/widget_test.dart
```

## Тексеру

```sh
flutter analyze
flutter test
flutter build web
```

Widget тесттері 280×568, 320×568, 390×844, 1024×768 және 1440×900 өлшемдерінде
екі экранды ашады, bookmark пен EU 41 өлшемін таңдайды, себетке қосады және
Bag ішіндегі санын тексереді. RenderFlex және басқа Flutter қателері тестті құлатады.
Нақты Android құрылғысында іске қосу бөлек тексерілуі керек.

## 3–5 минуттық қорғау

1. **Pitch (1 минут):** «SOLE студенттерге аяқ киімді категориямен қарап,
   ұнағанын сақтап, өлшемін таңдап, себетке жинауға көмектеседі».
2. **Demo (2 минут):** Discovery → категория → тауар → bookmark → EU 41 →
   Add to Cart → артқа → Bag. Терезе енін өзгертіп, бейімделуін көрсетіңіз.
3. **Code review (1 минут):** screens/widgets/models құрылымын, Stack,
   Wrap, Expanded және setState қолданылған жерлерді көрсетіңіз.
4. **Даму жоспары:** REST каталогы, жергілікті сақтау, BLoC, авторизация және checkout.

## GitHub

Репозиторий: [ordabekuly/sole-store](https://github.com/ordabekuly/sole-store).
Репозиторий public: код пен README сілтемесі бар кез келген адамға ашық.

```sh
git clone https://github.com/ordabekuly/sole-store.git
cd sole-store
flutter pub get
flutter run -d chrome
```

Келесі өзгерістерді жіберу:

```sh
git add .
git commit -m "feat: describe your change"
git push
```

