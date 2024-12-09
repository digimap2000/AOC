use Storable qw(dclone);

while (<>) {
    @x = split(//,$_);
    foreach (0..@x-1) {
        push(@$rawdisk, $_ % 2 ? '.' : $_ / 2) while @x[$_]--;
    }
}

sub gap {
    my ($width, $stop) = @_;
    my $space = 0;
    my $i = defined $gaps->{$width} ? $gaps->{$width} : 0;
    do {
        $space = (@$disk[$i] eq '.') ? $space+1 : 0;
        $gaps->{$width} = ($i - $space + 1), return $gaps->{$width} if $space >= $width;
    } while ($i++ < ($stop - $space - 1));
    return -1;
}

sub checksum {
    my $acc = 0;
    foreach (0..@$disk-1) {
        $acc += @$disk[$_] * $_ unless @$disk[$_] eq '.';
    }
    return $acc;
}

sub part1 {
    my $pos = 0;
    while ($pos < (scalar @$disk)-1) {
        @$disk[$pos] = pop(@$disk) if @$disk[$pos] eq '.';
        $pos++ if @$disk[$pos] ne '.';
    }
    return checksum();
}

sub part2 {
    my $fid = @$disk[$pos];
    my $org = (scalar @$disk) - 1;
    for(my $pos=scalar @$disk-1; $pos>=0; $pos--) {
        next if $fid eq @$disk[$pos];
        $gap = gap($org - $pos, $org);
        for (my $z=0; $gap>0 && $z<($org - $pos); $z++)
        {
            @$disk[$gap+$z] = @$disk[$org-$z];
            @$disk[$org-$z] = '.';
        }
        $fid = @$disk[$pos];
        $org = $pos;
    }
    return checksum();
}

@$disk = @{ dclone(\@$rawdisk) };
print "Part One: " . part1() . "\n";

@$disk = @{ dclone(\@$rawdisk) };
print "Part Two: " . part2() . "\n";
