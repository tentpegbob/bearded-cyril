#!/usr/bin/perl
# This program was written by Leander Metcalf II
# 19 May 2015
#
# This program will sort and organize jpg files
# created by an iphone by year, month, and day.
#
# Simply ensure that this program is inside the
# directory you want all your files sorted inside.
#
# Usage: ./organize

$|=1;

use File::Copy qw(move);

$dir = "*.jpg";
@pic_files = glob($dir);
$num_of_files = @pic_files;
@errors;
@months = qw| 00
01--January 02--February 03--March 04--April 05--May
06--June 07--July 08--August 09--September 10--October
11--November 12--December|;

@abbrev_months = qw| 00
Jan- Feb- Mar- Apr- May- Jun-
Jul- Aug- Sep- Oct- Nov- Dec-|;

@nums = qw| 00 01 02 03 04 05 06 07 08 09|;


print "\n[+] Sorting and organizing $num_of_files jpg picture(s) ... \n";
foreach(@pic_files){
	my $tmp = $_, $day, $dir;
	   @folder_dates = split(/-| /, $_);

	if($folder_dates[2] < 10){
		$day = $abbrev_months[$folder_dates[1]] . $nums[$folder_dates[2]];}
	else {
		$day = $abbrev_months[$folder_dates[1]] . $folder_dates[2];}
	
	$dir = $folder_dates[0];
	mkdir ($dir);
	$dir .= "/" . $months[$folder_dates[1]];
	mkdir ($dir);
	$dir .= "/" . $day;
	mkdir ($dir);
	$dir .= "/" . $tmp;

	open DATA, "<$dir" or move ($tmp, $dir);

	if(<DATA>){
		close (DATA) or die "\t[-] Couldn't close $dir properly.\n";
		push (@errors, "\t[-] $tmp  already exists, try renaming the file.\n");}
}

$tmp = @errors;
print "\n[+] There was $tmp error(s).\n";
foreach(@errors){
	print;}

print "\n[+] Done! Kiss the Nerd Bear!!!\n" .
	  "[+] Need it to do more? Ask hubby.\n\n";
