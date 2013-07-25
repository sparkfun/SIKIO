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
import android.widget.ToggleButton;
import android.view.ViewGroup;
/**
 * A Checkbox.Add instances to {@link apwidgets.APWidgetContainer}.<br>
 * <br> 
 * 
 * @author Rikard Lundstedt
 *
 */
public class APToggleButton extends APCompoundButton {
	
	private String textOn = null;
	private String textOff = null;
	
	public String getTextOn(){
		return textOn;
	}
	public String getTextOff(){
		return textOff;
	}
	
	/** 
	 * Creates a new toggle button. 
	 * @param x The x position of the check box.
	 * @param y The y position of the check box.
	 * @param text The text on the label of the check box.
	 */
	public APToggleButton(int x, int y, String text) {
		super(x, y, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, text);
	}
	
	/**
	 * Creates a new toggle button.<br>
	 * 
	 * @param x The button's x position.
	 * @param y The button's y position.
	 * @param width The button's width.
	 * @param height The button's height.
	 * @param text The text on the button's label.
	 */
	public APToggleButton(int x, int y, int width, int height,
			String text) {
		super(x, y, width, height, text);
	}
	
	/**
	 * Initializes the toggle button. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 * 
	 */
	public void init(PApplet argPApplet) {
		this.pApplet = argPApplet;

		if (view == null) {
			view = new ToggleButton(pApplet);
		}
		
		if(textOn == null){
			textOn = getText();
		}
		if(textOff == null){
			textOff = getText();
		}
		((ToggleButton) view).setTextOn(getTextOn());
		((ToggleButton) view).setTextOff(getTextOff());
		
		super.init(pApplet);
	}
	
	public void setTextOn(String textOn){
		this.textOn = textOn;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((ToggleButton) view).setTextOn(getTextOn());
				}
			});
		}
	}
	public void setTextOff(String textOff){
		this.textOff = textOff;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					((ToggleButton) view).setTextOn(getTextOff());
				}
			});
		}
	}

}