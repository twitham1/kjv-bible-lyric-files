# kjvmp3 config file

my $who = 'Stephen Johnston';
my $file = '66_Revelation_22.mp3';
-f $file
    or die "$file not found, are you sure this is $who?";

return {
    mp3file => sub {
	my($book, $chap) = @_;
	# tweaks to match zip filenames as/of 2022
	$book =~ s/ /_/g;
	$book =~ s/^III_/3/ or $book =~ s/^II_/2/ or  $book =~ s/^I_/1/;
	$book =~ s/_of_John//;
	$book =~ s/Psalms/Psalm/;
	$book =~ s/Proverbs/Prov/;
	$book =~ s/Solomon/Soloman/; # files are misspelled...
	$book =~ s/Daniel/Daniell/;
	$book =~ s/Corinthians/Cor/; # ... or abbreviated
	$book =~ s/Galatians/Gal/;
	$book =~ s/Thessalonians/Thess/;
	my $n = $book =~ /Psalm/ ? 3 : 2;
	$chap = sprintf "%s_%0${n}d", $book, $chap;
	my $file = (grep /$chap.mp3/, @mp3)[0]
	    || (grep /$book.mp3/, @mp3)[0] || 0;
	return $file;
    },
    length => sub {
	my($sec, $chap, $next) = @_;
	return $sec - 3;	# 3 second silent tail
    },
};
