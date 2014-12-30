<!---
	image.cfc v2.19, written by Rick Root (rick@webworksllc.com)
	Derivative of work originally done originally by James Dew.

	Related Web Sites:
	- http://www.opensourcecf.com/imagecfc (home page)
	- http://www.cfopen.org/projects/imagecfc (project page)

	LICENSE
	-------
	Copyright (c) 2007, Rick Root <rick@webworksllc.com>
	All rights reserved.

	Redistribution and use in source and binary forms, with or
	without modification, are permitted provided that the
	following conditions are met:

	- Redistributions of source code must retain the above
	  copyright notice, this list of conditions and the
	  following disclaimer.
	- Redistributions in binary form must reproduce the above
	  copyright notice, this list of conditions and the
	  following disclaimer in the documentation and/or other
	  materials provided with the distribution.
	- Neither the name of the Webworks, LLC. nor the names of
	  its contributors may be used to endorse or promote products
	  derived from this software without specific prior written
	  permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
	CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
	SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
	OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

	============================================================
	This is a derivative work.  Following is the original
	Copyright notice.
	============================================================

	Copyright (c) 2004 James F. Dew <jdew@yggdrasil.ca>

	Permission to use, copy, modify, and distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.

	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
--->
<!---
	SPECIAL NOTE FOR HEADLESS SYSTEMS
	---------------------------------
	If you get a "cannot connect to X11 server" when running certain
	parts of this component under Bluedragon (Linux), you must
	add "-Djava.awt.headless=true" to the java startup line in
	<bluedragon>/bin/StartBluedragon.sh.  This isssue is discussed
	in the Bluedragon Installation Guide section 3.8.1 for
	Bluedragon 6.2.1.

	Bluedragon may also report a ClassNotFound exception when trying
	to instantiate the java.awt.image.BufferedImage class.  This is
	most likely the same issue.

	If you get "This graphics environment can be used only in the
	software emulation mode" when calling certain parts of this
	component under Coldfusion MX, you should refer to Technote
	ID #18747:  http://www.macromedia.com/go/tn_18747
--->

<cfcomponent displayname="Image">

<cfset variables.throwOnError = "Yes">
<cfset variables.defaultJpegCompression = "90">
<cfset variables.interpolation = "bicubic">
<cfset variables.textAntiAliasing = "Yes">
<cfset variables.tempDirectory = "#expandPath(".")#">

<cfset variables.javanulls = "no">
<cftry>
	<cfset nullvalue = javacast("null","")>
	<cfset variables.javanulls = "yes">
	<cfcatch type="any">
		<cfset variables.javanulls = "no">
		<!--- javacast null not supported, so filters won't work --->
	</cfcatch>
</cftry>
<!---
<cfif javanulls>
	<cfset variables.blurFilter = createObject("component","blurFilter")>
	<cfset variables.sharpenFilter = createObject("component","sharpenFilter")>
	<cfset variables.posterizeFilter = createObject("component","posterizeFilter")>
</cfif>
--->

<cfset variables.Math = createobject("java", "java.lang.Math")>
<cfset variables.arrObj = createobject("java", "java.lang.reflect.Array")>
<cfset variables.floatClass = createobject("java", "java.lang.Float").TYPE>
<cfset variables.intClass = createobject("java", "java.lang.Integer").TYPE>
<cfset variables.shortClass = createobject("java", "java.lang.Short").TYPE>

<cffunction name="getImageInfo" access="public" output="true" returntype="struct" hint="Rotate an image (+/-)90, (+/-)180, or (+/-)270 degrees.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var img = "">

	<cfset retVal.errorCode = 0>
	<cfset retVal.errorMessage = "">

	<cfif inputFile neq "">
		<cfset loadImage = readImage(inputFile, "NO")>
		<cfif loadImage.errorCode is 0>
			<cfset img = loadImage.img>
		<cfelse>
			<cfset retVal = throw(loadImage.errorMessage)>
			<cfreturn retVal>
		</cfif>
		<cfset retVal.metaData = getImageMetadata(loadImage.inFile)>
	<cfelse>
		<cfset img = objImage>
		<cfset retVal.metadata = getImageMetadata("")>
	</cfif>
	<cftry>
		<cfset retVal.width = img.getWidth()>
		<cfset retVal.height = img.getHeight()>
		<cfset retVal.colorModel = img.getColorModel().toString()>
		<cfset retVal.colorspace = img.getColorModel().getColorSpace().toString()>
		<cfset retVal.objColorModel = img.getColorModel()>
		<cfset retVal.objColorspace = img.getColorModel().getColorSpace()>
		<cfset retVal.sampleModel = img.getSampleModel().toString()>
		<cfset retVal.imageType = img.getType()>
		<cfset retVal.misc = img.toString()>
		<cfset retVal.canModify = true>
		<cfreturn retVal>
		<cfcatch type="any">
			<cfset retVal = throw( "#cfcatch.message#: #cfcatch.detail#")>
			<cfreturn retVal>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="getImageMetadata" access="private" output="false" returntype="query">
	<cfargument name="inFile" required="yes" type="Any"><!--- java.io.File --->

	<cfset var retQry = queryNew("dirName,tagName,tagValue")>
	<cfset var paths = arrayNew(1)>
	<cfset var loader = "">
	<cfset var JpegMetadatareader = "">
	<cfset var myMetadata = "">
	<cfset var directories = "">
	<cfset var currentDirectory = "">
	<cfset var tags = "">
	<cfset var currentTag = "">
	<cfset var tagName = "">

	<cftry>
	<cfscript>
		paths = arrayNew(1);
		paths[1] = expandPath("metadata-extractor-2.3.1.jar");
		loader = createObject("component", "javaloader.JavaLoader").init(paths);

		//at this stage we only have access to the class, but we don't have an instance
		JpegMetadataReader = loader.create("com.drew.imaging.jpeg.JpegMetadataReader");

		myMetaData = JpegMetadataReader.readMetadata(inFile);
		directories = myMetaData.getDirectoryIterator();
		while (directories.hasNext()) {
			currentDirectory = directories.next();
			tags = currentDirectory.getTagIterator();
			while (tags.hasNext()) {
				currentTag = tags.next();
				if (currentTag.getTagName() DOES NOT CONTAIN "Unknown") { //leave out the junk data
					queryAddRow(retQry);
					querySetCell(retQry,"dirName",replace(currentTag.getDirectoryName(),' ','_','ALL'));
					tagName = replace(currentTag.getTagName(),' ','','ALL');
					tagName = replace(tagName,'/','','ALL');
					querySetCell(retQry,"tagName",tagName);
					querySetCell(retQry,"tagValue",currentTag.getDescription());
				}
			}
		}
		return retQry;
		</cfscript>
		<cfcatch type="any">
			<cfreturn retQry />
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="flipHorizontal" access="public" output="true" returntype="struct" hint="Flip an image horizontally.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn flipflop(objImage, inputFile, outputFile, "horizontal", jpegCompression)>
</cffunction>

<cffunction name="flipVertical" access="public" output="true" returntype="struct" hint="Flop an image vertically.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn flipflop(objImage, inputFile, outputFile, "vertical", jpegCompression)>
</cffunction>

<cffunction name="scaleWidth" access="public" output="true" returntype="struct" hint="Scale an image to a specific width.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn resize(objImage, inputFile, outputFile, newWidth, 0, "false", "false", jpegCompression)>
</cffunction>

<cffunction name="scaleHeight" access="public" output="true" returntype="struct" hint="Scale an image to a specific height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfreturn resize(objImage, inputFile, outputFile, 0, newHeight, "false", "false", jpegCompression)>
</cffunction>

<cffunction name="resize" access="public" output="true" returntype="struct" hint="Resize an image to a specific width and height.">
	<cfargument name="objImage" required="yes" type="Any">
	<cfargument name="inputFile" required="yes" type="string">
	<cfargument name="outputFile" required="yes" type="string">
	<cfargument name="newWidth" required="yes" type="numeric">
	<cfargument name="newHeight" required="yes" type="numeric">
	<cfargument name="preserveAspect" required="no" type="boolean" default="FALSE">
	<cfargument name="cropToExact" required="no" type="boolean" default="FALSE">
	<cfargument name="jpegCompression" required="no" type="numeric" default="#variables.defaultJpegCompression#">

	<cfset var retVal = StructNew()>
	<cfset var loadImage = StructNew()>
	<cfset var saveImage = StructNew()>
	<cfset var at = "">
	<cfset var op = "">
	<cfset var w = "">
	<cfset var h = "">
	<cfset var scale = 1>
	<cfset var scaleX = 1>
	<cfset var scaleY = 1>
	<cfset var resizedImage = "">
	<cfset var rh = getRenderingHints()>
	<cfset var specifiedWidth = arguments.newWidth>
	<cfset var specifiedHeight = arguments.newHeight>
	<cfset var imgInfo = "">
	<cfset var img = "">
	<cfset var cropImageResult = "">
	<cfset var cropOffsetX = "">
	<cfset var cropOffsetY = "">

	<cfset ret