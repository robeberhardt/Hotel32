package com.thelab.hotel32.views
{
	import com.thelab.hotel32.assets.fonts.FontLibrary;
	import com.thelab.hotel32.helpers.BasicTextField;

	public class OffersView extends BasicView
	{
		public function OffersView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			var myTextField : BasicTextField = new BasicTextField(FontLibrary.ARIAL_FORMAT, "SPECIAL OFFERS");
			addChild(myTextField);
			myTextField.size = 48;
			myTextField.x = 500;
			myTextField.y = 150;
			sendReady();
		}
	}
}