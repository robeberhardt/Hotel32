package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.loading.SWFLoader;
	import com.thelab.hotel32.assets.AssetLoader;
	import com.thelab.hotel32.helpers.CrossingGuard;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	public class VideoControls extends MovieClip
	{
		private var _host								: VideoPlayer;
		private var swfLoader							: SWFLoader;
		
		private var assetPath							: String;
		private var uiAsset 								: MovieClip;
		
		private var theme								: String;
		
		private var background							: Sprite;
		
		private var playPauseClip						: MovieClip;
		private var _playing							: Boolean;
		private var started								: Boolean;
		
		private var volumeControl						: VolumeControl;
		private var vol									: Number;
		
		private var barClip								: MovieClip;
		private var trackClip							: MovieClip;
		private var bufferClip							: MovieClip;
		private var playheadClip						: MovieClip;
		private var scrubberClip						: MovieClip;
		private var clicktrackClip						: MovieClip;
				
		private var _loaded								: Number;
		private var _playhead							: Number;
		private var _scrubbing							: Boolean;
		
		private var _seekPercent						: Number;
		private var _scrubPercent						: Number;
		
		// constants
		public static const PANEL_HEIGHT				: Number = 19;
		
		// events
		public static const VOLUME_CHANGED 				: String = "VOLUME_CHANGED";
		public static const PLAY_PAUSE_CLICKED 			: String = "PLAY_PAUSE_CLICKED";
		public static const VIDEO_SEEK					: String = "VIDEO_SEEK";
		public static const VIDEO_SCRUB					: String = "VIDEO_SCRUB";
		public static const START_VIDEO_SCRUB			: String = "START_VIDEO_SCRUB";
		public static const END_VIDEO_SCRUB				: String = "END_VIDEO_SCRUB";
		public static const REPLAY						: String = "REPLAY";
			
		public static const PAUSE_MODE					: String = "pause";
		public static const PLAY_MODE					: String = "play";
		
		public function VideoControls(host:VideoPlayer, loader:SWFLoader)
		{
			_host = host;
			swfLoader = loader;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			background = new Sprite();
			background.graphics.beginFill(0x000000, .25);
			background.graphics.drawRect(0, 0, _host.vWidth, 38);
			addChild(background);
			background.y = 72;
			
			trackClip = swfLoader.getSWFChild("trackClip") as MovieClip;
			trackClip.x = trackClip.y = 0;
			trackClip.alpha = .6;
			
			bufferClip = swfLoader.getSWFChild("bufferClip") as MovieClip;
			bufferClip.scaleX = 0;
			bufferClip.x = bufferClip.y = 0;
			bufferClip.alpha = .7;
			
			playheadClip = swfLoader.getSWFChild("playheadClip") as MovieClip;
			playheadClip.scaleX = 0;
			playheadClip.x = playheadClip.y = 0;
			
			clicktrackClip = swfLoader.getSWFChild("clicktrackClip") as MovieClip;
			clicktrackClip.x = clicktrackClip.y = 0;
			clicktrackClip.alpha = 0;
			clicktrackClip.scaleX = 0;
						
			scrubberClip = swfLoader.getSWFChild("scrubberClip") as MovieClip;
			scrubberClip.y = 0;
			scrubberClip.useHandCursor = true;
			scrubberClip.buttonMode = true;
			scrubberClip.addEventListener(MouseEvent.MOUSE_DOWN, scrubHandler, false, 0, true);
			scrubberClip.alpha = .6;
			
			barClip = new MovieClip();
			barClip.x = 39;
			barClip.y = 90;
			addChild(barClip);
			
			barClip.addChild(trackClip);
			barClip.addChild(bufferClip);
			barClip.addChild(playheadClip);
			barClip.addChild(clicktrackClip);
			barClip.addChild(scrubberClip);
			
			volumeControl = new VolumeControl(swfLoader);
			addChild(volumeControl);
			volumeControl.x = _host.vWidth - 32;
			volumeControl.y = 83;
			
			setupPlayPauseControl();
			
		}
		
		/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		*
		*                          Play-Pause Control
		*
		* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
		
		private function setupPlayPauseControl() : void
		{
			playPauseClip = swfLoader.getSWFChild("playPauseClip") as MovieClip;
			addChild(playPauseClip);
			playPauseClip.useHandCursor = true;
			playPauseClip.buttonMode = true;
			playPauseClip.addEventListener(MouseEvent.ROLL_OVER, onPlayPauseRollOver, false, 0, true);
			playPauseClip.addEventListener(MouseEvent.ROLL_OUT, onPlayPauseRollOut, false, 0, true);
			playPauseClip.addEventListener(MouseEvent.CLICK, onPlayPauseClick, false, 0, true);
			playPauseClip.x = 8;
			playPauseClip.y = 79;
			playPauseClip.alpha = .6;
			playPauseClip.scaleX = playPauseClip.scaleY = .95;
			setPlayPauseButton(PAUSE_MODE);
		}
		
		private function onPlayPauseRollOver(e:MouseEvent):void 
		{
			TweenMax.to(playPauseClip, .5, { alpha: 1 });
		}
		
		private function onPlayPauseRollOut(e:MouseEvent):void 
		{
			TweenMax.to(playPauseClip, .5, { alpha: .6 });
		}
		
		public function setPlayPauseButton(fr:String) : void
		{
			playPauseClip.gotoAndStop(fr);
		}
		
		private function onPlayPauseClick(e:MouseEvent=null):void 
		{
			if (_host.started)
			{
				if (_playing) 
				{
					_playing = false;
					setPlayPauseButton(PLAY_MODE);
				} else {
					_playing = true;
					setPlayPauseButton(PAUSE_MODE);
				} 
			} else
			{
				dispatchEvent(new Event("REPLAY"));
				_host.videoStream.seek(0);
				_host.started = true;
				setPlayPauseButton(PAUSE_MODE);
			}
			dispatchEvent(new Event(PLAY_PAUSE_CLICKED, true));
		}
		
		public function externalReplayClick(e:MouseEvent):void
		{
			onPlayPauseClick(e);
		}	

		/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		*
		*                          Scrubbing
		*
		* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
		
		private function scrubHandler(e:MouseEvent) : void
		{
			_scrubbing = true;
			addEventListener(Event.ENTER_FRAME, scrubPlayhead, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScrubbing, false, 0, true);
			scrubberClip.startDrag(true, new Rectangle(bufferClip.x, scrubberClip.y, bufferClip.width, 0));
			dispatchEvent(new Event(START_VIDEO_SCRUB));
		}
		
		private function stopScrubbing(e:Event) : void
		{
			_scrubbing = false;
			scrubberClip.stopDrag();
			removeEventListener(Event.ENTER_FRAME, scrubPlayhead);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrubbing);
			dispatchEvent(new Event(END_VIDEO_SCRUB));
			
			// handle scrubbing to the very end of the video
			if (_scrubPercent > .97)
			{
				_scrubPercent = .95;
				dispatchEvent(new Event(VIDEO_SCRUB));
			}
		}
		
		private function scrubPlayhead(e:Event) : void
		{
			_scrubPercent = ((scrubberClip.x - bufferClip.x) / bufferClip.width);
			dispatchEvent(new Event(VIDEO_SCRUB));
		}
		
		/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		*
		*                          Track and Playhead
		*
		* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
		
		public function clickTrackOn() : void
		{
			clicktrackClip.addEventListener(MouseEvent.CLICK, clicktrackHandler, false, 0, true);
			clicktrackClip.useHandCursor = true;
			clicktrackClip.buttonMode = true;
//			playPauseClip.gotoAndStop("pause");
			keyboardOn();
		}
		
		public function clickTrackOff() : void
		{
			clicktrackClip.removeEventListener(MouseEvent.CLICK, clicktrackHandler);
			clicktrackClip.useHandCursor = false;
			clicktrackClip.buttonMode = false;
			keyboardOff();
		}
		
		public function keyboardOn():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
		}
		
		public function keyboardOff():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32) // space
			{
				onPlayPauseClick();
			}
		}
		
		private function clicktrackHandler(e:MouseEvent):void 
		{
			var theScaleX:Number = clicktrackClip.scaleX;
			_seekPercent = Math.round( ( (clicktrackClip.mouseX * theScaleX) / (clicktrackClip.width / theScaleX) ) * 10000) / 10000;
			dispatchEvent(new Event(VIDEO_SEEK, true));
		}
		
		public function resetTrackClips():void {
			playheadClip.scaleX = 0;
			//bufferClip.scaleX = 0;
			scrubberClip.x = 0;
			clickTrackOff();
			playPauseClip.gotoAndStop("play");
			//_host.started = false;
		}
		
		public function set playhead(val:Number):void {
			
			playheadClip.scaleX = val;
			
			if  (!_scrubbing) {
				//scrubberClip.x = playheadClip.x + playheadClip.width - (scrubberClip.width/2);
				scrubberClip.x = playheadClip.x + playheadClip.width;
			}
		}
		
		public function get playhead():Number {
			return playheadClip.scaleX;
		}
		
		/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		*
		*                          ???
		*
		* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> */
		
		public function show() : void
		{
			//	
		}
		
		public function hide() : void
		{
			//
		}
		
		public function set loaded(val:Number):void 
		{
			_loaded = val;
			bufferClip.scaleX = val; 
			clicktrackClip.scaleX = val;
		}
		
		public function get loaded():Number {
			return _loaded;
		}
		
		public function get seekPercent():Number { return _seekPercent; }
		
		public function get scrubPercent():Number { return _scrubPercent; }
		
		public function get scrubbing():Boolean { return _scrubbing; }
		
		public function get playing():Boolean { return _playing; }
		
		public function set playing(value:Boolean):void 
		{
			_playing = value;
		}
		
		public function get barYPosition():Number
		{
			return barClip.y;
		}
	}
}