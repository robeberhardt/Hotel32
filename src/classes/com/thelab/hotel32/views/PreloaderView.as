package com.thelab.hotel32.views
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.ContentDisplay;
	import com.thelab.hotel32.PreloaderAsset;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	
	import org.osflash.signals.Signal;

	public class PreloaderView extends BasicView
	{
		private var preloader									: MovieClip;

		public var halfLoaded									: Signal;
		public var allLoaded									: Signal;
		
		/*   since we never know whether we're loaded first or the animation
		*   finishes first, these flags let us loop through completion twice
		*   to make sure we're REALLY ready to move on - they start out false
		*   and are set to true the first time through the completion handler */
		private var halfLoadedFlag								: Boolean = false;
		private var allLoadedFlag								: Boolean = false;
		
		private var timingMultiplier							: Number = .16;
		
		public var beginPhaseTwo								: Signal;
		public var preloadCompleted								: Signal;
		
		public function PreloaderView(name:String=null)
		{
			super(name);
			halfLoaded = new Signal();
			allLoaded = new Signal();
			beginPhaseTwo = new Signal();
			preloadCompleted = new Signal();
		}
		
		override public function setup():void
		{
			preloader = new PreloaderAsset();
			
			preloader.x = AppStage.getInstance().center.x;
			preloader.y = AppStage.getInstance().center.y;
			
			preloader.peopleClip.visible = false;
			preloader.peopleClip.alpha = 0;
			preloader.peopleTextClip.textmask.gotoAndStop(0);
			preloader.peopleTextClip.visible = false;
			preloader.peopleTextClip.alpha = 0;
			
			preloader.planeTextClip.visible = false;
			preloader.planeTextClip.alpha = 0;
			preloader.planeTextClip.textmask.gotoAndStop(0);
			
			setTint(preloader.planeTextClip.red, 0XFF363B);
			setTint(preloader.peopleTextClip.red, 0XFF363B);
			
			preloader.gridClip.visible = false;
			preloader.gridClip.alpha = 0;
			
			preloader.radial.alpha = 0;
			
			addChild(preloader);
			
			sendReady();
		}
		
		public function handleHalfLoaded():void
		{
			Logger.log("HALF LOADED! - flag: " + halfLoadedFlag, 3, Logger.LOG_BOTH);
			if (halfLoadedFlag)
			{
				TweenMax.to(preloader.planeTextClip, 1 * timingMultiplier, { autoAlpha: 0 } );
				TweenMax.to(preloader.planeClip, 1 * timingMultiplier, { autoAlpha: 0 } );
				TweenMax.to(preloader.peopleTextClip, 1 * timingMultiplier, { delay: 2 * timingMultiplier, autoAlpha: 1 } );
				TweenMax.to(preloader.peopleClip, 1 * timingMultiplier, { delay: .5 * timingMultiplier, autoAlpha: 1, onComplete: function() { beginPhaseTwo.dispatch(); } } );
				TweenMax.to(preloader.peopleClip.people, 14 * timingMultiplier, { delay: 1 * timingMultiplier, x: 103, y: 55, ease:Quad.easeOut } );
				TweenMax.to(preloader.peopleTextClip.textmask, 6 * timingMultiplier, { delay: 4 * timingMultiplier, frame: 50, onComplete: function() { TweenMax.delayedCall(.5, handleAllLoaded); } } );
//				TweenMax.delayedCall(12, handleAllLoaded);
				//beginPhaseTwo.dispatch();
			}
			else
			{
				// let's wait for the other piece to come in
				halfLoadedFlag = true;
			}
			
		}
		
		public function handleAllLoaded():void
		{
			Logger.log("ALL LOADED! - flag: " + allLoadedFlag, 3, Logger.LOG_BOTH);
			if (allLoadedFlag)
			{
				preloadCompleted.dispatch();
			}
			else
			{
				allLoadedFlag = true;
			}
		}
		
		private function setTint(clip:MovieClip, c:int):void
		{
			var ct:ColorTransform = clip.transform.colorTransform;
			ct.color = c;
			clip.transform.colorTransform = ct;
		}
			
		override public function transitionIn():void
		{
			x = 0;
			alpha = 1;
			visible = true;
			
			transitionStarted.dispatch(TRANSITION_IN);
			TweenMax.to(preloader.radial, 3 * timingMultiplier, { alpha: 1 } );
			TweenMax.to(preloader.gridClip, 2 * timingMultiplier, { delay: 1 * timingMultiplier, autoAlpha: 1, onComplete: sendTransitionFinishedSignal, onCompleteParams: [TRANSITION_IN] } );
			TweenMax.to(preloader.planeTextClip, 3 * timingMultiplier, { delay: 2 * timingMultiplier, autoAlpha: 1 });
			TweenMax.to(preloader.planeClip.plane, 7 * timingMultiplier, { delay: 2 * timingMultiplier, x: -193, ease: Cubic.easeOut } );
			TweenMax.to(preloader.planeTextClip.textmask, 6 * timingMultiplier, { delay: 4 * timingMultiplier, frame: 50, onComplete: function() { TweenMax.delayedCall(2, handleHalfLoaded); } } );
//			TweenMax.delayedCall(8, function() {preloader.planeTextClip.textmask.play();});
//			TweenMax.delayedCall(12, handleHalfLoaded );
			
		}
		
		private function revealPlaneText():void
		{
			
		}
	}
}