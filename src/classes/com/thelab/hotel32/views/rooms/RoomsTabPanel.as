package com.thelab.hotel32.views.rooms
{
	import com.thelab.hotel32.common.TabPanel;
	import com.thelab.hotel32.helpers.BasicButton;
	
	import org.osflash.signals.Signal;
	
	public class RoomsTabPanel extends TabPanel
	{
		public var thumbSender						: Signal;
		private var thumbButton						: RoomsGridThumbButton;
		
		public function RoomsTabPanel(name:String, pageXML:XMLList)
		{
			thumbSender = new Signal();
			super(name, pageXML);
		}
		
		override public function setup():void
		{
			thumbButton = new RoomsGridThumbButton("thumb");
			thumbButton.x = 38;
			thumbButton.y = 350;
			thumbButton.clickedSender.add(onThumbButtonClicked);
			addChild(thumbButton);
		}
		
		private function onThumbButtonClicked(which:BasicButton):void
		{
			thumbSender.dispatch();
		}
	}
}