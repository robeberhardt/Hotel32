package com.thelab.hotel32.views
{
	import com.thelab.hotel32.CasinoImage;
	import com.thelab.hotel32.common.PageButton;
	import com.thelab.hotel32.common.Panel;
	import com.thelab.hotel32.common.SimpleBackgroundLoader;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.temp.CopyBox;
	
	public class FoodView extends BasicView
	{
		private var panel								: Panel;
		private var bgLoader							: SimpleBackgroundLoader;
		
		public function FoodView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			transitionStarted.add(onTransStart);
			transitionFinished.add(onTransEnd);
			
			bgLoader = new SimpleBackgroundLoader(pageXML..images);
			addChild(bgLoader);
			bgLoader.show();
			
			panel = new Panel("foodPanel", pageXML..panel);
			addChild(panel);
			
			panel.paginatorReady.addOnce( function()
			{
				panel.paginator.selectedSender.add(onPageSelected);
				panel.active = false;
			});
			
			sendReady();
		}
		
		private function onPageSelected(which:PageButton):void
		{
			bgLoader.load(pageXML..images.image[which.index-1].@id.toString());
		}
		
		private function onTransStart(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					panel.active = true;
					break;
				
				case TRANSITION_OUT :
					
					break;
			}
		}
		
		private function onTransEnd(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					
					break;
				
				case TRANSITION_OUT :
					panel.active = false;
					break;
			}
		}
	}
}