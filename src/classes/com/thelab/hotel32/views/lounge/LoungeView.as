package com.thelab.hotel32.views.lounge
{
	import com.greensock.loading.LoaderStatus;
	import com.thelab.hotel32.CasinoImage;
	import com.thelab.hotel32.common.BackgroundLoader;
	import com.thelab.hotel32.common.PageButton;
	import com.thelab.hotel32.common.Panel;
	import com.thelab.hotel32.common.ToolTip;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.temp.CopyBox;
	import com.thelab.hotel32.views.BasicView;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class LoungeView extends BasicView
	{
		private var panel								: Panel;
		private var bgLoader							: BackgroundLoader;
		
		private var pano								: Panorama;
		private var panoTip								: ToolTip;
		private var wedge								: WedgeTag;
		private var loadTimer							: Timer;
		private var timerSignal							: NativeSignal;
		
		public function LoungeView(name:String=null)
		{
			super(name);
		}
		
		override public function setup():void
		{
			transitionStarted.add(onTransStart);
			transitionFinished.add(onTransEnd);
			
			loadTimer = new Timer(500, 1);
			timerSignal = new NativeSignal(loadTimer, TimerEvent.TIMER, TimerEvent);
			timerSignal.addOnce(onLoadTimer);
//			loadTimer.addEventListener(TimerEvent.TIMER, onLoadTimer);
			
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
			pano.progress.add(onPanoLoadProgress);
			pano.ready.addOnce(onPanoLoaded);
			pano.closed.add(onPanoClosed);
			addChild(pano);
			
			panoTip = new ToolTip(pageXML..panorama.tip.@text.toString());
			panoTip.clickedSender.add(onTipClicked);
			panoTip.x = 460;
			panoTip.y = 250;
			
			panoTip.ready.addOnce( function()
			{
				wedge = new WedgeTag(panoTip.width, Math.abs(panoTip.asset.fill.y), 1, 0xFFFFFF);
				addChildAt(wedge, numChildren-1);
				wedge.x = panoTip.x;
				wedge.y = panoTip.y;
				wedge.asset.fill.scaleX = panoTip.asset.fill.scaleX;
			});
			addChild(panoTip);
		
			sendReady();
		}
		
		private function onPanoLoadProgress(prog:Number):void
		{
			Logger.log("panoLoad: " + prog);
			wedge.progress = prog;
		}
		
		private function onPanoLoaded():void
		{
			panoTip.show();
			loadTimer.stop();
			wedge.hide();
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
		
		private function onLoadTimer(e:TimerEvent):void
		{
			Logger.log("SHOWING WEDGE!", 3);
			wedge.show();
		}
		
		private function onTransEnd(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					if (pano.status == LoaderStatus.READY)
					{
						Logger.log("LOADING PANO");
						pano.load();
						loadTimer.start();
					}
					
					break;
				
				case TRANSITION_OUT :
					panel.active = false;
					onPanoClosed();
					break;
			}
		}
	}
}