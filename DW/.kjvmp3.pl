# kjvmp3 config file

my $who = 'Dan Wagner';
my $file = '66_Revelation022.mp3';
-f $file
    or die "$file not found, are you sure this is $who?";

return {
    mp3file => sub {
	my($book, $chap) = @_;
	# tweaks to match zip filenames as/of 2022
	$book =~ s/ /_/g;
	$book =~ s/^III_/3/ or $book =~ s/^II_/2/ or  $book =~ s/^I_/1/;
	$book =~ s/_of_John//;
	$chap = sprintf "%s%03d", $book, $chap;
	my $file = (grep /_$chap.mp3/, @mp3)[0]
	    || (grep /_$book.mp3/, @mp3)[0] || 0;
	return $file;
    },
    length => sub {
	my($sec, $chap, $next) = @_;

	# Fix Pss 145 by ending time before the included Pss 146:1-8
	$chap eq 'Psalms Chapter 145' and $sec = 2 * 60 + 19;

	# Fix Nah 3 by ending time after the missing Nah 3:17-19
	$chap eq 'Nahum Chapter 3' and $sec = 3 * 60 + 20;

	return $sec - 3;	# 3 second silent tail
    },
};
