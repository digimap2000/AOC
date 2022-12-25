#!/usr/bin/perl
use Math::Round qw/round/;

sub digitTranslate {
    my $codes = {'-2' => '=', '=' => '-2', '-1' => '-', '-' => '-1'};
    return defined $codes->{@_[0]} ? $codes->{@_[0]} : @_[0];
}

sub toSnafu {
    my ($dec,$ans) = @_;
    for $c (0..31)
    {
        $base = 5 ** (31-$c);
        $digit = round($dec / $base);
        $dec -= $base * $digit;
        $ans .= digitTranslate($digit);
    }
    $ans =~ s/^[0]*//;
    return $ans;
}

sub toDecimal {
    my ($snafu,$ans) = @_;
    my ($dec,$mul) = (0,1);
    for (reverse split //, $snafu) {
        $dec += $mul * digitTranslate($_);
        $mul *= 5;
    }
    return $dec;
}

while (<>) {
    $acc += toDecimal($_);
}
print toSnafu($acc);
