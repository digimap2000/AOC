my $rules = {};

sub validate {
    my $seen = {};
    for ($i=0; $i < scalar(@_); $i++) {
        foreach (keys %$seen)
        {
            return ($i+1) if defined $rules->{@_[$i]}->{$_};
        }
        $seen->{@_[$i]}++;
    }
    return 0;
}

while (<>)
{
    chomp();
    if ($_ =~ /(\d+)\|(\d+)/)
    {
        $rules->{$1}->{$2} = 1;
    }
    elsif ($_ =~ /,/)
    {
        @pages = split(/,/,$_);
        $pos = validate(@pages);
        $p1 += @pages[@pages / 2] unless $pos;
        while ($pos) {
            @pages[$pos-2,$pos-1] = @pages[$pos-1,$pos-2];
            $pos = validate(@pages);
            $p2 += @pages[@pages / 2] unless $pos;
        };
    }
}

print "Part One: " . $p1 . "\n";
print "Part Two: " . $p2 . "\n";