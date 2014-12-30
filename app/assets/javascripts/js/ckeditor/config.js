/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	config.extraPlugins = 'youtube';
	config.youtube_width = '590';
	config.filebrowserBrowseUrl = server_url+'/filemanager/browser/default/browser.html?Connector='+server_url+'/filemanager/connectors/php/connector.php',
    config.filebrowserImageBrowseUrl = server_url+'/filemanager/browser/default/browser.html?type=Image&Connector='+server_url+'/filemanager/connectors/php/connector.php';
  //  config.filebrowserFlashBrowseUrl =server_url+'/filemanager/browser/default/browser.html?type=Flash&currentFolder=/Flash/';
  //  config.filebrowserUploadUrl =server_url+'/filemanager/connectors/php/filemanager.cfm?mode=add&type=Files&currentFolder=/File/';
   // config.filebrowserImageUploadUrl =server_url+'/filemanager/connectors/php/filemanager.cfm?mode=add&type=Image&currentFolder=/Image/';
  //  config.filebrowserFlashUploadUrl = server_url+'/filemanager/connectors/php/filemanager.cfm?mode=add&type=Flash&currentFolder=/Flash/';
  

};
