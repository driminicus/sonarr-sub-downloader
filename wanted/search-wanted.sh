#!/bin/bash

declare WANTED_FILE=`dirname $0`/subs.wanted

declare MISSED=""
echo "###### Process started at: $(date) ######"

while IFS=':' read -a line; do
  SOURCE=${line[0]}
  SRT=${line[1]}
  LANG=`echo $SRT | sed -e "s/\.srt//g" -e "s/.*\(..\)/\1/"`
  echo "subliminal download -l $LANG $SOURCE"
  docker run --rm --name subliminal -v subliminal_cache:/usr/src/cache -v /data/nethdd/Series:/tv -i diaoulael/subliminal download -l ${LANGUAGES}  "${EPISODE_PATH}" >> $LOG_FILE 2>&1
  SEARCHSRT=`echo $SRT | sed -e 's/tv/data\/nethdd\/Series/g'`
  if [[ ! -f $SEARCHSRT ]]; then
    IFS=''
    MISSED="$SOURCE:$SRT\n$MISSED"
    echo "Subtitle still not available"
  else
    echo "Great! we have found $SRT"
  fi
done < "$WANTED_FILE"

echo "Saving not found subtitles"
echo -en $MISSED > $WANTED_FILE
