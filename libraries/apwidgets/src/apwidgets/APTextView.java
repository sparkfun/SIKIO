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

import processing.core.PApplet;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.TextView;

public abstract class APTextView extends APWidget implements TextWatcher{

	private int textSize = -1;
	private String text;
	private int textColor = -1;
	
	
	public APTextView(int x, int y, int width, int height,
			String text) {
		super(x, y, width, height);
		this.text = text;
	}
	/**
	 * 
	 * @return The text content.
	 */
	public String getText() {
	//	if (!initialized) {
			return text;
	//	} else {
	//		long time = System.currentTimeMillis();
	//		while (view == null && System.currentTimeMillis() < time + 1000) {
	//		}
	//		return ((TextView) view).getText().toString();
	//	}
	}
	/**
	 * 
	 * @param textSize The size of the text.
	 */
	public void setTextSize(int textSize) {
		this.textSize = textSize;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((TextView) view).setTextSize(getTextSize());
				}
			});
		}
	}
	/**
	 * 
	 * @param text The text content.
	 */
	public void setText(String text) {
		this.text = text;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((TextView) view).setText(getText());
				}
			});
		}
	}
	/** 
	 * Sets the color of the text content.
	 * @param r	Red
	 * @param g Green
	 * @param b	Blue
	 * @param a Alpha
	 */
	public void setTextColor(int r, int g, int b, int a) {
		this.textColor = (a << 24) + (r << 16) + (g << 8) + (b);
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((TextView) view).setTextColor(textColor);
				}
			});
		}
	}
	/**
	 * Initializes the text field. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;
		
		((TextView) view).setText(text);
		if (textColor != -1) {
			((TextView) view).setTextColor(textColor);
		}
		if (textSize != -1) {
			((TextView) view).setTextSize(textSize);
		}
		
		((TextView) view).addTextChangedListener(this);
		super.init(pApplet);
	}
	/**
	 * 
	 * @return The size of the text content.
	 */
	public int getTextSize(){
		return textSize;
	}
	/**
	 * 
	 * @return The color of the text content.
	 */
	public int getTextColor(){
		return textColor;
	}
	/**
	 * Updating the {@link #text} variable.
	 */
	public void afterTextChanged(Editable s){
		text = ((TextView) view).getText().toString();
	}
	public void beforeTextChanged(CharSequence s, int start, int count, int after){}
	public void onTextChanged(CharSequence s, int start, int before, int count){}
	
	
}