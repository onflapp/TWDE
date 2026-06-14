#!/bin/perl

$CTRL_PIPE_PATH='/tmp/ctrl';

use IO::Select;
use POSIX qw(mkfifo);

binmode STDIN;
binmode STDOUT;

sub read_action {
  my $line = <$ctrl_pipe>;
  chomp($line);
  
  return $line;
}

sub read_message {
  my $buff = '';
  my $rv = 0;
  my $sz = 0;

  ### read size of the message
  $rv = read(STDIN, $buff, 4);

  die $! if not defined $rv;
  die "nothing to read" if not $rv;

  $sz = unpack('L', $buff);
  die "invalid message size" if ($sz <= 0);

  ### read rest of the message
  $rv = read(STDIN, $buff, $sz);

  die $! if not defined $rv;
  die "nothing to read" if not $rv;

  return $buff;
}

sub write_message {
  my ($msg) = @_;
  my $sz = 0;

  $msg = "\"".$msg."\"";
  $sz = length($msg);

  if ($sz > 0) {
    print(STDOUT pack('L', $sz));
    print(STDOUT $msg);
    STDOUT->flush();
  }
}

sub open_pipe {
  if (! -p $CTRL_PIPE_PATH) {
    mkfifo($CTRL_PIPE_PATH, 0700) || die 'unable to create a control pipe';
  }
  open($ctrl_pipe, '<', $CTRL_PIPE_PATH) || die 'unable open open control pipe';
}

open_pipe();

$select = IO::Select->new();
$select->add(\*STDIN);
$select->add($ctrl_pipe);

while(my @ready = $select->can_read()) {
  foreach my $f (@ready) {
    die "stream closed" if not defined $f;

    if ($f == \*STDIN) {
      $msg = read_message();
    }
    elsif ($f == $ctrl_pipe) {
      if (eof($ctrl_pipe)) {
        open_pipe();
      }
      $act = read_action();
      write_message($act);
    }
    last;
  }
}
