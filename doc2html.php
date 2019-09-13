#!/usr/bin/env php

<?php

require_once __DIR__ . '/vendor/autoload.php';

$files = glob(__DIR__ . "/*.docx");

foreach ($files as $file) {
    $source = \PhpOffice\PhpWord\IOFactory::load($file);
    $writer = \PhpOffice\PhpWord\IOFactory::createWriter($source, 'HTML');
    $name   = str_replace(".docx", ".html", $file);
    
    try {
        $writer->save($name);
        echo "successfully converted to html:\r\n - $name\n";
    } catch(\PhpOffice\PhpWord\Exception\Exception $e) {
        echo $e->getMessage();
    }
}
?>
