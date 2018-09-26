#!/usr/bin/env perl
package dbLib;
use warnings;
use strict;
use Exporter;

# ues path to create a path more easily
use File::Path qw(make_path);
use File::Copy;
our @ISA= qw( Exporter );
# these are exported by default.
our @EXPORT = qw(init_db get_branch_path set_cur_branch get_cur_branch
get_working_file_path add_commit get_cur_ver get_file_path_by_ver
get_working_ops_file uniq get_track_files get_file_content_by_ver
get_working_delete woring_ops_duplicate_remove remove_cache
get_content write_content);

sub get_working_file_path {
  my ($file) = @_;
  $file = (defined $file) ? $file : "";
  return ".legit/__meta__/work/$file"
}

sub uniq {
  my %seen;
  return grep { !$seen{$_}++ } @_;
}

sub get_content {
  # a helper function only read the whole file
  my ($file) = @_;
  open my $f, "<",$file;
  my @content = <$f>;
  close $f;
  return @content;
}

sub write_content($\@) {
  # helper function to write the whole file
  my ($file, $content_ref) = @_;
  open my $f, ">", $file;
  print $f @$content_ref;
  close $f;
}




sub touch {
  # a quick version of map
  map {open my $f,">>",$_; close $f } @_;
}

sub get_working_ops_file {
  # if there's no exist, then touch the file
  my $op_file = ".legit/__meta__/ops";
  if (! -e $op_file){
    touch($op_file);
  }
  return $op_file;
}

sub woring_ops_duplicate_remove {
  my %cur_ops_files;
  # change the ops to an hash array
  map {
    $_=~/([AD]) ([^\n]*)/;
    $cur_ops_files{$2} = 1 if ($1 eq "A");
    $cur_ops_files{$2} = 0 if ($1 eq "D");
  } get_content(get_working_ops_file());


  # the file is tracking now
  my @track_array = get_track_files(get_cur_ver());
  my %tracking;
  map { $tracking{$_}++ } @track_array;

  my @final_operations;
  map {
    if ($cur_ops_files{$_} == 1) {
      push @final_operations, "A $_\n";
    }
    elsif ($cur_ops_files{$_} == 0 and exists $tracking{$_}) {
      # perform a delete action when it is tracking
      push @final_operations, "D $_\n";
    }
    # ignore the cases if the record is 0
    # notice it as remove but not add
  } sort keys %cur_ops_files;

  # push the final operation to the file
  write_content(
    get_working_ops_file(), @final_operations
  );
}

sub remove_cache {
  my (@files) = @_;
  # file hash for remove operation quicker
  my %file_hash;
  map {!$file_hash{$_} ++ } @files;

  # remove the cached file in working
  map {
    unlink get_working_file_path($_) if -e get_working_file_path($_)
  } @files;

  # remove the record action of this working version
  my @content = get_content(get_working_ops_file());

  @content = grep  {
    $_ =~ /[AD] (.*)\\n/;
    # return those not we want to delete
    $_ if ! exists $file_hash{$1}
  } @content;


}



sub get_working_delete {
  # read all the pending operations
  open my $f, "<". get_working_ops_file;
  my @content = <$f>;
  close $f;

  # remove duplicate and grep those with D startup
  @content = uniq sort @content;
  @content =  grep {$_ =~ /^D/} @content;
  map {$_ =~ s/(^D |\n)//g} @content;
  return @content;
}


sub get_value_from_file {
  my ($file) = @_;
  # create a file to record the current branch
  open my $f, "<", $file;
  my @lines = <$f>;
  close $f;
  # return the first line, since it only has one line
  return $lines[0];
}

sub set_value_to_file {
  my ($file, $value) = @_;
  # create a file to record the current branch
  open F, ">", $file;
  print F $value;
  close F;
}

sub create_branch {
  my ($branch) = @_;

  # path to meta data for master branch
  my $path = get_branch_path($branch, "__meta__");

  # make a directory for this branch
  if (make_path($path)){
    # create an empty file for commits and operations
    touch("$path/commits","$path/ops","$path/currentVer");

    # successfully
    return 1;
  }
  # error occoured
  return 0;
}

sub set_cur_branch {
  return set_value_to_file(".legit/__meta__/cur_branch",@_);
}
sub get_cur_branch {
  return get_value_from_file(".legit/__meta__/cur_branch");
}

sub get_branch_path {
  # this function as a wrapper to generate the path to different
  # branch name
  my ($branch,$sub) = @_;
  # branch would be default to current branch
  $branch = (defined $branch and $branch ne "")? $branch : get_cur_branch();
  # mute the error by setting the default value
  $sub = (defined $sub and $branch ne "")? $sub: "";
  # generate the path
  return ".legit/$branch/$sub";
}


sub init_db {
  # create legit file sturecture
  # create a default branch name master
  if (
      make_path(get_working_file_path()) and
      create_branch("master") and
      set_cur_branch("master")
    ) {
    # init success fully

    return 1;
  }
  # else: some error occoured

  return 0;
}


#
# Commit support
#
sub get_cur_ver {
  # get the current branch's meta
  my $meta_path = get_branch_path(get_cur_branch(),"__meta__");
  my $cur_ver = get_value_from_file("$meta_path/currentVer");
  return int(defined $cur_ver? $cur_ver: -1);
}

sub add_commit {
  my ($commit) = @_;

  # ----
  # get the current branch's meta
  my $meta_path = get_branch_path("","__meta__");

  # fetch the current version
  my $cur_ver = get_cur_ver();

  # add up the current ver
  $cur_ver ++;

  # add the commit to record
  open my $commitFile,">>", "$meta_path/commits";
  print $commitFile  "$cur_ver $commit\n";

  # save the current vertion to file
  set_value_to_file("$meta_path/currentVer", $cur_ver);

  # ----
  # copy the file to the this version's directory to archive them

  #create a dir for current version
  my $archive_dir = get_branch_path("",$cur_ver);
  # get the global directory
  my $working_dir = get_working_file_path();
  # touch the archive folder
  make_path($archive_dir);
  # move all the working file to archive folder
  map {move($_,$archive_dir)} glob("$working_dir/*");

  # ----
  # add the track operations
  copy_op_file();
}

sub copy_op_file {
  my $cur_ver = get_cur_ver();
  open my $f,"<", get_working_ops_file();
  # print <$f>;
  my @lines = uniq(<$f>);
  close $f;
  # delete the old operations file
  unlink get_working_ops_file();

  # generate this version's option track
  open my $opt, ">", get_branch_path("","__meta__/$cur_ver.ops");
  # print @lines;
  print $opt @lines;
  close $opt
}

sub get_track_files {
  my ($version) = @_;

  # fetch all the tracked file from ops
  my @opfiles = glob get_branch_path("","__meta__/*.ops");
  if (!(defined $version and $version ne "")) {
    # version has a default is current version
    $version = get_cur_ver();
    # filter out those not valid for selected version
    @opfiles = grep {$_ =~ /(\d+)/; $1 <= $version} @opfiles;
    push @opfiles, get_working_ops_file();
  }
  else{
    # filter out those not valid for selected version
    @opfiles = grep {$_ =~ /(\d+)/; $1 <= $version} @opfiles;
  }


  my %trackfiles;
  foreach my $file (@opfiles) {
    open my $f,"<", $file;
    map {
      $_=~/([AD]) (.*)/;
      $trackfiles{$2} = 1 if $1 eq "A";
      $trackfiles{$2} = 0 if $1 eq "D";
    } <$f>;

    close $f;
  }

  # return all the currently tracking files
  return grep {$_ if $trackfiles{$_} == 1 } keys %trackfiles;
}


# ----
# show file function

sub get_file_path_by_ver{
  my ($version, $file)  = @_;

  # pop all the tracking files for this version
  my @track_files = get_track_files($version);
  my %track_files = map { $_ => 1 } @track_files;

  if (! (defined $version and $version ne "")) {
    # check whether there is a newer verion in working dir
    my $working_file =get_working_file_path($file);
    if (-e $working_file and $version eq ""){
      return $working_file;
    }
    else{
      # fetch the latest verion
      $version = get_cur_ver();
    }
  }

  if( int($version) >  int(get_cur_ver())){
    # die for fetch error
    print STDERR "legit.pl: error: unknown commit '$version'\n";
    exit 1 ;
  }

  # this is not tracking for this version;
  if (! exists $track_files{$file}) {
    return "";
  }

  # search till i found the latest version of this file
  for (my $ver = $version; $ver >= 0; $ver--) {
    # show the version of this file;
    # print("searched",get_branch_path("", "$ver/$file"),"\n");
    if(-e get_branch_path("", "$ver/$file")){
      return get_branch_path("", "$ver/$file");
    }
  }
  # ile not found
  return "";
}

sub get_file_content_by_ver {
  # return the content array of the file
  my ($version, $file) = @_;

  # fetch the path
  my $path = get_file_path_by_ver($version, $file);
  if ($path eq "") {
    return "";
  }

  open my $f, "<", $path;
  my @content = <$f>;
  close $f;
  # return the read content
  return @content
}



1;
