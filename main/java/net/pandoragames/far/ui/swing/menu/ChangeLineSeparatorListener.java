package net.pandoragames.far.ui.swing.menu;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import net.pandoragames.far.ui.model.CharacterUtil;
import net.pandoragames.far.ui.model.TargetFile;
import net.pandoragames.far.ui.swing.component.FileSetTableModel;
import net.pandoragames.far.ui.swing.component.listener.AbstractFileUpdaterListener;
import net.pandoragames.util.i18n.Localizer;

/**
 *
 * @author Olivier Wehner
 * <!-- copyright note -->
 */
class ChangeLineSeparatorListener extends AbstractFileUpdaterListener {
	private char[] sepp;
	public ChangeLineSeparatorListener(FileSetTableModel model, Localizer localizer, char ... ls ) {
		super( model, localizer );
		sepp = ls;
	}
	protected boolean executeForUpdate(TargetFile targetFile, File tempfile) throws IOException {
		int currentChar = 0;
		int lastChar = 0;
		InputStream input = null;
		OutputStream output = null;
		try {
			input = new FileInputStream( targetFile.getFile() );
			output = new BufferedOutputStream( new FileOutputStream( tempfile ) );
			while( input.available() > 0 ) {
				lastChar = currentChar;
				currentChar = input.read();
				if( currentChar < 0 ) {
					break;
				} else if( CharacterUtil.isLineBreakChar( (char) currentChar ) ) {
					if( CharacterUtil.isLineBreakChar( (char) lastChar ) ) {
						currentChar = 0; // skip this one
					} else {
						for(int i = 0; i < sepp.length; i++) output.write( sepp[i] );
					}
				} else {
					output.write( currentChar );
				}
			}
			output.flush();
		} finally {
			if( input != null ) try { input.close(); } catch(IOException x) { /* ignore me*/ }
			if( output != null ) try { output.close(); } catch(IOException x) { /* ignore me*/ }
		}
		return true;
	}
	protected void success(TargetFile targetFile) {
		targetFile.info( localizer.localize("message.ok") );
		logger.info("Changed line separator for " + targetFile.getFile().getPath());
	}
}
