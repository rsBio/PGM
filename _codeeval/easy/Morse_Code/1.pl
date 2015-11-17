$\ = $/;

{
local $/;
$_ = <DATA>;
}

%h = reverse split;

while(<>){
    chomp;
    s/\S+/$h{$&}/g,
    s/ \b//g;
    print
    
    }
    
    
    
__DATA__
Letter	Morse
A	.-
B	-...
C	-.-.
D	-..
E	.
F	..-.
G	--.
H	....
I	..
J	.---
K	-.-
L	.-..
M	--
Letter	Morse
N	-.
O	---
P	.--.
Q	--.-
R	.-.
S	...
T	-
U	..-
V	...-
W	.--
X	-..-
Y	-.--
Z	--..
Digit	Morse
0	-----
1	.----
2	..---
3	...--
4	....-
5	.....
6	-....
7	--...
8	---..
9	----.
