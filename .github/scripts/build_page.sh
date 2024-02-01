
P_DRIVE=/media/github

./kerberos_auth.sh

timestamp=$(date "+%Y_%m_%d")
path=$P_DRIVE/$timestamp/$RUN_NUMBER

cd $path
index_html=index.html
links=$(find -P . -name index.html -type f -printf "%h\n" | sed 's;^\./;;' | sed 's;^\(.*\)$;<li><a href="./\1/index.html">\1</a></li>;')

echo links $links

echo '' > $index_html

echo '<!DOCTYPE html>'                                    >> $index_html
echo '<html lang="en">'                                   >> $index_html
echo '<head>'                                             >> $index_html
echo   '<title>Test Run ${{ github.run_number }}</title>' >> $index_html
echo '</head>'                                            >> $index_html
echo '<body>'                                             >> $index_html
echo   "<h2>Test Run $RUN_NUMBER ($timestamp)</h2>"       >> $index_html
echo   '<ul style="list-style: none;">'                   >> $index_html
echo     $links                                           >> $index_html
echo   '</ul>'                                            >> $index_html
echo '</body>'                                            >> $index_html
echo '</html>'                                            >> $index_html

cat $index_html

chmod -c -R +rX $path

tar \
    --dereference --hard-dereference \
    --directory $path \
    -cf "artifact.tar" \
    --exclude=.git --exclude=.github \
    . || true # prevents the command from returning 1 as a warning which fails the entire workflow
