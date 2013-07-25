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
import android.widget.CompoundButton;

public abstract class APCompoundButton extends APButton{// implements OnClickListener{

	private boolean checked = false;

	public APCompoundButton(int x, int y, int width, int height,
			String text) {
		super(x, y, width, height, text);
	}
	/**
	 * 
	 * @return The state of the button.
	 */
	public boolean isChecked() {
		if (!initialized) {
			return checked;
		} else {
			return ((CompoundButton) view).isChecked();
		}
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
		if (initialized) {
			if (checked) {
				pApplet.runOnUiThread(new Runnable() {
					public void run() {
						((CompoundButton) view).setChecked(true);
					}
				});
			} else {
				pApplet.runOnUiThread(new Runnable() {
					public void run() {
						((CompoundButton) view).setChecked(false);
					}
				});
			}
		}
	}

	public void init(PApplet pApplet) {
		this.pApplet = pApplet;
		if (checked) {

			((CompoundButton) view).setChecked(true);

		} else {

			((CompoundButton) view).setChecked(false);

		}
		//((CompoundButton) view).setOnClickListener(this);
		super.init(pApplet);
	}
	/** 
	 * Updating the {@link #checked} variable.
	 */
/*	public void onClick(View view) {
		super.onClick(view);
		checked = ((CompoundButton) view).isChecked();
	}
	*/
}
