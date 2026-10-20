# Өзгерістер журналы

## CHG-0009 — 2026-10-09 — feat: SOLE Flutter MVP

Discovery және Product Preview, bookmark, категория сүзгісі, EU өлшемдері,
өлшем бойынша себет және жалпы баға қосылды. Stack/Row/Column/Wrap/Expanded
және StatefulWidget/setState қолданылады. Суреттер CustomPainter арқылы салынады.

Тексеру: flutter analyze — қате жоқ; бес widget тесті өтті
(280×568, 320×568, 390×844, 1024×768, 1440×900); flutter build web өтті.
Android құрылғысында тексерілмеген. API/база/BLoC кейінгі кезеңдерге жоспарланған.

## CHG-0010 — 2026-10-09 — docs: GitHub репозиторийі

ordabekuly/sole-store private репозиторийі құрылды; README clone/run және
келесі өзгерістерді жіберу командаларымен жаңартылды.

## CHG-0011 — 2026-10-09 — docs: репозиторийді public ету

Пайдаланушы сұрауымен репозиторий public болды. README қолжетімділік ақпараты жаңартылды.
GitHub API private=false, visibility=public қайтарды.


## CHG-0012 — 2026-10-09 — feat: LAB 6 тіркелу формасы

Create account навигациясы және registration_screen.dart қосылды.
Form/GlobalKey/FormState, төрт TextEditingController, live/submit validators,
пароль сәйкестігін қайта тексеру, role dropdown, Terms checkbox және success
SnackBar жұмыс істейді. Терминалға профиль деректері және жасырылған парольдер шығады.
Бұрын аккаунт экраны жоқ еді; енді бөлек тіркелу UI демонстрациясы бар.

Тексеру: 10 widget тесті өтті, оның ішінде LAB 6 үшін 5 тест.
280×568, 390×844, 1440×900 өлшемдерінде registration overflow жоқ.
flutter analyze — No issues found; flutter build web өтті. Android құрылғысында тексерілмеген.

## 2026-10-20 — feat: LAB 7 Navigation & Tabs

Feed/Favorites/Profile BottomNavigationBar, IndexedStack күй сақтау, профиль
баптауы, толық Product аргументтері және екі Navigator.pop батырмасы қосылды.
Әр тауардың жеке сипаттамасы және жергілікті PNG мұқабасы бар.
Favorites detail/bookmark өзгерістерімен синхрондалады. LAB 5–6 мүмкіндіктері сақталды.

Бейне: docs/lab7-navigation.mp4 және GIF — автоматты Flutter UI сценарийінің
нақты рендер жазбасы; физикалық құрылғы жазбасы емес.

Тексеру: 14 widget тесті өтті; flutter analyze — No issues found; Web build өтті.
Толық объект, екі Back, favorites синхрондалуы, фильтр/себет/профиль күйі
және 280/390/1440 ендерінде үш root қойындысы тексерілді.
MP4: 196 кадр, 390x844, 12.5 FPS, 15.68 секунд; FFmpeg decode қатесіз.
