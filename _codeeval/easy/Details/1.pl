print - 2 + (sort {$a <=> $b} map length, /X\.*Y/g)[0], $/ for <>
