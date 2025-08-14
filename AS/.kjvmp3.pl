# kjvmp3 config file

my $who = 'Alexander Scourby';
my $file = 'Revelations 22.mp3';
-f $file
    or die "$file not found, are you sure this is $who?";

return {
    mp3file => sub {
	my($book, $chap) = @_;
	# tweaks to match zip filenames as/of 2024
	$book =~ s/^III /3/ or $book =~ s/^II /2/ or  $book =~ s/^I /1/;
	$book =~ s/ of John//;
	$book =~ s/^([123])(\S+)/$1 $2/;
	$book =~ s/Psalms/Psalm/;
	$book =~ s/(Revelation)\b/$1s/;
	for my $n (3, 2, 1) {
	    my $file = sprintf "%s %0${n}d.mp3", $book, $chap;
	    grep /^$file$/, @mp3 and return $file;
	}
	# 1 chapter books:
	grep /^$book.mp3$/, @mp3 and return "$book.mp3";
	return 0;
    },
    length => sub {
	my($sec, $chap, $next) = @_;
	(my $book = $chap) =~ s/ Chapter.*//;
	# warn "config $sec $chap $next\n";
	
	# book closing statement runs longer past the text
	$next =~ /^$book / or return $sec - 7;

	# 2 second silent tail
	return $sec - 2;
    },
};

# optional text/audio sync points follow in format:
# AbbreviatedBook
# Chapter:Verse Minutes:Seconds
__END__
1Sam
14:4 0:31
14:19 2:47
14:24 3:32
14:33 4:54
14:36 5:29
14:47 7:21
15:6 0:42
15:10 1:25
15:20 2:56
15:24 3:44
15:32 4:58
