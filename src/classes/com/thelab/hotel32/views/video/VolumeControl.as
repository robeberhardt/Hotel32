package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.greensock.loading.SWFLoader;
	import com.thelab.hotel32.assets.AssetController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class VolumeControl extends MovieClip
	{
//		private var _asset								: MovieClip;
		private var swfLoader							: SWFLoader;
		private var icon								: MovieClip;
		private var slider								: MovieClip;
		
		private var hitRect								: Sprite;
		private var isHitting							: Boolean = false;
		private var dragging							: Boolean = false;
		
		private var vol									: Number;
		public static const VOLUME_CHANGED				: String = "VOLUME_CHANGED";
		
		public function VolumeControl(loader:SWFLoader)
		{
			swfLoader = loader;
			
			hitRect = new Sprite();
			hitRect.graphics.beginFill(0xFF0000, 1);
			hitRect.graphics.drawRect(-5,-70,40,100);
			hitRect.graphics.endFill();
			hitRect.alpha = 0;
			addChild(hitRect);
			
			icon = swfLoader.getSWFChild("volumeIcon") as MovieClip;
			icon.alpha = .6;
			icon.x = icon.y = 0;
			icon.useHandCursor = true;
			icon.buttonMode = true;
			icon.scaleX = icon.scaleY = .95;
			addChild(icon);
			
			icon.addEventListener(MouseEvent.ROLL_OVER, onIconRollOver, false, 0, true);
			icon.addEventListener(MouseEvent.ROLL_OUT, onIconRollOut, false, 0, true);
			icon.addEventListener(MouseEvent.CLICK, onIconClick, false, 0, true);
			
			slider = swfLoader.getSWFChild("volumeSlider") as MovieClip;
			slider.rotation = -90;
			slider.x = 10;
			slider.y = -12;
			slider.trackMask.scaleX = 0;
			slider.visible = false;
			slider.alpha = 0;
			addChild(slider);
			slider.thumb.useHandCursor = true;
			slider.thumb.buttonMode = true;
			updateSlider();
			
			slider.thumb.addEventListener(MouseEvent.MOUSE_DOWN, onSliderThumbMouseDown, false, 0, true);
			
			
		}
		
		private function hitRectOn():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMotion);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			//hitRect.alpha = .5;
		}
		
		private function hitRectOff():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMotion);
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
		}
		
		private function onMouseMotion(e:MouseEvent):void
		{
			doHitTest();
		}
		
		private function doHitTest():void
		{
			if (hitRect.hitTestPoint(stage.mouseX, stage.mouseY))
			{
				isHitting = true;
			}
			else if (!dragging)
			{
				hideSlider();
				hitRectOff();
				isHitting = false;
			}
		}
		
		public function onMouseLeave(e:Event=null):void
		{
			if (!dragging)
			{
				hideSlider();
				hitRectOff();
				isHitting = false;
			}
		}
		
		private function onIconRollOver(e:MouseEvent):void
		{
			TweenMax.to(icon, .5, { alpha: 1 });
			showSlider();
			hitRectOn();
		}
		
		private function onIconRollOut(e:MouseEvent):void
		{
			TweenMax.to(icon, .5, { alpha: .6 });
		}
		
		private function onIconClick(e:MouseEvent):void
		{
			//dispatchEvent(new Event(VOLUME_MUTE_TOGGLE));
			if (AssetController.getInstance().volumeLevel > 0) 
			{
				AssetController.getInstance().previousVolumeLevel = AssetController.getInstance().volumeLevel;
				AssetController.getInstance().volumeLevel = 0;
				TweenMax.to(slider.thumb, .25, { x: 0, ease:Quad.easeOut });
				TweenMax.to(slider.trackMask, .25, { scaleX: 0, ease:Quad.easeOut });
				TweenMax.to(icon.waves, .25, { alpha: .25 });
			}
			else
			{
				AssetController.getInstance().volumeLevel = AssetController.getInstance().previousVolumeLevel;
				TweenMax.to(slider.thumb, .25, { x: slider.track.width * AssetController.getInstance().volumeLevel, ease:Quad.easeOut });
				TweenMax.to(slider.trackMask, .25, { scaleX: AssetController.getInstance().volumeLevel, ease:Quad.easeOut });
				TweenMax.to(icon.waves, .25, { alpha: 1 });
			}
			dispatchEvent(new Event(VOLUME_CHANGED, true));
		}
		
		private function tweenSlider():void {
			slider.trackMask.scaleX = slider.thumb.x / slider.track.width;
			vol = slider.thumb.x / slider.track.width;
			if (vol >= .98) { vol = 1; }
			if (vol <= .02) { vol = 0; }
			AssetController.getInstance().volumeLevel = vol;
			dispatchEvent(new Event(VOLUME_CHANGED, true));
		}
		
		private function showSlider():void
		{
			TweenMax.to(slider, .5, { autoAlpha: 1 });
		}
		
		private function hideSlider():void
		{
			TweenMax.to(slider, .5, { autoAlpha: 0 });	
			hitRectOff();
		}
		
		private function updateSlider():void
		{
			vol = AssetController.getInstance().volumeLevel;
			slider.thumb.x = vol * slider.track.width;
			slider.trackMask.scaleX = slider.thumb.x / slider.track.width; 
		}
		
		private function onSliderThumbMouseDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onSliderThumbMouseUp, false, 0, true);
			addEventListener(Event.ENTER_FRAME, trackMouse, false, 0, true);
			slider.thumb.startDrag(true, new Rectangle(0, 2, slider.track.width, 0));
			dragging = true;
		}
		
		private function trackMouse(e:Event):void {
			slider.trackMask.scaleX = slider.thumb.x / slider.track.width;
			vol = slider.thumb.x / slider.track.width;
			if (vol >= .98) { vol = 1; }
			if (vol <= .02) { vol = 0; }
			AssetController.getInstance().volumeLevel = vol;
			dispatchEvent(new Event(VOLUME_CHANGED, true));
		}
		
		private function onSliderThumbMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSliderThumbMouseUp);
			slider.thumb.stopDrag();
			removeEventListener(Event.ENTER_FRAME, trackMouse);
			dragging = false;
			AssetController.getInstance().writeVolumeToSO();
		}		
	}
}