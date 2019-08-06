bulkrename() {
    OLDFILENAMES=$(mktemp)
    RENAMETMP=$(mktemp)
    ls *$1 | tee $OLDFILENAMES > $RENAMETMP && nvim $RENAMETMP
    for oldnum in $(seq 1 $(cat $OLDFILENAMES | wc -l)); do
        for newnum in $(seq 1 $(cat $RENAMETMP | wc -l)); do
            if [ "$(sed "${oldnum}q;d" $OLDFILENAMES)" = \
                "$(sed "${newnum}q;d" $RENAMETMP)" ] \
                && [ $oldnum != $newnum ]; then
                echo "File Naming Confict" && return 0
            fi
        done
    done
    for oldnum in $(seq 1 $(cat $OLDFILENAMES | wc -l)); do
        [ -f "$(sed "${oldnum}q;d" $RENAMETMP)" ] || \
        mv "$(sed "${oldnum}q;d" $OLDFILENAMES)" \
            "$(sed "${oldnum}q;d" $RENAMETMP)"
    done
    rm $OLDFILENAMES $RENAMETMP
}