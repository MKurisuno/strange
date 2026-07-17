#! /bin/sh

for source in "$@"; do
    case $source in
	*ChangeLog|*changelog) 
            source-highlight --failsafe -f esc --lang-def=changelog.lang --style-file=esc.style -i "$source" ;;
	*Makefile|*makefile) 
            source-highlight --failsafe -f esc --lang-def=makefile.lang --style-file=esc.style -i "$source" ;;
	*.tar|*.tgz|*.gz|*.bz2|*.xz)
	    lesspipe "$source" ;;
	*.zshrc)
		source-highlight --failsafe -f esc256 --lang-def=zsh.lang --style-file=$HOME/.source-highlight/custom.style   -i "$source" ;;
        *) source-highlight --failsafe --infer-lang -f esc256 --style-file=$HOME/.source-highlight/custom.style -i "$source" ;;
    esac
done
