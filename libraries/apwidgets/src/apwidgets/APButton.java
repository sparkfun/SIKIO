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
import android.view.ViewGroup;
import android.widget.Button;
/**
 * A button. Add instances to {@link apwidgets.APWidgetContainer}.<br>
 * <br>
 * To capture onClick events, declare in sketch: <br>
 * <br>
 * void onClickWidget(PWidget source)<br>
 * {<br>
 * 	// Your code here.<br>
 * }<br>
 * 
 * 
 * @author Rikard Lundstedt
 *
 */
public class APButton extends APTextView {
	/**
	 * Creates a button.<br>
	 * 
	 * @param x The button's x position.
	 * @param y The button's y position.
	 * @param text The text on the button's label.
	 */
	public APButton(int x, int y, String text) {
		this(x, y, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, text);
	}
	/**
	 * Creates a button.<br>
	 * 
	 * @param x The button's x position.
	 * @param y The button's y position.
	 * @param width The button's width.
	 * @param height The button's height.
	 * @param text The text on the button's label.
	 */
	public APButton(int x, int y, int width, int height,
			String text) {
		super(x, y, width, height, text);
	}
	/**
	 * Initializes the button. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 * 
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;

		if (view == null) {
			view = new Button(pApplet);
		}

		super.init(pApplet);
	}
}