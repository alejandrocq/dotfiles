set nu

au VimLeave * set guicursor=a:ver25-blinkon0 | call chansend(v:stderr, "\027[ q")
