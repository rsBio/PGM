print join "\n", map {$i = 0; join " ", map '*' x $i ++ . $_, split //, (sort {length $b <=> length $a} split)[0]} <>
