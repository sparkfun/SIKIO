/**
 * Copyright 2010 Rikard Lundstedt
 * 
 * This file is part of APWidgets.
 * 
 * APWidgets is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * APWidgets is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with APWidgets. If not, see <http://www.gnu.org/licenses/>.
 */

package apwidgets;

import java.util.Vector;

import processing.core.PApplet;
import android.content.Context;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnErrorListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.util.Log;
import android.view.KeyEvent;
import android.view.ViewGroup;
import android.widget.MediaController;
import android.widget.VideoView;
/**
 * 
 * 
 * @author Rikard Lundstedt
 *
 */
public class APVideoView extends APWidget implements OnCompletionListener, OnPreparedListener, OnErrorListener{
	private static final String TAG = "PVideoView";
	private boolean hasMediaController = false;
	private String videoPath = null;
	private boolean looping = false;
	private boolean prepared = false;
	private Vector<MediaPlayerTask> tasks = new Vector<MediaPlayerTask>();
	
	/**
	 * Makes the video start from the beginning when the end of the video has been reached
	 * @param looping
	 */
	public void setLooping(boolean looping){
		this.looping = looping;
	}
	/**
	 * Creates a new video view that fills the screen and has a media controller
	 */
	public APVideoView() {
		this(0, 0, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, true);
	}
	/**
	 * Creates a new video view that fills the screen 
	 * @param hasMediaController Specifies whether the video view should have a media controller or not
	 */
	public APVideoView(boolean hasMediaController) {
		this(0, 0, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, hasMediaController);
	}
	/**
	 * Creates a new video view
	 * @param x The x-position of the video view
	 * @param y The y-position of the video view
	 * @param width The width of the video view
	 * @param height The height of the video view
	 * @param hasMediaController Specifies whether the video view should have a media controller or not
	 */
	public APVideoView(int x, int y, int width, int height,
			boolean hasMediaController) {
		super(x, y, width, height);

		this.hasMediaController = hasMediaController;
	}
	/**
	 * Sets the path of the video file. It should be placed on the SD-card
	 * @param videoPath The path of the video file
	 */
	public void setVideoPath(String videoPath) {
		this.videoPath = videoPath;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((VideoView) view).setVideoPath(getVideoPath());
				}
			});
		}
	}
	/**
	 * Starts playing the video file
	 */
	public void start() {
	//	if (initialized) {
			if(prepared){
				pApplet.runOnUiThread(new Runnable() {
					public void run() {
						((VideoView) view).start();
					}
				});
			}else{
				tasks.addElement(new MediaPlayerTask(){
					public void doTask(){
						start();
					}
				});
			}
	//	}
	}
	/**
	 *  Stops the playback I guess. I haven't tested this.
	 * 
	 */
	public void stopPlayBack() {
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((VideoView) view).stopPlayback();
				}
			});
		}
	}
	/**
	 * Pauses the playing of the video file
	 */
	public void pause() {
		if (((VideoView) view).isPlaying()) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((VideoView) view).pause();
				}
			});
		}
	}

	/*
	 * void resume(){ //wait til level 8 ((VideoView)view).resume(); }
	 */
	/**
	 * Move to a certain point in the file,
	 * counted from the beginning in millisecond.
	 * @param msec
	 */
	public void seekTo(int msec) {
		if (prepared) {
			pApplet.runOnUiThread(new GUIThreadSeekToTask(msec));
		}else {
			tasks.addElement(new SeekToTask(msec));
		}
	}
	
	class GUIThreadSeekToTask implements Runnable {
		int msec;
		public GUIThreadSeekToTask(int argmsec) {
			msec = argmsec;
		}
		public void run() {
			if((msec > getCurrentPosition() && ((VideoView) view).canSeekForward())||
			(msec < getCurrentPosition() && ((VideoView) view).canSeekBackward())){
				((VideoView) view).seekTo(msec);
			}
		}
	}
	/**
	 * Initializes the video view. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;

		if (view == null) {
			view = new MyVideoView(pApplet);
		}
		((VideoView) view).setZOrderMediaOverlay(true);

		if (hasMediaController) {
			MediaController mediaController = new MediaController(pApplet);
			mediaController.setAnchorView(((VideoView) view));

			((VideoView) view).setMediaController(mediaController);
		}
		if (videoPath != null) {
			((VideoView) view).setVideoPath(videoPath);
		}
		((VideoView) view).setOnCompletionListener(this);
		((VideoView) view).setOnPreparedListener(this);
		((VideoView) view).setOnErrorListener(this);

		super.init(pApplet);
	}
	/** 
	 * Get the path of the video file
	 * @return
	 */
	public String getVideoPath(){
		return videoPath;
	}
	/**
	 * Returns the duration of the video
	 * @return
	 */
	public int getDuration(){
		if(initialized && videoPath != null){
			return ((VideoView) view).getDuration();
		}
		return 0;
	}
	/**
	 * Returns the current position.
	 * @return
	 */
	public int getCurrentPosition(){
		if(initialized && videoPath != null){
			return ((VideoView) view).getCurrentPosition();
		}
		return 0;
	}
	public void onCompletion(MediaPlayer mediaPlayer){
		
		if(looping){
			((VideoView) view).start();
		}
	}
	public boolean onError(MediaPlayer mediaPlayer, int a, int b){
		Log.e(TAG, a+" " +b);
		return false;
	}
	public void onPrepared(MediaPlayer mp){
		prepared = true;
				for(int i = 0;i<tasks.size();i++){
					tasks.elementAt(i).doTask();
				}
				tasks.removeAllElements();
	}
	interface MediaPlayerTask {
		public void doTask();
	}
	class SeekToTask implements MediaPlayerTask{
		int msec;
		public SeekToTask(int msec){
			this.msec = msec;
		}
		public void doTask(){
			((VideoView) view).seekTo(msec);
		}
	}
	class MyVideoView extends VideoView{

		public MyVideoView(Context context) {
			super(context);
			// TODO Auto-generated constructor stub
		}
		public boolean onKeyDown(int key, KeyEvent keyEvent){
			pApplet.surfaceKeyDown(key, keyEvent);
			return super.onKeyDown(key, keyEvent);
		}
	}
}
