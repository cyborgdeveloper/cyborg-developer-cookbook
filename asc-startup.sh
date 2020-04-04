#!/bin/sh
release_folder=dist
log=asciidoctor.log

book_name=cyborg-developer-cookbook
book_name_asc=$book_name.asc

version=${1:-development}

revdate=$(date '+%Y-%m-%d')
params="--attribute revnumber=$version --attribute revdate=$revdate -D $release_folder"

mkdir -p $release_folder

printf "\n--------------------------------------------------------\n" >> $log
printf "$(date '+%Y-%m-%d %H:%M:%S') ---------- Exporting book formats...\n" >> $log

printf "Converting to HTML...\n"
asciidoctor $params $book_name_asc >> $log
printf " -- HTML output at $book_name.html\n"

printf "Converting to EPub...\n"
asciidoctor-epub3 $params $book_name_asc >> $log
printf " -- Epub output at $book_name.epub\n"

printf "Converting to Mobi (kf8)...\n"
asciidoctor-epub3 $params -a ebook-format=kf8 $book_name_asc >> $log
printf " -- Mobi output at $book_name-kf8.epub\n"
printf " -- Mobi output at $book_name.mobi\n"
printf " -- Mobi output at $book_name.mobi8\n"

printf "Converting to PDF... (this one takes a while)\n"
asciidoctor-pdf $params $book_name_asc 2>/dev/null >> $log
printf " -- PDF  output at $book_name.pdf\n"

printf "Converting to PDF (toc with 3 levels)... (this one takes a while again)\n"
asciidoctor-pdf $params -a toclevels=3 -o $book_name-detailed-toc.pdf $book_name_asc 2>/dev/null >> $log
printf " -- PDF  output at $book_name-detailed-toc.pdf\n"
