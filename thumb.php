<?php

		//echo 'test'; die;

		//$image_settings = get_image_setting_data();	

		echo getcwd();

		 $base_path = getcwd();

		 $new_img = $_POST['new_img'];

		 $folder = $_POST['folder'];

		 

		$new_w = 175;//$image_settings['p_width']; //You can change these to fit the width and height you want

		$new_h = 175;//$image_settings['p_height'];

		

		require_once 'thumbgenerator/ThumbLib.inc.php';

		$thumb = PhpThumbFactory::create( $base_path."/public/data/orig/".$folder."/".$new_img);

		$thumb->adaptiveResize($new_w,$new_h);

		$cache_path =  $base_path."/public/data/thumb/".$folder."/".$new_img;

		$thumb->save($cache_path);

		die;

?>