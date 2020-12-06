Implementacje algorytmów znajdują się w plikach o odpowiednich nazwach. Trzeba
je odpalić poleceniem python3, np. python3 FA.py 'wzorzec' nazwa_pliku.format.

Co do samego rozwiązania to raczej nie wychodzi poza to, co jest napisane we
"Wprowadzeniu do algorytmów", poza modyfikacjami związanymi z tym, że w książce
tablice indeksuje się od 1. W FA dodałam minimalizację alfabetu, jak było to
sugerowane na zajęciach, czyli przez rozpatrywanie tylko symboli występujących 
we wzorcu, a w wypadku napotkania innego symbolu przejście do stanu 0.

Jeżeli chodzi o output programu, to wypisuje po kolei numery linii i dla każdej
z nich listę zawierającą indeksy kolumn, od których rozpoczyna się wystąpienie
wzorca. Linie i kolumny numerowane są od 1. Maksymalny rozmiar pliku na jakim
testowałam program to 128,5 MB i dał radę, a z większymi też bez problemu
powinien dać radę, bo nie wczytuje całego pliku na raz, tylko linijka po 
linijce. No chyba, że cały plik będzie jedną linijką, to wtedy może być
problem.

W poleceniu jest napisane, że plik README powinien zawierać moje dane, więc oto
one - Dominika Szydło, nr albumu 250109.
