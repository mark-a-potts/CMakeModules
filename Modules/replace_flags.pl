#!/usr/bin/perl

  @lines = split(/\n/,`grep set GNU.cmake`);
  foreach(@lines) {
    $line = $_;
    @words = split(/\(/,$line);
    $data = @words[1];
    @words = split(/\"/,$data);
    $flagname = @words[0];
    $flag = @words[1];
    $flagname =~ s/\s+$//;
#   print("$flagname and $flag\n");
    $command = "sed -i \'s/$flag/\${$flagname}/g\' setGNUFlags.cmake";
#   $command = "sed -i ";
    print("$command\n");
    system($command);
  }
