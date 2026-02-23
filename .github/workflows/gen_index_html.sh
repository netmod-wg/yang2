#!/bin/bash
#
# enter directory
cd mysite/

# sort by last-update
for d in */; do
  DATE=`grep 'DATE:' $d/metadata.txt | sed 's/^DATE: //'`
  dd=`echo $d | sed 's#/$##'`
  echo "$dd $DATE" >> sort.txt
done
SORTED=`sort -r -k 2 sort.txt | awk '{print $1}'`

# create the index.html file
echo "<html>" > index.html
echo "<head>" >> index.html
echo "  <style>" >> index.html
echo "    table.bg { border-collapse: collapse; width: 100%; }" >> index.html
echo "    tr.bg:nth-child(odd) {background-color: #f2f2f2}" >> index.html
echo "    tr.bg:nth-child(even) {background-color: white}" >> index.html
echo "    th.bg    {background-color: #A0A0A0; color: white;}" >> index.html
echo "    th.bg,td.bg {padding: 15px; text-align: left; vertical-align: top;}" >> index.html
echo "    td.fg {text-align: right; vertical-align: bottom; white-space: nowrap;}" >> index.html
echo "  </style>" >> index.html
echo "  <base target=\"_blank\">" >> index.html
echo "</head>" >> index.html
echo "<body>" >> index.html
echo "<h1>Build artifacts for YANG2</h1>" >> index.html
echo "<i>Most recent first</i>" >> index.html
echo "<br><br>" >> index.html
echo "<table class=\"bg\">" >> index.html
echo "  <tr class=\"bg\">" >> index.html
echo "    <th class=\"bg\"><b>Updated</b></th>" >> index.html
echo "    <th class=\"bg\"><b>Pull Request</b></th>" >> index.html
echo "    <th class=\"bg\"><b>Merge Operation</b></th>" >> index.html
echo "    <th class=\"bg\"><b>Formats</b></th>" >> index.html
echo "    <th class=\"bg\"><b>Actions</b></th>" >> index.html
echo "  </tr>" >> index.html
for branch in $SORTED; do
  echo "  <tr class=\"bg\">" >> index.html
  NUMBER=`grep NUMBER $branch/metadata.txt | awk '{print $2}'`
  TITLE=`grep TITLE $branch/metadata.txt | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}'`
  DATE=`grep DATE $branch/metadata.txt | awk '{print $2}'`
  grep -q BASE $branch/metadata.txt || BASE="main" # delete this after PR #36 merges...
  grep -q BASE $branch/metadata.txt && BASE=`grep BASE $branch/metadata.txt | awk '{print $2}'`
  echo "    <td class=\"bg\" nowrap>$DATE</td>" >> index.html

  if [ $branch = "main" ]; then
    echo "    <td class=\"bg\">N/A, since this is the \"main\" branch (last updated by <a href=\"https://github.com/netmod-wg/yang2/pull/$NUMBER\">#$NUMBER: $TITLE</a>).</td>" >> index.html
  else
    echo "    <td class=\"bg\"><a href=\"https://github.com/netmod-wg/yang2/pull/$NUMBER\">#$NUMBER: $TITLE</a></td>" >> index.html
  fi

  if [ $branch = "main" ]; then
    echo "    <td class=\"bg\">N/A, since this is the <a href=\"https://github.com/netmod-wg/yang2/tree/main\">\"main\"</a> branch.</td>" >> index.html
  else
    echo "    <td class=\"bg\">Branch <a href=\"https://github.com/netmod-wg/yang2/tree/$branch\">\"$branch\"</a> merges into branch <a href=\"https://github.com/netmod-wg/yang2/tree/$BASE\">\"$BASE\"</a>.</td>" >> index.html
  fi

  echo "    <td nowrap class=\"bg\"> <table> <tr> <td nowrap><a href=\"$branch/draft-yn-netmod-yang2-00.html\">html</a> / <a href=\"$branch/draft-yn-netmod-yang2-00.txt\">text</a> / <a href=\"$branch/draft-yn-netmod-yang2-00.xml\">xml</a></td> </tr>  </table> </td>" >> index.html

  if [ $branch = "main" ]; then
    echo "    <td nowrap class=\"bg\"><a href=\"https://author-tools.ietf.org/iddiff?url_1=https://netmod-wg.github.io/yang2/main/rfc7950.txt&url_2=https://netmod-wg.github.io/yang2/main/draft-yn-netmod-yang2-00.txt\">Diff with RFC7950</a><br><a href=\"https://author-tools.ietf.org/api/iddiff?doc_1=draft-yn-netmod-yang2&url_2=https://netmod-wg.github.io/yang2/main/draft-yn-netmod-yang2-00.txt\"><s>Diff with Datatracker</s></a> </td>" >> index.html
  else
    echo "    <td nowrap class=\"bg\"> <a href=\"https://author-tools.ietf.org/api/iddiff?url_1=https://netmod-wg.github.io/yang2/$BASE/draft-yn-netmod-yang2-00.txt&url_2=https://netmod-wg.github.io/yang2/$branch/draft-yn-netmod-yang2-00.txt\">Diff with Main</a> </td>" >> index.html
  fi
  echo "  </tr>" >> index.html
done
echo "</table>" >> index.html
echo "</body>" >> index.html
