#!/bin/bash
#
# Inspiration:
# https://stackoverflow.com/questions/42715785/how-do-i-show-statistics-for-authors-contributions-in-git/73781404#73781404

sorted_author_ids() {
  git log --format='author: %an' --numstat $FILE \
    | tr '[A-Z]' '[a-z]' \
    | grep -v '^$' \
    | grep -v '^-' \
    | gawk '
        {
            if ($1 == "author:") {
                author = $2;
                commits[author]++;
            } else {
                insertions[author] += $1;
                deletions[author] += $2;
                total[author] += $1 + $2;
                # if this is the first time seeing this file for this
                # author, increment their file count
                author_file = author ":" $3;
                if (!(author_file in seen)) {
                    seen[author_file] = 1;
                    files[author]++;
                }
            }
        }
        END {
            # sort and output authors by total lines
            n = asorti(total, sorted_emails, "@val_num_desc");
            for (i = 1; i <= n; i++) {
                email = sorted_emails[i];
                printf("%s\n", email);
            }
        }
'
}


sorted_xml_authors() {

  # get sorted list of authors
  AUTHORS=`sorted_author_ids`

  # output authors as an XML <author> element
  for a in $AUTHORS; do

    FULL_NAME=`grep $a $0 | awk -F'"' '{print $2}'`
    ORGANIZATION=`grep $a $0 | awk -F'"' '{print $4}'`
    FIRST_NAME=`echo $FULL_NAME | awk '{print $1}'`
    LAST_NAME=`echo $FULL_NAME | awk '{print $2}'`
    FIRST_INITIAL=${FIRST_NAME:0:1}
    EMAIL=`grep $a $0 | awk -F'"' '{print $6}'`

    echo "<author initials=\"$FIRST_INITIAL\" surname=\"$LAST_NAME\" fullname=\"$FULL_NAME\">"
    echo "    <organization>$ORGANIZATION</organization>"
    echo "    <address>"
    echo "        <email>$EMAIL</email>"
    echo "    </address>"
    echo "</author>"
  done
}


main() {
  SORTED_XML=`sorted_xml_authors`
  if [[ "$?" -ne "0" ]]; then
     echo error!
     exit 1
  fi
  echo "$SORTED_XML" > .authors.txt
}


main "$@"


#### AUTHOR INFO ####
#kwatsen: "Kent Watsen" "Watsen Networks" "kent+ietf@watsen.net"
