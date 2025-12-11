
use Data::Dumper;

my $network = {};

sub expand {
    my ($ip) = @_;
    my $op = {'out' => $ip->{'out'}};
    foreach $x (keys %{$ip}) {
        foreach (@{$network->{$x}})
        {
            my @qo = @{$op->{$_}}; 
            my @qi = @{$ip->{$x}};
            @qo[0] += @qi[0];

            if ($_ eq 'fft')
            {
                if (@qi[2] gt 0) {
                    @qo[3] += @qi[2];
                }
                @qo[1] += @qi[0];
            }
            
            if ($_ eq 'dac')
            {
                if (@qi[1] gt 0) {
                    @qo[3] += @qi[1];
                }
                @qo[2] += @qi[0];
            }

            @qo[1] += @qi[1];
            @qo[2] += @qi[2];
            @qo[3] += @qi[3];

            $op->{$_} = \@qo;
            print "$x $_ " . join('-',@qo) . "\n";
        }        
    }
    return $op;
}

while (<>) {
    chomp($_);

    my $key;
    foreach (split(' ',$_)) {
        $key = $1, next if $_ =~ /(.*):/;
        push @{$network->{$key}}, $_;
    }
}

my $it = 0;
my $result = {'svr' => [1,0,0,0]};
do {
    $result = expand($result);
    print "Iteration " . $it++ . " ==> " . join(',',keys %{$result}) . "\n";
} while (scalar(keys %{$result}) > 1);
$p1 = join('-',@{$result->{'out'}});

#print Dumper $result;


print "Part One: " . $p1 . "\n";   # 
print "Part Two: " . $p2 . "\n";   # 
