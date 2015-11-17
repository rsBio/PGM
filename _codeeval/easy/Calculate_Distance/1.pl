$\ = $/;

while(<>){
	print map eval "sqrt($_)", map s/(?<=2)(?= )/+/r, map s/(-?\d+) (-?\d+)/(abs(($1)-($2)))**2/rg, join ' ', ((/-?\d+/g)[0,2,1,3])
	}
