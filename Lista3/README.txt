zad. 1
Rozwiązanie zadania 1 znajduje się w plikach zad1.l oraz zad1.y. Makefile
wszystko ładnie kompiluje, ma też cleana. Po uruchomieniu programu bez żadnych
argumentów pojawi się prompt i można wpisywać po kolei linijkami wyrażenia.
Program też można odpalić z przekierowaniem stdina z wybranego pliku i wtedy
przerobi wszystko naraz. Kontynuacja lini za pomocą \ jest możliwa zarówno w
komentarzu, jak i w wyrażeniu do policzenia.

zad. 2
Rozwiązanie zadania 2 znajduje się w pliku zad2.py. Nie korzystam w nim z
żadnych śmiesznych modułów, tylko PLY oraz sys. Proszę go odpalać w taki sposób:
python3 zad2.py <plik.txt, gdzie plik.txt to plik zawierający wyrażenia do
policzenia, każde w osobnej linijce (oczywiście obsługa \ pozostaje taka sama
jak w zadaniu 1). Program wszystko przerobi i wydrukuje output taki sam jak
jak w poprzedim zadaniu. Ewentualnie można go uruchomić przez python3 zad2.py,
wpisać wyrażenia linijka po linijce w terminalu i wcisnąć enter-ctrl-d, żeby
program dostał EOF i też wszystko przerobi.
