$documents_dir = ''

$word = New-Object -ComObject Word.Application

Get-ChildItem -Path $documents_dir -Filter *.doc? | ForEach-Object {
    $document     = $word.Documents.Open($_.FullName)
    $pdf_filename = "$($_.DirectoryName)\$($_.BaseName).pdf"
    $document.SaveAs([ref] $pdf_filename, [ref] 17)
    $document.Close()
}

$word_app.Quit()
