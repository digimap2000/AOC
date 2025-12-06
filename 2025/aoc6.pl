use Data::Dumper;

my ($p1,$p2) = (0,0);
my @data;

while (<>) {
    last unless chomp($_) && $_;
    push(@data,[split(//,$_)]);
}

my $operand;
my $acc = '';
while (scalar(@{$data[0]}))
{
    my $line;
    foreach (0..4) {
        my $c = shift(@{$data[$_]});
        $operand = $c,next if $c =~ /[\+\*]/;
        $line .= $c if $c =~/\d/;
    }
    print "$operand:$line  ";
    if ($line)
    {
        $acc = $line, next unless $acc;
        $acc += $line if $operand eq '+';
        $acc *= $line if $operand eq '*';
    }
    else
    {
        $p2 += $acc;
        print "$operand $line ... $acc \n";
        $operand = '';
        $acc = '';
    }
}

print "Part One: " . $p1 . "\n";   # 
print "Part Two: " . $p2 . "\n";   # 10188206723429

