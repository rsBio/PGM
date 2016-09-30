"žodžių kryžiuoklis" valgo TSV: klausimas \t atsakymas(vienas žodis)
išveda TSV su kryžiažodžiu, po juo - klausimus.

    kryžiažodžio atsakymai turi būti sudaryti TIK iš [a-z] raidžių.

"mąsto" taip:
0) prideda žodžio pradžioj ir pabaigoj po nesikryžiuojantį simbolį.
1) horizontaliai įpaišo ilgiausią žodį
2) kiekvienam iš likusių žodžių tikrina:
    kurioje erdvės vietoje jis susikryžiuotų su jau esamais ir
    kiek tokių susikryžiavimų bus ir
    kokio aukščio bei pločio pataps kryžiažodis
3) pasirenka įpaišyti tą žodį ir tą jo vietą, kur jis daugiausiai kryžiuojasi, 
    o jei tokių keli/kelios - pasirenka pagal mažiausią naują kryžiažodžio plotą.

Taigi:
    karštoji vieta - net 4 FOR ciklai, dėl to veikia ~1 sek. jau prie 20 žodžių.
    vietoje nesikryžiuojančio simbolio žodžio pradžioj perrašoma raidė V arba H.
    klausimai nesunumeruoti, tačiau kryžiažodyje seka pagal V/H raides
        iš viršaus į apačią ir kairės į dešinę.

