package com.thelab.hotel32.common
{
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Utils
	{
		
		/*
		* FUNCTION getURL (url:String, window:String):void
		* 
		* Replaces the AS2-style getURL function with some simple error trapping
		* Valid values for window = "_blank", "_self"
		* 
		*/
		
		public static function getURL(url:String, window:String = null):void {
			var req:URLRequest = new URLRequest(url);
			trace("getURL "+ url);
			try
			{
				navigateToURL(req, window);
			}
			catch (e:Error)
			{
				trace("Navigate to URL failed "+ e.message);
			}
		}
		
		/*
		* FUNCTION: stringToHTML (inputString:String) : String
		* 
		* Parses an HTML string and replaces Unicode tags with the actual characters for curly
		* quotes, apostrophes and other special characters
		*
		*/
		
		public static function stringToHTML(inString:String) : String {
			
			var out:String = inString;
			out = out.split("<br>").join("\n"); // line break
//			out = out.split("&#233;").join("é"); // accented e
//			out = out.split("’").join("\'") // handle curly apos in xml
//			out = out.split("’").join("&apos;");
//			out = out.split("#8220;").join("“"); // double left quote
//			out = out.split("#8221;").join("”"); // double right quote
//			out = out.split("&#8217;").join(String.fromCharCode(8217)); // single right quote / apostrophe
//			out = out.split("&lt;").join("<"); // less than
//			out = out.split("&gt;").join(">"); // greater than
//			out = out.split("&quot;").join("\""); // straight double quote
//			out = out.split("&apos;").join("\'"); // straight single quote
			
							
			return unescape(out);
		}
	}
}