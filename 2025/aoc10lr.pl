
use Data::Dumper;

my $alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

sub writecode {
    my ($target,$c,$numvars) = @_;
    my @values = split(',',$target);
    open(FH, '>', "model.lp") or die $!;

    print FH "min: ";
    print FH join(" + ", split('',substr($alpha,0,$numvars)));
    print FH ";\n\n";    
    
    foreach (keys %{$c})
    {
        print FH join(" + ", @{$c->{$_}}) . " = " . @values[$_] . ";\n";
    }

    print FH "\nint ";
    print FH join(", ", split('',substr($alpha,0,$numvars)));
    print FH ";\n";    
}

sub execute {
    my $output = `lp_solve -S2 -g -v0 model.lp`;
    my $count = 0;
    foreach (split(/\n/,$output))
    {
        next unless $_ =~ /^([A-Z])\s+(\d+)/;
        $count += $2;
    }
    return $count;
}

my $limit = 0;
while (<>) {
    chomp($_);

    my $target;
    my @buttons;
    foreach (split(' ',$_)) {
#        $target = $1 if $_ =~ /\[(.*)\]/;
        push(@buttons,$1) if $_ =~ /\((.*)\)/;
        $target = $1 if $_ =~ /\{(.*)\}/;
    }

    my $c = {};
    my $b = 'A';
    foreach (@buttons) {
        foreach (split(',',$_))
        {
            $c->{$_} = [] unless defined $c->{$_};
            push(@{$c->{$_}}, $b);
        } 
        $b++;
    }

    writecode($target,$c,scalar(@buttons));
    $ans = execute();

    print "$target .... $ans\n";
    $p2 += $ans;

}


#print "Part One: " . $p1 . "\n";   # 
print "Part Two: " . $p2 . "\n";   #18786 (too high) 
