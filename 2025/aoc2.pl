use strict;
my ($p1,$p2) = (0,0);

# Check if the passed value produces identical pieces when split into
# some number of equally sized chunks. Does this by verifying that
# all digits match their equivalent position in the first chunk.
sub isEqualChunks {
    my ($v,$chunks) = @_;
    my $len = length($v);
    return 0 if $len % $chunks;
    foreach (0..$len-1) {
        return 0 unless substr($v,$_,1) eq substr($v,$_ % ($len/$chunks),1);
    }
    return 1;
}

# For every value in all the ranges determine if the value can be split
# into equal pieces. The least number of chunks is always 2, the most 
# would be to split into single digits so equals the length of the value.
foreach (split(',',<>))
{
    my ($a,$b) = split('-',$_);

    print "Checking $a => $b\n";
    foreach ($a..$b) {
        foreach my $chunks (2..length($_)) {
            next unless isEqualChunks($_,$chunks);
            $p1 += $_ if $chunks eq 2;
            $p2 += $_;
            last;
        }
    }
}

# P1 only cares about splitting into two chunks whilst P2 splits into
# any number of chunks to satisfy inclusion.
print "Part One: " . $p1 . "\n";  # 31000881061
print "Part Two: " . $p2 . "\n";  # 46769308485