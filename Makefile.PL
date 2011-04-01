use inc::Module::Install;
name 'Data-Deduper';
all_from 'lib/Data/Deduper.pm';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
