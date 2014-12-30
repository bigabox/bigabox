<?php

$base_path = getcwd();
$new_img = $_POST['new_img'];
$folder = $_POST['folder'];
// Create image instances
$image_width  = $_POST['img_width'];
$image_height = $_POST['img_height'];

$source_x = $_POST['source_x'];
$source_y = $_POST['source_y'];
$src_path =$base_path."/public/data/orig/".$folder."/".$new_img;
$src = imagecreatefromjpeg($src_path);
$dest = imagecreatetruecolor($image_width, $image_height);
$cache_path =  $base_path."/public/data/thumb/".$folder."/".$new_img;
// Copy
imagecopy($dest, $src, 0, 0, $source_x, $source_y, $image_width, $image_height);

// Output and free from memory
//header('Content-Type: image/jpeg');
imagejpeg($dest,$cache_path);

imagedestroy($dest);
imagedestroy($src);

/*
  // Create image instances
  $src = imagecreatefromjpeg('test.jpg');
  $dest = imagecreatetruecolor(100, 100);

  // Copy
  imagecopy($dest, $src, 392, 100, 492, 200, 100, 100);

  // Output and free from memory
  header('Content-Type: image/jpeg');
  imagejpeg($dest);

  imagedestroy($dest);
  imagedestroy($src); */
?>

