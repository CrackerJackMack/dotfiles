alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias fis="sudo eix-sync && sudo update-eix-remote update"
alias fiuw="sudo emerge --update --newuse --deep --ask -vt world"
alias fic="sudo emerge --ask -v --depclean && sudo eclean -d distfiles && sudo eclean -d packages && sudo etcportclean -c111111 -r1 -w1 -d1 -v1 && sudo find /var/log/ -name "*.log" -mtime +1 -exec bzip2 -z '{}' \; && sudo find /var/log -name "*.bz2" -mtime +30 -exec rm '{}' \;"
alias fir="sudo revdep-rebuild -v"
alias treport="/usr/local/lib/tsung/bin/tsung_stats.pl; firefox report.html"


