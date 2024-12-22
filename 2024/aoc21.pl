use Data::Dumper;

my @results;
my $set = {};
my $hack = 0;

my $pad = {};
$pad->{'9'} = [2,0];
$pad->{'8'} = [1,0];
$pad->{'7'} = [0,0];
$pad->{'6'} = [2,1];
$pad->{'5'} = [1,1];
$pad->{'4'} = [0,1];
$pad->{'3'} = [2,2];
$pad->{'2'} = [1,2];
$pad->{'1'} = [0,2];
$pad->{'0'} = [1,3];
$pad->{'A'} = [2,3];
$pad->{'X'} = [0,3];

my $dir = {};
$dir->{'^'} = [1,0];
$dir->{'v'} = [1,1];
$dir->{'<'} = [0,1];
$dir->{'>'} = [2,1];
$dir->{'A'} = [2,0];
$dir->{'X'} = [0,0];

sub rekkie {
    my ($tag) = @_;
    my $acc = 0;
    foreach (keys %{$set->{$tag}}) {
        $acc += (length($_) * $set->{$tag}->{$_});
    }
    return $acc;
}

sub rellie {
    my ($local, $tag) = @_;
    my $acc = 0;
    foreach (keys %{$local->{$tag}}) {
        $acc += (length($_) * $local->{$tag}->{$_});
    }
    return $acc;
}

sub check {
    my ($a, $path, $p) = @_;
    my ($x,$y) = ($p->{$a}[0], $p->{$a}[1]);
    foreach (split(//,$path)) {
        $x++ if $_ eq '>';
        $x-- if $_ eq '<';
        $y++ if $_ eq 'v';
        $y-- if $_ eq '^';
        return 0 if ($x eq $p->{'X'}[0]) && ($y eq $p->{'X'}[1]);
    }
    return 1;
}

sub dist {
    my ($a,$b,$p) = @_;
    $dx = $p->{$b}[0] - $p->{$a}[0];
    $dy = $p->{$b}[1] - $p->{$a}[1];

    my $pathA = "";
    foreach (1..abs($dx)) {
        $pathA .= ($dx > 0) ? ">" : "<";
    }    
    foreach (1..abs($dy)) {
        $pathA .= ($dy > 0) ? "v" : "^";
    }   

    my $pathB = "";
    foreach (1..abs($dy)) {
        $pathB .= ($dy > 0) ? "v" : "^";
    }   
    foreach (1..abs($dx)) {
        $pathB .= ($dx > 0) ? ">" : "<";
    }    

    my @paths;

    # straight line paths, no options...
    if (($dx eq 0) || ($dy eq 0)) {
        push(@paths, $pathA . 'A');
        return @paths;
    }
    
    # cant both be illegal
    if (!check($a,$pathA,$p)) {
        push(@paths, $pathB . 'A');
        return @paths;
    }
    if (!check($a,$pathB,$p)) {
        push(@paths, $pathA . 'A');
        return @paths;
    }

    # Just do both for the number pad
    if (($a =~ /\d+/) || ($b =~ /\d+/))
    {
        push(@paths, $pathA . 'A') if check($a,$pathA,$p);
        push(@paths, $pathB . 'A') if check($a,$pathB,$p);
        return @paths;
    }

    # Fuckers
    if (($a . $b) eq 'Av')
    {
        $anotb = ($hack >> 0) % 2;
    }
    elsif (($a . $b) eq 'vA')
    {
        $anotb = ($hack >> 1) % 2;
    }
    elsif (($a . $b) eq '^>')
    {
        $anotb = ($hack >> 2) % 2;
    }
    elsif (($a . $b) eq '>^')
    {
        $anotb = ($hack >> 3) % 2;
    }
    push(@paths, $pathA . 'A') if $anotb;
    push(@paths, $pathB . 'A') unless $anotb;
    return @paths;
}

sub perm {
    my ($a,$code,$seq,$p,$fan) = @_;
    if (length($code) eq 0)
    {
        push(@result,$seq);
        return;
    }

    my @s = dist($a,substr($code,0,1),$p,$fan);
    foreach (@s) {
        perm(substr($code,0,1),substr($code,1,length($code)-1),$seq . $_,$p,$fan);
    }
}

sub permex {
    my ($loop) = @_;
    foreach (sort keys %{$set->{$loop-1}}) {
        my $mult = $set->{$loop-1}->{$_};

        my $local = {};

        @result = ();
        perm('A',$_,"",$dir,0);
        my $count = 0;
        my $best = -1;
        my $save = 0;

        foreach (@result) {

            my $concat = $_;
            while ($concat) {
                $concat =~ /^([^(A)]*A)(.*)$/;
                $local->{$count}->{$1} += $mult;
                $concat = $2;
            }
            my $rk = rellie($local, $count);
            if (($best eq -1) || ($rk < $best))
            {
                $best = $rk;
                $save = $count;
            }
            $count++;
        }

        foreach (sort keys %{$local->{$save}}) {
            $set->{$loop}->{$_} += $local->{$save}->{$_};
        }
    }
}

my @file = ('789A','540A','285A','140A','189A');
foreach (0..15) {
    $hack = $_;
    $m1 = 0;   
    $m2 = 0;   
    foreach (@file) {
        my $numbers = $_;

        $set = {};
        @result = ();
        perm('A',$numbers,"",$pad, 1);
        $numbers =~ s/[\D]//g;

        my ($bestP1,$bestP2) = (0,0); 
        my $combinations = join('-',@result);
        foreach (split(/-/,$combinations)) {

            # Hack the first level in manually
            $set = {};
            my @chunks = split(/A/,$_);
            foreach (@chunks) {
                $set->{0}->{$_ . 'A'}++;
            }

            # Iterate for the deepest stack of robots
            my $depth = 25;
            foreach (1..$depth) {
                permex($_);
            }

            $bestP1 = rekkie(2) if !$bestP1 || (rekkie(2) < $bestP1);
            $bestP2 = rekkie($depth) if !$bestP2 || (rekkie($depth) < $bestP2);
        }    
        $m1 += ($bestP1*$numbers);
        $m2 += ($bestP2*$numbers);
    }
    $p1->{$m1}++;
    $p2->{$m2}++;
}

print "Part Two: " . (sort keys %$p1)[0] . "\n";            # 134120
print "Part Two: " . (sort keys %$p2)[0] . "\n";            # 167389793580400
   