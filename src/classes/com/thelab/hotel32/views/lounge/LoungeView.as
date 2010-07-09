package com.thelab.hotel32.views.lounge
{
	import com.thelab.hotel32.CasinoImage;
	import com.thelab.hotel32.common.BackgroundLoader;
	import com.thelab.hotel32.common.PageButton;
	import com.thelab.hotel32.common.Panel;
	import com.thelab.hotel32.common.ToolTip;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.temp.CopyBox;
	import com.thelab.hotel32.views.BasicView;
	
	public class LoungeView extends BasicView
	{
		private var panel								: Panel;
		private var bgLoader							: BackgroundLoader;
		
		private var pano								: Panorama;
		private var panoTip								: ToolTip;
		
		public function LoungeView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			transitionStarted.add(onTransStart);
			transitionFinished.add(onTransEnd);
			
			bgLoader = new BackgroundLoader(pageXML..images);
			addChild(bgLoader);
			bgLoader.show();
			
			panel = new Panel("loungePanel", pageXML..panel);
			addChild(panel);
			
			panel.paginatorReady.addOnce( function()
			{
				panel.paginator.selectedSender.add(onPageSelected);
				panel.active = false;
			});
			
			pano = new Panorama(pageXML..panorama);
			pano.ready.addOnce(onPanoLoaded);
			pano.closed.add(onPanoClosed);
			addChild(pano);
			
			panoTip = new ToolTip(pageXML..panorama.tip.@text.toString());
			panoTip.clickedSender.add(onTipClicked);
			panoTip.x = 460;
			panoTip.y = 250;
			addChild(panoTip);
			
			sendReady();
		}
		
		private function onPanoLoaded():void
		{
			panoTip.show();
		}
		
		private function onTipClicked():void
		{
			switchToPano();	
		}
		
		private function switchToPano():void
		{
			pano.show();
			panoTip.hide();
			bgLoader.hide();
			panel.hide();
		}
		
		private function onPanoClosed():void
		{
			pano.hide();
			panoTip.show();
			bgLoader.show();
			panel.show();
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
					pano.active = false;
//					if (pano.active) { onPanoClosed(); }
					break;
			}
		}
		
		private function onTransEnd(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					pano.load();
					break;
				
				case TRANSITION_OUT :
					panel.active = false;
					onPanoClosed();
					break;
			}
		}
	}
}