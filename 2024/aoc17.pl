use Data::Dumper;
use POSIX;
use Math::Base::Convert "cnv";

my $reg = {};
my @code;

sub combo {
    my ($op) = @_;
    return $op if $op < 4;
    return $reg->{'A'} if $op eq 4;
    return $reg->{'B'} if $op eq 5;
    return $reg->{'C'} if $op eq 6;
    return 0;
}

sub run {
    my ($a) = @_;
    $reg->{'A'} = $a;

    my $pcmax = scalar(@code);
    my @output;
    my $pc = 0;

    while (($pc < $pcmax)) {
        $i = $code[$pc];
        $o = $code[$pc+1];
        if ($i eq 0)
        {
#            $reg->{'A'} = floor($reg->{'A'} / (2 ** combo($o)));
            $reg->{'A'} = $reg->{'A'} >> combo($o);
           $pc += 2;
        }
        elsif ($i eq 1) # Bitwise XOR
        {
            $reg->{'B'} = $reg->{'B'} ^ $o;
            $pc += 2;
        }
        elsif ($i eq 2)
        {
            $reg->{'B'} = combo($o) % 8;                
            $pc += 2;
        }
        elsif ($i eq 3)
        {
            $pc = ($reg->{'A'} ne 0) ? $o : ($pc+2);
        }
        elsif ($i eq 4)
        {
            $reg->{'B'} = $reg->{'B'} ^ $reg->{'C'}; 
            $pc += 2;
        }
        elsif ($i eq 5)
        {
            push(@output,combo($o) % 8);
            $pc += 2;
        }
        elsif ($i eq 6)
        {
#            $reg->{'B'} = floor($reg->{'A'} / (2 ** combo($o)));
            $reg->{'B'} = $reg->{'A'} >> combo($o);
            $pc += 2;                
        }
        elsif ($i eq 7)
        {
#            $reg->{'C'} = floor($reg->{'A'} / (2 ** combo($o)));
            $reg->{'C'} = $reg->{'A'} >> combo($o);
            $pc += 2;                
        }
#        print "A=" . $reg->{'A'} . " B=" . $reg->{'B'} . " C=" . $reg->{'C'} . "\n";
    }    
    return join(",",@output);
}

sub convert {
    my ($oct) = @_;
    my $mul = 1;
    my $acc = 0;
    foreach (reverse split(//,$oct))
    {   
        $acc += ($mul * $_);
        $mul *= 8;
    }
    return $acc;
}

sub octal {
    my ($dec) = @_;
    my $mul = 1;
    my $acc = 0;
    foreach (reverse split(//,$dec))
    {   
        $acc += ($mul * $_);
        $mul *= 10;
    }
    return $acc;
}

sub faff {
    my ($prefix,$match) = @_;

    my $result = [];
    foreach $digit (0..7) {
        foreach (@$prefix) {
            my $a = $_ . $digit;
            my $test = cnv($a,8,10);
            my $op = run($test);
            next unless ($match =~ /$op$/);
            print $a . " " . $test . " => " . $op . " vs " . $match . "\n";
            push(@$result,$a);
        }
    }
    return $result;
}

while (<>) {
    chomp(); 
    if ($_ =~ /^Register (\w): (\d+)/)
    {
        $reg->{$1} = $2;
    }
    if ($_ =~ /^Program: (.*)$/)
    {
        @code = split(/,/,$1);
        my $match = $1;

        my $prefix = ['3'];
        foreach (1..15) {
            $prefix = faff($prefix,$match);
        }

        $p = {};
        foreach (@$prefix) {
            $p->{$_}++;
        }

        @keys = (sort {$a <=> $b} keys %$p);
        print @keys[0] . "\n";
        print cnv(@keys[0],8,10)  . "\n";

        exit;

        foreach (0..65535) {
            my $test = cnv($_,10,8);
            my $op = run($_);
            next unless ($match =~ /$op$/);
            print $_ . " " . $test . " => " . $op . " vs " . $match . "\n";
        }
        exit;


        my $a = '0';
        foreach $digit (0..31) {
            $match = 0;
            foreach (0..7) {
                my $test = $_ . $a; 
                my $dec = convert($test);
#                next if int($dec) eq 0;
                my $op = run($dec);
                print $test . " => " . $dec . " => " . $op . " vs " . $1 . "\n";
                next unless length($op) > (length($test));
                print "GOOOO", exit if $1 eq $op;
                if ((length($op) > 1) && ($1 =~ /$op$/))
                {
                    $a = $_ . $a;
                    $match = 1;
                    last;
                }
            }
            #exit unless $match;
        }
    }
};

#            print "Part One: " . run($1) . "\n";
#print "Part Two: " . $p2 . "\n";


# 345300