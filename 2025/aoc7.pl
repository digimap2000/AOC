use strict;

my ($p1,$p2) = (0,0);

sub permutate {
    my @symbols = split(//,@_[0]);
    my @op = split(/,/,@_[1]);
    my @ip = @op;
    foreach (0..scalar(@symbols)-1)
    {
         @op[$_] = '1', next if @symbols[$_] eq 'S';
         if (@symbols[$_] eq '^' && @ip[$_] =~ /\d+/)
         {
            @op[$_-1] = @ip[$_] + @op[$_-1];
            @op[$_+0] = ' ';
            @op[$_+1] = @ip[$_] + @op[$_+1];
            $p1++, next;
         }         
         @op[$_] = ' ' unless $op[$_];
    }
    return join(',',@op);    
}

my $status;
while (<>) {
    last unless chomp($_) && $_;
    $status = permutate($_,$status);
}
foreach (split(/,/,$status)) {$p2+= $_;}

print "Part One: " . $p1 . "\n";   # 1533
print "Part Two: " . $p2 . "\n";   # 10733529153890



