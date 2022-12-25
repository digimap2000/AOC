#!/usr/bin/perl
use Math::Round qw/round/;

sub digitTranslate {
    my $codes = {'-2' => '=', '=' => '-2', '-1' => '-', '-' => '-1'};
    return defined $codes->{@_[0]} ? $codes->{@_[0]} : @_[0];
}

sub toSnafu {
    my ($dec,$ans) = @_;
    for (reverse 0..31)
    {
        $base = 5 ** $_;
        $digit = round($dec / $base);
        $dec -= $base * $digit;
        $ans .= digitTranslate($digit) if $ans || $digit ne '0';
    }
    return $ans;
}

sub toDecimal {
    my ($ans,$mul);
    $ans += (5 ** ++$mul) * digitTranslate($_) for (reverse split //, @_[0]);
    return $ans;
}

while (<>) {
    $acc += toDecimal($_);
}
print toSnafu($acc);
