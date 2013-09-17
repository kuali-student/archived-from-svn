package net.pandoragames.far.ui;

import java.io.File;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import net.pandoragames.far.ui.model.FileNamePattern;
import net.pandoragames.far.ui.model.FindForm;
import net.pandoragames.far.ui.model.RenameForm;
import net.pandoragames.far.ui.model.ReplaceForm;
import net.pandoragames.util.i18n.DummyLocalizer;
import net.pandoragames.util.i18n.Localizer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Data container for configuration values.
 * @author Olivier Wehner
 * <!-- copyright note --> 
 */
public class FARConfig
{
	/**
	 * The applications (short) name: FAR
	 */
	public static final String APPLICATION_NAME = "FAR";
	/**
	 * The application title: Find And Replace
	 */
	public static final String APPLICATION_TITLE = "Find And Replace";
	
	/**
	 * Property name for base directory.
	 */
	public static final String PPT_BASEDIR = "far.basedir";
	/**
	 * Property name for backup directory.
	 */
	public static final String PPT_BCKPDIR = "far.backupdir";
	/**
	 * Property name for file list export directory.
	 */
	public static final String PPT_LISTEXDIR = "far.listexportdir";
	/**
	 * Property name for group reference indicator.
	 */
	public static final String PPT_GROUPREF = "far.groupreference";
	/**
	 * Property name for version number.
	 */
	public static final String PPT_VERSION = "far.version";
	/**
	 * The set of possible group reference indicators. "\", "$" and "%".
	 */
	public static final String[] GROUPREFINDICATORLIST = new String[]{"\\", "$", "%"};	
	/**
	 * Standard ISO 8601 date time format
	 */
	public static final String STANDARD_DATE_TIME_FORMAT = "yyyy-MM-dd hh:mm";

	// directory for configuration settings
	private File configDir;
	// last used base directory
	private File lastBaseDir = new File( System.getProperty("user.home") ); 
	// translation for label
	private Localizer localizer = new DummyLocalizer();
	// default backup directory
	private File defaultBackupDirectory = new File( System.getProperty("java.io.tmpdir") );
	// file name pattern list
	private List<FileNamePattern> patternList;
	// default character set
	private Charset defaultCharset;
	// has the application version changed since last run?
	private boolean versionHasChanged = false;
	// currently set group reference indicator
	private char groupReferenceIndicator;
	// available character sets
	private List<Charset> charsetList;
	// last used directory for file list im/export
	private File fileListExportDir = new File( System.getProperty("user.home") ); 
	// java version number
	private static int effectiveJavaVersion = -1;
	// logger for I/O operations
	protected Log logger = LogFactory.getLog( this.getClass() );
	
	/**
	 * Returns the "effective" java version, i.e. the "minor" verision returned
	 * by the system property "java version". Returns 4 for java 1.4.x, 5 for
	 * java 1.5.x and so on. Returns 0 (zero) if the System property "java.version" 
	 * could not be parsed.
	 * @return "effective" java version as a positive integer
	 */
	public static int getEffectiveJavaVersion() {
		if( effectiveJavaVersion < 0 ) {
			String versionString = System.getProperty("java.version");
			if( versionString == null ) return 0;
			int start = versionString.indexOf('.');
			if( start < 0 ) return 0;
			start = start + 1;
			int end = versionString.indexOf('.', start);
			if( end < 0 ) end = Math.min( versionString.length(), start+1);
			try{
				effectiveJavaVersion = Integer.parseInt( versionString.substring(start, end));
			} catch(NumberFormatException nfx) {
				return 0;
			}
		}
		return effectiveJavaVersion;
	}
		
	/**
	 * Returns the lastBaseDir.
	 * @return lastBaseDir
	 */
	public File getBaseDirectory()
	{
		return lastBaseDir;
	}
	
	/**
	 * Returns the Localizer to be used for labels and messages.
	 * @return Localizer instance
	 */
	public Localizer getLocalizer() {
		return localizer;
	}
	
	/**
	 * Sets the Localizer to be used.
	 * @param localizer for labels and messages
	 */
	public void setLocalizer(Localizer localizer) {
		if (localizer != null) this.localizer = localizer;
	}

	
	/**
	 * Returns the list of predefined FileNamePatterns
	 * @return predefined patterns.
	 */
	public List<FileNamePattern> getFileNamePatternList() {
		return patternList;		
	}
	
	/**
	 * Returns the default backup directory.
	 * @return default backup directory
	 */
	public File getBackupDirectory() {
		return defaultBackupDirectory;
	}
	
	/**
	 * Returns the list of available character sets.
	 * @return available character sets
	 */
	public List<Charset> getCharsetList()
	{
		return charsetList;
	}

	/**
	 * Returns the default character set.
	 * @return default character set
	 */
	public Charset getDefaultCharset()
	{
		return defaultCharset;
	}

	/**
	 *  Sets the default character set.
	 *  @param charset default character set to be used
	 */
	public void setDefaultCharset(Charset charset)
	{
		if(charset != null) {
			defaultCharset = charset;
		}
	}
	
	/**
	 * Returns the default directory for file list import and export.
	 * @return default directory for file list import and export
	 */
	public File getFileListExportDirectory() {
		return fileListExportDir;
	}

	/**
	 * Returns the currently set group reference indicator.
	 * This is a single character, indicating group references in 
	 * regular expressions.
	 * @return currently set group reference indicator
	 */
	public char getGroupReferenceIndicator() {
		return groupReferenceIndicator;
	}

	/**
	 * Sets the group reference indicator.
	 * This is a single character, indicating group references in 
	 * regular expressions.
	 * @param groupReferenceIndicator group reference indicator
	 */
	public void setGroupReferenceIndicator(char groupReferenceIndicator) {
		this.groupReferenceIndicator = groupReferenceIndicator;
	}

	/**
	 * Returns a new FindForm with default settings.
	 * @return default FindForm
	 */
	public FindForm getDefaultFindForm() {
		FindForm form = new FindForm();
		form.setBaseDirectory( getBaseDirectory() );
		form.setCharacterset( getDefaultCharset() );
		form.setFileNamePattern( getFileNamePatternList().get(0) );
		return form;
	}
	
	/**
	 * Returns a new ReplaceForm with default settings.
	 * @return default ReplaceForm
	 */
	public ReplaceForm getDefaultReplaceForm() {
		ReplaceForm form = new ReplaceForm();
		form.setBackupDirectory( getBackupDirectory() );
		form.setBaseDirectory( getBaseDirectory() );
		form.setCharacterset( getDefaultCharset() );
		form.setGroupReference( getGroupReferenceIndicator() );
		return form;
	}
	
	/**
	 * Returns a new RenameForm with default settings.
	 * @return default RenameForm
	 */
	public RenameForm getDefaultRenameForm() {
		RenameForm form = new RenameForm();
		form.setGroupReference( getGroupReferenceIndicator() );
		return form;
	}
	
	/**
	 * Returns true if the application version has changed since 
	 * the last run.
	 * @return true if application version has changed.
	 */
	public boolean versionHasChanged() {
		return versionHasChanged;
	}
	
	/**
	 * Returns the directory for configuration options.
	 * @return configuration directory
	 */
	public File getConfigDir() {
		return configDir;
	}
	
// -- attribute setter ------------------------------------------------------------------------------------

	/**
	 *  Sets the list of available character sets.
	 *  @param charsetList available character sets
	 */
	protected void setCharsetList(List<Charset> charsetList)
	{
		this.charsetList = charsetList;
	}

	/**
	 * Sets the default backup directory. 
	 * If the specified directory does not exist, the call will be ignored.
	 * @param backupDirectory default backup directory.
	 */
	public final void setBackupDirectory(File backupDirectory)
	{
		if((backupDirectory != null) && (backupDirectory.isDirectory())) {
			this.defaultBackupDirectory = backupDirectory;
		}
	}

	/**
	 * Sets the default base directory.
	 * If the specified directory does not exist, the call will be ignored.
	 * @param baseDir default base directory.
	 */
	public final void setBaseDirectory(File baseDir)
	{
		if((baseDir != null) && (baseDir.isDirectory())) {
			this.lastBaseDir = baseDir;
		}
	}
	
	/**
	 * Sets the default directory for file list import and export.
	 * If the specified directory does not exist, the call will be ignored.
	 * @param exportDir default directory for file list import and export
	 */
	public final void setFileListExportDirectory(File exportDir) {
		if((exportDir != null) && (exportDir.isDirectory())) {
			fileListExportDir = exportDir;
		}
	}

	
	/**
	 * Loads the base and the backupd directory from a Properties object.
	 * The property names are defined as constants of this class.
	 * The property values are supposed to be valid pathes, but both
	 * directories are controlled for existance. Inheriting classes may overwrite
	 * this method to load additional properties.
	 * @param properties holding properties for base and backup directory.
	 */
	protected void loadFromProperties(Properties properties) {
		// base directory
		File baseDir = getValidFile( properties.getProperty( PPT_BASEDIR ) );
		if(baseDir != null) {
			setBaseDirectory( baseDir );
		} else {
			logger.info("Base directory " + properties.getProperty( PPT_BASEDIR ) 
					+ " could not be restored. Using fall back: " + lastBaseDir.getPath());
		}
		// backup directory
		File bckpDir = getValidFile( properties.getProperty( PPT_BCKPDIR ) );
		if(bckpDir != null) {
			if (bckpDir.canWrite()) {
				setBackupDirectory( bckpDir );
			} else {
				logger.info("Backup directory " + properties.getProperty( PPT_BCKPDIR ) 
						+ " is not writable. Using fall back: " + defaultBackupDirectory.getPath());				
			}
		} else {
			logger.info("Backup directory " + properties.getProperty( PPT_BCKPDIR ) 
					+ " could not be restored. Using fall back: " + defaultBackupDirectory.getPath());
		}
		// list impex directory
		setFileListExportDirectory( getValidFile( properties.getProperty( PPT_LISTEXDIR ) ) );
		// group reference indicator
		String grefind = properties.getProperty( PPT_GROUPREF );
		if( grefind == null || 
				! (grefind.equals(GROUPREFINDICATORLIST[0]) 
				    || grefind.equals(GROUPREFINDICATORLIST[1]) 
				    || grefind.equals(GROUPREFINDICATORLIST[2]))) {
			grefind = GROUPREFINDICATORLIST[0];
		}
		groupReferenceIndicator = grefind.charAt( 0 );
		// application version
		String versionNumber = properties.getProperty( PPT_VERSION );
		String currentVersion = getCurrentApplicationVersion();
		if( currentVersion != null && !currentVersion.equals( versionNumber ) ) {
			versionHasChanged = true;
		}
	}
	
	/**
	 * The inverse operation to <code>loadFromProperties()</code>.
	 * @param properties where to write base and backup directory to
	 */
	protected void writeToProperties(Properties properties) {
		properties.setProperty(PPT_BASEDIR, lastBaseDir.getPath() );
		properties.setProperty(PPT_BCKPDIR, defaultBackupDirectory.getPath() );
		properties.setProperty(PPT_LISTEXDIR, fileListExportDir.getPath() );
		properties.setProperty(PPT_GROUPREF, String.valueOf( groupReferenceIndicator ) );
		if( getCurrentApplicationVersion() != null ) {
			properties.setProperty(PPT_VERSION, getCurrentApplicationVersion());
		}
	}

	/**
	 * Sets the file name pattern list.
	 * @param fileNamepattern file name pattern list
	 */
	protected void setPatternList(List<FileNamePattern> fileNamepattern)
	{
		if(fileNamepattern != null)  {
			patternList = new ArrayList<FileNamePattern>();
			patternList.addAll( fileNamepattern );
		}
	}
	
	/**
	 * Sets the directory for configuration options.
	 * @param dir configuration directory
	 */
	protected void setConfigDir(File dir) {
		if( dir == null ) throw new NullPointerException("Configuration directory must not be null");
		configDir = dir;
	}
	
	private File getValidFile(String path) {
		if( path == null ) return null;
		File file = new File( path );
		if(! file.exists() ) {
			logger.warn("The path " + path + " could not be found");
			return null;
		}
		return file;
	}

	private String getCurrentApplicationVersion() {
		Package pkg = getClass().getPackage();
		if( pkg != null ) {
			return pkg.getSpecificationVersion();
		} else {	// not in a jar
			return null;
		}
	}
}
