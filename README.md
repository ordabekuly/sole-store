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
  screens/registration_screen.dart
  widgets/product_art.dart
test/widget_test.dart
test/registration_test.dart
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

## LAB 6 — User Registration & Profile Setup

Discovery үстіндегі **Create account** белгісін басыңыз.

- Form және GlobalKey<FormState> батырма басылғанда барлық өрісті тексереді.
- TextEditingController: Full Name, Email, Password және Confirm Password.
- Full Name бос/тек бос орын болса қабылданбайды.
- Email ішінде @ және домен нүктесі болуы керек; бос орындар мен қате құрылым қабылданбайды.
- Password кемінде 6 таңба; екі пароль өрісі obscureText арқылы жасырылған.
- Confirm Password дәл сәйкес болуы керек. Password өзгерсе, растау қайта тексеріледі.
- AutovalidateMode енгізу кезінде қателерді көрсетеді; submit барлық өрісті тексереді.
- Dropdown: Student / Teacher / Developer.
- Terms and Conditions checkbox белгіленбейінше тіркелу орындалмайды.
- Сәтті submit: terminal/debug console деректері және success SnackBar.
  Парольдер терминалда [REDACTED] деп көрсетіледі.
- Controller ресурстары dispose арқылы босатылады.

Бұл UI демонстрациясы: аккаунт серверде жасалмайды, деректер сақталмайды.
Registration тесттері міндетті өрістерді, live тексеруді, пароль өзгергендегі
сәйкестікті, checkbox талабын, сәтті submit пен рөлді тексереді.
280×568, 390×844 және 1440×900 өлшемдерінде форма overflow бермейді.
Жалпы 10 widget тесті өтті; flutter analyze қате таппады.
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
